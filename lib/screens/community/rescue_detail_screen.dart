import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/rescue_story.dart';
import 'package:intl/intl.dart';

class RescueDetailScreen extends StatelessWidget {
  final RescueStory story;

  const RescueDetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 420.0,
      pinned: true,
      backgroundColor: AppColors.creamWhite,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'image_${story.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(story.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      transform: Matrix4.translationValues(0.0, -40.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28.0, 64.0, 28.0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rescuer Info Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.chestnutGray.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.peachFuzz.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: AppColors.peachFuzz,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rescuer: ${story.rescuerName}',
                        style: const TextStyle(
                          color: AppColors.cocoaBrown,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMMM d, yyyy').format(story.date),
                        style: const TextStyle(
                          color: AppColors.chestnutGray,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Pet Name & Type
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  story.petName,
                  style: const TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.w900,
                    fontSize: 36,
                    letterSpacing: -0.5,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      story.petType,
                      style: const TextStyle(
                        color: AppColors.seafoam,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Pet Info Card
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.mistyFoam.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: AppColors.seafoam.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.medical_information_outlined,
                        color: AppColors.seafoam,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Condition Found',
                        style: TextStyle(
                          color: AppColors.cocoaBrown,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    story.condition,
                    style: const TextStyle(
                      color: AppColors.cocoaBrown,
                      fontSize: 16,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Story Section
            const Row(
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.peachFuzz,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  'Rescue Journey',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              story.story,
              style: const TextStyle(
                color: AppColors.chestnutGray,
                fontSize: 17,
                height: 1.9,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
