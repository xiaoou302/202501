import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/insight_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/emotion_tag_model.dart';
import '../../core/constants/app_constants.dart';
import '../../services/blocked_users_service.dart';
import '../widgets/insight_card.dart';
import 'insight_detail_screen.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  List<Insight> _insights = [];
  Set<String> _deletedInsightIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeletedInsights();
  }

  Future<void> _loadDeletedInsights() async {
    final prefs = await SharedPreferences.getInstance();
    final deletedIds = prefs.getStringList('deleted_insights') ?? [];
    final blockedUsers = await BlockedUsersService().getBlockedUsers();
    
    setState(() {
      _deletedInsightIds = deletedIds.toSet();
      _insights = _getMockInsights()
          .where((insight) => 
              !_deletedInsightIds.contains(insight.id) &&
              !blockedUsers.contains(insight.author.id))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _saveDeletedInsight(String insightId) async {
    final prefs = await SharedPreferences.getInstance();
    _deletedInsightIds.add(insightId);
    await prefs.setStringList('deleted_insights', _deletedInsightIds.toList());
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
              'Loading inspiring stories...',
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

    if (_insights.isEmpty) {
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
                Icons.auto_stories_outlined,
                size: 64,
                color: AppConstants.midGray.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No insights yet',
              style: TextStyle(
                color: AppConstants.offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back soon for inspiring dance stories',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _insights.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return InsightCard(
          insight: _insights[index],
          onTap: () async {
            final insight = _insights[index];
            final messenger = ScaffoldMessenger.of(context);
            if (!mounted) return;
            
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsightDetailScreen(
                  insight: insight,
                  onDelete: () async {
                    await _saveDeletedInsight(insight.id);
                    setState(() {
                      _insights.removeAt(index);
                    });
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Insight deleted successfully'),
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
              await _saveDeletedInsight(insight.id);
              setState(() {
                _insights.remove(insight);
              });
            }
          },
          onDelete: (authorName) async {
            final insight = _insights[index];
            // 屏蔽用户
            await BlockedUsersService().blockUser(insight.author.id);
            // 删除该用户的所有内容
            await _saveDeletedInsight(insight.id);
            // 重新加载列表以过滤被屏蔽用户的所有内容
            await _loadDeletedInsights();
            
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
    );
  }

  List<Insight> _getMockInsights() {
    final users = _getMockUsers();

    return [
      Insight(
        id: 'insight1',
        title: 'Starting Ballet at 28: It\'s Never Too Late',
        content: 'As an office worker, I never thought I\'d wear a leotard. But here I am, 3 months into my adult ballet journey, and I\'ve never felt more alive...',
        imageUrl: 'assets/wzk/wzk1.jpg',
        author: users[0],
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        emotionTags: [
          EmotionTag(
            name: '#Courage',
            color: AppConstants.energyYellow,
            type: TagType.resilience,
          ),
          EmotionTag(
            name: '#NewBeginnings',
            color: AppConstants.techBlue,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Empowerment',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
        ],
        readCount: 2834,
      ),
      Insight(
        id: 'insight2',
        title: 'From Code to Choreography: An Engineer\'s Dance Journey',
        content: 'I spend my days debugging code, but at night, I\'m learning to freestyle. Hip hop taught me that mistakes are just new moves waiting to happen...',
        imageUrl: 'assets/wzk/wzk2.jpg',
        author: users[1],
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        emotionTags: [
          EmotionTag(
            name: '#Creativity',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Balance',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
        ],
        readCount: 3156,
      ),
      Insight(
        id: 'insight3',
        title: 'Teaching by Day, Dancing by Night',
        content: 'As a teacher, I\'m used to being in control. Contemporary dance taught me to let go and trust the process. It\'s been transformative...',
        imageUrl: 'assets/wzk/wzk3.jpg',
        author: users[2],
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        emotionTags: [
          EmotionTag(
            name: '#Transformation',
            color: AppConstants.energyYellow,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#LettingGo',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Growth',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
        ],
        readCount: 2176,
      ),
      Insight(
        id: 'insight4',
        title: 'Dancing with My Kids: A Dad\'s Salsa Story',
        content: 'My kids laughed when I said I was taking salsa classes. Now they ask me to teach them. Dance brought our family closer together...',
        imageUrl: 'assets/wzk/wzk4.jpg',
        author: users[3],
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        emotionTags: [
          EmotionTag(
            name: '#Family',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Connection',
            color: AppConstants.energyYellow,
            type: TagType.joy,
          ),
        ],
        readCount: 4543,
      ),
      Insight(
        id: 'insight5',
        title: 'Healing Through Movement: A Nurse\'s Story',
        content: 'After 12-hour shifts in the ER, lyrical dance is my therapy. It helps me process the emotions I can\'t express at work...',
        imageUrl: 'assets/wzk/wzk5.jpg',
        author: users[4],
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        emotionTags: [
          EmotionTag(
            name: '#Healing',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#SelfCare',
            color: AppConstants.balletPink,
            type: TagType.resilience,
          ),
          EmotionTag(
            name: '#Strength',
            color: AppConstants.energyYellow,
            type: TagType.resilience,
          ),
        ],
        readCount: 5287,
      ),
      Insight(
        id: 'insight6',
        title: 'Bollywood Dreams: A Developer\'s Cultural Journey',
        content: 'Growing up in America, I felt disconnected from my Indian roots. Bollywood dance helped me reconnect with my heritage...',
        imageUrl: 'assets/wzk/wzk6.jpg',
        author: users[5],
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        emotionTags: [
          EmotionTag(
            name: '#Heritage',
            color: AppConstants.energyYellow,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Identity',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
        ],
        readCount: 3654,
      ),
      Insight(
        id: 'insight7',
        title: 'Tango at 35: Embracing Vulnerability',
        content: 'As an accountant, I\'m all about control and precision. Tango taught me that true connection requires vulnerability...',
        imageUrl: 'assets/wzk/wzk7.jpg',
        author: users[6],
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        emotionTags: [
          EmotionTag(
            name: '#Vulnerability',
            color: AppConstants.balletPink,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Trust',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Breakthrough',
            color: AppConstants.energyYellow,
            type: TagType.resilience,
          ),
        ],
        readCount: 2834,
      ),
      Insight(
        id: 'insight8',
        title: 'College Life and Street Dance: Finding My Tribe',
        content: 'Joining a street dance crew was the best decision of my college life. I found friends who became family...',
        imageUrl: 'assets/wzk/wzk8.jpg',
        author: users[7],
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
        emotionTags: [
          EmotionTag(
            name: '#Community',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Belonging',
            color: AppConstants.energyYellow,
            type: TagType.joy,
          ),
        ],
        readCount: 4189,
      ),
      Insight(
        id: 'insight9',
        title: 'Adult Ballet: Overcoming the "Too Old" Myth',
        content: 'As a graphic designer, I thought my creative outlet was design. Then I discovered adult ballet and found a new way to express myself...',
        imageUrl: 'assets/wzk/wzk9.jpg',
        author: users[8],
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        emotionTags: [
          EmotionTag(
            name: '#Defiance',
            color: AppConstants.theatreRed,
            type: TagType.resilience,
          ),
          EmotionTag(
            name: '#Dreams',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
        ],
        readCount: 3924,
      ),
      Insight(
        id: 'insight10',
        title: 'Salsa Sundays: A Chef\'s Weekend Escape',
        content: 'In the kitchen, I create with food. On the dance floor, I create with movement. Both are forms of art that bring people together...',
        imageUrl: 'assets/wzk/wzk10.jpg',
        author: users[9],
        timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 10)),
        emotionTags: [
          EmotionTag(
            name: '#Passion',
            color: AppConstants.theatreRed,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Art',
            color: AppConstants.balletPink,
            type: TagType.reflection,
          ),
        ],
        readCount: 2723,
      ),
      Insight(
        id: 'insight11',
        title: 'Jazz Dance and Marketing: Finding the Rhythm',
        content: 'My marketing campaigns need rhythm and timing. Jazz dance taught me both. Now I apply dance principles to my work...',
        imageUrl: 'assets/wzk/wzk11.jpg',
        author: users[10],
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        emotionTags: [
          EmotionTag(
            name: '#Innovation',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Synergy',
            color: AppConstants.energyYellow,
            type: TagType.joy,
          ),
        ],
        readCount: 2156,
      ),
      Insight(
        id: 'insight12',
        title: 'Tap Dancing Lawyer: Finding Joy in Rhythm',
        content: 'Law is serious business. Tap dance reminds me not to take life too seriously. The sound of my feet is pure joy...',
        imageUrl: 'assets/wzk/wzk12.jpg',
        author: users[11],
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
        emotionTags: [
          EmotionTag(
            name: '#Joy',
            color: AppConstants.energyYellow,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Freedom',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
        ],
        readCount: 1978,
      ),
      Insight(
        id: 'insight13',
        title: 'Through the Lens and Movement: A Photographer Dances',
        content: 'I capture movement through my camera. Modern dance taught me to BE the movement. It changed how I see the world...',
        imageUrl: 'assets/wzk/wzk13.jpg',
        author: users[12],
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        emotionTags: [
          EmotionTag(
            name: '#Perspective',
            color: AppConstants.techBlue,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Discovery',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
        ],
        readCount: 3234,
      ),
      Insight(
        id: 'insight14',
        title: 'Swing Dancing Firefighter: Life Lessons from the Dance Floor',
        content: 'As a firefighter, I face danger daily. Swing dance taught me to trust my partner completely. It\'s a lesson that saves lives...',
        imageUrl: 'assets/wzk/wzk14.jpg',
        author: users[13],
        timestamp: DateTime.now().subtract(const Duration(days: 6, hours: 8)),
        emotionTags: [
          EmotionTag(
            name: '#Trust',
            color: AppConstants.techBlue,
            type: TagType.resilience,
          ),
          EmotionTag(
            name: '#Partnership',
            color: AppConstants.balletPink,
            type: TagType.reflection,
          ),
          EmotionTag(
            name: '#Courage',
            color: AppConstants.energyYellow,
            type: TagType.resilience,
          ),
        ],
        readCount: 4545,
      ),
      Insight(
        id: 'insight15',
        title: 'Belly Dance: A Dentist\'s Journey to Self-Love',
        content: 'I spend my days looking at teeth. Belly dance taught me to appreciate my whole body. It\'s been a journey of self-acceptance...',
        imageUrl: 'assets/wzk/wzk15.jpg',
        author: users[14],
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        emotionTags: [
          EmotionTag(
            name: '#SelfLove',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
          EmotionTag(
            name: '#Acceptance',
            color: AppConstants.energyYellow,
            type: TagType.resilience,
          ),
        ],
        readCount: 3867,
      ),
      Insight(
        id: 'insight16',
        title: 'Breaking Barriers: A Barista\'s B-Boy Dreams',
        content: 'I serve coffee by day, practice breaking by night. My dream is to compete. Age is just a number when you have passion...',
        imageUrl: 'assets/wzk/wzk16.jpg',
        author: users[15],
        timestamp: DateTime.now().subtract(const Duration(days: 7, hours: 5)),
        emotionTags: [
          EmotionTag(
            name: '#Ambition',
            color: AppConstants.theatreRed,
            type: TagType.resilience,
          ),
          EmotionTag(
            name: '#Dedication',
            color: AppConstants.energyYellow,
            type: TagType.resilience,
          ),
          EmotionTag(
            name: '#Dreams',
            color: AppConstants.balletPink,
            type: TagType.joy,
          ),
        ],
        readCount: 5156,
      ),
    ];
  }

  List<User> _getMockUsers() {
    // 16位业余舞者
    return [
      User(
        id: 'amateur1',
        username: 'jenny_beginner',
        displayName: 'Jenny Park',
        bio: 'Office worker learning ballet at 28',
        joinDate: DateTime(2024, 1, 15),
        followersCount: 1200,
        followingCount: 450,
        posesCount: 45,
      ),
      User(
        id: 'amateur2',
        username: 'tom_dancer',
        displayName: 'Tom Anderson',
        bio: 'Engineer by day, hip hop dancer by night',
        joinDate: DateTime(2023, 11, 20),
        followersCount: 2100,
        followingCount: 380,
        posesCount: 67,
      ),
      User(
        id: 'amateur3',
        username: 'lisa_moves',
        displayName: 'Lisa Wong',
        bio: 'Teacher discovering contemporary dance',
        joinDate: DateTime(2024, 2, 10),
        followersCount: 890,
        followingCount: 320,
        posesCount: 34,
      ),
      User(
        id: 'amateur4',
        username: 'mark_rhythm',
        displayName: 'Mark Thompson',
        bio: 'Dad of 2, salsa enthusiast',
        joinDate: DateTime(2023, 9, 5),
        followersCount: 1560,
        followingCount: 290,
        posesCount: 78,
      ),
      User(
        id: 'amateur5',
        username: 'anna_grace',
        displayName: 'Anna Schmidt',
        bio: 'Nurse finding peace in lyrical dance',
        joinDate: DateTime(2024, 3, 28),
        followersCount: 670,
        followingCount: 210,
        posesCount: 23,
      ),
      User(
        id: 'amateur6',
        username: 'raj_bollywood',
        displayName: 'Raj Patel',
        bio: 'Software developer, Bollywood dance lover',
        joinDate: DateTime(2023, 12, 12),
        followersCount: 1890,
        followingCount: 410,
        posesCount: 56,
      ),
      User(
        id: 'amateur7',
        username: 'maria_tango',
        displayName: 'Maria Santos',
        bio: 'Accountant learning tango at 35',
        joinDate: DateTime(2024, 1, 8),
        followersCount: 1120,
        followingCount: 340,
        posesCount: 41,
      ),
      User(
        id: 'amateur8',
        username: 'kevin_street',
        displayName: 'Kevin Lee',
        bio: 'College student, street dance crew member',
        joinDate: DateTime(2023, 10, 22),
        followersCount: 2340,
        followingCount: 520,
        posesCount: 89,
      ),
      User(
        id: 'amateur9',
        username: 'sophie_ballet',
        displayName: 'Sophie Martin',
        bio: 'Graphic designer, adult ballet student',
        joinDate: DateTime(2024, 2, 14),
        followersCount: 980,
        followingCount: 280,
        posesCount: 38,
      ),
      User(
        id: 'amateur10',
        username: 'carlos_salsa',
        displayName: 'Carlos Ruiz',
        bio: 'Chef dancing salsa on weekends',
        joinDate: DateTime(2023, 11, 5),
        followersCount: 1450,
        followingCount: 360,
        posesCount: 62,
      ),
      User(
        id: 'amateur11',
        username: 'emily_jazz',
        displayName: 'Emily Davis',
        bio: 'Marketing manager, jazz dance student',
        joinDate: DateTime(2024, 3, 17),
        followersCount: 780,
        followingCount: 250,
        posesCount: 29,
      ),
      User(
        id: 'amateur12',
        username: 'david_tap',
        displayName: 'David Kim',
        bio: 'Lawyer learning tap dance',
        joinDate: DateTime(2023, 12, 25),
        followersCount: 1230,
        followingCount: 310,
        posesCount: 47,
      ),
      User(
        id: 'amateur13',
        username: 'rachel_modern',
        displayName: 'Rachel Green',
        bio: 'Photographer exploring modern dance',
        joinDate: DateTime(2024, 1, 11),
        followersCount: 1670,
        followingCount: 420,
        posesCount: 53,
      ),
      User(
        id: 'amateur14',
        username: 'mike_swing',
        displayName: 'Mike Brown',
        bio: 'Firefighter, swing dance enthusiast',
        joinDate: DateTime(2023, 10, 19),
        followersCount: 1340,
        followingCount: 330,
        posesCount: 71,
      ),
      User(
        id: 'amateur15',
        username: 'linda_belly',
        displayName: 'Linda Hassan',
        bio: 'Dentist discovering belly dance',
        joinDate: DateTime(2024, 2, 7),
        followersCount: 890,
        followingCount: 270,
        posesCount: 36,
      ),
      User(
        id: 'amateur16',
        username: 'alex_breaking',
        displayName: 'Alex Turner',
        bio: 'Barista, breaking dance beginner',
        joinDate: DateTime(2024, 3, 21),
        followersCount: 1120,
        followingCount: 390,
        posesCount: 44,
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
