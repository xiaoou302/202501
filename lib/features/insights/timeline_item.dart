import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/news_event.dart';

/// Reusable widget for each timeline entry
class TimelineItem extends StatelessWidget {
  final NewsEvent event;
  const TimelineItem({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用RepaintBoundary提高渲染性能
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot and line - 使用缓存
            _buildTimelineDot(),
            const SizedBox(width: 16),

            // Event content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 时间、来源和分类标签 - 预先构建常用样式
                  Row(
                    children: [
                      Text(
                        event.timeAgo,
                        style: _timeAgoStyle,
                      ),
                      if (event.source.isNotEmpty) ...[
                        Text(
                          ' · ',
                          style: _timeAgoStyle,
                        ),
                        Text(
                          event.source,
                          style: _sourceStyle,
                        ),
                      ],
                      const Spacer(),
                      // 添加分类标签
                      _buildCategoryChip(),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 标题 - 使用const样式
                  Text(event.title, style: AppStyles.heading3),
                  const SizedBox(height: 4),

                  // 摘要 - 使用const样式
                  Text(
                    event.summary,
                    style: _summaryStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // 受影响的货币对 - 使用ListView.builder优化大量标签的渲染
                  _buildAffectedPairs(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 预先定义常用样式，避免重复创建
  static final TextStyle _timeAgoStyle = TextStyle(
    fontSize: 12,
    color: AppColors.stardustWhite.withOpacity(0.7),
  );

  static final TextStyle _sourceStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.fieryRed.withOpacity(0.8),
  );

  static final TextStyle _summaryStyle = TextStyle(
    fontSize: 14,
    color: AppColors.stardustWhite.withOpacity(0.8),
  );

  Widget _buildTimelineDot() {
    Color dotColor;
    IconData iconData;

    // Set color and icon based on impact
    switch (event.impact) {
      case 'High':
        dotColor = AppColors.fieryRed;
        iconData = Icons.priority_high;
        break;
      case 'Medium':
        dotColor = AppColors.coolBlue;
        iconData = Icons.info_outline;
        break;
      default:
        dotColor = Colors.grey;
        iconData = Icons.circle_outlined;
    }

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: dotColor.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: dotColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: dotColor.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              iconData,
              color: dotColor,
              size: 14,
            ),
          ),
        ),
        Container(width: 2, height: 100, color: Colors.white.withOpacity(0.1)),
      ],
    );
  }

  Widget _buildAffectedPairs() {
    // 优化：限制最多显示4个标签，避免过多渲染
    final displayPairs = event.affectedPairs.length > 4
        ? event.affectedPairs.sublist(0, 4)
        : event.affectedPairs;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayPairs.map((pair) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: _pairContainerDecoration,
          child: Text(
            pair,
            style: _pairTextStyle,
          ),
        );
      }).toList(),
    );
  }

  // 预先定义装饰样式
  static final BoxDecoration _pairContainerDecoration = BoxDecoration(
    color: AppColors.midnightBlue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
  );

  // 预先定义文本样式
  static const TextStyle _pairTextStyle = TextStyle(
    fontSize: 12,
    color: AppColors.stardustWhite,
  );

  // 构建分类标签
  Widget _buildCategoryChip() {
    // 使用InsightsScreen中的方法获取分类
    final category = _getCategoryForEvent(event);

    // 如果分类是"全部"，则不显示标签
    if (category == '全部') return const SizedBox.shrink();

    // 获取分类对应的颜色和图标
    final (Color color, IconData icon) = _getCategoryStyle(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 获取分类的样式（颜色和图标）
  (Color, IconData) _getCategoryStyle(String category) {
    switch (category) {
      case '全部':
        return (AppColors.stardustWhite, Icons.apps_rounded);
      case '比特币':
        return (Colors.orange, Icons.currency_bitcoin);
      case '以太坊':
        return (Colors.purple.shade300, Icons.diamond_outlined);
      case '稳定币':
        return (Colors.green, Icons.attach_money_rounded);
      case 'Layer2':
        return (Colors.blue, Icons.layers_outlined);
      case '公链':
        return (Colors.teal, Icons.link_rounded);
      case 'DeFi':
        return (AppColors.fieryRed, Icons.account_balance_outlined);
      case 'NFT':
        return (Colors.pink, Icons.palette_outlined);
      case '交易所':
        return (AppColors.goldenHighlight, Icons.storefront_outlined);
      case '元宇宙':
        return (AppColors.coolBlue, Icons.view_in_ar_outlined);
      default:
        return (AppColors.stardustWhite, Icons.tag);
    }
  }

  // 根据事件内容判断其所属分类
  String _getCategoryForEvent(NewsEvent event) {
    // 检查受影响的货币对和内容
    final content = '${event.title} ${event.summary}'.toLowerCase();
    final affectedPairs = event.affectedPairs.join(' ').toLowerCase();

    // 比特币相关
    if (content.contains('比特币') ||
        content.contains('btc') ||
        content.contains('bitcoin') ||
        affectedPairs.contains('btc') ||
        content.contains('挖矿') && !content.contains('以太坊挖矿')) {
      return '比特币';
    }

    // 以太坊相关
    if (content.contains('以太坊') ||
        content.contains('eth') ||
        content.contains('ethereum') ||
        content.contains('vitalik') ||
        content.contains('以太') ||
        affectedPairs.contains('eth')) {
      return '以太坊';
    }

    // 稳定币相关
    if (content.contains('稳定币') ||
        content.contains('usdt') ||
        content.contains('usdc') ||
        content.contains('泰达币') ||
        content.contains('tether') ||
        content.contains('stablecoin') ||
        content.contains('dai') && !content.contains('daily') ||
        content.contains('busd') ||
        affectedPairs.contains('usdt') ||
        affectedPairs.contains('usdc')) {
      return '稳定币';
    }

    // Layer2相关
    if (content.contains('layer2') ||
        content.contains('二层') ||
        content.contains('扩容') ||
        content.contains('rollup') ||
        content.contains('optimism') ||
        content.contains('arbitrum') ||
        content.contains('zksync') ||
        content.contains('polygon') && !content.contains('多边形') ||
        content.contains('matic') ||
        content.contains('侧链') ||
        affectedPairs.contains('op') ||
        affectedPairs.contains('arb') ||
        affectedPairs.contains('matic')) {
      return 'Layer2';
    }

    // 公链相关
    if (content.contains('公链') ||
        content.contains('solana') ||
        content.contains('sol/') ||
        content.contains('avalanche') ||
        content.contains('avax') ||
        content.contains('cardano') ||
        content.contains('ada/') ||
        content.contains('波卡') ||
        content.contains('polkadot') ||
        content.contains('dot/') ||
        content.contains('cosmos') ||
        content.contains('atom/') ||
        content.contains('algorand') ||
        content.contains('tron') ||
        content.contains('trx/') ||
        content.contains('near') ||
        content.contains('chainlink') ||
        content.contains('link/') ||
        affectedPairs.contains('sol') ||
        affectedPairs.contains('avax') ||
        affectedPairs.contains('ada') ||
        affectedPairs.contains('dot') ||
        affectedPairs.contains('atom')) {
      return '公链';
    }

    // DeFi相关
    if (content.contains('defi') ||
        content.contains('去中心化金融') ||
        content.contains('流动性') ||
        content.contains('yield') ||
        content.contains('swap') ||
        content.contains('lending') ||
        content.contains('借贷') ||
        content.contains('uniswap') ||
        content.contains('aave') ||
        content.contains('compound') ||
        content.contains('curve') ||
        content.contains('流动性挖矿') ||
        content.contains('质押') ||
        content.contains('staking') ||
        content.contains('amm') ||
        content.contains('dex') ||
        content.contains('去中心化交易') ||
        affectedPairs.contains('uni') ||
        affectedPairs.contains('aave') ||
        affectedPairs.contains('comp') ||
        affectedPairs.contains('crv')) {
      return 'DeFi';
    }

    // NFT相关
    if (content.contains('nft') ||
        content.contains('非同质化') ||
        content.contains('数字艺术') ||
        content.contains('数字收藏品') ||
        content.contains('opensea') ||
        content.contains('blur') && content.contains('nft') ||
        content.contains('yuga') ||
        content.contains('bayc') ||
        content.contains('azuki') ||
        content.contains('数字藏品')) {
      return 'NFT';
    }

    // 元宇宙相关
    if (content.contains('元宇宙') ||
        content.contains('metaverse') ||
        content.contains('sandbox') && !content.contains('沙盒测试') ||
        content.contains('decentraland') ||
        content.contains('虚拟世界') ||
        content.contains('虚拟土地') ||
        content.contains('web3游戏') ||
        content.contains('gamefi') ||
        affectedPairs.contains('sand') ||
        affectedPairs.contains('mana') ||
        affectedPairs.contains('axs')) {
      return '元宇宙';
    }

    // 交易所相关
    if (content.contains('交易所') ||
        content.contains('binance') ||
        content.contains('币安') ||
        content.contains('coinbase') ||
        content.contains('okx') ||
        content.contains('ftx') ||
        content.contains('火币') ||
        content.contains('huobi') ||
        content.contains('gate') ||
        content.contains('kucoin') ||
        content.contains('交易平台') ||
        content.contains('cex') ||
        content.contains('中心化交易') ||
        affectedPairs.contains('bnb') ||
        affectedPairs.contains('okb') ||
        affectedPairs.contains('ht') ||
        affectedPairs.contains('gt') ||
        affectedPairs.contains('kcs') ||
        affectedPairs.contains('ftt')) {
      return '交易所';
    }

    // 默认分类
    return '全部';
  }
}
