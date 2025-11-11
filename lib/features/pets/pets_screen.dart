import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/pet_model.dart';
import '../../data/models/reminder_model.dart';
import '../../data/models/growth_track_model.dart';
import '../../data/repositories/pet_repository.dart';
import '../../data/services/local_storage_service.dart';
import 'widgets/pet_avatar_selector.dart';
import 'widgets/reminder_card.dart';
import 'widgets/growth_timeline.dart';
import 'add_pet_screen.dart';
import 'add_reminder_screen.dart';
import 'add_growth_track_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  late PetRepository _petRepository;
  List<Pet> _pets = [];
  Pet? _selectedPet;
  List<Reminder> _reminders = [];
  List<GrowthTrack> _growthTracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initRepository();
  }

  Future<void> _initRepository() async {
    final storage = await LocalStorageService.getInstance();
    _petRepository = PetRepository(storage);
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final pets = await _petRepository.getAllPets();
    setState(() {
      _pets = pets.where((p) => p.isActive).toList();
      _selectedPet = _pets.isNotEmpty ? _pets.first : null;
      _isLoading = false;
    });

    if (_selectedPet != null) {
      await _loadPetDetails(_selectedPet!.id);
    }
  }

  Future<void> _loadPetDetails(String petId) async {
    final reminders = await _petRepository.getRemindersForPet(petId);
    final tracks = await _petRepository.getGrowthTracksForPet(petId);

    if (mounted) {
      setState(() {
        _reminders = reminders..sort((a, b) => a.dueDate.compareTo(b.dueDate));
        _growthTracks = tracks..sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void _onPetSelected(Pet pet) {
    setState(() {
      _selectedPet = pet;
    });
    _loadPetDetails(pet.id);
  }

  String _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    final difference = now.difference(birthday);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0) {
      return '$years year${years > 1 ? 's' : ''} old';
    } else {
      return '$months month${months > 1 ? 's' : ''} old';
    }
  }

  Future<void> _navigateToAddPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetScreen(repository: _petRepository),
      ),
    );

    if (result == true) {
      await _loadData();
    }
  }

  Future<void> _navigateToAddReminder() async {
    if (_selectedPet == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(
          repository: _petRepository,
          petId: _selectedPet!.id,
          petName: _selectedPet!.name,
        ),
      ),
    );

    if (result == true) {
      await _loadPetDetails(_selectedPet!.id);
    }
  }

  Future<void> _navigateToAddGrowthTrack() async {
    if (_selectedPet == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGrowthTrackScreen(
          repository: _petRepository,
          petId: _selectedPet!.id,
          petName: _selectedPet!.name,
        ),
      ),
    );

    if (result == true) {
      await _loadPetDetails(_selectedPet!.id);
    }
  }

  Future<void> _showArchiveDialog() async {
    if (_selectedPet == null) return;

    final petName = _selectedPet!.name;
    final petId = _selectedPet!.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Archive Pet'),
          content: Text(
            'Are you sure you want to end the record for $petName?\n\n'
            'This will archive all data and make it read-only. '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConstants.mediumGray),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Archive',
                style: TextStyle(color: AppConstants.softCoral),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _petRepository.archivePet(petId);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$petName has been archived'),
            backgroundColor: AppConstants.softCoral,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.softCoral),
          ),
        ),
      );
    }

    if (_pets.isEmpty) {
      final isDark = theme.brightness == Brightness.dark;
      return Scaffold(
        backgroundColor: isDark
            ? AppConstants.deepPlum
            : AppConstants.shellWhite,
        appBar: AppBar(
          title: Text(
            'My Pets',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstants.softCoral.withOpacity(0.2),
                          AppConstants.softCoral.withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.softCoral.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      size: 70,
                      color: AppConstants.softCoral,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXL),
                  Text(
                    'No pets yet',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  Text(
                    'Create a profile for your furry friend\nand start recording precious moments',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppConstants.mediumGray,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXL * 1.5),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppConstants.softCoral, Color(0xFFFF8A9A)],
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusFull,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.softCoral.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _navigateToAddPet,
                      icon: const Icon(Icons.add_rounded, size: 24),
                      label: const Text(
                        'Add Your First Pet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXL,
                          vertical: AppConstants.spacingM + 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusFull,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppConstants.deepPlum : AppConstants.shellWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingL,
                AppConstants.spacingM,
                AppConstants.spacingM,
                AppConstants.spacingS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Pets',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_pets.length} ${_pets.length == 1 ? 'pet' : 'pets'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppConstants.mediumGray,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppConstants.softCoral, Color(0xFFFF8A9A)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.softCoral.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_rounded, size: 26),
                      onPressed: _navigateToAddPet,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Pet Avatar Selector
            PetAvatarSelector(
              pets: _pets,
              selectedPet: _selectedPet,
              onPetSelected: _onPetSelected,
              onAddPet: _navigateToAddPet,
            ),

            // Pet Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: _selectedPet != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPetInfoCard(),
                          const SizedBox(height: AppConstants.spacingL),
                          _buildRemindersSection(),
                          const SizedBox(height: AppConstants.spacingL),
                          _buildGrowthTrackSection(),
                          const SizedBox(height: AppConstants.spacingXL),
                          _buildArchiveButton(),
                          const SizedBox(height: AppConstants.spacingL),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _selectedPet!.name,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS - 2,
            ),
            decoration: BoxDecoration(
              color: AppConstants.softCoral.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Text(
              '${_selectedPet!.breed} • ${_selectedPet!.gender}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.softCoral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              color: isDark
                  ? AppConstants.deepPlum.withOpacity(0.5)
                  : AppConstants.shellWhite,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 20,
                  color: AppConstants.softCoral.withOpacity(0.7),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    _selectedPet!.hobbies,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM + 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.softCoral.withOpacity(0.1),
                        AppConstants.softCoral.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    border: Border.all(
                      color: AppConstants.softCoral.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cake_rounded,
                        color: AppConstants.softCoral,
                        size: 24,
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        'Birthday',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppConstants.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedPet!.birthday.month}/${_selectedPet!.birthday.day}/${_selectedPet!.birthday.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _calculateAge(_selectedPet!.birthday),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppConstants.softCoral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM + 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.softCoral.withOpacity(0.1),
                        AppConstants.softCoral.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    border: Border.all(
                      color: AppConstants.softCoral.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: AppConstants.softCoral,
                        size: 24,
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        'Gotcha Day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppConstants.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedPet!.gotchaDay.month}/${_selectedPet!.gotchaDay.day}/${_selectedPet!.gotchaDay.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.softCoral.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    size: 20,
                    color: AppConstants.softCoral,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Text(
                  'Reminders',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: AppConstants.softCoral.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add_rounded, size: 20),
                onPressed: _navigateToAddReminder,
                color: AppConstants.softCoral,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingM),
        if (_reminders.isEmpty)
          Center(
            child: Text(
              'No reminders yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.mediumGray,
              ),
            ),
          )
        else
          ..._reminders.map(
            (reminder) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
              child: ReminderCard(reminder: reminder),
            ),
          ),
      ],
    );
  }

  Widget _buildGrowthTrackSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.softCoral.withOpacity(0.2),
                        AppConstants.softCoral.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    size: 20,
                    color: AppConstants.softCoral,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Text(
                  'Growth Track',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.softCoral, Color(0xFFFF8A9A)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.softCoral.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: _navigateToAddGrowthTrack,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingM),
        if (_growthTracks.isEmpty)
          Center(
            child: Text(
              'No growth tracks yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.mediumGray,
              ),
            ),
          )
        else
          GrowthTimeline(tracks: _growthTracks),
      ],
    );
  }

  Widget _buildArchiveButton() {
    if (_selectedPet == null) return const SizedBox.shrink();

    return Center(
      child: TextButton.icon(
        onPressed: _showArchiveDialog,
        icon: const Icon(
          Icons.archive_outlined,
          size: 18,
          color: AppConstants.mediumGray,
        ),
        label: Text(
          'End Record for ${_selectedPet!.name}...',
          style: const TextStyle(
            color: AppConstants.mediumGray,
            decoration: TextDecoration.underline,
            fontSize: 14,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingS,
          ),
        ),
      ),
    );
  }
}
