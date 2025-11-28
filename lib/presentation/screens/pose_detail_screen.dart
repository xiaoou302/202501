import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/pose_model.dart';

class PoseDetailScreen extends StatefulWidget {
  final Pose pose;
  final VoidCallback? onDelete;
  final bool showMenu;

  const PoseDetailScreen({
    super.key,
    required this.pose,
    this.onDelete,
    this.showMenu = true,
  });

  @override
  State<PoseDetailScreen> createState() => _PoseDetailScreenState();
}

class _PoseDetailScreenState extends State<PoseDetailScreen> {
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadFollowingStatus();
  }

  Future<void> _loadFollowingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'following_${widget.pose.author.id}';
    setState(() {
      _isFollowing = prefs.getBool(key) ?? false;
    });
  }

  Future<void> _saveFollowingStatus(bool isFollowing) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'following_${widget.pose.author.id}';
    await prefs.setBool(key, isFollowing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                _buildAuthorInfo(),
                _buildProfessionalProfile(),
                _buildCaption(),
                _buildTags(),
                _buildStats(),
               
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppConstants.ebony.withValues(alpha: 0.95),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConstants.graphite.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppConstants.offWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: widget.showMenu ? [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.graphite.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppConstants.offWhite, size: 22),
            color: AppConstants.graphite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            offset: const Offset(0, 50),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.offWhite.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.flag_rounded, color: AppConstants.offWhite, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Report',
                      style: TextStyle(
                        color: AppConstants.offWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                height: 1,
                enabled: false,
                child: Divider(color: AppConstants.midGray, height: 1),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.theatreRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_rounded, color: AppConstants.theatreRed, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Delete & Block User',
                      style: TextStyle(
                        color: AppConstants.theatreRed,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ] : [],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'report':
        _showReportDialog(context);
        break;
      case 'delete':
        _showDeleteConfirmDialog(context);
        break;
    }
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _ReportDialog(
        authorName: widget.pose.author.displayName,
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.graphite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.theatreRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.block_rounded,
                  color: AppConstants.theatreRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Delete & Block User',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will:',
                style: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '• Delete this content\n'
                '• Block ${widget.pose.author.displayName}\n'
                '• Hide all their future content\n'
                '• This action cannot be undone',
                style: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppConstants.midGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                
                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'User Blocked & Content Deleted',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.pose.author.displayName} has been blocked. You won\'t see their content anymore.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppConstants.theatreRed,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 4),
                    padding: const EdgeInsets.all(16),
                  ),
                );
                
                Navigator.pop(context, 'delete'); // Return to previous screen
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: AppConstants.theatreRed,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete & Block',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'pose_${widget.pose.id}',
      child: Stack(
        children: [
          Image.asset(
            widget.pose.imageUrl,
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.graphite,
                      AppConstants.ebony,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.photo_library_rounded, size: 80, color: AppConstants.midGray),
                ),
              );
            },
          ),
          // Gradient overlay for better content readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppConstants.ebony.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.energyYellow.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.energyYellow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.energyYellow,
                  AppConstants.theatreRed,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.energyYellow.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.transparent,
              child: Text(
                widget.pose.author.displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.pose.author.displayName,
                        style: const TextStyle(
                          color: AppConstants.offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppConstants.energyYellow,
                            AppConstants.theatreRed,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, color: Colors.white, size: 12),
                          SizedBox(width: 3),
                          Text(
                            'PRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '@${widget.pose.author.username}',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _isFollowing
              ? ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isFollowing = false;
                    });
                    await _saveFollowingStatus(false);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text('Unfollowed ${widget.pose.author.displayName}'),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppConstants.graphite,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.energyYellow,
                    foregroundColor: AppConstants.ebony,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.star_rounded, size: 18),
                  label: const Text(
                    'Following',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              : OutlinedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isFollowing = true;
                    });
                    await _saveFollowingStatus(true);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppConstants.energyYellow, size: 20),
                              const SizedBox(width: 8),
                              Text('Following ${widget.pose.author.displayName}'),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppConstants.graphite,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppConstants.energyYellow,
                    side: const BorderSide(color: AppConstants.energyYellow, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(
                    'Follow',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    if (widget.pose.caption.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        widget.pose.caption,
        style: const TextStyle(
          color: AppConstants.offWhite,
          fontSize: 16,
          height: 1.7,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildTags() {
    if (widget.pose.tags.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tag_rounded,
                size: 18,
                color: AppConstants.midGray.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 8),
              Text(
                'Tags',
                style: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.pose.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.energyYellow.withValues(alpha: 0.2),
                      AppConstants.theatreRed.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.energyYellow.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: AppConstants.energyYellow,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.graphite.withValues(alpha: 0.5),
              AppConstants.graphite.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppConstants.midGray.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatButton(
              icon: Icons.favorite_rounded,
              count: widget.pose.likesCount,
              label: 'Likes',
              onTap: () {},
            ),
            Container(
              width: 1,
              height: 50,
              color: AppConstants.midGray.withValues(alpha: 0.2),
            ),
            _buildStatButton(
              icon: Icons.chat_bubble_rounded,
              count: 12,
              label: 'Comments',
              onTap: () {},
            ),
            Container(
              width: 1,
              height: 50,
              color: AppConstants.midGray.withValues(alpha: 0.2),
            ),
            _buildStatButton(
              icon: Icons.bookmark_rounded,
              count: 89,
              label: 'Saves',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatButton({
    required IconData icon,
    required int count,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.energyYellow.withValues(alpha: 0.2),
                  AppConstants.theatreRed.withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppConstants.energyYellow, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppConstants.midGray.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalProfile() {
    final profile = _getProfessionalProfile();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.graphite.withValues(alpha: 0.6),
              AppConstants.graphite.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppConstants.energyYellow.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppConstants.energyYellow.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppConstants.energyYellow,
                    AppConstants.theatreRed,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.energyYellow.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Professional Dancer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              profile['bio']!,
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 15,
                height: 1.7,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppConstants.energyYellow,
                        AppConstants.theatreRed,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Achievements',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...profile['achievements']!.split('|').map((achievement) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.energyYellow.withValues(alpha: 0.3),
                            AppConstants.theatreRed.withValues(alpha: 0.3),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.energyYellow,
                              AppConstants.theatreRed,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        achievement.trim(),
                        style: TextStyle(
                          color: AppConstants.midGray.withValues(alpha: 0.9),
                          fontSize: 14,
                          height: 1.5,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getProfessionalProfile() {
    switch (widget.pose.author.id) {
      case 'pro1':
        return {
          'bio': 'Emma Swan is a Principal Dancer at the Royal Ballet Company with over 15 years of professional experience. She specializes in classical ballet and has performed lead roles in Swan Lake, Giselle, and The Nutcracker.',
          'achievements': 'Prix de Lausanne Winner 2010|Royal Ballet Company Principal since 2018|Performed at Royal Opera House 200+ times|Guest artist at Bolshoi Ballet|Featured in Dance Magazine "30 Under 30"',
        };
      case 'pro2':
        return {
          'bio': 'Alex Rivera is an acclaimed contemporary choreographer and dancer with the Alvin Ailey American Dance Theater. Known for innovative fusion of modern and traditional techniques.',
          'achievements': 'Alvin Ailey Company Member since 2015|Choreographed 12 original pieces|Bessie Award Winner 2022|Taught masterclasses in 25 countries|Collaborated with Cirque du Soleil',
        };
      case 'pro3':
        return {
          'bio': 'Michael Chen is the 2023 World Hip Hop Dance Championship winner. A pioneer in urban dance, he has revolutionized battle culture with his unique style.',
          'achievements': 'World Hip Hop Champion 2023|Red Bull BC One Finalist 3 times|Choreographed for BTS and Blackpink|Founded "Urban Legends" dance crew|Over 2M YouTube subscribers',
        };
      case 'pro4':
        return {
          'bio': 'Sarah Johnson is a Broadway performer currently starring in Hamilton. With a background in jazz and musical theatre, she brings energy and precision to every performance.',
          'achievements': 'Hamilton Cast Member since 2021|Performed in 8 Broadway shows|Tony Award Nominee 2023|Trained at Juilliard School|Featured in "Broadway: The Next Generation"',
        };
      case 'pro5':
        return {
          'bio': 'David Martinez is an Olympic breaking athlete representing Team USA. A Red Bull BC One champion, he\'s at the forefront of breaking\'s Olympic debut.',
          'achievements': 'Red Bull BC One World Champion 2022|Olympic Team USA 2024|Battle of the Year Winner|Guinness World Record holder (most windmills)|Sponsored by Nike and Red Bull',
        };
      case 'pro6':
        return {
          'bio': 'Isabella García is a renowned flamenco soloist from Seville. She preserves and innovates traditional Spanish dance, performing at major festivals worldwide.',
          'achievements': 'Seville Dance Academy Principal|Performed at Bienal de Flamenco 10 times|Grammy-nominated album collaboration|Taught flamenco to 5000+ students|Cultural Ambassador of Andalusia',
        };
      case 'pro7':
        return {
          'bio': 'James Wilson is a tap dance master who has graced Broadway stages for over 20 years. His rhythmic innovations have influenced a new generation of tap dancers.',
          'achievements': 'Broadway performer for 20+ years|Choreographed "Tap Revolution" show|Astaire Award Winner 2020|Performed with Savion Glover|Founded NYC Tap Academy',
        };
      case 'pro8':
        return {
          'bio': 'Yuki Tanaka is a butoh performer from Tokyo, specializing in this unique Japanese dance form. Her performances explore the boundaries between dance and theatre.',
          'achievements': 'Tokyo Dance Theatre Principal|Performed at 50+ international festivals|Collaborated with Pina Bausch Company|Featured in "Art of Butoh" documentary|Japan Cultural Medal recipient',
        };
      case 'pro9':
        return {
          'bio': 'María Rodriguez is an Argentine tango champion from Buenos Aires. She has won multiple world championships and teaches tango globally.',
          'achievements': 'World Tango Champion 2019, 2021|Performed at Teatro Colón 100+ times|Taught in 40 countries|Founded "Tango Pasión" school|Featured in "Tango Fire" tour',
        };
      case 'pro10':
        return {
          'bio': 'André Silva is a Capoeira Mestre from Brazil with 25 years of experience. He combines martial arts, dance, and acrobatics in mesmerizing performances.',
          'achievements': 'Capoeira Mestre since 2010|Founded 3 capoeira schools|Performed at Olympics Opening Ceremony|Trained 10,000+ students worldwide|Brazilian Cultural Ambassador',
        };
      case 'pro11':
        return {
          'bio': 'Nina Petrov is a principal dancer with the Martha Graham Dance Company. She embodies the Graham technique and has performed globally.',
          'achievements': 'Martha Graham Company Principal|Performed in 30 countries|Guggenheim Fellowship recipient|Choreographed 8 original works|Featured in "Modern Masters" series',
        };
      case 'pro12':
        return {
          'bio': 'Raj Kapoor is a leading Bollywood choreographer who has worked on over 50 films. His innovative choreography blends traditional and contemporary styles.',
          'achievements': 'Choreographed 50+ Bollywood films|Filmfare Award Winner 3 times|Worked with Shah Rukh Khan, Deepika Padukone|Founded "Bollywood Dreams" academy|10M Instagram followers',
        };
      case 'pro13':
        return {
          'bio': 'Sophie Laurent is a lyrical dance specialist with the Paris Opera Ballet. Her emotional performances have captivated audiences worldwide.',
          'achievements': 'Paris Opera Ballet Soloist|Performed at Palais Garnier 150+ times|Prix Benois de la Danse Nominee|Guest artist at Royal Ballet|Featured in "Dance Europe" magazine',
        };
      case 'pro14':
        return {
          'bio': 'Carlos Mendez is a salsa world champion from Cali, Colombia. Known as the "Salsa King," he has revolutionized salsa performance and teaching.',
          'achievements': 'World Salsa Champion 2018, 2020, 2022|Performed at 100+ international festivals|Founded "Salsa Caleña" school|Choreographed for "Dancing with the Stars"|5M TikTok followers',
        };
      case 'pro15':
        return {
          'bio': 'Anna Kowalski is a ballroom dance champion who won the prestigious Blackpool Dance Festival. She excels in all standard and Latin dances.',
          'achievements': 'Blackpool Dance Festival Champion|UK National Champion 5 times|Performed on "Strictly Come Dancing"|Trained 50+ competition couples|International adjudicator',
        };
      case 'pro16':
        return {
          'bio': 'Kevin Brown is a krump pioneer from Los Angeles. He has been instrumental in bringing krump from the streets to mainstream recognition.',
          'achievements': 'Krump pioneer since 2005|Featured in "Rize" documentary|Choreographed for Kendrick Lamar|Founded "Krump Kings" collective|Taught at Juilliard and USC',
        };
      case 'pro17':
        return {
          'bio': 'Mei Lin is a Chinese classical dance master from Beijing Dance Academy. She preserves ancient techniques while creating contemporary interpretations.',
          'achievements': 'Beijing Dance Academy Principal|Performed for Chinese President|Plum Blossom Award Winner|Choreographed for Beijing Olympics|Cultural Heritage Ambassador',
        };
      case 'pro18':
        return {
          'bio': 'Layla Hassan is a belly dance champion from Cairo. She has won multiple international competitions and teaches the art of Middle Eastern dance.',
          'achievements': 'Cairo Dance Festival Champion 2019, 2021|Performed in 35 countries|Founded "Desert Rose" academy|Featured in National Geographic|Trained 8000+ students',
        };
      case 'pro19':
        return {
          'bio': 'Lucas Santos is the lead dancer for Rio Carnival. His samba performances embody the spirit and energy of Brazilian culture.',
          'achievements': 'Rio Carnival Lead Dancer 10 years|Performed for 2M+ spectators|Choreographed for 5 samba schools|Featured in "Carnival!" documentary|Brazilian Tourism Ambassador',
        };
      case 'pro20':
        return {
          'bio': 'Elena Volkov is the director of a Russian folk dance ensemble. She preserves traditional Russian dance while touring internationally.',
          'achievements': 'Ensemble Director since 2015|Performed in 45 countries|Russian State Prize recipient|Choreographed 20 traditional pieces|Trained at Bolshoi Academy',
        };
      default:
        return {
          'bio': 'Professional dancer with years of experience and dedication to the art.',
          'achievements': 'Multiple performances|Trained extensively|Passionate about dance',
        };
    }
  }



  List<Map<String, String>> _getCommentsForPose() {
    // 根据作者ID返回不同的评论
    switch (widget.pose.author.id) {
      case 'pro1': // Emma Swan - Ballet
        return [
          {
            'name': 'Alex Rivera',
            'username': '@alex_contemporary',
            'text': 'Your lines are absolutely stunning! The extension in this arabesque is perfection! 🩰✨',
          },
          {
            'name': 'Michael Chen',
            'username': '@mike_hiphop',
            'text': 'Even as a hip hop dancer, I can appreciate this level of technique. Respect! 🙌',
          },
          {
            'name': 'Sarah Johnson',
            'username': '@sarah_jazz',
            'text': 'This is what dedication looks like! How long did it take to achieve this balance?',
          },
          {
            'name': 'Sophie Laurent',
            'username': '@sophie_lyrical',
            'text': 'The grace and elegance in every movement! You inspire me every day! 💕',
          },
        ];
      case 'pro2': // Alex Rivera - Contemporary
        return [
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'The fluidity in your movement is mesmerizing! Contemporary at its finest 💫',
          },
          {
            'name': 'David Martinez',
            'username': '@david_breaking',
            'text': 'Love how you blend different styles! This flow is incredible! 🔥',
          },
          {
            'name': 'Nina Petrov',
            'username': '@nina_graham',
            'text': 'Your interpretation of Graham technique is beautiful! So much emotion! 🎭',
          },
        ];
      case 'pro3': // Michael Chen - Hip Hop
        return [
          {
            'name': 'David Martinez',
            'username': '@david_breaking',
            'text': 'Yo! That freeze is SICK! The control you have is insane! 💪🔥',
          },
          {
            'name': 'Kevin Brown',
            'username': '@kevin_krump',
            'text': 'The power and precision in your moves! Hip hop excellence right here! 👏',
          },
          {
            'name': 'Alex Rivera',
            'username': '@alex_contemporary',
            'text': 'Your musicality is incredible! Love the energy you bring! ⚡',
          },
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'Different style but same passion! Your rhythm is on point! 🎵',
          },
        ];
      case 'pro4': // Sarah Johnson - Jazz/Broadway
        return [
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'Your stage presence is incredible! Jazz hands on point! ✨👐',
          },
          {
            'name': 'Michael Chen',
            'username': '@mike_hiphop',
            'text': 'That smile! That energy! You light up the stage! 🌟',
          },
          {
            'name': 'James Wilson',
            'username': '@james_tap',
            'text': 'Broadway magic! Your performance quality is outstanding! 🎭✨',
          },
        ];
      case 'pro5': // David Martinez - Breaking
        return [
          {
            'name': 'Michael Chen',
            'username': '@mike_hiphop',
            'text': 'Bro! That breaking technique is fire! Your freezes are legendary! 🔥💯',
          },
          {
            'name': 'Kevin Brown',
            'username': '@kevin_krump',
            'text': 'The athleticism required for this is insane! So impressive! 💪',
          },
          {
            'name': 'André Silva',
            'username': '@andre_capoeira',
            'text': 'Your acrobatic skills remind me of capoeira! Amazing control! 🤸',
          },
          {
            'name': 'Sarah Johnson',
            'username': '@sarah_broadway',
            'text': 'The strength and precision! Olympic-level performance! 🏅',
          },
        ];
      case 'pro6': // Isabella García - Flamenco
        return [
          {
            'name': 'María Rodriguez',
            'username': '@maria_tango',
            'text': 'The passion in your flamenco is breathtaking! Olé! 💃🔥',
          },
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'Your footwork is incredible! The rhythm, the fire! Hermosa! ❤️',
          },
          {
            'name': 'Layla Hassan',
            'username': '@layla_belly',
            'text': 'The emotion you convey through movement is powerful! Beautiful! 🌹',
          },
        ];
      case 'pro7': // James Wilson - Tap
        return [
          {
            'name': 'Sarah Johnson',
            'username': '@sarah_broadway',
            'text': 'Your tap rhythms are mesmerizing! Broadway legend! 👞✨',
          },
          {
            'name': 'Michael Chen',
            'username': '@mike_hiphop',
            'text': 'The musicality in your feet! This is pure art! 🎵',
          },
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'Rhythm master! Your timing is absolutely perfect! 🥁',
          },
        ];
      case 'pro8': // Yuki Tanaka - Butoh
        return [
          {
            'name': 'Alex Rivera',
            'username': '@alex_contemporary',
            'text': 'The depth and intensity of butoh! Your performance is haunting and beautiful! 🎭',
          },
          {
            'name': 'Nina Petrov',
            'username': '@nina_graham',
            'text': 'Such powerful storytelling through movement! Absolutely captivating! 🌙',
          },
          {
            'name': 'Mei Lin',
            'username': '@mei_chinese',
            'text': 'The traditional meets contemporary! Your artistry is profound! 🎨',
          },
        ];
      case 'pro9': // María Rodriguez - Tango
        return [
          {
            'name': 'Isabella García',
            'username': '@isabella_flamenco',
            'text': 'The connection and passion in your tango! Absolutely stunning! 💃❤️',
          },
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'Your lead/follow is perfection! The chemistry is electric! ⚡',
          },
          {
            'name': 'Anna Kowalski',
            'username': '@anna_ballroom',
            'text': 'World champion quality! Your technique is flawless! 🏆',
          },
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'The elegance and drama! Tango at its finest! 🌹',
          },
        ];
      case 'pro10': // André Silva - Capoeira
        return [
          {
            'name': 'David Martinez',
            'username': '@david_breaking',
            'text': 'The acrobatics! The flow! Capoeira is incredible! 🤸🔥',
          },
          {
            'name': 'Michael Chen',
            'username': '@mike_hiphop',
            'text': 'That combination of dance and martial arts is mind-blowing! 💪',
          },
          {
            'name': 'Lucas Santos',
            'username': '@lucas_samba',
            'text': 'Brazilian excellence! Your energy is contagious, mestre! 🇧🇷',
          },
        ];
      case 'pro11': // Nina Petrov - Modern/Graham
        return [
          {
            'name': 'Alex Rivera',
            'username': '@alex_contemporary',
            'text': 'Your Graham technique is impeccable! The contraction and release! 🌊',
          },
          {
            'name': 'Yuki Tanaka',
            'username': '@yuki_butoh',
            'text': 'The emotional depth in your performance! Modern dance perfection! 💫',
          },
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'The strength and vulnerability you show! Truly inspiring! 🎭',
          },
        ];
      case 'pro12': // Raj Kapoor - Bollywood
        return [
          {
            'name': 'Isabella García',
            'username': '@isabella_flamenco',
            'text': 'The colors! The energy! Bollywood magic! 🎨✨',
          },
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'Your choreography is always innovative! Love the fusion! 🔥',
          },
          {
            'name': 'Sarah Johnson',
            'username': '@sarah_broadway',
            'text': 'The theatrical quality! Your work is cinema gold! 🎬',
          },
          {
            'name': 'Mei Lin',
            'username': '@mei_chinese',
            'text': 'Beautiful blend of traditional and modern! Spectacular! 🌟',
          },
        ];
      case 'pro13': // Sophie Laurent - Lyrical
        return [
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'Your lyrical style is so emotional and beautiful! Paris Opera excellence! 🩰💕',
          },
          {
            'name': 'Alex Rivera',
            'username': '@alex_contemporary',
            'text': 'The way you interpret music through movement! Absolutely gorgeous! 🎵',
          },
          {
            'name': 'Nina Petrov',
            'username': '@nina_graham',
            'text': 'Your performances always move me to tears! Such artistry! 😢✨',
          },
        ];
      case 'pro14': // Carlos Mendez - Salsa
        return [
          {
            'name': 'María Rodriguez',
            'username': '@maria_tango',
            'text': 'Salsa King! Your footwork is lightning fast! 🔥👞',
          },
          {
            'name': 'Isabella García',
            'username': '@isabella_flamenco',
            'text': 'The rhythm! The passion! Cali style at its best! 💃',
          },
          {
            'name': 'Lucas Santos',
            'username': '@lucas_samba',
            'text': 'Latin dance excellence! Your energy is infectious! 🎉',
          },
          {
            'name': 'Anna Kowalski',
            'username': '@anna_ballroom',
            'text': 'World champion moves! Your partner work is flawless! 🏆',
          },
        ];
      case 'pro15': // Anna Kowalski - Ballroom
        return [
          {
            'name': 'María Rodriguez',
            'username': '@maria_tango',
            'text': 'Blackpool champion! Your standard dances are perfection! 👗✨',
          },
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'The elegance and precision! Ballroom royalty! 👑',
          },
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'Your posture and frame are impeccable! So inspiring! 💫',
          },
        ];
      case 'pro16': // Kevin Brown - Krump
        return [
          {
            'name': 'Michael Chen',
            'username': '@mike_hiphop',
            'text': 'The raw power of krump! Your energy is unmatched! 💥🔥',
          },
          {
            'name': 'David Martinez',
            'username': '@david_breaking',
            'text': 'Street dance legend! The intensity you bring is incredible! 💪',
          },
          {
            'name': 'Alex Rivera',
            'username': '@alex_contemporary',
            'text': 'The emotion and storytelling in krump! Powerful performance! ⚡',
          },
        ];
      case 'pro17': // Mei Lin - Chinese Classical
        return [
          {
            'name': 'Yuki Tanaka',
            'username': '@yuki_butoh',
            'text': 'The grace of Chinese classical dance! Your technique is exquisite! 🌸',
          },
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'The fluidity and control! Ancient art preserved beautifully! 🎋',
          },
          {
            'name': 'Raj Kapoor',
            'username': '@raj_bollywood',
            'text': 'Asian dance excellence! Your cultural preservation is admirable! 🏮',
          },
        ];
      case 'pro18': // Layla Hassan - Belly Dance
        return [
          {
            'name': 'Isabella García',
            'username': '@isabella_flamenco',
            'text': 'The isolations! The shimmy! Middle Eastern beauty! 🌙✨',
          },
          {
            'name': 'María Rodriguez',
            'username': '@maria_tango',
            'text': 'Your hip movements are mesmerizing! Cairo champion! 💃',
          },
          {
            'name': 'Raj Kapoor',
            'username': '@raj_bollywood',
            'text': 'The cultural richness in your performance! Absolutely stunning! 🌟',
          },
        ];
      case 'pro19': // Lucas Santos - Samba
        return [
          {
            'name': 'Carlos Mendez',
            'username': '@carlos_salsa',
            'text': 'Rio Carnival energy! Your samba is pure joy! 🎉🇧🇷',
          },
          {
            'name': 'André Silva',
            'username': '@andre_capoeira',
            'text': 'Brazilian pride! Your rhythm is infectious! 🥁🔥',
          },
          {
            'name': 'Isabella García',
            'username': '@isabella_flamenco',
            'text': 'The celebration in every move! Carnival spirit! 💃✨',
          },
          {
            'name': 'Anna Kowalski',
            'username': '@anna_ballroom',
            'text': 'Your samba technique is world-class! Amazing footwork! 👞',
          },
        ];
      case 'pro20': // Elena Volkov - Russian Folk
        return [
          {
            'name': 'Emma Swan',
            'username': '@emma_ballet',
            'text': 'Russian dance tradition at its finest! The precision! 🇷🇺✨',
          },
          {
            'name': 'Mei Lin',
            'username': '@mei_chinese',
            'text': 'Cultural preservation through dance! Your ensemble is magnificent! 🎭',
          },
          {
            'name': 'Isabella García',
            'username': '@isabella_flamenco',
            'text': 'The traditional costumes and movements! Beautiful heritage! 🌺',
          },
        ];
      default:
        return [
          {
            'name': 'Dance Enthusiast',
            'username': '@dance_lover',
            'text': 'Amazing performance! Your dedication shows! 💃✨',
          },
          {
            'name': 'Movement Artist',
            'username': '@art_in_motion',
            'text': 'Beautiful work! Keep inspiring us! 🌟',
          },
        ];
    }
  }

  Widget _buildComment(String name, String username, String comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppConstants.graphite,
          child: Text(
            name[0],
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    username,
                    style: const TextStyle(
                      color: AppConstants.midGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: const TextStyle(
                  color: AppConstants.offWhite,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// Report Dialog Widget
class _ReportDialog extends StatefulWidget {
  final String authorName;

  const _ReportDialog({required this.authorName});

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  
  final List<Map<String, dynamic>> _reportReasons = [
    {
      'title': 'Inappropriate Content',
      'icon': Icons.warning_rounded,
      'color': const Color(0xFFE74C3C),
    },
    {
      'title': 'Spam or Misleading',
      'icon': Icons.block_rounded,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'title': 'Harassment or Bullying',
      'icon': Icons.person_off_rounded,
      'color': const Color(0xFFE67E22),
    },
    {
      'title': 'Violence or Dangerous',
      'icon': Icons.dangerous_rounded,
      'color': const Color(0xFFC0392B),
    },
    {
      'title': 'Copyright Violation',
      'icon': Icons.copyright_rounded,
      'color': const Color(0xFF9B59B6),
    },
    {
      'title': 'Other',
      'icon': Icons.more_horiz_rounded,
      'color': const Color(0xFF95A5A6),
    },
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Please select a reason'),
            ],
          ),
          backgroundColor: AppConstants.theatreRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    Navigator.pop(context);
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.theatreRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppConstants.theatreRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Report Submitted',
                style: TextStyle(
                  color: AppConstants.offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for reporting this content.',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.9),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.ebony.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.theatreRed.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: AppConstants.theatreRed.withValues(alpha: 0.8),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'What happens next?',
                        style: TextStyle(
                          color: AppConstants.offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Our moderation team will review your report\n'
                    '• We will investigate the reported content\n'
                    '• If violations are confirmed, appropriate action will be taken\n'
                    '• The reported user may be warned or banned',
                    style: TextStyle(
                      color: AppConstants.midGray.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We take reports seriously and will take appropriate action if the content violates our community guidelines.',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.7),
                fontSize: 13,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppConstants.theatreRed,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: AppConstants.graphite,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.theatreRed.withValues(alpha: 0.2),
                    AppConstants.graphite,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppConstants.theatreRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: AppConstants.theatreRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report Content',
                          style: TextStyle(
                            color: AppConstants.offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Help us keep the community safe',
                          style: TextStyle(
                            color: AppConstants.midGray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppConstants.midGray),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why are you reporting this?',
                      style: TextStyle(
                        color: AppConstants.midGray.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Report reasons
                    ..._reportReasons.map((reason) => _buildReasonOption(
                      reason['title'],
                      reason['icon'],
                      reason['color'],
                    )),
                    
                    const SizedBox(height: 20),
                    
                    // Additional details
                    Text(
                      'Additional Details (Optional)',
                      style: TextStyle(
                        color: AppConstants.midGray.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppConstants.ebony.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppConstants.midGray.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _detailsController,
                        maxLines: 4,
                        maxLength: 200,
                        style: const TextStyle(
                          color: AppConstants.offWhite,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Provide more context about your report...',
                          hintStyle: TextStyle(
                            color: AppConstants.midGray.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          counterStyle: TextStyle(
                            color: AppConstants.midGray.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppConstants.midGray.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.midGray,
                        side: BorderSide(
                          color: AppConstants.midGray.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.theatreRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit Report',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildReasonOption(String title, IconData icon, Color color) {
    final isSelected = _selectedReason == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppConstants.ebony.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : AppConstants.midGray.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppConstants.offWhite : AppConstants.midGray,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
