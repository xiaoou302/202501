import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/pose_model.dart';
import '../../data/models/insight_model.dart';
import '../../services/blocked_users_service.dart';
import 'pose_detail_screen.dart';
import 'insight_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> _followedProfessionals = [];
  List<User> _followedAmateurs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFollowedUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final blockedUsers = await BlockedUsersService().getBlockedUsers();
    final allUsers = [..._getProfessionalUsers(), ..._getAmateurUsers()];
    
    final professionals = <User>[];
    final amateurs = <User>[];
    
    for (final user in allUsers) {
      // 跳过被屏蔽的用户
      if (blockedUsers.contains(user.id)) {
        continue;
      }
      
      final key = 'following_${user.id}';
      final isFollowing = prefs.getBool(key) ?? false;
      
      if (isFollowing) {
        if (user.id.startsWith('pro')) {
          professionals.add(user);
        } else {
          amateurs.add(user);
        }
      }
    }
    
    setState(() {
      _followedProfessionals = professionals;
      _followedAmateurs = amateurs;
      _isLoading = false;
    });
  }

  Future<void> _unfollowUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'following_${user.id}';
    await prefs.setBool(key, false);
    
    setState(() {
      _followedProfessionals.removeWhere((u) => u.id == user.id);
      _followedAmateurs.removeWhere((u) => u.id == user.id);
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Unfollowed ${user.displayName}'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppConstants.graphite,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildFollowedList(_followedProfessionals, 'Professional Dancers'),
                        _buildFollowedList(_followedAmateurs, 'Amateur Dancers'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.3),
            AppConstants.ebony,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppConstants.theatreRed, AppConstants.balletPink],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.theatreRed.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Favorites',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Dancers you follow',
                  style: TextStyle(
                    color: AppConstants.midGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppConstants.offWhite, size: 24),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.settingsRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppConstants.graphite.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppConstants.theatreRed, AppConstants.balletPink],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppConstants.theatreRed.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.midGray,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 18),
                const SizedBox(width: 8),
                Text('Pros (${_followedProfessionals.length})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_rounded, size: 18),
                const SizedBox(width: 8),
                Text('Amateurs (${_followedAmateurs.length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
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
            'Loading your favorites...',
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

  Widget _buildFollowedList(List<User> users, String category) {
    if (users.isEmpty) {
      return _buildEmptyState(category);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserCard(users[index]);
      },
    );
  }

  Widget _buildEmptyState(String category) {
    final isPro = category.contains('Professional');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppConstants.graphite.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPro ? Icons.star_outline_rounded : Icons.favorite_border_rounded,
                size: 80,
                color: AppConstants.midGray.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $category Yet',
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isPro
                  ? 'Follow professional dancers from the Pose Flow\nto see them here'
                  : 'Follow amateur dancers from Insights\nto see them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    final isPro = user.id.startsWith('pro');
    
    return GestureDetector(
      onTap: () async {
        // 根据用户类型导航到不同的详情页
        if (isPro) {
          // 专业舞者 -> Pose Detail Screen
          final pose = _getPoseByUserId(user.id);
          if (pose != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PoseDetailScreen(
                  pose: pose,
                  showMenu: true, // 显示菜单
                  onDelete: () async {
                    // 屏蔽用户
                    await BlockedUsersService().blockUser(pose.author.id);
                    // 重新加载以移除被屏蔽用户
                    await _loadFollowedUsers();
                    
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
                                      '${pose.author.displayName} has been blocked. You won\'t see their content anymore.',
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
                ),
              ),
            );
            
            if (result == 'delete' && mounted) {
              _loadFollowedUsers();
            }
          }
        } else {
          // 业余舞者 -> Insight Detail Screen
          final insight = _getInsightByUserId(user.id);
          if (insight != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsightDetailScreen(
                  insight: insight,
                  showMenu: true, // 显示菜单
                  onDelete: () async {
                    // 屏蔽用户
                    await BlockedUsersService().blockUser(insight.author.id);
                    // 重新加载以移除被屏蔽用户
                    await _loadFollowedUsers();
                    
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
                                      '${insight.author.displayName} has been blocked. You won\'t see their content anymore.',
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
                ),
              ),
            );
            
            if (result == 'delete' && mounted) {
              _loadFollowedUsers();
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.graphite.withValues(alpha: 0.5),
              AppConstants.graphite.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPro
                ? AppConstants.energyYellow.withValues(alpha: 0.2)
                : AppConstants.theatreRed.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isPro
                    ? [AppConstants.energyYellow, AppConstants.theatreRed]
                    : [AppConstants.theatreRed, AppConstants.balletPink],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isPro ? AppConstants.energyYellow : AppConstants.theatreRed)
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.transparent,
              child: Text(
                user.displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
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
                        user.displayName,
                        style: const TextStyle(
                          color: AppConstants.offWhite,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    if (isPro) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppConstants.energyYellow, AppConstants.theatreRed],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, color: Colors.white, size: 10),
                            SizedBox(width: 3),
                            Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (user.bio.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    user.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppConstants.midGray.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                // 阻止事件冒泡到 GestureDetector
                _unfollowUser(user);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPro ? AppConstants.energyYellow : AppConstants.theatreRed,
                foregroundColor: isPro ? AppConstants.ebony : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPro ? Icons.star_rounded : Icons.favorite_rounded,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Following',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<User> _getProfessionalUsers() {
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

  List<User> _getAmateurUsers() {
    return [
      User(
        id: 'amateur1',
        username: 'jenny_ballet',
        displayName: 'Jenny Park',
        bio: 'Office Worker | Adult Ballet Beginner',
        joinDate: DateTime(2024, 1, 10),
        followersCount: 234,
        followingCount: 89,
        posesCount: 12,
      ),
      User(
        id: 'amateur2',
        username: 'tom_hiphop',
        displayName: 'Tom Anderson',
        bio: 'Software Engineer | Hip Hop Enthusiast',
        joinDate: DateTime(2023, 11, 5),
        followersCount: 456,
        followingCount: 123,
        posesCount: 28,
      ),
      User(
        id: 'amateur3',
        username: 'lisa_contemporary',
        displayName: 'Lisa Wong',
        bio: 'High School Teacher | Contemporary Dance Lover',
        joinDate: DateTime(2024, 2, 14),
        followersCount: 189,
        followingCount: 67,
        posesCount: 15,
      ),
      User(
        id: 'amateur4',
        username: 'mark_salsa',
        displayName: 'Mark Thompson',
        bio: 'Marketing Manager | Salsa Dancer',
        joinDate: DateTime(2023, 9, 20),
        followersCount: 567,
        followingCount: 145,
        posesCount: 34,
      ),
      User(
        id: 'amateur5',
        username: 'anna_lyrical',
        displayName: 'Anna Schmidt',
        bio: 'Nurse | Lyrical Dance Student',
        joinDate: DateTime(2024, 3, 8),
        followersCount: 312,
        followingCount: 98,
        posesCount: 19,
      ),
      User(
        id: 'amateur6',
        username: 'raj_bollywood',
        displayName: 'Raj Patel',
        bio: 'Web Developer | Bollywood Dance Fan',
        joinDate: DateTime(2023, 12, 1),
        followersCount: 423,
        followingCount: 156,
        posesCount: 25,
      ),
      User(
        id: 'amateur7',
        username: 'maria_tango',
        displayName: 'Maria Santos',
        bio: 'Accountant | Tango Beginner',
        joinDate: DateTime(2024, 1, 22),
        followersCount: 278,
        followingCount: 82,
        posesCount: 14,
      ),
      User(
        id: 'amateur8',
        username: 'kevin_street',
        displayName: 'Kevin Lee',
        bio: 'College Student | Street Dance Crew',
        joinDate: DateTime(2023, 10, 15),
        followersCount: 689,
        followingCount: 234,
        posesCount: 42,
      ),
      User(
        id: 'amateur9',
        username: 'sophie_ballet',
        displayName: 'Sophie Martin',
        bio: 'Graphic Designer | Ballet Enthusiast',
        joinDate: DateTime(2024, 2, 28),
        followersCount: 345,
        followingCount: 112,
        posesCount: 18,
      ),
      User(
        id: 'amateur10',
        username: 'carlos_salsa',
        displayName: 'Carlos Ruiz',
        bio: 'Chef | Salsa Social Dancer',
        joinDate: DateTime(2023, 11, 18),
        followersCount: 512,
        followingCount: 167,
        posesCount: 31,
      ),
      User(
        id: 'amateur11',
        username: 'emily_jazz',
        displayName: 'Emily Davis',
        bio: 'Marketing Specialist | Jazz Dance Student',
        joinDate: DateTime(2024, 3, 15),
        followersCount: 267,
        followingCount: 78,
        posesCount: 16,
      ),
      User(
        id: 'amateur12',
        username: 'david_tap',
        displayName: 'David Kim',
        bio: 'Lawyer | Tap Dance Hobbyist',
        joinDate: DateTime(2024, 1, 5),
        followersCount: 398,
        followingCount: 134,
        posesCount: 22,
      ),
      User(
        id: 'amateur13',
        username: 'rachel_modern',
        displayName: 'Rachel Green',
        bio: 'Photographer | Modern Dance Explorer',
        joinDate: DateTime(2024, 2, 10),
        followersCount: 445,
        followingCount: 156,
        posesCount: 27,
      ),
      User(
        id: 'amateur14',
        username: 'mike_swing',
        displayName: 'Mike Brown',
        bio: 'Firefighter | Swing Dance Enthusiast',
        joinDate: DateTime(2023, 12, 20),
        followersCount: 334,
        followingCount: 101,
        posesCount: 20,
      ),
      User(
        id: 'amateur15',
        username: 'linda_belly',
        displayName: 'Linda Hassan',
        bio: 'Dentist | Belly Dance Student',
        joinDate: DateTime(2024, 3, 1),
        followersCount: 289,
        followingCount: 89,
        posesCount: 17,
      ),
      User(
        id: 'amateur16',
        username: 'alex_breaking',
        displayName: 'Alex Turner',
        bio: 'Barista | Breaking Beginner',
        joinDate: DateTime(2024, 3, 20),
        followersCount: 223,
        followingCount: 67,
        posesCount: 13,
      ),
    ];
  }

  // 根据用户ID获取对应的Pose（专业舞者）
  Pose? _getPoseByUserId(String userId) {
    final users = _getProfessionalUsers();
    final user = users.firstWhere((u) => u.id == userId);
    
    // 根据用户ID返回对应的Pose
    final poseMap = {
      'pro1': Pose(
        id: 'pose1',
        imageUrl: 'assets/wzc/wzc1.jpg',
        caption: 'Perfecting the arabesque for tonight\'s Swan Lake performance. 15 years of training in this moment. 🩰',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['#Ballet', '#SwanLake', '#RoyalBallet'],
        likesCount: 8234,
      ),
      'pro2': Pose(
        id: 'pose2',
        imageUrl: 'assets/wzc/wzc2.jpg',
        caption: 'Choreographing for Alvin Ailey\'s new season. Contemporary dance is about breaking boundaries. 💫',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['#Contemporary', '#AlvinAiley', '#Choreography'],
        likesCount: 6189,
      ),
      'pro3': Pose(
        id: 'pose3',
        imageUrl: 'assets/wzc/wzc3.jpg',
        caption: 'World Championship winning move! Hip hop is life, life is hip hop. 🏆🔥',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        tags: ['#HipHop', '#WorldChampion', '#Battle'],
        likesCount: 15456,
      ),
      'pro4': Pose(
        id: 'pose4',
        imageUrl: 'assets/wzc/wzc4.jpg',
        caption: 'Hamilton matinee today! 8 shows a week on Broadway never gets old. ✨🎭',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['#Broadway', '#Hamilton', '#Musical'],
        likesCount: 9312,
      ),
      'pro5': Pose(
        id: 'pose5',
        imageUrl: 'assets/wzc/wzc5.jpg',
        caption: 'Training for Paris 2024 Olympics. Breaking is now an Olympic sport! 💪🥇',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        tags: ['#Breaking', '#Olympics', '#RedBullBCOne'],
        likesCount: 12278,
      ),
      'pro6': Pose(
        id: 'pose6',
        imageUrl: 'assets/wzc/wzc6.jpg',
        caption: 'Flamenco passion from Seville. Every zapateado tells a story of Andalusia. 🌹',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        tags: ['#Flamenco', '#Seville', '#Spanish'],
        likesCount: 5523,
      ),
      'pro7': Pose(
        id: 'pose7',
        imageUrl: 'assets/wzc/wzc7.jpg',
        caption: 'Tap dancing on Broadway for 20 years. The rhythm never stops! 🎵👞',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['#Tap', '#Broadway', '#Rhythm'],
        likesCount: 4401,
      ),
      'pro8': Pose(
        id: 'pose8',
        imageUrl: 'assets/wzc/wzc8.jpg',
        caption: 'Butoh performance in Tokyo. Dance of darkness and light. 🎭🇯🇵',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        tags: ['#Butoh', '#Tokyo', '#Japanese'],
        likesCount: 3267,
      ),
      'pro9': Pose(
        id: 'pose9',
        imageUrl: 'assets/wzc/wzc9.jpg',
        caption: 'Argentine Tango champion. Buenos Aires is in my blood. 🖤🇦🇷',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        tags: ['#Tango', '#Argentina', '#Champion'],
        likesCount: 7345,
      ),
      'pro10': Pose(
        id: 'pose10',
        imageUrl: 'assets/wzc/wzc10.jpg',
        caption: 'Capoeira Mestre from Brazil. Dance, fight, art - all in one. 🇧🇷⚡',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['#Capoeira', '#Brazil', '#Mestre'],
        likesCount: 6198,
      ),
      'pro11': Pose(
        id: 'pose11',
        imageUrl: 'assets/wzc/wzc11.jpg',
        caption: 'Martha Graham technique. Modern dance is the language of the soul. 🌟',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        tags: ['#Modern', '#MarthaGraham', '#Technique'],
        likesCount: 5412,
      ),
      'pro12': Pose(
        id: 'pose12',
        imageUrl: 'assets/wzc/wzc12.jpg',
        caption: 'Choreographing for Bollywood! Mumbai film industry magic. 🎬✨',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        tags: ['#Bollywood', '#Mumbai', '#Film'],
        likesCount: 11289,
      ),
      'pro13': Pose(
        id: 'pose13',
        imageUrl: 'assets/wzc/wzc13.jpg',
        caption: 'Paris Opera Ballet lyrical performance. Grace and emotion combined. 🩰🇫🇷',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        tags: ['#Lyrical', '#ParisOpera', '#Ballet'],
        likesCount: 5567,
      ),
      'pro14': Pose(
        id: 'pose14',
        imageUrl: 'assets/wzc/wzc14.jpg',
        caption: 'Salsa World Champion from Cali! Colombian rhythm in my veins. 💃🇨🇴',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 4)),
        tags: ['#Salsa', '#Colombia', '#WorldChampion'],
        likesCount: 8334,
      ),
      'pro15': Pose(
        id: 'pose15',
        imageUrl: 'assets/wzc/wzc15.jpg',
        caption: 'Blackpool Ballroom winner! Waltz, tango, foxtrot - mastered them all. 👗💎',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 8)),
        tags: ['#Ballroom', '#Blackpool', '#Champion'],
        likesCount: 6445,
      ),
      'pro16': Pose(
        id: 'pose16',
        imageUrl: 'assets/wzc/wzc16.jpg',
        caption: 'LA Krump legend! Street dance pioneer since 2005. 💥👑',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['#Krump', '#LA', '#Pioneer'],
        likesCount: 10378,
      ),
      'pro17': Pose(
        id: 'pose17',
        imageUrl: 'assets/wzc/wzc17.jpg',
        caption: 'Chinese Classical Dance from Beijing Academy. 5000 years of tradition. 🏮🇨🇳',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 3)),
        tags: ['#Chinese', '#Classical', '#Beijing'],
        likesCount: 9423,
      ),
      'pro18': Pose(
        id: 'pose18',
        imageUrl: 'assets/wzc/wzc18.jpg',
        caption: 'Cairo Belly Dance Festival champion. Ancient art, modern expression. 🌙✨',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 7)),
        tags: ['#BellyDance', '#Cairo', '#Champion'],
        likesCount: 7512,
      ),
      'pro19': Pose(
        id: 'pose19',
        imageUrl: 'assets/wzc/wzc19.jpg',
        caption: 'Rio Carnival lead dancer! Samba is the heartbeat of Brazil. 🎉🇧🇷',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        tags: ['#Samba', '#Rio', '#Carnival'],
        likesCount: 13298,
      ),
      'pro20': Pose(
        id: 'pose20',
        imageUrl: 'assets/wzc/wzc20.jpg',
        caption: 'Russian Folk Dance Ensemble Director. Preserving our cultural heritage. 🪆🇷🇺',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 6, hours: 5)),
        tags: ['#Russian', '#Folk', '#Traditional'],
        likesCount: 4489,
      ),
    };
    
    return poseMap[userId];
  }

  // 根据用户ID获取对应的Insight（业余舞者）
  Insight? _getInsightByUserId(String userId) {
    final users = _getAmateurUsers();
    final user = users.firstWhere((u) => u.id == userId);
    
    // 根据用户ID返回对应的Insight
    final insightMap = {
      'amateur1': Insight(
        id: 'insight1',
        title: 'Starting Ballet at 28: It\'s Never Too Late',
        content: 'Three months ago, I walked into my first adult ballet class...',
        imageUrl: 'assets/wzk/wzk1.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        emotionTags: [],
        readCount: 1234,
      ),
      'amateur2': Insight(
        id: 'insight2',
        title: 'From Code to Choreography: My Hip Hop Journey',
        content: 'As a software engineer, I spend most of my day solving logical problems...',
        imageUrl: 'assets/wzk/wzk2.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        emotionTags: [],
        readCount: 987,
      ),
      'amateur3': Insight(
        id: 'insight3',
        title: 'Teaching by Day, Dancing by Night',
        content: 'Contemporary dance has become my escape from the classroom...',
        imageUrl: 'assets/wzk/wzk3.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        emotionTags: [],
        readCount: 756,
      ),
      'amateur4': Insight(
        id: 'insight4',
        title: 'Salsa Saved My Marriage',
        content: 'My wife suggested we take salsa classes together...',
        imageUrl: 'assets/wzk/wzk4.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        emotionTags: [],
        readCount: 2145,
      ),
      'amateur5': Insight(
        id: 'insight5',
        title: 'Dancing Through Self-Doubt',
        content: 'Every dancer knows that voice. "You\'re not good enough..."',
        imageUrl: 'assets/wzk/wzk5.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        emotionTags: [],
        readCount: 1876,
      ),
      'amateur6': Insight(
        id: 'insight6',
        title: 'Reconnecting with My Roots Through Bollywood',
        content: 'Growing up in America, I felt disconnected from my Indian heritage...',
        imageUrl: 'assets/wzk/wzk6.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        emotionTags: [],
        readCount: 1432,
      ),
      'amateur7': Insight(
        id: 'insight7',
        title: 'Tango: My New Year\'s Resolution Success Story',
        content: 'For once, I actually kept my New Year\'s resolution...',
        imageUrl: 'assets/wzk/wzk7.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 8)),
        emotionTags: [],
        readCount: 892,
      ),
      'amateur8': Insight(
        id: 'insight8',
        title: 'Finding My College Family Through Dance',
        content: 'Freshman year was lonely until I joined the street dance club...',
        imageUrl: 'assets/wzk/wzk8.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 9)),
        emotionTags: [],
        readCount: 1654,
      ),
      'amateur9': Insight(
        id: 'insight9',
        title: 'Childhood Dreams at 30: Never Too Late for Ballet',
        content: 'I always wanted to be a ballerina as a child...',
        imageUrl: 'assets/wzk/wzk9.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        emotionTags: [],
        readCount: 2087,
      ),
      'amateur10': Insight(
        id: 'insight10',
        title: 'Cooking and Dancing: Two Passions, One Heart',
        content: 'As a chef, I create with food. As a salsa dancer, I create with movement...',
        imageUrl: 'assets/wzk/wzk10.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 11)),
        emotionTags: [],
        readCount: 1123,
      ),
      'amateur11': Insight(
        id: 'insight11',
        title: 'Jazz Dance: My Creative Outlet',
        content: 'Marketing campaigns are creative, but jazz dance is pure expression...',
        imageUrl: 'assets/wzk/wzk11.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 12)),
        emotionTags: [],
        readCount: 945,
      ),
      'amateur12': Insight(
        id: 'insight12',
        title: 'Tap Dancing Lawyer: Yes, It\'s a Thing',
        content: 'My colleagues think I\'m crazy, but tap dance keeps me sane...',
        imageUrl: 'assets/wzk/wzk12.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 13)),
        emotionTags: [],
        readCount: 1567,
      ),
      'amateur13': Insight(
        id: 'insight13',
        title: 'From Behind the Camera to Center Stage',
        content: 'I spent years photographing dancers. Now I am one...',
        imageUrl: 'assets/wzk/wzk13.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
        emotionTags: [],
        readCount: 1789,
      ),
      'amateur14': Insight(
        id: 'insight14',
        title: 'Fire Station Dance Tradition',
        content: 'Our fire station started a swing dance tradition...',
        imageUrl: 'assets/wzk/wzk14.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 15)),
        emotionTags: [],
        readCount: 1234,
      ),
      'amateur15': Insight(
        id: 'insight15',
        title: 'Belly Dance: My Journey to Self-Love',
        content: 'Belly dance taught me to love and appreciate my body...',
        imageUrl: 'assets/wzk/wzk15.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 16)),
        emotionTags: [],
        readCount: 2345,
      ),
      'amateur16': Insight(
        id: 'insight16',
        title: 'Breaking Dreams: A Barista\'s Story',
        content: 'I serve coffee by day and practice breaking by night...',
        imageUrl: 'assets/wzk/wzk16.jpg',
        author: user,
        timestamp: DateTime.now().subtract(const Duration(days: 17)),
        emotionTags: [],
        readCount: 876,
      ),
    };
    
    return insightMap[userId];
  }
}
