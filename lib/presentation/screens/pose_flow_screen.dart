import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/pose_model.dart';
import '../../data/models/user_model.dart';
import '../../services/blocked_users_service.dart';
import '../widgets/pose_card.dart';
import 'pose_detail_screen.dart';

class PoseFlowScreen extends StatefulWidget {
  const PoseFlowScreen({super.key});

  @override
  State<PoseFlowScreen> createState() => _PoseFlowScreenState();
}

class _PoseFlowScreenState extends State<PoseFlowScreen> {
  List<Pose> _poses = [];
  Set<String> _deletedPoseIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeletedPoses();
  }

  Future<void> _loadDeletedPoses() async {
    final prefs = await SharedPreferences.getInstance();
    final deletedIds = prefs.getStringList('deleted_poses') ?? [];
    final blockedUsers = await BlockedUsersService().getBlockedUsers();
    
    setState(() {
      _deletedPoseIds = deletedIds.toSet();
      _poses = _getMockPoses()
          .where((pose) => 
              !_deletedPoseIds.contains(pose.id) &&
              !blockedUsers.contains(pose.author.id))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _saveDeletedPose(String poseId) async {
    final prefs = await SharedPreferences.getInstance();
    _deletedPoseIds.add(poseId);
    await prefs.setStringList('deleted_poses', _deletedPoseIds.toList());
  }

  void _showReportDialog(BuildContext context, String authorName) {
    showDialog(
      context: context,
      builder: (context) => _ReportDialog(authorName: authorName),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.graphite.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                color: AppConstants.theatreRed,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading amazing poses...',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_poses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.graphite.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 64,
                color: AppConstants.midGray.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No poses yet',
              style: TextStyle(
                color: AppConstants.offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back soon for inspiring dance poses',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PoseCard(
                  pose: _poses[index],
                  onTap: () async {
                    final pose = _poses[index];
                    final messenger = ScaffoldMessenger.of(context);
                    if (!mounted) return;

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoseDetailScreen(
                          pose: pose,
                          onDelete: () async {
                            await _saveDeletedPose(pose.id);
                            setState(() {
                              _poses.removeAt(index);
                            });
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Pose deleted successfully'),
                                backgroundColor: AppConstants.theatreRed,
                              ),
                            );
                          },
                        ),
                      ),
                    );

                    // Handle delete result
                    if (!mounted) return;
                    if (result == 'delete') {
                      await _saveDeletedPose(pose.id);
                      setState(() {
                        _poses.remove(pose);
                      });
                    }
                  },
                  onDelete: (authorName) async {
                    final pose = _poses[index];
                    // 屏蔽用户
                    await BlockedUsersService().blockUser(pose.author.id);
                    // 删除该用户的所有内容
                    await _saveDeletedPose(pose.id);
                    // 重新加载列表以过滤被屏蔽用户的所有内容
                    await _loadDeletedPoses();
                    
                    if (mounted) {
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
                                      '$authorName has been blocked. You won\'t see their content anymore.',
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
                    }
                  },
                  onReport: (authorName) {
                    _showReportDialog(context, authorName);
                  },
                );
              },
              childCount: _poses.length,
            ),
          ),
        ],
      ),
    );
  }

  List<Pose> _getMockPoses() {
    final users = _getMockUsers();

    return [
      Pose(
        id: 'pose1',
        imageUrl: 'assets/wzc/wzc1.jpg',
        caption: 'Perfecting the arabesque for tonight\'s Swan Lake performance. 15 years of training in this moment. 🩰',
        author: users[0],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['#Ballet', '#SwanLake', '#RoyalBallet'],
        likesCount: 8234,
      ),
      Pose(
        id: 'pose2',
        imageUrl: 'assets/wzc/wzc2.jpg',
        caption: 'Choreographing for Alvin Ailey\'s new season. Contemporary dance is about breaking boundaries. 💫',
        author: users[1],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['#Contemporary', '#AlvinAiley', '#Choreography'],
        likesCount: 6189,
      ),
      Pose(
        id: 'pose3',
        imageUrl: 'assets/wzc/wzc3.jpg',
        caption: 'World Championship winning move! Hip hop is life, life is hip hop. 🏆🔥',
        author: users[2],
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        tags: ['#HipHop', '#WorldChampion', '#Battle'],
        likesCount: 15456,
      ),
      Pose(
        id: 'pose4',
        imageUrl: 'assets/wzc/wzc4.jpg',
        caption: 'Hamilton matinee today! 8 shows a week on Broadway never gets old. ✨🎭',
        author: users[3],
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['#Broadway', '#Hamilton', '#Musical'],
        likesCount: 9312,
      ),
      Pose(
        id: 'pose5',
        imageUrl: 'assets/wzc/wzc5.jpg',
        caption: 'Training for Paris 2024 Olympics. Breaking is now an Olympic sport! 💪🥇',
        author: users[4],
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        tags: ['#Breaking', '#Olympics', '#RedBullBCOne'],
        likesCount: 12278,
      ),
      Pose(
        id: 'pose6',
        imageUrl: 'assets/wzc/wzc6.jpg',
        caption: 'Flamenco passion from Seville. Every zapateado tells a story of Andalusia. 🌹',
        author: users[5],
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        tags: ['#Flamenco', '#Seville', '#Spanish'],
        likesCount: 5523,
      ),
      Pose(
        id: 'pose7',
        imageUrl: 'assets/wzc/wzc7.jpg',
        caption: 'Tap dancing on Broadway for 20 years. The rhythm never stops! 🎵👞',
        author: users[6],
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['#Tap', '#Broadway', '#Rhythm'],
        likesCount: 4401,
      ),
      Pose(
        id: 'pose8',
        imageUrl: 'assets/wzc/wzc8.jpg',
        caption: 'Butoh performance in Tokyo. Dance of darkness and light. 🎭🇯🇵',
        author: users[7],
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        tags: ['#Butoh', '#Tokyo', '#Japanese'],
        likesCount: 3267,
      ),
      Pose(
        id: 'pose9',
        imageUrl: 'assets/wzc/wzc9.jpg',
        caption: 'Argentine Tango champion. Buenos Aires is in my blood. 🖤🇦🇷',
        author: users[8],
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        tags: ['#Tango', '#Argentina', '#Champion'],
        likesCount: 7345,
      ),
      Pose(
        id: 'pose10',
        imageUrl: 'assets/wzc/wzc10.jpg',
        caption: 'Capoeira Mestre from Brazil. Dance, fight, art - all in one. 🇧🇷⚡',
        author: users[9],
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['#Capoeira', '#Brazil', '#Mestre'],
        likesCount: 6198,
      ),
      Pose(
        id: 'pose11',
        imageUrl: 'assets/wzc/wzc11.jpg',
        caption: 'Martha Graham technique. Modern dance is the language of the soul. 🌟',
        author: users[10],
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        tags: ['#Modern', '#MarthaGraham', '#Technique'],
        likesCount: 5412,
      ),
      Pose(
        id: 'pose12',
        imageUrl: 'assets/wzc/wzc12.jpg',
        caption: 'Choreographing for Bollywood! Mumbai film industry magic. 🎬✨',
        author: users[11],
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        tags: ['#Bollywood', '#Mumbai', '#Film'],
        likesCount: 11289,
      ),
      Pose(
        id: 'pose13',
        imageUrl: 'assets/wzc/wzc13.jpg',
        caption: 'Paris Opera Ballet lyrical performance. Grace and emotion combined. 🩰🇫🇷',
        author: users[12],
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        tags: ['#Lyrical', '#ParisOpera', '#Ballet'],
        likesCount: 5567,
      ),
      Pose(
        id: 'pose14',
        imageUrl: 'assets/wzc/wzc14.jpg',
        caption: 'Salsa World Champion from Cali! Colombian rhythm in my veins. 💃🇨🇴',
        author: users[13],
        timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 4)),
        tags: ['#Salsa', '#Colombia', '#WorldChampion'],
        likesCount: 8334,
      ),
      Pose(
        id: 'pose15',
        imageUrl: 'assets/wzc/wzc15.jpg',
        caption: 'Blackpool Ballroom winner! Waltz, tango, foxtrot - mastered them all. 👗💎',
        author: users[14],
        timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 8)),
        tags: ['#Ballroom', '#Blackpool', '#Champion'],
        likesCount: 6445,
      ),
      Pose(
        id: 'pose16',
        imageUrl: 'assets/wzc/wzc16.jpg',
        caption: 'LA Krump legend! Street dance pioneer since 2005. 💥👑',
        author: users[15],
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['#Krump', '#LA', '#Pioneer'],
        likesCount: 10378,
      ),
      Pose(
        id: 'pose17',
        imageUrl: 'assets/wzc/wzc17.jpg',
        caption: 'Chinese Classical Dance from Beijing Academy. 5000 years of tradition. 🏮🇨🇳',
        author: users[16],
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 3)),
        tags: ['#Chinese', '#Classical', '#Beijing'],
        likesCount: 9423,
      ),
      Pose(
        id: 'pose18',
        imageUrl: 'assets/wzc/wzc18.jpg',
        caption: 'Cairo Belly Dance Festival champion. Ancient art, modern expression. 🌙✨',
        author: users[17],
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 7)),
        tags: ['#BellyDance', '#Cairo', '#Champion'],
        likesCount: 7512,
      ),
      Pose(
        id: 'pose19',
        imageUrl: 'assets/wzc/wzc19.jpg',
        caption: 'Rio Carnival lead dancer! Samba is the heartbeat of Brazil. 🎉🇧🇷',
        author: users[18],
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        tags: ['#Samba', '#Rio', '#Carnival'],
        likesCount: 13298,
      ),
      Pose(
        id: 'pose20',
        imageUrl: 'assets/wzc/wzc20.jpg',
        caption: 'Russian Folk Dance Ensemble Director. Preserving our cultural heritage. 🪆🇷🇺',
        author: users[19],
        timestamp: DateTime.now().subtract(const Duration(days: 6, hours: 5)),
        tags: ['#Russian', '#Folk', '#Traditional'],
        likesCount: 4489,
      ),
    ];
  }

  List<User> _getMockUsers() {
    // 20位专业舞者
    return [
      User(
        id: 'pro1',
        username: 'emma_ballet',
        displayName: 'Emma Swan',
        bio: 'Principal Dancer @ Royal Ballet Company',
        joinDate: DateTime(2020, 1, 15),
        followersCount: 125000,
        followingCount: 300,
        posesCount: 420,
      ),
      User(
        id: 'pro2',
        username: 'alex_contemporary',
        displayName: 'Alex Rivera',
        bio: 'Contemporary Choreographer | Alvin Ailey',
        joinDate: DateTime(2019, 3, 20),
        followersCount: 98000,
        followingCount: 450,
        posesCount: 385,
      ),
      User(
        id: 'pro3',
        username: 'mike_hiphop',
        displayName: 'Michael Chen',
        bio: 'World Hip Hop Champion 2023',
        joinDate: DateTime(2018, 2, 10),
        followersCount: 215000,
        followingCount: 520,
        posesCount: 567,
      ),
      User(
        id: 'pro4',
        username: 'sarah_broadway',
        displayName: 'Sarah Johnson',
        bio: 'Broadway Performer | Hamilton Cast',
        joinDate: DateTime(2019, 4, 5),
        followersCount: 156000,
        followingCount: 380,
        posesCount: 298,
      ),
      User(
        id: 'pro5',
        username: 'david_breaking',
        displayName: 'David Martinez',
        bio: 'Olympic Breaking Athlete | Red Bull BC One',
        joinDate: DateTime(2017, 1, 28),
        followersCount: 189000,
        followingCount: 410,
        posesCount: 634,
      ),
      User(
        id: 'pro6',
        username: 'lisa_flamenco',
        displayName: 'Isabella García',
        bio: 'Flamenco Soloist | Seville Dance Academy',
        joinDate: DateTime(2020, 6, 12),
        followersCount: 87000,
        followingCount: 245,
        posesCount: 312,
      ),
      User(
        id: 'pro7',
        username: 'james_tap',
        displayName: 'James Wilson',
        bio: 'Tap Dance Master | Broadway Rhythm',
        joinDate: DateTime(2019, 8, 22),
        followersCount: 76000,
        followingCount: 198,
        posesCount: 445,
      ),
      User(
        id: 'pro8',
        username: 'yuki_butoh',
        displayName: 'Yuki Tanaka',
        bio: 'Butoh Performer | Tokyo Dance Theatre',
        joinDate: DateTime(2018, 11, 5),
        followersCount: 65000,
        followingCount: 167,
        posesCount: 289,
      ),
      User(
        id: 'pro9',
        username: 'maria_tango',
        displayName: 'María Rodriguez',
        bio: 'Argentine Tango Champion | Buenos Aires',
        joinDate: DateTime(2019, 2, 14),
        followersCount: 112000,
        followingCount: 334,
        posesCount: 378,
      ),
      User(
        id: 'pro10',
        username: 'andre_capoeira',
        displayName: 'André Silva',
        bio: 'Capoeira Mestre | Brazilian Dance Master',
        joinDate: DateTime(2017, 9, 8),
        followersCount: 94000,
        followingCount: 412,
        posesCount: 523,
      ),
      User(
        id: 'pro11',
        username: 'nina_modern',
        displayName: 'Nina Petrov',
        bio: 'Modern Dance Principal | Martha Graham Company',
        joinDate: DateTime(2020, 3, 17),
        followersCount: 103000,
        followingCount: 289,
        posesCount: 356,
      ),
      User(
        id: 'pro12',
        username: 'raj_bollywood',
        displayName: 'Raj Kapoor',
        bio: 'Bollywood Choreographer | Mumbai Film Industry',
        joinDate: DateTime(2018, 7, 25),
        followersCount: 178000,
        followingCount: 567,
        posesCount: 489,
      ),
      User(
        id: 'pro13',
        username: 'sophie_lyrical',
        displayName: 'Sophie Laurent',
        bio: 'Lyrical Dance Specialist | Paris Opera Ballet',
        joinDate: DateTime(2019, 5, 11),
        followersCount: 89000,
        followingCount: 234,
        posesCount: 267,
      ),
      User(
        id: 'pro14',
        username: 'carlos_salsa',
        displayName: 'Carlos Mendez',
        bio: 'Salsa World Champion | Cali Colombia',
        joinDate: DateTime(2018, 12, 3),
        followersCount: 134000,
        followingCount: 445,
        posesCount: 512,
      ),
      User(
        id: 'pro15',
        username: 'anna_ballroom',
        displayName: 'Anna Kowalski',
        bio: 'Ballroom Dance Champion | Blackpool Winner',
        joinDate: DateTime(2019, 10, 19),
        followersCount: 98000,
        followingCount: 312,
        posesCount: 398,
      ),
      User(
        id: 'pro16',
        username: 'kevin_krump',
        displayName: 'Kevin Brown',
        bio: 'Krump Pioneer | LA Street Dance Legend',
        joinDate: DateTime(2017, 4, 7),
        followersCount: 167000,
        followingCount: 489,
        posesCount: 678,
      ),
      User(
        id: 'pro17',
        username: 'mei_chinese',
        displayName: 'Mei Lin',
        bio: 'Chinese Classical Dance Master | Beijing Academy',
        joinDate: DateTime(2020, 2, 28),
        followersCount: 145000,
        followingCount: 278,
        posesCount: 423,
      ),
      User(
        id: 'pro18',
        username: 'omar_bellydance',
        displayName: 'Layla Hassan',
        bio: 'Belly Dance Champion | Cairo Dance Festival',
        joinDate: DateTime(2018, 6, 15),
        followersCount: 112000,
        followingCount: 356,
        posesCount: 445,
      ),
      User(
        id: 'pro19',
        username: 'lucas_samba',
        displayName: 'Lucas Santos',
        bio: 'Samba Performer | Rio Carnival Lead Dancer',
        joinDate: DateTime(2019, 1, 9),
        followersCount: 156000,
        followingCount: 423,
        posesCount: 534,
      ),
      User(
        id: 'pro20',
        username: 'elena_folk',
        displayName: 'Elena Volkov',
        bio: 'Russian Folk Dance Ensemble Director',
        joinDate: DateTime(2018, 9, 21),
        followersCount: 78000,
        followingCount: 201,
        posesCount: 367,
      ),
    ];
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
                      padding: const EdgeInsets.all(12),
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
