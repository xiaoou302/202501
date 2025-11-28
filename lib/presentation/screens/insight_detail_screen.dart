import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/insight_model.dart';
import '../widgets/emotion_tag_chip.dart';

class InsightDetailScreen extends StatefulWidget {
  final Insight insight;
  final VoidCallback? onDelete;
  final bool showMenu;

  const InsightDetailScreen({
    super.key,
    required this.insight,
    this.onDelete,
    this.showMenu = true,
  });

  @override
  State<InsightDetailScreen> createState() => _InsightDetailScreenState();
}

class _InsightDetailScreenState extends State<InsightDetailScreen> {
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadFollowingStatus();
  }

  Future<void> _loadFollowingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'following_${widget.insight.author.id}';
    setState(() {
      _isFollowing = prefs.getBool(key) ?? false;
    });
  }

  Future<void> _saveFollowingStatus(bool isFollowing) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'following_${widget.insight.author.id}';
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
                _buildCoverImage(),
                _buildHeader(),
                _buildAuthorInfo(),
                _buildDanceJourneyTimeline(),
                _buildContent(),
                _buildTags(),
                _buildStats(),
                _buildRelatedInsights(),
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
        authorName: widget.insight.author.displayName,
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
                '• Block ${widget.insight.author.displayName}\n'
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
                                '${widget.insight.author.displayName} has been blocked. You won\'t see their content anymore.',
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

  Widget _buildCoverImage() {
    if (widget.insight.imageUrl.isEmpty) return const SizedBox();
    
    return Hero(
      tag: 'insight_${widget.insight.id}',
      child: Stack(
        children: [
          Image.asset(
            widget.insight.imageUrl,
            width: double.infinity,
            height: 280,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 280,
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
                  child: Icon(Icons.image_rounded, size: 80, color: AppConstants.midGray),
                ),
              );
            },
          ),
          // Gradient overlay for better text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppConstants.ebony.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.insight.title,
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.graphite.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.midGray.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppConstants.midGray.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(widget.insight.timestamp),
                      style: TextStyle(
                        color: AppConstants.midGray.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.theatreRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.theatreRed.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility_rounded,
                      size: 14,
                      color: AppConstants.theatreRed,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.insight.readCount}',
                      style: const TextStyle(
                        color: AppConstants.theatreRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.4),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
        ),
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
                  AppConstants.theatreRed,
                  AppConstants.balletPink,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.theatreRed.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.transparent,
              child: Text(
                widget.insight.author.displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.insight.author.displayName,
                  style: const TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${widget.insight.author.username}',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.8),
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
                              Text('Unfollowed ${widget.insight.author.displayName}'),
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
                    backgroundColor: AppConstants.theatreRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text(
                    'Following',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
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
                              const Icon(Icons.favorite_rounded, color: AppConstants.theatreRed, size: 20),
                              const SizedBox(width: 8),
                              Text('Following ${widget.insight.author.displayName}'),
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
                    foregroundColor: AppConstants.theatreRed,
                    side: const BorderSide(color: AppConstants.theatreRed, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(
                    'Follow',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final contentSections = _getContentForInsight();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.insight.content,
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
          ...contentSections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                _buildContentParagraph(
                  section['title']!,
                  section['content']!,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  List<Map<String, String>> _getContentForInsight() {
    // 根据文章ID返回不同的内容
    switch (widget.insight.id) {
      case 'insight1': // Jenny Park - Starting Ballet at 28
        return [
          {
            'title': 'The First Class',
            'content': 'Walking into that adult ballet studio at 28 felt like stepping into a dream I\'d buried years ago. The mirror showed me someone who looked nothing like the graceful dancers around me. But my teacher smiled and said, "Everyone starts somewhere. Welcome."',
          },
          {
            'title': 'Office Life vs. Ballet Life',
            'content': 'My coworkers think I\'m crazy. "Ballet? At your age?" they ask. But they don\'t understand the feeling of finally doing something just for me. Not for a promotion, not for anyone else - just because it makes me feel alive.',
          },
          {
            'title': 'Small Victories',
            'content': 'Three months in, and I can finally hold a proper first position. My turnout is improving. I\'m nowhere near perfect, but I\'m better than I was yesterday. And that\'s enough.',
          },
        ];
      case 'insight2': // Tom Anderson - Engineer/Hip Hop
        return [
          {
            'title': 'Debugging Code, Learning to Dance',
            'content': 'I spend 8 hours a day writing code, finding bugs, solving problems. Hip hop dance is the opposite - it\'s about letting go, feeling the music, making "mistakes" that become new moves. It\'s the perfect balance to my analytical day job.',
          },
          {
            'title': 'The Crew',
            'content': 'Finding my dance crew was like finding my tribe. We\'re all beginners, all learning together. No judgment, just support. They don\'t care that I\'m an engineer who can\'t do a proper windmill yet. They just care that I show up and give it my all.',
          },
          {
            'title': 'Two Worlds Collide',
            'content': 'Funny thing - hip hop is teaching me to be a better engineer. Both require creativity, problem-solving, and the courage to try something new. Who knew dancing would make me better at my day job?',
          },
        ];
      case 'insight3': // Lisa Wong - Teacher/Contemporary
        return [
          {
            'title': 'Control vs. Flow',
            'content': 'As a teacher, I\'m used to being in control. Lesson plans, schedules, outcomes - everything is structured. Contemporary dance is teaching me to let go. To trust the process. To allow movement to emerge rather than forcing it.',
          },
          {
            'title': 'The Crying Session',
            'content': 'During my third class, I cried. Not from pain or frustration, but from release. All the stress I carry from work, from trying to be perfect for my students - it all came out through movement. My dance teacher just nodded and said, "That\'s what dance does."',
          },
          {
            'title': 'Teaching and Learning',
            'content': 'Dance is making me a better teacher. I\'m learning that not everything needs to be controlled or planned. Sometimes the best learning happens when we let go and explore. My students are noticing the change too.',
          },
        ];
      case 'insight4': // Mark Thompson - Dad/Salsa
        return [
          {
            'title': 'Date Night Evolution',
            'content': 'My wife suggested salsa classes as a way to spend more time together. I was skeptical - I\'m not a "dancer." But watching her light up on the dance floor made me realize this was about more than just steps. It was about connection.',
          },
          {
            'title': 'Family Dance Parties',
            'content': 'Our kids thought it was hilarious when we started dancing at home. Now they ask us to teach them. Last weekend, we had a family salsa party in the living room. My 7-year-old daughter said it was the best day ever. That\'s when I knew we\'d made the right choice.',
          },
          {
            'title': 'More Than Dance',
            'content': 'Salsa didn\'t just teach me to dance - it taught me to be present with my family. To laugh, to play, to not take life so seriously. We\'re closer now than we\'ve been in years. All because we decided to dance.',
          },
        ];
      case 'insight5': // Anna Schmidt - Nurse/Lyrical
        return [
          {
            'title': 'The Voice of Doubt',
            'content': 'Every dancer knows that voice. "You\'re not good enough." "You\'ll never make it." "Look at how much better they are." It whispers during practice, shouts during auditions, and echoes in the quiet moments before sleep. Self-doubt is the invisible opponent we all face.',
          },
          {
            'title': 'My Darkest Moment',
            'content': 'I almost quit after failing my third audition in a row. I sat in my car, crying, convinced that I wasn\'t meant to be a dancer. But then I remembered something my first teacher told me: "Doubt means you care. It means this matters to you. Use it as fuel, not as a reason to stop."',
          },
          {
            'title': 'Dancing Louder',
            'content': 'Now when doubt creeps in, I don\'t try to silence it. Instead, I dance louder. I practice harder. I perform with more passion. Because the best response to "you can\'t" is to show them - and yourself - that you absolutely can.',
          },
        ];
      default:
        return [
          {
            'title': 'The Journey',
            'content': 'Every dancer\'s path is unique, filled with challenges, triumphs, and countless hours of dedication. This is my story, and I hope it resonates with yours.',
          },
          {
            'title': 'The Lesson',
            'content': 'Through dance, we learn not just about movement, but about ourselves. We discover our limits and then push past them. We find strength we didn\'t know we had.',
          },
          {
            'title': 'Moving Forward',
            'content': 'The journey continues, one step at a time, one dance at a time. And that\'s the beauty of it - there\'s always more to learn, more to express, more to become.',
          },
        ];
    }
  }

  Widget _buildContentParagraph(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppConstants.offWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: AppConstants.offWhite,
            fontSize: 16,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    if (widget.insight.emotionTags.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer_rounded,
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
            children: widget.insight.emotionTags
                .map((tag) => EmotionTagChip(tag: tag))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.midGray.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(Icons.visibility_rounded, '${widget.insight.readCount}', 'Views'),
            Container(
              width: 1,
              height: 40,
              color: AppConstants.midGray.withValues(alpha: 0.2),
            ),
            _buildStatItem(Icons.favorite_rounded, '234', 'Likes'),
            Container(
              width: 1,
              height: 40,
              color: AppConstants.midGray.withValues(alpha: 0.2),
            ),
            _buildStatItem(Icons.chat_bubble_rounded, '45', 'Comments'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppConstants.theatreRed.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppConstants.theatreRed, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          count,
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
    );
  }

  Widget _buildDanceJourneyTimeline() {
    final timeline = _getDanceJourneyTimeline();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.graphite,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.timeline,
                  color: AppConstants.techBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Dance Journey Timeline',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...timeline.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;
              final isLast = index == timeline.length - 1;
              
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppConstants.theatreRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppConstants.offWhite,
                            width: 2,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 60,
                          color: AppConstants.midGray.withValues(alpha: 0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['date']!,
                            style: const TextStyle(
                              color: AppConstants.theatreRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event['title']!,
                            style: const TextStyle(
                              color: AppConstants.offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event['description']!,
                            style: const TextStyle(
                              color: AppConstants.midGray,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getDanceJourneyTimeline() {
    switch (widget.insight.author.id) {
      case 'amateur1': // Jenny Park - Ballet at 28
        return [
          {
            'date': 'Jan 2024',
            'title': 'First Ballet Class',
            'description': 'Walked into my first adult ballet class feeling terrified and excited.',
          },
          {
            'date': 'Feb 2024',
            'title': 'Learning the Basics',
            'description': 'Mastered first position and basic pliés. My legs were so sore!',
          },
          {
            'date': 'Mar 2024',
            'title': 'First Recital',
            'description': 'Performed in the studio showcase. Nervous but proud!',
          },
          {
            'date': 'Apr 2024',
            'title': 'Continuing the Journey',
            'description': 'Now practicing 3 times a week. Ballet has become my passion.',
          },
        ];
      case 'amateur2': // Tom Anderson - Engineer/Hip Hop
        return [
          {
            'date': 'Nov 2023',
            'title': 'Discovered Hip Hop',
            'description': 'Watched a street performance and knew I had to try it.',
          },
          {
            'date': 'Dec 2023',
            'title': 'Joined a Crew',
            'description': 'Found a beginner-friendly crew. Finally felt like I belonged.',
          },
          {
            'date': 'Feb 2024',
            'title': 'First Battle',
            'description': 'Competed in my first battle. Lost, but learned so much.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Finding My Style',
            'description': 'Developing my own freestyle style. Engineering meets art!',
          },
        ];
      case 'amateur3': // Lisa Wong - Teacher/Contemporary
        return [
          {
            'date': 'Feb 2024',
            'title': 'Trying Something New',
            'description': 'Signed up for contemporary dance as a stress relief.',
          },
          {
            'date': 'Mar 2024',
            'title': 'Emotional Release',
            'description': 'First time I cried during dance. It was therapeutic.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Growing Confidence',
            'description': 'Learning to let go of control and trust the process.',
          },
        ];
      case 'amateur4': // Mark Thompson - Dad/Salsa
        return [
          {
            'date': 'Sep 2023',
            'title': 'Wife\'s Suggestion',
            'description': 'My wife suggested we take salsa classes together.',
          },
          {
            'date': 'Nov 2023',
            'title': 'Family Dance Nights',
            'description': 'Started teaching our kids basic salsa steps.',
          },
          {
            'date': 'Jan 2024',
            'title': 'Social Dancing',
            'description': 'Attended our first salsa social. Met amazing people!',
          },
          {
            'date': 'Apr 2024',
            'title': 'Dance Family',
            'description': 'Salsa brought our family closer. Best decision ever!',
          },
        ];
      case 'amateur5': // Anna Schmidt - Nurse/Lyrical
        return [
          {
            'date': 'Mar 2024',
            'title': 'Seeking Balance',
            'description': 'After a tough month at the hospital, I needed an outlet.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Finding Peace',
            'description': 'Lyrical dance became my meditation and therapy.',
          },
        ];
      case 'amateur6': // Raj Patel - Developer/Bollywood
        return [
          {
            'date': 'Dec 2023',
            'title': 'Reconnecting with Roots',
            'description': 'Wanted to connect with my Indian heritage through dance.',
          },
          {
            'date': 'Jan 2024',
            'title': 'First Bollywood Class',
            'description': 'The energy and colors reminded me of family celebrations.',
          },
          {
            'date': 'Mar 2024',
            'title': 'Cultural Pride',
            'description': 'Performed at a cultural festival. My parents were so proud!',
          },
          {
            'date': 'Apr 2024',
            'title': 'Teaching Others',
            'description': 'Started teaching Bollywood basics to coworkers.',
          },
        ];
      case 'amateur7': // Maria Santos - Accountant/Tango
        return [
          {
            'date': 'Jan 2024',
            'title': 'New Year Resolution',
            'description': 'Decided to try something completely out of my comfort zone.',
          },
          {
            'date': 'Feb 2024',
            'title': 'Learning to Trust',
            'description': 'Tango taught me about vulnerability and connection.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Embracing the Journey',
            'description': 'No longer afraid to make mistakes. Growth is beautiful.',
          },
        ];
      case 'amateur8': // Kevin Lee - College/Street Dance
        return [
          {
            'date': 'Oct 2023',
            'title': 'Freshman Year',
            'description': 'Joined the university street dance club.',
          },
          {
            'date': 'Dec 2023',
            'title': 'First Performance',
            'description': 'Performed at the winter showcase. Adrenaline rush!',
          },
          {
            'date': 'Feb 2024',
            'title': 'Crew Family',
            'description': 'My dance crew became my college family.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Choreography Debut',
            'description': 'Choreographed my first piece for the crew.',
          },
        ];
      case 'amateur9': // Sophie Martin - Designer/Ballet
        return [
          {
            'date': 'Feb 2024',
            'title': 'Childhood Dream',
            'description': 'Finally pursuing the ballet dream I had as a child.',
          },
          {
            'date': 'Mar 2024',
            'title': 'Adult Ballet Community',
            'description': 'Found a supportive community of adult learners.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Design Meets Dance',
            'description': 'My design work is now influenced by ballet aesthetics.',
          },
        ];
      case 'amateur10': // Carlos Ruiz - Chef/Salsa
        return [
          {
            'date': 'Nov 2023',
            'title': 'Weekend Escape',
            'description': 'Started salsa as a break from the kitchen.',
          },
          {
            'date': 'Jan 2024',
            'title': 'Salsa Socials',
            'description': 'Weekend salsa socials became my favorite activity.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Two Passions',
            'description': 'Cooking and dancing - both are about creating joy.',
          },
        ];
      case 'amateur11': // Emily Davis - Marketing/Jazz
        return [
          {
            'date': 'Mar 2024',
            'title': 'Creative Outlet',
            'description': 'Needed a creative outlet beyond marketing campaigns.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Jazz Energy',
            'description': 'Jazz dance brings the energy I need in my life.',
          },
        ];
      case 'amateur12': // David Kim - Lawyer/Tap
        return [
          {
            'date': 'Dec 2023',
            'title': 'Holiday Gift',
            'description': 'Received tap shoes as a Christmas gift. Best gift ever!',
          },
          {
            'date': 'Feb 2024',
            'title': 'Rhythm and Law',
            'description': 'Found unexpected parallels between rhythm and legal arguments.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Pure Joy',
            'description': 'Tap dancing is pure, unadulterated joy.',
          },
        ];
      case 'amateur13': // Rachel Green - Photographer/Modern
        return [
          {
            'date': 'Jan 2024',
            'title': 'From Observer to Participant',
            'description': 'Tired of just photographing dancers. Wanted to BE one.',
          },
          {
            'date': 'Mar 2024',
            'title': 'New Perspective',
            'description': 'Dancing changed how I see and capture movement.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Art in Motion',
            'description': 'Now I understand dance from the inside out.',
          },
        ];
      case 'amateur14': // Mike Brown - Firefighter/Swing
        return [
          {
            'date': 'Oct 2023',
            'title': 'Station Tradition',
            'description': 'Our fire station started a swing dance tradition.',
          },
          {
            'date': 'Dec 2023',
            'title': 'Trust and Partnership',
            'description': 'Swing dance taught me about trust - crucial in my job.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Life Lessons',
            'description': 'Dance lessons that save lives. Literally.',
          },
        ];
      case 'amateur15': // Linda Hassan - Dentist/Belly Dance
        return [
          {
            'date': 'Feb 2024',
            'title': 'Self-Discovery',
            'description': 'Started belly dance to reconnect with my body.',
          },
          {
            'date': 'Apr 2024',
            'title': 'Body Positivity',
            'description': 'Learning to love and appreciate my body through dance.',
          },
        ];
      case 'amateur16': // Alex Turner - Barista/Breaking
        return [
          {
            'date': 'Mar 2024',
            'title': 'Street Inspiration',
            'description': 'Saw breakers in the park. Had to learn!',
          },
          {
            'date': 'Apr 2024',
            'title': 'Daily Practice',
            'description': 'Practice before work, practice after work. Obsessed!',
          },
        ];
      default:
        return [
          {
            'date': 'Recently',
            'title': 'Started Dancing',
            'description': 'Beginning my dance journey with passion and dedication.',
          },
        ];
    }
  }

  Widget _buildRelatedInsights() {
    final relatedArticles = _getRelatedArticles();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'More from this author',
            style: TextStyle(
              color: AppConstants.offWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...relatedArticles.asMap().entries.map((entry) {
            final index = entry.key;
            final article = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 8),
                _buildRelatedItem(
                  article['title']!,
                  article['readTime']!,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  List<Map<String, String>> _getRelatedArticles() {
    // 根据作者ID返回不同的相关文章
    switch (widget.insight.author.id) {
      case 'amateur1': // Jenny Park - Office Worker/Ballet
        return [
          {'title': 'My First Pointe Shoes: A Dream Come True', 'readTime': '4 min read'},
          {'title': 'Balancing Work Deadlines and Ballet Classes', 'readTime': '5 min read'},
          {'title': 'Why I\'m Not Too Old for Ballet', 'readTime': '6 min read'},
        ];
      case 'amateur2': // Tom Anderson - Engineer/Hip Hop
        return [
          {'title': 'Coding by Day, Dancing by Night', 'readTime': '5 min read'},
          {'title': 'My First Battle: Lessons in Failure', 'readTime': '6 min read'},
          {'title': 'How Hip Hop Made Me a Better Engineer', 'readTime': '7 min read'},
        ];
      case 'amateur3': // Lisa Wong - Teacher/Contemporary
        return [
          {'title': 'From Control Freak to Flow State', 'readTime': '5 min read'},
          {'title': 'Teaching Kids vs. Learning Dance', 'readTime': '6 min read'},
          {'title': 'The Day I Cried in Dance Class', 'readTime': '4 min read'},
        ];
      case 'amateur4': // Mark Thompson - Dad/Salsa
        return [
          {'title': 'Date Night Revolution: Our Salsa Story', 'readTime': '6 min read'},
          {'title': 'Teaching My Kids to Dance', 'readTime': '5 min read'},
          {'title': 'How Dance Saved My Marriage', 'readTime': '7 min read'},
        ];
      case 'amateur5': // Anna Schmidt - Nurse/Lyrical
        return [
          {'title': 'Dancing Away the ER Stress', 'readTime': '5 min read'},
          {'title': 'Finding Peace After 12-Hour Shifts', 'readTime': '6 min read'},
          {'title': 'Why Every Nurse Needs a Creative Outlet', 'readTime': '5 min read'},
        ];
      case 'amateur6': // Raj Patel - Developer/Bollywood
        return [
          {'title': 'Reconnecting with My Indian Roots', 'readTime': '6 min read'},
          {'title': 'Bollywood Dance: More Than Just Movies', 'readTime': '5 min read'},
          {'title': 'Teaching Coworkers to Dance', 'readTime': '4 min read'},
        ];
      case 'amateur7': // Maria Santos - Accountant/Tango
        return [
          {'title': 'Tango: My New Year\'s Resolution Success', 'readTime': '5 min read'},
          {'title': 'Learning to Trust on the Dance Floor', 'readTime': '6 min read'},
          {'title': 'From Spreadsheets to Passion', 'readTime': '5 min read'},
        ];
      case 'amateur8': // Kevin Lee - College Student/Street
        return [
          {'title': 'Finding My College Family Through Dance', 'readTime': '5 min read'},
          {'title': 'Balancing Studies and Street Dance', 'readTime': '6 min read'},
          {'title': 'My First Choreography: A Beginner\'s Tale', 'readTime': '7 min read'},
        ];
      case 'amateur9': // Sophie Martin - Designer/Ballet
        return [
          {'title': 'Childhood Dreams at 30: Never Too Late', 'readTime': '6 min read'},
          {'title': 'How Ballet Influences My Design Work', 'readTime': '5 min read'},
          {'title': 'Adult Ballet: Finding My Community', 'readTime': '5 min read'},
        ];
      case 'amateur10': // Carlos Ruiz - Chef/Salsa
        return [
          {'title': 'Cooking and Dancing: Two Passions', 'readTime': '5 min read'},
          {'title': 'Weekend Salsa Socials: My Escape', 'readTime': '4 min read'},
          {'title': 'From Kitchen Heat to Dance Floor', 'readTime': '6 min read'},
        ];
      case 'amateur11': // Emily Davis - Marketing/Jazz
        return [
          {'title': 'Jazz Dance: My Creative Outlet', 'readTime': '5 min read'},
          {'title': 'Marketing Campaigns and Dance Routines', 'readTime': '6 min read'},
          {'title': 'Finding Energy Through Movement', 'readTime': '4 min read'},
        ];
      case 'amateur12': // David Kim - Lawyer/Tap
        return [
          {'title': 'Tap Dancing Lawyer: Yes, It\'s a Thing', 'readTime': '5 min read'},
          {'title': 'Rhythm and Legal Arguments', 'readTime': '6 min read'},
          {'title': 'My Christmas Gift That Changed Everything', 'readTime': '5 min read'},
        ];
      case 'amateur13': // Rachel Green - Photographer/Modern
        return [
          {'title': 'From Behind the Camera to Center Stage', 'readTime': '6 min read'},
          {'title': 'How Dance Changed My Photography', 'readTime': '5 min read'},
          {'title': 'Understanding Movement from the Inside', 'readTime': '7 min read'},
        ];
      case 'amateur14': // Mike Brown - Firefighter/Swing
        return [
          {'title': 'Fire Station Dance Tradition', 'readTime': '5 min read'},
          {'title': 'Trust: From Dance Floor to Fire Ground', 'readTime': '6 min read'},
          {'title': 'Swing Dance Lessons That Save Lives', 'readTime': '7 min read'},
        ];
      case 'amateur15': // Linda Hassan - Dentist/Belly Dance
        return [
          {'title': 'Belly Dance: My Journey to Self-Love', 'readTime': '6 min read'},
          {'title': 'Body Positivity Through Movement', 'readTime': '5 min read'},
          {'title': 'From Dental Chair to Dance Floor', 'readTime': '5 min read'},
        ];
      case 'amateur16': // Alex Turner - Barista/Breaking
        return [
          {'title': 'Breaking Dreams: A Barista\'s Story', 'readTime': '5 min read'},
          {'title': 'Practice Before and After Work', 'readTime': '4 min read'},
          {'title': 'Street Inspiration: How I Started', 'readTime': '6 min read'},
        ];
      default:
        return [
          {'title': 'My Dance Journey Continues', 'readTime': '5 min read'},
          {'title': 'Lessons from the Dance Floor', 'readTime': '6 min read'},
        ];
    }
  }

  Widget _buildRelatedItem(String title, String readTime) {
    return Builder(
      builder: (BuildContext ctx) {
        return GestureDetector(
          onTap: () => _showRelatedArticleDialog(ctx, title),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.graphite,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  readTime,
                  style: const TextStyle(
                    color: AppConstants.midGray,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.midGray,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRelatedArticleDialog(BuildContext context, String title) {
    final content = _getRelatedArticleContent(title);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppConstants.ebony,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppConstants.graphite,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: AppConstants.offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppConstants.midGray,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      content,
                      style: const TextStyle(
                        color: AppConstants.offWhite,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppConstants.graphite,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppConstants.theatreRed,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'By ${widget.insight.author.displayName}',
                        style: const TextStyle(
                          color: AppConstants.midGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRelatedArticleContent(String title) {
    // 根据文章标题返回对应的内容
    final contentMap = {
      // Jenny Park
      'My First Pointe Shoes: A Dream Come True': 'When the package arrived, my hands were shaking. Inside were my first pair of pointe shoes. At 28, I never thought this moment would come. I spent the evening just holding them, feeling the satin, the ribbons. My childhood dream, finally real. The next class, when I first stood en pointe, I cried. Not from pain, but from pure joy. This is what it feels like to never give up on your dreams.',
      'Balancing Work Deadlines and Ballet Classes': 'Monday: client presentation. Tuesday: quarterly report. Wednesday: ballet class. My coworkers think I\'m crazy for rushing out at 5 PM sharp. But they don\'t understand - ballet is what keeps me sane. It\'s my escape from spreadsheets and emails. Yes, I\'m tired. Yes, it\'s hard. But when I\'m at the barre, nothing else matters. Work can wait. My dreams can\'t.',
      'Why I\'m Not Too Old for Ballet': 'Someone asked me, "Aren\'t you too old for ballet?" I smiled and said, "I\'m too old to care what people think." Age is just a number. Passion has no expiration date. Every class, I\'m surrounded by women like me - professionals, mothers, dreamers - all pursuing something we love. We may not become prima ballerinas, but we\'re living our truth. And that\'s more valuable than any perfect pirouette.',
      
      // Tom Anderson
      'Coding by Day, Dancing by Night': 'My life is split between two worlds. By day, I write code - logical, structured, predictable. By night, I dance - free, expressive, spontaneous. My colleagues don\'t understand why I need both. But I do. Code exercises my mind. Dance frees my soul. Together, they make me whole. I\'m not just an engineer. I\'m an engineer who dances. And that makes all the difference.',
      'My First Battle: Lessons in Failure': 'I lost. Badly. My first hip hop battle was a disaster. I froze, forgot my moves, looked like a complete beginner. Because I am one. But you know what? I showed up. I tried. And the crew respected that. They told me, "You\'ll lose a hundred battles before you win one. Keep going." So I am. Because failure is just practice in disguise.',
      'How Hip Hop Made Me a Better Engineer': 'Hip hop taught me to think differently. In dance, there\'s no "right" answer - just creative solutions. Same with coding. Now when I hit a bug, I don\'t just follow the manual. I freestyle. I improvise. I find new approaches. My code is better because my mind is more flexible. Dance didn\'t just change how I move. It changed how I think.',
      
      // Lisa Wong
      'From Control Freak to Flow State': 'As a teacher, I control everything. Lesson plans, classroom management, student outcomes. Contemporary dance is teaching me to let go. To trust. To flow. It\'s terrifying and liberating at the same time. I\'m learning that not everything needs to be planned. Sometimes the best moments happen when you stop trying to control them. This lesson is changing my teaching, my dancing, and my life.',
      'Teaching Kids vs. Learning Dance': 'I teach 30 kids every day. I\'m the expert, the authority. But in dance class, I\'m the student. I make mistakes. I struggle. I ask for help. It\'s humbling. And it\'s exactly what I needed. Being a student again reminds me what my kids feel like. It\'s making me a more patient, understanding teacher. Dance is teaching me to teach better.',
      'The Day I Cried in Dance Class': 'It happened during a slow, emotional piece. The music, the movement, the release - it all hit me at once. Years of stress, of trying to be perfect, of holding it together for my students - it all came pouring out. I cried in the middle of class. And my teacher just nodded, like she understood. Because she did. Dance doesn\'t just move your body. It moves everything you\'ve been holding inside.',
      
      // Mark Thompson
      'Date Night Revolution: Our Salsa Story': 'We were stuck in a rut. Work, kids, sleep, repeat. My wife suggested salsa classes. I thought it was silly. But I went. And everything changed. Now we have something that\'s just ours. Not about the kids, not about work. Just us, dancing, laughing, connecting. Salsa didn\'t just teach us to dance. It taught us to be a couple again.',
      'Teaching My Kids to Dance': 'Last Saturday, my daughter asked, "Daddy, can you teach me salsa?" My heart melted. Now every weekend, we have family dance time. My son tries to spin his sister. My wife and I demonstrate. We laugh, we stumble, we have fun. I\'m not just teaching them to dance. I\'m teaching them that it\'s okay to try new things, to be silly, to enjoy life. These are the moments they\'ll remember.',
      'How Dance Saved My Marriage': 'I almost lost her. We were roommates, not partners. Too busy, too tired, too distant. Salsa brought us back together. It forced us to communicate, to touch, to look at each other. Every dance is a conversation without words. We\'re learning each other again. Dance didn\'t just save our marriage. It reminded us why we fell in love in the first place.',
      
      // Anna Schmidt
      'Dancing Away the ER Stress': 'Twelve-hour shifts in the ER drain everything from you. The pain, the loss, the constant pressure - it builds up. Lyrical dance is my release. When I dance, I let it all out. The grief I can\'t show at work. The exhaustion I hide from my family. Dance holds it all. It\'s not just exercise. It\'s survival.',
      'Finding Peace After 12-Hour Shifts': 'I come home from the hospital carrying the weight of the day. But twice a week, I go to dance class instead. For one hour, I\'m not a nurse. I\'m not responsible for anyone. I\'m just me, moving, breathing, being. That hour of peace carries me through the rest of the week. Dance is my therapy, my sanctuary, my lifeline.',
      'Why Every Nurse Needs a Creative Outlet': 'Nursing is all about giving. You give your time, your energy, your compassion. But who fills you back up? For me, it\'s dance. It\'s the one thing I do just for myself. Not for patients, not for family, just for me. Every nurse needs something like this. Something that reminds you that you\'re more than your job. You\'re human too.',
    };
    
    return contentMap[title] ?? 'This article explores the journey of ${widget.insight.author.displayName} and their experiences with dance. Through dedication and passion, they continue to grow and inspire others in the dance community. Stay tuned for the full article coming soon!';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
