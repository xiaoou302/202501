import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../services/database_service.dart';
import '../../models/journal_entry.dart';
import 'package:uuid/uuid.dart';

class SaveActivityDialog extends StatefulWidget {
  final String gameName;
  final Duration recordedDuration;

  const SaveActivityDialog({
    super.key,
    required this.gameName,
    required this.recordedDuration,
  });

  @override
  State<SaveActivityDialog> createState() => _SaveActivityDialogState();
}

class _SaveActivityDialogState extends State<SaveActivityDialog> {
  String? _selectedName;
  List<String> _petNames = [];
  bool _isLoading = true;
  int _selectedMinutes = 5;
  final List<int> _durationOptions = [5, 10, 15, 20];
  final TextEditingController _customDurationController =
      TextEditingController();
  bool _isCustomDuration = false;

  @override
  void initState() {
    super.initState();
    _loadPets();
    // Auto-select the closest predefined duration
    int minutes = widget.recordedDuration.inMinutes;
    if (minutes < 1) minutes = 1;

    if (_durationOptions.contains(minutes)) {
      _selectedMinutes = minutes;
    } else {
      // Find closest
      int closest = _durationOptions.reduce(
        (a, b) => (a - minutes).abs() < (b - minutes).abs() ? a : b,
      );
      if ((closest - minutes).abs() > 2) {
        _isCustomDuration = true;
        _selectedMinutes = minutes;
        _customDurationController.text = minutes.toString();
      } else {
        _selectedMinutes = closest;
      }
    }
  }

  Future<void> _loadPets() async {
    final entries = await DatabaseService().getJournalEntries();
    final names = entries
        .where((e) => e.name != null && e.name!.isNotEmpty)
        .map((e) => e.name!)
        .toSet()
        .toList();

    setState(() {
      _petNames = names;
      if (_petNames.isNotEmpty) {
        _selectedName = _petNames.first;
      }
      _isLoading = false;
    });
  }

  Future<void> _saveRecord() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a pet name')),
      );
      return;
    }

    int durationToSave = _selectedMinutes;
    if (_isCustomDuration) {
      durationToSave = int.tryParse(_customDurationController.text) ?? 5;
    }

    final newTag = "${widget.gameName} (${durationToSave}m)";
    final now = DateTime.now();
    final entries = await DatabaseService().getJournalEntries();

    // Find if there is already an entry for this pet today
    final todayIndex = entries.indexWhere(
      (e) =>
          e.name == _selectedName &&
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day,
    );

    if (todayIndex != -1) {
      // Append to existing record
      final existing = entries[todayIndex];
      final updatedTags = List<String>.from(existing.activityTags)..add(newTag);

      final updatedEntry = JournalEntry(
        id: existing.id,
        date: existing.date,
        scanRecordId: existing.scanRecordId,
        weight: existing.weight,
        mealDescription: existing.mealDescription,
        activityTags: updatedTags,
        notes: existing.notes,
        photoPath: existing.photoPath,
        name: existing.name,
        age: existing.age,
        condition: existing.condition,
      );
      await DatabaseService().updateJournalEntry(updatedEntry);
    } else {
      // Create new record
      final entry = JournalEntry(
        id: const Uuid().v4(),
        date: now,
        weight: 0,
        name: _selectedName,
        activityTags: [newTag],
        notes: "",
        condition: "Happy & Active",
      );
      await DatabaseService().saveJournalEntry(entry);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity saved to Rescue Journey!'),
          backgroundColor: AppColors.seafoam,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.seafoam),
      );
    }

    return AlertDialog(
      backgroundColor: AppColors.creamWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.seafoam),
          const SizedBox(width: 8),
          Text(
            'Save Activity',
            style: const TextStyle(
              color: AppColors.cocoaBrown,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game: ${widget.gameName}',
              style: const TextStyle(
                color: AppColors.cocoaBrown,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Select Pet:',
              style: TextStyle(color: AppColors.chestnutGray, fontSize: 13),
            ),
            const SizedBox(height: 8),
            if (_petNames.isEmpty)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter pet name',
                  hintStyle: TextStyle(
                    color: AppColors.chestnutGray.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.oatMilk,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => _selectedName = val,
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.oatMilk,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedName,
                    isExpanded: true,
                    style: const TextStyle(
                      color: AppColors.cocoaBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedName = newValue;
                      });
                    },
                    items: _petNames.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 24),
            const Text(
              'Duration (minutes):',
              style: TextStyle(color: AppColors.chestnutGray, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._durationOptions.map((mins) => _buildDurationChip(mins)),
                _buildCustomDurationChip(),
              ],
            ),
            if (_isCustomDuration) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _customDurationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter minutes',
                  filled: true,
                  fillColor: AppColors.oatMilk,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixText: 'min',
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Discard',
            style: TextStyle(color: AppColors.chestnutGray),
          ),
        ),
        ElevatedButton(
          onPressed: _saveRecord,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.seafoam,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Save to Journey',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationChip(int mins) {
    final isSelected = !_isCustomDuration && _selectedMinutes == mins;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCustomDuration = false;
          _selectedMinutes = mins;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.peachFuzz : AppColors.oatMilk,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.peachFuzz : AppColors.warmGauze,
          ),
        ),
        child: Text(
          '$mins min',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.cocoaBrown,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDurationChip() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCustomDuration = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isCustomDuration ? AppColors.peachFuzz : AppColors.oatMilk,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isCustomDuration
                ? AppColors.peachFuzz
                : AppColors.warmGauze,
          ),
        ),
        child: Text(
          'Custom',
          style: TextStyle(
            color: _isCustomDuration ? Colors.white : AppColors.cocoaBrown,
            fontWeight: _isCustomDuration ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
