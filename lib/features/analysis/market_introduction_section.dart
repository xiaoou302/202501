import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/trading_pair.dart';
import '../../data/models/sentiment.dart';

/// Market Introduction section providing information about cryptocurrency markets and trading
class MarketIntroductionSection extends StatefulWidget {
  final List<TradingPair> tradingPairs;
  final List<Sentiment> sentiments;
  final Map<String, dynamic> marketOverview;

  const MarketIntroductionSection({
    Key? key,
    required this.tradingPairs,
    required this.sentiments,
    required this.marketOverview,
  }) : super(key: key);

  @override
  State<MarketIntroductionSection> createState() =>
      _MarketIntroductionSectionState();
}

class _MarketIntroductionSectionState extends State<MarketIntroductionSection> {
  int _selectedTopicIndex = 0;

  // Market introduction topics
  final List<Map<String, dynamic>> _marketTopics = [
    {
      'title': '加密货币市场概览',
      'icon': Icons.currency_bitcoin,
      'color': Colors.orange,
      'content': '''
加密货币市场是一个全天候运行的全球性市场，不同于传统金融市场，它没有固定的交易时间，全年无休。这个市场由数千种加密货币组成，总市值超过1万亿美元。

比特币作为第一个加密货币，仍然占据着最大的市场份额，其次是以太坊。除了这些主要加密货币外，还有许多"替代币"（Altcoins）、去中心化金融（DeFi）代币、非同质化代币（NFT）和稳定币等不同类型的加密资产。

加密货币市场以其高波动性而闻名，价格可能在短时间内大幅波动。这种波动性既带来了高回报的潜力，也伴随着显著的风险。市场受到多种因素的影响，包括技术发展、监管变化、机构采用和市场情绪等。
      ''',
    },
    {
      'title': '交易所与交易平台',
      'icon': Icons.swap_horiz,
      'color': Colors.blue,
      'content': '''
加密货币交易所是买卖加密货币的平台，主要分为中心化交易所（CEX）和去中心化交易所（DEX）两种类型。

中心化交易所如币安、Coinbase等，由公司运营，提供用户友好的界面和高流动性，但需要用户将资产托管给交易所。这些平台通常提供多种交易对、杠杆交易和期货合约等高级功能。

去中心化交易所如Uniswap、SushiSwap等，基于智能合约运行，无需中介，用户保持对资产的完全控制。DEX通常使用自动做市商（AMM）模型，允许用户直接从流动性池中交易代币。

选择交易平台时，应考虑安全性、流动性、费用结构、支持的币种和用户体验等因素。对于新手来说，中心化交易所可能更容易上手，而经验丰富的用户可能更喜欢去中心化平台的自主权。
      ''',
    },
    {
      'title': '交易策略与风险管理',
      'icon': Icons.trending_up,
      'color': Colors.green,
      'content': '''
在加密货币市场交易需要明确的策略和严格的风险管理。常见的交易策略包括：

• 长期持有（HODL）：购买并长期持有加密货币，不受短期价格波动影响
• 日内交易：在同一天内进行多次交易，利用短期价格波动获利
• 波段交易：在较长时间范围内买入低点卖出高点
• 价值平均策略：定期投资固定金额，平摊购买成本
• 套利交易：利用不同交易所或交易对之间的价格差异获利

风险管理是成功交易的关键，包括：
• 资金管理：不要投入超过能够承受损失的资金，建议只用总资产的5-10%进行加密货币投资
• 止损设置：预先确定退出点，限制潜在损失
• 分散投资：不要将所有资金集中在单一加密货币上
• 情绪控制：避免FOMO（害怕错过）和恐慌性决策
• 持续学习：跟踪市场发展和技术进步
      ''',
    },
    {
      'title': '市场指标与分析工具',
      'icon': Icons.assessment,
      'color': Colors.purple,
      'content': '''
分析加密货币市场时，投资者通常结合基本面分析和技术分析。

基本面分析关注项目的内在价值，考虑因素包括：
• 项目团队和开发活动
• 技术创新和实际应用场景
• 代币经济模型和供应机制
• 社区规模和参与度
• 合作伙伴关系和机构支持

技术分析使用价格图表和指标预测未来价格走势，常用工具包括：
• 移动平均线（MA）：识别长期趋势
• 相对强弱指标（RSI）：判断资产是否超买或超卖
• MACD（移动平均收敛散度）：识别动量变化
• 布林带：衡量价格波动性
• 成交量：确认价格趋势的强度

链上分析是加密货币独有的分析方法，通过区块链数据评估网络健康状况和用户活动，包括活跃地址数量、交易量、矿工费用等指标。
      ''',
    },
    {
      'title': '加密货币钱包与安全',
      'icon': Icons.account_balance_wallet,
      'color': Colors.amber,
      'content': '''
加密货币钱包是存储和管理您的数字资产的工具，它们实际上存储的是访问区块链上资产所需的私钥。主要类型包括：

• 热钱包（在线）：便于频繁交易，但安全性较低
  - 移动钱包：手机应用程序（如Trust Wallet、MetaMask移动版）
  - 网页钱包：浏览器扩展（如MetaMask、Phantom）
  - 桌面钱包：电脑软件（如Exodus、Electrum）

• 冷钱包（离线）：最安全的存储方式，适合长期持有
  - 硬件钱包：物理设备（如Ledger、Trezor）
  - 纸钱包：打印在纸上的私钥和地址

安全最佳实践：
• 使用强密码和双因素认证（2FA）
• 备份助记词并安全存储（不要数字化存储）
• 对大额资产使用冷钱包
• 定期更新钱包软件
• 警惕钓鱼攻击和欺诈计划
• 在发送大额交易前先测试小额交易
• 使用多重签名钱包增加安全层级
      ''',
    },
    {
      'title': '监管环境与合规',
      'icon': Icons.gavel,
      'color': Colors.teal,
      'content': '''
加密货币的监管环境在全球范围内差异很大，且不断发展变化。了解您所在地区的监管要求对于合规交易至关重要。

主要监管考虑因素：
• KYC（了解您的客户）和AML（反洗钱）要求
• 税务报告义务
• 证券法规（某些代币可能被视为证券）
• 跨境交易限制
• 许可和注册要求

不同地区的监管态度：
• 一些国家如新加坡、瑞士采取积极支持的监管框架
• 美国通过SEC、CFTC等机构进行监管，态度较为复杂
• 欧盟推出了MiCA（加密资产市场）法规，提供统一框架
• 一些国家对加密货币采取限制或禁止态度

合规建议：
• 保留所有交易记录
• 使用税务合规工具跟踪应税事件
• 关注监管变化
• 在必要时咨询专业法律和税务顾问
• 选择遵守当地法规的交易平台
      ''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Market overview section
          _buildMarketOverview(),
          const SizedBox(height: 24),

          // Market introduction topics
          _buildSectionHeader('市场知识', '了解加密货币市场基础知识'),
          const SizedBox(height: 16),

          // Topic selection
          _buildTopicSelection(),
          const SizedBox(height: 24),

          // Selected topic content
          _buildTopicContent(),

          const SizedBox(height: 24),

          // Example trading pairs
          _buildSectionHeader('热门加密货币', '了解主流加密货币的基本情况'),
          const SizedBox(height: 16),

          // Top cryptocurrencies
          _buildTopCryptocurrencies(),

          // Bottom padding
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMarketOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.midnightBlue.withOpacity(0.8),
            AppColors.goldenHighlight.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '加密货币市场',
            style: AppStyles.heading2,
          ),
          const SizedBox(height: 8),
          Text(
            '加密货币是基于区块链技术的数字或虚拟货币，使用加密技术确保安全性。'
            '与传统法定货币不同，加密货币通常不受中央机构控制，而是通过分布式网络运行。',
            style: AppStyles.bodyText,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('全球市值', '~1.5万亿美元', AppColors.fieryRed),
              _buildStatCard('日交易量', '~500亿美元', AppColors.coolBlue),
              _buildStatCard('加密货币数量', '24,000+', AppColors.goldenHighlight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppStyles.secondaryText.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.heading3,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppStyles.secondaryText.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTopicSelection() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _marketTopics.length,
        itemBuilder: (context, index) {
          final topic = _marketTopics[index];
          final isSelected = _selectedTopicIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTopicIndex = index;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? topic['color'].withOpacity(0.2)
                    : Colors.grey.shade900.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? topic['color'] : AppColors.borderColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    topic['icon'],
                    color: topic['color'],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      topic['title'],
                      style: TextStyle(
                        color: isSelected
                            ? topic['color']
                            : AppColors.stardustWhite,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicContent() {
    final selectedTopic = _marketTopics[_selectedTopicIndex];
    final color = selectedTopic['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                selectedTopic['icon'],
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedTopic['title'],
                  style: AppStyles.heading3.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            selectedTopic['content'],
            style: AppStyles.bodyText,
          ),
        ],
      ),
    );
  }

  Widget _buildTopCryptocurrencies() {
    // Use the first few trading pairs as examples
    final topCoins = widget.tradingPairs.take(5).toList();

    return Column(
      children: topCoins.map((coin) {
        final isPositive = coin.changePercent >= 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildCoinIcon(coin.id.split('/')[0]),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coin.id,
                            style: AppStyles.heading3,
                          ),
                          Text(
                            _getCoinFullName(coin.id.split('/')[0]),
                            style: AppStyles.secondaryText,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${coin.buyRate < 1 ? coin.buyRate.toStringAsFixed(4) : coin.buyRate.toStringAsFixed(2)}',
                        style: AppStyles.heading3,
                      ),
                      Text(
                        '${isPositive ? '+' : ''}${coin.changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '简介',
                style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _getCoinDescription(coin.id.split('/')[0]),
                style: AppStyles.bodyText,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                      '24h交易量', '\$${coin.volume.toStringAsFixed(1)}B'),
                  _buildInfoItem(
                      '波动率', '${coin.volatility.toStringAsFixed(0)}'),
                  _buildInfoItem('市场情绪', coin.marketSentiment),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCoinIcon(String symbol) {
    Color color;

    switch (symbol) {
      case 'BTC':
        color = Colors.orange;
        break;
      case 'ETH':
        color = Colors.purple;
        break;
      case 'BNB':
        color = Colors.amber;
        break;
      case 'SOL':
        color = Colors.green;
        break;
      case 'ADA':
        color = Colors.blue;
        break;
      default:
        color = Colors.teal;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(
          symbol.substring(0, 1),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppStyles.secondaryText.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppStyles.bodyTextSmall.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _getCoinFullName(String symbol) {
    switch (symbol) {
      case 'BTC':
        return '比特币 (Bitcoin)';
      case 'ETH':
        return '以太坊 (Ethereum)';
      case 'BNB':
        return '币安币 (Binance Coin)';
      case 'SOL':
        return '索拉纳 (Solana)';
      case 'ADA':
        return '卡尔达诺 (Cardano)';
      case 'DOGE':
        return '狗狗币 (Dogecoin)';
      case 'SHIB':
        return '柴犬币 (Shiba Inu)';
      case 'XRP':
        return '瑞波币 (Ripple)';
      case 'DOT':
        return '波卡 (Polkadot)';
      default:
        return symbol;
    }
  }

  String _getCoinDescription(String symbol) {
    switch (symbol) {
      case 'BTC':
        return '比特币是第一个去中心化的加密货币，由中本聪于2009年创建。它使用点对点技术，无需中央机构或银行。比特币的创建和转移基于开源协议，没有任何单一实体的控制。';
      case 'ETH':
        return '以太坊是一个去中心化的开源区块链平台，支持智能合约功能。它允许开发者构建和部署去中心化应用程序(DApps)。以太币(ETH)是平台的原生加密货币，用于支付交易费用和计算服务。';
      case 'BNB':
        return '币安币是全球最大的加密货币交易所币安的原生代币。它可用于支付交易费用、参与代币销售、进行跨链转账等。币安还开发了币安智能链(BSC)，一个与以太坊兼容的区块链，支持智能合约和DeFi应用。';
      case 'SOL':
        return '索拉纳是一个高性能区块链，专注于提供快速交易速度和低费用。它使用创新的历史证明(PoH)共识机制，能够处理每秒数千笔交易，是DeFi、NFT和Web3应用的流行平台。';
      case 'ADA':
        return '卡尔达诺是一个基于学术研究和科学哲学构建的区块链平台，使用权益证明算法Ouroboros。它旨在提供更安全、可扩展的基础设施，支持智能合约和去中心化应用的开发。';
      case 'DOGE':
        return '狗狗币最初作为一个互联网梗创建，基于Shiba Inu狗的形象。尽管起源于玩笑，但它已发展成为一种受欢迎的加密货币，拥有强大的社区支持和知名度，部分归功于埃隆·马斯克等名人的支持。';
      case 'SHIB':
        return '柴犬币是一种基于以太坊的代币，灵感来自狗狗币。它被称为"狗狗币杀手"，拥有庞大且活跃的社区。SHIB生态系统包括去中心化交易所ShibaSwap和其他相关代币。';
      default:
        return '这是一种加密货币，基于区块链技术运行，提供去中心化的价值转移和存储功能。';
    }
  }
}
