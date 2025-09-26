import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soli/presentation/providers/app_state.dart';
import 'package:soli/presentation/screens/community_screen.dart';
import 'package:soli/presentation/screens/gallery_screen.dart';
import 'package:soli/presentation/screens/planner_screen.dart';
import 'package:soli/presentation/screens/profile_screen.dart';
import 'package:soli/presentation/widgets/nav_bar.dart';

/// 主页面，包含底部导航和四个主要页面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // 处理参数，如果需要切换到社区页面并显示方案
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.arguments != null) {
        final args = widget.arguments!;

        // 切换到指定的标签页
        if (args.containsKey('initialTab')) {
          final initialTab = args['initialTab'] as int;
          Provider.of<AppState>(
            context,
            listen: false,
          ).setCurrentIndex(initialTab);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取路由参数
    final Map<String, dynamic>? routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // 合并路由参数和构造函数参数
    final Map<String, dynamic> args = {...?widget.arguments, ...?routeArgs};

    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Scaffold(
          body: IndexedStack(
            index: appState.currentIndex,
            children: [
              const GalleryScreen(),
              CommunityScreen(
                proposalPlan: args['showProposalPlan'] == true
                    ? args['proposalPlan']
                    : null,
              ),
              const PlannerScreen(),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: NavBar(
            currentIndex: appState.currentIndex,
            onTap: (index) => appState.setCurrentIndex(index),
          ),
        );
      },
    );
  }
}
