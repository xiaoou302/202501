import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/nav_bar.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/date_utils.dart';
import '../models/user_profile.dart';
import '../../love_diary/models/relationship.dart';
import '../../../routes.dart';
import '../../../theme.dart';

class ProfileScreen extends StatefulWidget {
  final bool useNavBar;

  const ProfileScreen({super.key, this.useNavBar = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  Relationship? _relationship;
  bool _isLoading = true;

  int _loveDays = 0;
  int _consecutiveRecordDays = 28; // 模拟数据
  int _generatedImages = 0;
  int _tripPlans = 0;
  int _memoriesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // 加载用户配置
    final userProfileJson = prefs.getString(AppConstants.prefUserProfile);
    if (userProfileJson != null) {
      setState(() {
        _userProfile = UserProfile.fromJson(
          jsonDecode(userProfileJson) as Map<String, dynamic>,
        );
      });
    } else {
      // 创建默认用户配置
      _createDefaultUserProfile();
    }

    // 加载恋爱关系数据
    final relationshipJson = prefs.getString(AppConstants.prefRelationship);
    if (relationshipJson != null) {
      final relationship = Relationship.fromJson(
        jsonDecode(relationshipJson) as Map<String, dynamic>,
      );

      setState(() {
        _relationship = relationship;
        _loveDays = AppDateUtils.calculateLoveDays(
          relationship.anniversaryDate,
        );
      });
    }

    // 加载卡通图片数量
    final cartoonsJson = prefs.getString(AppConstants.prefCartoons);
    if (cartoonsJson != null) {
      final List<dynamic> cartoonsList =
          jsonDecode(cartoonsJson) as List<dynamic>;
      setState(() {
        _generatedImages = cartoonsList.length;
      });
    }

    // 加载旅行计划数量
    final tripsJson = prefs.getString(AppConstants.prefTrips);
    if (tripsJson != null) {
      final List<dynamic> tripsList = jsonDecode(tripsJson) as List<dynamic>;
      setState(() {
        _tripPlans = tripsList.length;
      });
    }

    // 加载记忆数量
    final memoriesJson = prefs.getString(AppConstants.prefMemories);
    if (memoriesJson != null) {
      final List<dynamic> memoriesList =
          jsonDecode(memoriesJson) as List<dynamic>;
      setState(() {
        _memoriesCount = memoriesList.length;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _createDefaultUserProfile() async {
    final defaultProfile = UserProfile(
      name: AppConstants.defaultUserName,
      partnerName: AppConstants.defaultPartnerName,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefUserProfile,
      jsonEncode(defaultProfile.toJson()),
    );

    setState(() {
      _userProfile = defaultProfile;
    });
  }

  Future<void> _toggleSetting(String setting) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(
      darkModeEnabled: setting == 'darkMode'
          ? !_userProfile!.darkModeEnabled
          : _userProfile!.darkModeEnabled,
      notificationsEnabled: setting == 'notifications'
          ? !_userProfile!.notificationsEnabled
          : _userProfile!.notificationsEnabled,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefUserProfile,
      jsonEncode(updatedProfile.toJson()),
    );

    setState(() {
      _userProfile = updatedProfile;
    });
  }

  Future<void> _resetRelationship() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置恋爱信息'),
        content: const Text('确定要重置恋爱信息吗？这将删除所有与当前恋爱关系相关的数据，包括恋爱记录、纪念日等信息。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefRelationship);
    await prefs.remove(AppConstants.prefMemories);
    await prefs.remove(AppConstants.prefMilestones);

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.loveDiary);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          if (widget.useNavBar) const AppNavBar(currentIndex: 3),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildUserHeader(),
        const SizedBox(height: 20),
        _buildAppInfoCard(),
        const SizedBox(height: 20),
        _buildSupportCard(),
        const SizedBox(height: 20),
        _buildLegalCard(),
      ],
    );
  }

  Widget _buildUserHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.settings,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Settings",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Customize your app experience",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAppInfoCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.info_outline,
            iconColor: Colors.blue,
            title: 'About Us',
            onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
          ),
          _buildSettingItem(
            icon: Icons.lightbulb,
            iconColor: Colors.amber,
            title: 'User Guide',
            onTap: () => Navigator.pushNamed(context, AppRoutes.userGuide),
          ),
          _buildSettingItem(
            icon: Icons.history,
            iconColor: Colors.purple,
            title: 'Version History',
            onTap: () => Navigator.pushNamed(context, AppRoutes.versionHistory),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.contact_support,
            iconColor: Colors.green,
            title: 'Contact Us',
            onTap: () => Navigator.pushNamed(context, AppRoutes.contactUs),
          ),
          _buildSettingItem(
            icon: Icons.feedback,
            iconColor: Colors.orange,
            title: 'Feedback',
            onTap: () => Navigator.pushNamed(context, AppRoutes.feedback),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.gavel,
            iconColor: Colors.red,
            title: 'Terms of Service',
            onTap: () => Navigator.pushNamed(context, AppRoutes.termsOfService),
          ),
          _buildSettingItem(
            icon: Icons.security,
            iconColor: Colors.teal,
            title: 'Privacy Policy',
            onTap: () => Navigator.pushNamed(context, AppRoutes.privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.darkBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.deepPurple.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
