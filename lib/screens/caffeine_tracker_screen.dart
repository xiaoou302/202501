import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/drink.dart';
import '../repositories/drink_repository.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/caffeine_history_chart.dart';
import '../widgets/quick_add_drink.dart';
import '../widgets/radial_progress.dart';

class CaffeineTrackerScreen extends StatefulWidget {
  const CaffeineTrackerScreen({super.key});

  @override
  State<CaffeineTrackerScreen> createState() => CaffeineTrackerScreenState();
}

class CaffeineTrackerScreenState extends State<CaffeineTrackerScreen>
    with SingleTickerProviderStateMixin {
  final DrinkRepository _drinkRepository = DrinkRepository();
  List<Drink> _allDrinks = [];
  List<Drink> _todayDrinks = [];
  double _metabolismPercentage = 100;
  int _todayTotalIntake = 0;
  DateTime _estimatedMetabolismTime = DateTime.now();
  bool _isLoading = true;
  bool _showHistory = false;
  late TabController _tabController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _showHistory = _tabController.index == 1;
      });
    });
    _loadDrinks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Load drinks data
  Future<void> _loadDrinks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allDrinks = await _drinkRepository.getAllDrinks();
      final todayDrinks = await _drinkRepository.getTodayDrinks();

      setState(() {
        _allDrinks = allDrinks;
        _todayDrinks = todayDrinks;
        _metabolismPercentage = CaffeineHelper.calculateMetabolismPercentage(
          allDrinks,
        );
        _todayTotalIntake = CaffeineHelper.calculateTodayTotalIntake(
          todayDrinks,
        );
        _estimatedMetabolismTime = CaffeineHelper.estimateFullMetabolismTime(
          allDrinks,
        );
      });
    } catch (e) {
      // Handle error
      debugPrint('Failed to load drinks: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Add drink record
  Future<void> _addDrink(Drink drink) async {
    try {
      await _drinkRepository.addDrink(drink);
      _loadDrinks(); // Reload data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${drink.name}'),
          backgroundColor: AppColors.hologramPurple,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Failed to add drink: $e');
    }
  }

  // Delete drink record
  Future<void> _deleteDrink(Drink drink) async {
    try {
      await _drinkRepository.removeDrink(drink);
      _loadDrinks(); // Reload data
    } catch (e) {
      debugPrint('Failed to delete drink: $e');
    }
  }

  // Show add drink dialog - modified to be public so it can be called from HomeScreen
  void showAddDrinkDialog() {
    final nameController = TextEditingController();
    final volumeController = TextEditingController();
    final caffeineController = TextEditingController();
    String selectedDrink = 'Americano';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Auto-fill caffeine content when selecting preset drinks
            void updateCaffeineContent() {
              final volume = int.tryParse(volumeController.text) ?? 0;
              final caffeinePerMl =
                  CaffeineConstants.caffeineContent[selectedDrink] ?? 0;
              final totalCaffeine = (volume * caffeinePerMl).round();
              caffeineController.text = totalCaffeine.toString();
            }

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: AlertDialog(
                backgroundColor: AppColors.deepSpace,
                title: const Text('Add Drink'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drink selection
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: AppColors.nebulaPurple,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedDrink,
                            decoration: InputDecoration(
                              labelText: 'Select Drink',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: AppColors.deepSpace.withOpacity(0.8),
                              labelStyle: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            dropdownColor: AppColors.nebulaPurple,
                            style: const TextStyle(color: Colors.white),
                            items: CaffeineConstants.caffeineContent.keys.map((
                              String drink,
                            ) {
                              return DropdownMenuItem<String>(
                                value: drink,
                                child: Text(drink),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedDrink = newValue;
                                  nameController.text = newValue;
                                  updateCaffeineContent();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Volume input
                        TextFormField(
                          controller: volumeController,
                          decoration: InputDecoration(
                            labelText: 'Volume (ml)',
                            border: const OutlineInputBorder(),
                            suffixText: 'ml',
                            filled: true,
                            fillColor: AppColors.deepSpace.withOpacity(0.8),
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4), // Max 4 digits
                          ],
                          onChanged: (_) => updateCaffeineContent(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a volume';
                            }
                            final volume = int.tryParse(value);
                            if (volume == null || volume <= 0) {
                              return 'Please enter a valid volume';
                            }
                            if (volume > 2000) {
                              return 'Volume cannot exceed 2000ml';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Caffeine content input
                        TextFormField(
                          controller: caffeineController,
                          decoration: InputDecoration(
                            labelText: 'Caffeine Content (mg)',
                            border: const OutlineInputBorder(),
                            suffixText: 'mg',
                            filled: true,
                            fillColor: AppColors.deepSpace.withOpacity(0.8),
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4), // Max 4 digits
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter caffeine content';
                            }
                            final caffeine = int.tryParse(value);
                            if (caffeine == null || caffeine <= 0) {
                              return 'Please enter valid caffeine content';
                            }
                            if (caffeine > 1000) {
                              return 'Caffeine content cannot exceed 1000mg';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Create new drink record
                        final name = nameController.text.isNotEmpty
                            ? nameController.text
                            : selectedDrink;
                        final volume = int.tryParse(volumeController.text) ?? 0;
                        final caffeine =
                            int.tryParse(caffeineController.text) ?? 0;

                        final drink = Drink(
                          name: name,
                          volume: volume,
                          caffeine: caffeine,
                          time: DateTime.now(),
                          icon: CaffeineConstants.drinkIcons[selectedDrink] ??
                              'mug-hot',
                          category: CaffeineConstants
                                  .drinkCategories[selectedDrink] ??
                              'Other',
                        );

                        _addDrink(drink);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context)
          .unfocus(), // Dismiss keyboard when tapping outside
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 20),

                    // Tab bar
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Today'),
                        Tab(text: 'History'),
                      ],
                      indicatorColor: AppColors.electricBlue,
                      labelColor: AppColors.electricBlue,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      indicatorSize: TabBarIndicatorSize.label,
                    ),
                    const SizedBox(height: 20),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Today's intake page
                          _buildTodayTab(),

                          // History page
                          _buildHistoryTab(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // Build today's tab
  Widget _buildTodayTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // Metabolism progress
        _buildMetabolismProgress(),
        const SizedBox(height: 20),

        // Today's intake
        _buildDailyIntake(),
        const SizedBox(height: 20),

        // Quick add
        QuickAddDrink(onDrinkAdded: _addDrink),
        const SizedBox(height: 20),

        // Drink records
        _buildDrinkRecords(),
      ],
    );
  }

  // Build history tab
  Widget _buildHistoryTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // History chart
        CaffeineHistoryChart(drinks: _allDrinks),
        const SizedBox(height: 20),

        // Health tips
        _buildHealthTips(),
      ],
    );
  }

  // Build header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          AppStrings.caffeineTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.plus,
              color: AppColors.electricBlue,
              size: 20,
            ),
            onPressed: showAddDrinkDialog,
          ),
        ),
      ],
    );
  }

  // Build metabolism progress
  Widget _buildMetabolismProgress() {
    return Center(
      child: RadialProgress(
        percentage: _metabolismPercentage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppStrings.caffeineMetabolizing,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_metabolismPercentage.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              AppStrings.caffeineEstimatedTime,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(_estimatedMetabolismTime),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Build daily intake
  Widget _buildDailyIntake() {
    // Calculate safe range percentage
    final safePercentage =
        (_todayTotalIntake / CaffeineConstants.safeDailyIntake * 100)
            .clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.caffeineDailyIntake,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_todayTotalIntake}mg',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _todayTotalIntake > CaffeineConstants.safeDailyIntake
                      ? Colors.red
                      : AppColors.electricBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.7 *
                      safePercentage /
                      100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.electricBlue,
                        AppColors.hologramPurple,
                        const Color(0xFFff4d94),
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.caffeineSafeRange,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _todayTotalIntake > CaffeineConstants.safeDailyIntake
                    ? 'Exceeded safe range!'
                    : AppStrings.caffeineMaxDaily,
                style: TextStyle(
                  fontSize: 12,
                  color: _todayTotalIntake > CaffeineConstants.safeDailyIntake
                      ? Colors.red
                      : Colors.grey,
                  fontWeight:
                      _todayTotalIntake > CaffeineConstants.safeDailyIntake
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build drink records
  Widget _buildDrinkRecords() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.caffeineDrinkRecords,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton.icon(
                    icon: const Icon(
                      FontAwesomeIcons.plus,
                      size: 14,
                    ),
                    label: const Text('Add'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.electricBlue,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    onPressed: showAddDrinkDialog,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.hologramPurple.withOpacity(0.2),
          ),
          SizedBox(
            height: 300,
            child: _todayDrinks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.mugSaucer,
                          color: Colors.grey,
                          size: 40,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No drinks recorded today',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _todayDrinks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final drink = _todayDrinks[index];
                      return _buildDrinkItem(drink);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Build drink item
  Widget _buildDrinkItem(Drink drink) {
    // Choose color based on drink category
    Color categoryColor;
    switch (drink.category) {
      case 'Coffee':
        categoryColor = AppColors.electricBlue;
        break;
      case 'Tea':
        categoryColor = AppColors.hologramPurple;
        break;
      case 'Energy Drinks':
        categoryColor = const Color(0xFFff4d94);
        break;
      default:
        categoryColor = Colors.amber;
    }

    // Build icon
    IconData iconData;
    switch (drink.icon) {
      case 'mug-hot':
        iconData = FontAwesomeIcons.mugHot;
        break;
      case 'bolt':
        iconData = FontAwesomeIcons.bolt;
        break;
      case 'glass':
        iconData = FontAwesomeIcons.glassWater;
        break;
      default:
        iconData = FontAwesomeIcons.mugHot;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.nebulaPurple.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [categoryColor, categoryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(iconData, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),

          // Drink info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drink.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateTimeHelper.formatTime(drink.time)} · ${drink.volume}ml',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Caffeine content
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${drink.caffeine}mg',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: categoryColor,
              ),
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            color: Colors.white.withOpacity(0.5),
            onPressed: () => _deleteDrink(drink),
          ),
        ],
      ),
    );
  }

  // Build health tips
  Widget _buildHealthTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                FontAwesomeIcons.lightbulb,
                color: AppColors.hologramPurple,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Health Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Health tips content
          _buildTipItem(
            'Safe Intake',
            'Most healthy adults should limit caffeine intake to 400mg per day.',
            FontAwesomeIcons.shieldHalved,
          ),
          const SizedBox(height: 12),

          _buildTipItem(
            'Half-life',
            'Caffeine has a half-life of 5-6 hours, meaning half still remains in your body 6 hours after consumption.',
            FontAwesomeIcons.hourglassHalf,
          ),
          const SizedBox(height: 12),

          _buildTipItem(
            'Precautions',
            'Pregnant or nursing women and those sensitive to caffeine should reduce intake. Avoid caffeine after 6 PM for better sleep.',
            FontAwesomeIcons.circleExclamation,
          ),
        ],
      ),
    );
  }

  // Build tip item
  Widget _buildTipItem(String title, String content, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.nebulaPurple.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.electricBlue, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
