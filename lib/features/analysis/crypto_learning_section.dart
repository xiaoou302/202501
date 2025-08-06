import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../services/deepseek_service.dart';

/// Cryptocurrency Learning section providing educational content about cryptocurrencies
class CryptoLearningSection extends StatefulWidget {
  final DeepseekService deepseekService;

  const CryptoLearningSection({
    Key? key,
    required this.deepseekService,
  }) : super(key: key);

  @override
  State<CryptoLearningSection> createState() => _CryptoLearningSectionState();
}

class _CryptoLearningSectionState extends State<CryptoLearningSection> {
  bool _isLoading = false;
  final List<Map<String, dynamic>> _cryptoTopics = [
    {
      'title': '比特币基础知识',
      'icon': Icons.currency_bitcoin,
      'color': Colors.orange,
      'sections': [
        {
          'title': '什么是比特币？',
          'content':
              '比特币是第一个去中心化的加密货币，由中本聪于2009年创建。它是一种点对点的电子现金系统，允许在线支付直接从一方发送到另一方，无需通过金融机构。比特币使用区块链技术来记录所有交易，确保交易的安全性和透明度。',
        },
        {
          'title': '比特币如何工作？',
          'content':
              '比特币网络通过分布式共识机制运行，使用工作量证明(PoW)算法来验证交易并创建新的区块。矿工通过解决复杂的数学问题来竞争记录交易的权利，获胜者将获得比特币奖励。比特币的总供应量限制在2100万个，这种稀缺性是其价值的重要来源。',
        },
        {
          'title': '比特币钱包',
          'content':
              '比特币钱包是存储私钥的软件或硬件，用于访问和管理您的比特币。钱包类型包括：热钱包（在线连接）、冷钱包（离线存储）、硬件钱包、纸钱包和脑钱包。每种类型都有不同的安全性和便利性权衡。',
        },
        {
          'title': '比特币交易',
          'content':
              '比特币交易是将价值从一个地址转移到另一个地址的过程。每笔交易都包含输入（资金来源）和输出（资金去向）。交易需要使用私钥进行签名，并由网络验证。交易费用支付给矿工，以激励他们将交易包含在区块中。',
        },
      ],
    },
    {
      'title': '以太坊与智能合约',
      'icon': Icons.currency_exchange,
      'color': Colors.purple,
      'sections': [
        {
          'title': '以太坊简介',
          'content':
              '以太坊是一个去中心化的开源区块链平台，支持智能合约功能。它由Vitalik Buterin于2015年推出，目标是创建一个可以运行去中心化应用程序(DApps)的全球计算机。以太坊的原生加密货币称为以太(ETH)。',
        },
        {
          'title': '智能合约',
          'content':
              '智能合约是在区块链上运行的自动执行的程序，当预定条件满足时，合约会自动执行。这些合约是用Solidity等编程语言编写的，可以实现各种功能，从简单的价值转移到复杂的去中心化应用。智能合约的执行不需要中介，提高了效率并降低了成本。',
        },
        {
          'title': '以太坊2.0',
          'content':
              '以太坊2.0（现在称为"合并"）是以太坊网络的重大升级，将共识机制从工作量证明(PoW)转变为权益证明(PoS)。这一变化旨在提高网络的可扩展性、安全性和可持续性，显著降低能源消耗，并为未来的分片技术铺平道路。',
        },
        {
          'title': 'Gas费用',
          'content':
              'Gas是以太坊网络上执行操作所需的计算工作量单位。每个交易或智能合约执行都需要一定量的Gas，用户需要支付Gas费用（以ETH计价）。Gas费用取决于网络拥堵程度和操作复杂性，是以太坊经济模型的重要组成部分。',
        },
      ],
    },
    {
      'title': '区块链技术基础',
      'icon': Icons.link,
      'color': Colors.blue,
      'sections': [
        {
          'title': '什么是区块链？',
          'content':
              '区块链是一种分布式账本技术，它将交易记录在多台计算机上的区块中，这些区块通过加密哈希链接在一起。区块链的关键特性包括：去中心化（没有单一控制点）、不可篡改性（一旦记录无法更改）、透明性（所有参与者可以查看）和安全性（通过加密技术保护）。',
        },
        {
          'title': '共识机制',
          'content':
              '共识机制是区块链网络中参与者就交易有效性达成一致的方法。主要类型包括：工作量证明(PoW)、权益证明(PoS)、委托权益证明(DPoS)、实用拜占庭容错(PBFT)等。每种机制都有不同的安全性、效率和去中心化程度权衡。',
        },
        {
          'title': '公有链与私有链',
          'content':
              '公有链对所有人开放，任何人都可以参与网络并查看交易（如比特币和以太坊）。私有链由单一组织控制，访问受限。联盟链介于两者之间，由预先选定的组织共同维护。选择哪种类型取决于应用场景、安全需求和去中心化程度。',
        },
        {
          'title': '区块链应用场景',
          'content':
              '区块链技术应用广泛，包括：金融服务（支付、借贷、保险）、供应链管理（产品溯源、防伪）、医疗健康（病历管理、药品追踪）、身份验证、投票系统、知识产权保护等。每个领域都利用了区块链的不同特性来解决特定问题。',
        },
      ],
    },
    {
      'title': 'DeFi去中心化金融',
      'icon': Icons.account_balance,
      'color': Colors.green,
      'sections': [
        {
          'title': 'DeFi简介',
          'content':
              'DeFi（去中心化金融）是建立在区块链上的金融应用生态系统，旨在重建传统金融系统，无需中介机构参与。DeFi应用通常基于以太坊等支持智能合约的区块链，提供借贷、交易、保险等服务，特点是开放、无许可和透明。',
        },
        {
          'title': '流动性挖矿',
          'content':
              '流动性挖矿是用户向DeFi协议提供资金（流动性）并获得奖励的过程。用户通常将资产存入流动性池，获得交易费用分成和治理代币奖励。这种机制帮助DeFi协议吸引资金，同时为用户提供额外收益，但也存在无常损失等风险。',
        },
        {
          'title': '去中心化交易所(DEX)',
          'content':
              '去中心化交易所是允许用户直接进行点对点加密货币交易的平台，无需中央机构托管资金。主要类型包括：自动做市商(AMM)如Uniswap，使用流动性池和价格算法；订单簿DEX如dYdX，匹配买卖订单。DEX优点是无需KYC、保持资产控制权，缺点是可能流动性较低。',
        },
        {
          'title': '借贷协议',
          'content':
              'DeFi借贷协议允许用户无需中介即可借出或借入加密资产。用户提供抵押品以借入其他资产，或提供资产获取利息收益。主要平台如Aave、Compound使用超额抵押模式确保安全性。借贷利率通常根据供需动态调整，提供比传统金融更高的资本效率。',
        },
      ],
    },
    {
      'title': 'NFT与元宇宙',
      'icon': Icons.image,
      'color': Colors.pink,
      'sections': [
        {
          'title': 'NFT基础',
          'content':
              'NFT（非同质化代币）是区块链上的独特数字资产，每个都具有不可替代的特性。与比特币等同质化代币不同，每个NFT都有唯一标识符和元数据。NFT主要基于以太坊ERC-721和ERC-1155标准，用于表示数字艺术品、收藏品、游戏物品等的所有权。',
        },
        {
          'title': 'NFT市场',
          'content':
              'NFT市场是买卖NFT的平台，主要包括OpenSea、Rarible、Foundation等。这些平台允许创作者铸造（创建）NFT，设定版税，并出售给收藏者。交易通常使用ETH或平台原生代币进行，并记录在区块链上，确保所有权透明且可验证。',
        },
        {
          'title': '元宇宙概念',
          'content':
              '元宇宙是一个持久的、共享的、3D虚拟空间网络，用户可以在其中互动、社交和创造。区块链技术和NFT在元宇宙中扮演重要角色，提供数字资产所有权、虚拟土地管理和经济系统。主要项目包括Decentraland、The Sandbox等，它们允许用户购买虚拟地产并构建体验。',
        },
        {
          'title': '游戏与Play-to-Earn',
          'content':
              'Play-to-Earn是一种游戏模式，玩家通过游戏活动获得真实经济价值。这些游戏使用NFT表示游戏资产（角色、装备、土地等），玩家可以通过游戏获得、交易这些资产或赚取代币。代表项目如Axie Infinity，玩家饲养和战斗NFT生物，获得可交易代币作为奖励。',
        },
      ],
    },
  ];

  int _selectedTopicIndex = 0;
  int _selectedSectionIndex = 0;
  List<Map<String, dynamic>>? _marketTrends;

  @override
  void initState() {
    super.initState();
    _loadMarketTrends();
  }

  Future<void> _loadMarketTrends() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final trends = await widget.deepseekService.getMarketTrends();

      if (mounted) {
        setState(() {
          _marketTrends = trends;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载市场趋势失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Market trends section
          _buildSectionHeader('市场热点', '了解当前加密货币市场热点话题'),
          const SizedBox(height: 16),

          // Market trends cards
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _marketTrends == null
                  ? _buildMarketTrendsPlaceholder()
                  : _buildMarketTrendsCards(),

          const SizedBox(height: 24),

          // Learning topics section
          _buildSectionHeader('加密货币知识', '从基础到高级的加密货币学习内容'),
          const SizedBox(height: 16),

          // Topic selection
          _buildTopicSelection(),
          const SizedBox(height: 16),

          // Selected topic content
          _buildTopicContent(),

          // Bottom padding
          const SizedBox(height: 80),
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

  Widget _buildMarketTrendsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 48,
            color: AppColors.stardustWhite.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '无法加载市场趋势',
            style: AppStyles.bodyText,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadMarketTrends,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldenHighlight,
              foregroundColor: Colors.black,
            ),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrendsCards() {
    return Column(
      children: (_marketTrends ?? []).map((trend) {
        final heatIndex = trend['heatIndex'] ?? 5;
        final color = _getHeatColor(heatIndex);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.6),
                color.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        trend['name'] ?? '市场趋势',
                        style: AppStyles.heading3.copyWith(color: color),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: color,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$heatIndex',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  trend['description'] ?? '',
                  style: AppStyles.bodyTextSmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (trend['relatedAssets'] as List<dynamic>? ?? [])
                      .map((asset) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        asset.toString(),
                        style: AppStyles.secondaryText.copyWith(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getHeatColor(num heatIndex) {
    if (heatIndex >= 8) {
      return Colors.red;
    } else if (heatIndex >= 6) {
      return Colors.orange;
    } else if (heatIndex >= 4) {
      return Colors.amber;
    } else {
      return Colors.blue;
    }
  }

  Widget _buildTopicSelection() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _cryptoTopics.length,
        itemBuilder: (context, index) {
          final topic = _cryptoTopics[index];
          final isSelected = _selectedTopicIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTopicIndex = index;
                _selectedSectionIndex =
                    0; // Reset section index when topic changes
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
    final selectedTopic = _cryptoTopics[_selectedTopicIndex];
    final sections = selectedTopic['sections'] as List<Map<String, dynamic>>;
    final color = selectedTopic['color'] as Color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section tabs
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              final isSelected = _selectedSectionIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSectionIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : AppColors.borderColor,
                    ),
                  ),
                  child: Text(
                    section['title'],
                    style: TextStyle(
                      color: isSelected ? color : AppColors.stardustWhite,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Section content
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sections[_selectedSectionIndex]['title'],
                style: AppStyles.heading3.copyWith(color: color),
              ),
              const SizedBox(height: 16),
              Text(
                sections[_selectedSectionIndex]['content'],
                style: AppStyles.bodyText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
