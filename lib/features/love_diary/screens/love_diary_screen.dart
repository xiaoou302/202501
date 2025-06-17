import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/nav_bar.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/input_utils.dart';
import '../../../shared/utils/app_strings.dart';
import '../models/relationship.dart';
import '../models/memory.dart';
import '../models/milestone.dart';
import '../widgets/love_counter.dart';
import '../widgets/milestone_card.dart';
import '../widgets/timeline_item.dart';
import '../../../routes.dart';

class LoveDiaryScreen extends StatefulWidget {
  final bool useNavBar;

  const LoveDiaryScreen({super.key, this.useNavBar = true});

  @override
  State<LoveDiaryScreen> createState() => _LoveDiaryScreenState();
}

class _LoveDiaryScreenState extends State<LoveDiaryScreen> {
  Relationship? relationship;
  List<Memory> memories = [];
  List<Milestone> milestones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load relationship data
    final relationshipJson = prefs.getString(AppConstants.prefRelationship);
    if (relationshipJson != null) {
      setState(() {
        relationship = Relationship.fromJson(
          jsonDecode(relationshipJson) as Map<String, dynamic>,
        );
      });

      // Create milestones
      _createMilestones();
    }

    // Load memories data
    final memoriesJson = prefs.getString(AppConstants.prefMemories);
    if (memoriesJson != null) {
      final List<dynamic> memoriesList =
          jsonDecode(memoriesJson) as List<dynamic>;
      setState(() {
        memories = memoriesList
            .map((item) => Memory.fromJson(item as Map<String, dynamic>))
            .toList();

        // Sort by date (newest first)
        memories.sort((a, b) => b.date.compareTo(a.date));
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _createMilestones() {
    if (relationship == null) return;

    final milestonesList = <Milestone>[];
    final now = DateTime.now();

    // Add partner's birthday milestone
    final nextPartnerBirthday = DateTime(
      now.year,
      relationship!.partnerBirthday.month,
      relationship!.partnerBirthday.day,
    );

    if (nextPartnerBirthday.isBefore(now)) {
      // If this year's birthday has passed, calculate next year's
      milestonesList.add(
        Milestone(
          title: '${relationship!.partnerName}\'s ${AppStrings.birthday}',
          date: DateTime(
            now.year + 1,
            relationship!.partnerBirthday.month,
            relationship!.partnerBirthday.day,
          ),
          type: AppConstants.milestoneBirthday,
        ),
      );
    } else {
      milestonesList.add(
        Milestone(
          title: '${relationship!.partnerName}\'s ${AppStrings.birthday}',
          date: nextPartnerBirthday,
          type: AppConstants.milestoneBirthday,
        ),
      );
    }

    // Add anniversary milestone
    final nextAnniversary = AppDateUtils.getNextAnniversaryDate(
      relationship!.anniversaryDate,
    );
    final years = nextAnniversary.year - relationship!.anniversaryDate.year;

    milestonesList.add(
      Milestone(
        title: '$years Year ${AppStrings.anniversary}',
        date: nextAnniversary,
        type: AppConstants.milestoneAnniversary,
      ),
    );

    // Add Valentine's Day milestone
    final valentineDay = DateTime(now.year, 2, 14);
    if (valentineDay.isBefore(now)) {
      milestonesList.add(
        Milestone(
          title: AppStrings.valentinesDay,
          date: DateTime(now.year + 1, 2, 14),
          type: AppConstants.milestoneValentine,
        ),
      );
    } else {
      milestonesList.add(
        Milestone(
          title: AppStrings.valentinesDay,
          date: valentineDay,
          type: AppConstants.milestoneValentine,
        ),
      );
    }

    // Sort by days left
    milestonesList.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

    setState(() {
      milestones = milestonesList;
    });
  }

  Future<void> _deleteMemory(Memory memory) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.deleteRecord),
        content: Text(AppStrings.deleteRecordConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.delete),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = prefs.getString(AppConstants.prefMemories);

    if (memoriesJson != null) {
      final List<dynamic> memoriesList =
          jsonDecode(memoriesJson) as List<dynamic>;
      final updatedMemories = memoriesList
          .map((item) => Memory.fromJson(item as Map<String, dynamic>))
          .where((m) => m.id != memory.id)
          .toList();

      await prefs.setString(
        AppConstants.prefMemories,
        jsonEncode(updatedMemories.map((m) => m.toJson()).toList()),
      );

      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (relationship == null) {
      return _buildSetupScreen();
    }

    return DismissKeyboardScaffold(
      appBar: AppBar(
        title: Text(AppStrings.loveDiary),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          if (widget.useNavBar) const AppNavBar(currentIndex: 0),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (relationship != null) _buildLoveCounter(),
        const SizedBox(height: 24),
        if (milestones.isNotEmpty) _buildMilestones(),
        if (milestones.isNotEmpty) const SizedBox(height: 24),
        _buildMemoriesHeader(),
        const SizedBox(height: 16),
        _buildMemoriesTimeline(),
      ],
    );
  }

  Widget _buildLoveCounter() {
    if (relationship == null) return const SizedBox();

    final loveDays = AppDateUtils.calculateLoveDays(
      relationship!.anniversaryDate,
    );
    final loveYears = loveDays ~/ 365;
    final hasYears = loveYears > 0;

    return Center(
      child: LoveCounter(
        days: loveDays,
        subtitle: hasYears
            ? '${loveYears} ${AppStrings.yearsInLove}'
            : AppStrings.inLove,
      ),
    );
  }

  Widget _buildMilestones() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pinkAccent),
              const SizedBox(width: 8),
              Text(
                AppStrings.importantDates,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...milestones.map(
            (milestone) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MilestoneCard(milestone: milestone),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoriesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.book, color: Colors.purpleAccent),
            const SizedBox(width: 8),
            Text(
              AppStrings.loveRecords,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GradientButton(
          text: AppStrings.addRecord,
          icon: Icons.add,
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.addMemory,
            ).then((_) => _loadData());
          },
        ),
      ],
    );
  }

  Widget _buildMemoriesTimeline() {
    if (memories.isEmpty) {
      return AppCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(AppStrings.noRecords),
          ),
        ),
      );
    }

    return AppCard(
      child: Column(
        children: memories.map((memory) {
          final isLast = memory == memories.last;
          return Dismissible(
            key: Key(memory.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppStrings.deleteRecord),
                  content: Text(AppStrings.deleteRecordConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(AppStrings.delete),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              _deleteMemory(memory);
            },
            child: TimelineItem(
              memory: memory,
              isLast: isLast,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSetupScreen() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 80, color: Colors.pinkAccent),
              const SizedBox(height: 24),
              Text(
                AppStrings.welcome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.setupPrompt,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GradientButton(
                text: AppStrings.setupRelationship,
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.setupRelationship);
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
