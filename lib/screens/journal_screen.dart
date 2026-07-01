import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';
import '../widgets/journal/journal_card.dart';
import '../widgets/journal/trend_chart.dart';
import '../models/journal_entry.dart';
import '../services/database_service.dart';

class JournalScreen extends StatefulWidget {
  final JournalEntry? initialEntry;
  const JournalScreen({super.key, this.initialEntry});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _allEntries = [];
  List<JournalEntry> _filteredEntries = [];
  List<String> _uniqueNames = [];
  String _selectedName = "All"; // "All" means show all records
  bool _isLoading = true;
  final Set<String> _expandedNames = {};

  @override
  void initState() {
    super.initState();
    _loadEntries().then((_) {
      if (widget.initialEntry != null) {
        // Show dialog automatically with passed data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAddEntryDialog(initialEntry: widget.initialEntry);
        });
      }
    });
    DatabaseService().journalUpdateNotifier.addListener(_onJournalUpdated);
  }

  @override
  void didUpdateWidget(covariant JournalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialEntry != oldWidget.initialEntry &&
        widget.initialEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddEntryDialog(initialEntry: widget.initialEntry);
      });
    }
  }

  void _onJournalUpdated() {
    if (mounted) {
      _loadEntries();
    }
  }

  @override
  void dispose() {
    DatabaseService().journalUpdateNotifier.removeListener(_onJournalUpdated);
    super.dispose();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    final entries = await DatabaseService().getJournalEntries();
    // Sort by date descending
    entries.sort((a, b) => b.date.compareTo(a.date));

    final names = entries
        .map((e) => e.name?.trim() ?? "Unknown")
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
    names.sort();

    if (mounted) {
      setState(() {
        _allEntries = entries;
        _uniqueNames = ["All", ...names];

        // Keep the selection valid
        if (!_uniqueNames.contains(_selectedName)) {
          _selectedName = "All";
        }

        _filterEntries();
        _isLoading = false;
      });
    }
  }

  void _filterEntries() {
    if (_selectedName == "All") {
      _filteredEntries = List.from(_allEntries);
    } else {
      _filteredEntries = _allEntries.where((e) {
        final name = e.name?.trim() ?? "Unknown";
        return name == _selectedName;
      }).toList();
    }
  }

  void _onNameSelected(String name) {
    setState(() {
      _selectedName = name;
      _filterEntries();
    });
  }

  void _toggleExpand(String name) {
    setState(() {
      if (_expandedNames.contains(name)) {
        _expandedNames.remove(name);
      } else {
        _expandedNames.add(name);
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.seafoam),
              SizedBox(width: 8),
              Text(
                'About Rescue Journey',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Interface Guide',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Data Mirror: A chart tracking the weight and activity trends of the selected pet.\n'
                  '• Rescue Journey: A chronological list of daily records for all or specific rescued pets.',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Core Functions',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Add Record (+): Start a new rescue journey or add a daily update.\n'
                  '• Continuous Tracking: Tap an existing record card to add a new daily entry for the same pet.\n'
                  '• Delete: Tap the trash can icon on an expanded card to permanently remove a record.\n'
                  '• Stack Mode: Multiple records of the same pet are stacked. Tap to expand.',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: AppColors.seafoam,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddEntryDialog({JournalEntry? initialEntry}) async {
    // If we have an initialEntry (from ScanScreen or previous record), we are creating a new one based on it.
    final weightController = TextEditingController(
      text: (initialEntry != null && initialEntry.weight > 0)
          ? initialEntry.weight.toString()
          : '',
    );
    final mealController = TextEditingController(
      text: initialEntry?.mealDescription ?? '',
    );
    final activityController = TextEditingController(
      text: initialEntry?.activityTags.join(', ') ?? '',
    );
    final nameController = TextEditingController(
      text: initialEntry?.name ?? '',
    );
    final ageController = TextEditingController(text: initialEntry?.age ?? '');
    final conditionController = TextEditingController(
      text: initialEntry?.condition ?? '',
    );

    File? selectedImage;
    if (initialEntry?.photoPath != null) {
      selectedImage = File(initialEntry!.photoPath!);
    }

    final picker = ImagePicker();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.creamWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Add Rescue/Daily Record',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo picker
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setStateDialog(() {
                              selectedImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.oatMilk,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.seafoam.withValues(alpha: 0.3),
                            ),
                            image: selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(selectedImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: selectedImage == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      color: AppColors.seafoam,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Upload Photo',
                                      style: TextStyle(
                                        color: AppColors.chestnutGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      const Text(
                        'Name / Identifier',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: nameController,
                        maxLength: 8,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\n')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'e.g. Fluffy',
                          filled: true,
                          fillColor: AppColors.oatMilk,
                          counterText: '', // Hide counter to keep UI clean
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Age
                      const Text(
                        'Estimated Age',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: ageController,
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g. 2 (months or years)',
                          filled: true,
                          fillColor: AppColors.oatMilk,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Condition
                      const Text(
                        'Condition',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: conditionController,
                        maxLength: 50,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\n')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'e.g. Healthy, injured leg',
                          filled: true,
                          fillColor: AppColors.oatMilk,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Weight (kg)',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: weightController,
                        maxLength: 6,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: 'e.g. 4.5',
                          filled: true,
                          fillColor: AppColors.oatMilk,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Meal Note',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: mealController,
                        maxLength: 100,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\n')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'e.g. Salmon 80g',
                          filled: true,
                          fillColor: AppColors.oatMilk,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Activities (comma separated)',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: activityController,
                        maxLength: 100,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\n')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'e.g. Walk 30m, Play',
                          filled: true,
                          fillColor: AppColors.oatMilk,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.chestnutGray),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.peachFuzz,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final weightStr = weightController.text.trim();
                    final weight = double.tryParse(weightStr) ?? 0.0;
                    final meal = mealController.text.trim();
                    final acts = activityController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    final entry = JournalEntry(
                      id: const Uuid().v4(),
                      date: DateTime.now(),
                      weight: weight,
                      mealDescription: meal.isEmpty ? null : meal,
                      activityTags: acts,
                      notes: "",
                      photoPath: selectedImage?.path,
                      name: nameController.text.trim(),
                      age: ageController.text.trim(),
                      condition: conditionController.text.trim(),
                    );

                    await DatabaseService().saveJournalEntry(entry);

                    if (mounted) {
                      Navigator.pop(context);
                      _loadEntries();
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.creamWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildGroupedEntries() {
    if (_filteredEntries.isEmpty) {
      return [
        const SizedBox(height: 24),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.creamWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.warmGauze),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.chestnutGray.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.peachFuzz,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Animals are our best friends.',
                      style: TextStyle(
                        color: AppColors.cocoaBrown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Every small act of kindness matters. Tap the + icon above to start your rescue journey. Record their daily progress and witness the miracle of love.',
                      style: TextStyle(
                        color: AppColors.chestnutGray,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mistyFoam.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco, color: AppColors.seafoam, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Adopt, don\'t shop. Be kind to strays.',
                            style: TextStyle(
                              color: AppColors.seafoam,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    }

    final grouped = <String, List<JournalEntry>>{};
    for (var e in _filteredEntries) {
      final n = e.name?.trim() ?? "Unknown";
      grouped.putIfAbsent(n, () => []).add(e);
    }

    List<Widget> widgets = [];

    for (var entry in grouped.entries) {
      final name = entry.key;
      final entriesForName = entry.value;
      final isExpanded = _expandedNames.contains(name);

      if (entriesForName.length > 1 && !isExpanded) {
        // Stacked mode
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () => _toggleExpand(name),
              child: JournalCard(
                entry: entriesForName.first,
                isStackedMode: true,
                stackCount: entriesForName.length,
              ),
            ),
          ),
        );
      } else {
        // Expanded mode or single item
        if (entriesForName.length > 1) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🐾 $name\'s Records (${entriesForName.length})',
                    style: const TextStyle(
                      color: AppColors.cocoaBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _toggleExpand(name),
                    child: const Text(
                      'Collapse',
                      style: TextStyle(
                        color: AppColors.seafoam,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        for (var e in entriesForName) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: JournalCard(
                entry: e,
                onEdit: () {
                  final prefilledForUpdate = JournalEntry(
                    id: const Uuid().v4(),
                    date: DateTime.now(),
                    weight: e.weight,
                    activityTags: [],
                    notes: "",
                    photoPath: e.photoPath,
                    name: e.name,
                    age: e.age,
                    condition: e.condition,
                  );
                  _showAddEntryDialog(initialEntry: prefilledForUpdate);
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Delete Record?'),
                      content: const Text(
                        'This will permanently delete this record. It cannot be recovered.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await DatabaseService().deleteJournalEntry(e.id);
                    if (mounted) {
                      _loadEntries();
                    }
                  }
                },
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Body Diary',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.chestnutGray),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.seafoam,
            ),
            onPressed: _showAddEntryDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mistyFoam.withValues(alpha: 0.4),
              AppColors.pageBackground,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.seafoam),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrendChart(
                        selectedName: _selectedName,
                        entries: _allEntries,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Rescue Journey',
                            style: TextStyle(
                              color: AppColors.cocoaBrown,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (_uniqueNames.length > 1)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.creamWhite,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.seafoam.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.seafoam.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedName,
                                      isExpanded: false,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: AppColors.seafoam,
                                        size: 20,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.seafoam,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _onNameSelected(newValue);
                                        }
                                      },
                                      items: _uniqueNames
                                          .map<DropdownMenuItem<String>>((
                                            String value,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: SizedBox(
                                                width:
                                                    80, // Prevent dropdown text from expanding indefinitely
                                                child: Text(
                                                  value,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._buildGroupedEntries(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
