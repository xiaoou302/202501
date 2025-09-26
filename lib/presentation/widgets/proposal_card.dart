import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/proposal_plan_model.dart';

/// 求婚方案卡片组件
class ProposalCard extends StatelessWidget {
  final ProposalPlanModel proposal;
  final VoidCallback? onTap;

  const ProposalCard({super.key, required this.proposal, this.onTap});

  // 获取方案类型对应的图标
  IconData _getTypeIcon() {
    switch (proposal.type.toLowerCase()) {
      case 'romantic':
        return Icons.favorite;
      case 'intimate':
        return Icons.home;
      case 'adventurous':
        return Icons.landscape;
      case 'elaborate':
        return Icons.celebration;
      case 'creative':
        return Icons.lightbulb;
      default:
        return Icons.diamond;
    }
  }

  // 获取方案类型对应的颜色
  Color _getTypeColor() {
    switch (proposal.type.toLowerCase()) {
      case 'romantic':
        return Colors.red[400]!;
      case 'intimate':
        return Colors.purple[300]!;
      case 'adventurous':
        return Colors.green[500]!;
      case 'elaborate':
        return Colors.amber[600]!;
      case 'creative':
        return Colors.blue[400]!;
      default:
        return AppTheme.champagne;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: ColorUtils.withOpacity(AppTheme.silverstone, 0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ColorUtils.withOpacity(AppTheme.champagne, 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和类型
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 类型图标
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorUtils.withOpacity(_getTypeColor(), 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      color: _getTypeColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 标题和日期
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proposal.title,
                          style: const TextStyle(
                            color: AppTheme.moonlight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(proposal.createdAt),
                          style: TextStyle(
                            color: ColorUtils.withOpacity(
                              AppTheme.moonlight,
                              0.6,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 类型标签
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorUtils.withOpacity(_getTypeColor(), 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorUtils.withOpacity(_getTypeColor(), 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      proposal.type,
                      style: TextStyle(
                        color: _getTypeColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 描述
              Text(
                proposal.description,
                style: TextStyle(
                  color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // 地点和预算
              Row(
                children: [
                  // 地点
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 16,
                          color: ColorUtils.withOpacity(
                            AppTheme.moonlight,
                            0.7,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            proposal.location,
                            style: TextStyle(
                              color: ColorUtils.withOpacity(
                                AppTheme.moonlight,
                                0.7,
                              ),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 预算
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 16,
                        color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        proposal.budget.contains('\$')
                            ? proposal.budget
                            : 'Varies',
                        style: TextStyle(
                          color: ColorUtils.withOpacity(
                            AppTheme.moonlight,
                            0.7,
                          ),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
