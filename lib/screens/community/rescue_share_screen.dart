import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../models/rescue_story.dart';
import 'rescue_detail_screen.dart';

class RescueShareScreen extends StatefulWidget {
  const RescueShareScreen({super.key});

  @override
  State<RescueShareScreen> createState() => _RescueShareScreenState();
}

class _RescueShareScreenState extends State<RescueShareScreen> {
  List<RescueStory> _activeStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final deletedIds =
        prefs.getStringList(AppConstants.deletedStoriesKey) ?? [];

    setState(() {
      _activeStories = mockRescueStories
          .where((story) => !deletedIds.contains(story.id))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteStory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final deletedIds =
        prefs.getStringList(AppConstants.deletedStoriesKey) ?? [];

    if (!deletedIds.contains(id)) {
      deletedIds.add(id);
      await prefs.setStringList(AppConstants.deletedStoriesKey, deletedIds);
    }

    setState(() {
      _activeStories.removeWhere((story) => story.id == id);
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: const Row(
            children: [
              Icon(Icons.volunteer_activism, color: AppColors.peachFuzz),
              SizedBox(width: 8),
              Text(
                'About',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          content: const Text(
            'Welcome to Rescue Stories!\n\nThis is a warm place to discover and share heartwarming moments between rescuers and their beloved pets.\n\nFeatures:\n• Browse authentic rescue journeys.\n• Long-press any story card to Report or Delete it.\n\nThank you for supporting stray animal rescue!',
            style: TextStyle(
              color: AppColors.chestnutGray,
              height: 1.6,
              fontSize: 15,
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
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(RescueStory story) {
    String selectedType = 'Inappropriate Content';
    final TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            backgroundColor: AppColors.creamWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: const Text(
              'Report Story',
              style: TextStyle(
                color: AppColors.cocoaBrown,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reason',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        isExpanded: true,
                        dropdownColor: AppColors.creamWhite,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.chestnutGray,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.chestnutGray.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.chestnutGray.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: AppColors.seafoam,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        items:
                            [
                              'Spam or Scam',
                              'Inappropriate Content',
                              'Other',
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                    color: AppColors.cocoaBrown,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) =>
                            setDialogState(() => selectedType = value!),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Details',
                        style: TextStyle(
                          color: AppColors.chestnutGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: reportController,
                        maxLines: 4,
                        style: const TextStyle(
                          color: AppColors.cocoaBrown,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Please provide more details...',
                          hintStyle: TextStyle(
                            color: AppColors.chestnutGray.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.chestnutGray.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.chestnutGray.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: AppColors.seafoam,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.peachFuzz,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Thank you for reporting. We will verify and process it within 24 hours.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: AppColors.seafoam,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(20),
                    ),
                  );
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsBottomSheet(RescueStory story) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.creamWhite,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.cocoaBrown.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.chestnutGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.peachFuzz.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.report_problem_outlined,
                        color: AppColors.peachFuzz,
                      ),
                    ),
                    title: const Text(
                      'Report Story',
                      style: TextStyle(
                        color: AppColors.cocoaBrown,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showReportDialog(story);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Divider(height: 24, color: AppColors.mistyFoam),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                    title: const Text(
                      'Delete Story',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmDialog(story);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(RescueStory story) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: const Text(
            'Delete Story',
            style: TextStyle(
              color: AppColors.cocoaBrown,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          content: const Text(
            'Are you sure you want to permanently delete this story? This action cannot be undone.',
            style: TextStyle(
              color: AppColors.chestnutGray,
              height: 1.6,
              fontSize: 15,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.chestnutGray,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                _deleteStory(story.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Story deleted permanently.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: AppColors.chestnutGray,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(20),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: const Text(
          'Rescue Stories',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.chestnutGray.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                color: AppColors.chestnutGray,
                size: 20,
              ),
            ),
            onPressed: _showHelpDialog,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.seafoam),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight +
                        24,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverToBoxAdapter(child: _buildBanner()),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 24)),
                if (_activeStories.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          'No stories available.',
                          style: TextStyle(
                            color: AppColors.chestnutGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final story = _activeStories[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 28.0),
                          child: _buildStoryCard(story),
                        );
                      }, childCount: _activeStories.length),
                    ),
                  ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 120),
                ), // Space for bottom nav
              ],
            ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.morningPeach, AppColors.peachFuzz],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.peachFuzz.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share Love,\nSave Lives',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Discover heartwarming rescue stories.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(RescueStory story) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RescueDetailScreen(story: story),
          ),
        );
      },
      onLongPress: () => _showOptionsBottomSheet(story),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.chestnutGray.withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
          border: Border.all(color: Colors.white, width: 2), // Glossy edge
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Glassmorphism Overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: 'image_${story.id}',
                    child: Image.asset(
                      story.imageUrl,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Glassmorphism Rescuer Tag
                  Positioned(
                    top: 16,
                    left: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                story.rescuerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.seafoam.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          story.petName,
                          style: const TextStyle(
                            color: AppColors.seafoam,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          story.petType,
                          style: const TextStyle(
                            color: AppColors.chestnutGray,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    story.story,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.cocoaBrown,
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.chestnutGray,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_formatDate(story.date)} • Shared a rescue',
                        style: TextStyle(
                          color: AppColors.chestnutGray.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
