import 'package:flutter/material.dart';
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/proposal_plan_model.dart';
import 'package:soli/data/repositories/proposal_repository.dart';
import 'package:soli/presentation/screens/proposal_detail_screen.dart';
import 'package:soli/presentation/screens/proposal_generator_screen.dart';
import 'package:soli/presentation/widgets/proposal_card.dart';

/// 策划页面
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen>
    with AutomaticKeepAliveClientMixin {
  final ProposalRepository _proposalRepository = ProposalRepository();
  List<ProposalPlanModel> _proposals = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  // 加载方案数据
  Future<void> _loadProposals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final proposals = await _proposalRepository.getAllProposalPlans();

      if (mounted) {
        setState(() {
          _proposals = proposals;
        });
      }
    } catch (e) {
      // 处理错误
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 导航到方案生成页面
  Future<void> _navigateToProposalGenerator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProposalGeneratorScreen()),
    );

    if (result == true) {
      _loadProposals();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和操作按钮
              Animations.fadeSlideIn(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppConstants.titlePlanner,
                      style: const TextStyle(
                        color: AppTheme.moonlight,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppTheme.champagne),
                      onPressed: () => _navigateToProposalGenerator(context),
                      tooltip: 'Create New Proposal',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 自定义方案部分
              Animations.fadeSlideIn(
                delay: 100,
                child: const Text(
                  'My Plans',
                  style: TextStyle(
                    color: AppTheme.champagne,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 方案列表
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.champagne,
                        ),
                      )
                    : _proposals.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _proposals.length,
                        itemBuilder: (context, index) {
                          return Animations.fadeSlideIn(
                            delay: 250 + (index * 100),
                            child: ProposalCard(
                              proposal: _proposals[index],
                              onTap: () {
                                _showProposalDetails(_proposals[index]);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _proposals.isEmpty && !_isLoading
          ? Animations.fadeSlideIn(
              delay: 400,
              child: FloatingActionButton(
                onPressed: () => _navigateToProposalGenerator(context),
                backgroundColor: AppTheme.champagne,
                foregroundColor: AppTheme.deepSpace,
                elevation: 4,
                tooltip: 'Create New Proposal',
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }

  // 构建空状态
  Widget _buildEmptyState() {
    return Animations.fadeSlideIn(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 装饰元素 - 顶部
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.champagne.withOpacity(0.7),
                      AppTheme.champagne.withOpacity(0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 60,
                    color: ColorUtils.withOpacity(AppTheme.deepSpace, 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 主标题
              Text(
                'Create Your Perfect Proposal',
                style: TextStyle(
                  color: AppTheme.moonlight,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 副标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Design a memorable moment that will create a lasting impression. Get started with our AI-powered proposal planner.',
                  style: TextStyle(
                    color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // 创建按钮
              ElevatedButton.icon(
                onPressed: () => _navigateToProposalGenerator(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Your First Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.champagne,
                  foregroundColor: AppTheme.deepSpace,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: AppTheme.champagne.withOpacity(0.5),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 特性展示
              _buildFeatureItem(
                icon: Icons.auto_awesome,
                title: 'AI-Powered Ideas',
                description:
                    'Get creative proposal suggestions tailored to your preferences',
              ),
              _buildFeatureItem(
                icon: Icons.check_circle_outline,
                title: 'Step-by-Step Plans',
                description:
                    'Detailed instructions to ensure everything goes perfectly',
              ),
              _buildFeatureItem(
                icon: Icons.favorite,
                title: 'Personalized Experience',
                description:
                    'Create a moment that reflects your unique relationship',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建特性项
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.champagne, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.champagne,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 显示方案详情
  Future<void> _showProposalDetails(ProposalPlanModel proposal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProposalDetailScreen(
          proposal: proposal,
          showSaveButton: false,
          showDeleteButton: true,
        ),
      ),
    );

    // 如果方案被删除，重新加载方案列表
    if (result == 'deleted') {
      _loadProposals();
    }
  }
}
