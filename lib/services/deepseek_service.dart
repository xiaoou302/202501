import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/news_event.dart';
import 'package:intl/intl.dart';

/// Service for interacting with the DeepSeek API to fetch financial news
class DeepseekService {
  static const String _baseUrl = 'https://api.deepseek.com';
  static const String _apiKey = 'sk-eec22474a39a402fa513bb39de45bd4a';

  /// 敏感内容关键词列表，用于过滤资讯
  static const List<String> _sensitiveKeywords = [
    // 战争相关
    '战争',
    '冲突',
    '军事',
    '恐怖',
    '核武器',
    '导弹',
    'war',
    'conflict',
    'military',
    'terror',
    'nuclear',
    'missile',

    // 政治相关
    '政治',
    '制裁',
    '选举',
    '总统',
    '议会',
    '民主',
    '独裁',
    'politics',
    'sanctions',
    'election',
    'president',
    'parliament',
    'democracy',
    'dictatorship',

    // 法律相关
    '法律',
    '诉讼',
    '起诉',
    '法院',
    '判决',
    '律师',
    '法规',
    'legal',
    'lawsuit',
    'sue',
    'court',
    'judgment',
    'lawyer',
    'regulation',

    // 医疗相关
    '医疗',
    '疾病',
    '治疗',
    '药物',
    '症状',
    '诊断',
    '手术',
    '医院',
    'medical',
    'disease',
    'treatment',
    'medicine',
    'symptom',
    'diagnosis',
    'surgery',
    'hospital'
  ];

  /// 获取最新的金融和货币市场资讯
  Future<List<NewsEvent>> getFinancialNews() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一个专业的金融市场资讯助手，请提供最新的虚拟货币和加密货币相关资讯。'
                  '请以JSON格式返回5条最新资讯，每条包含标题、简短摘要、影响程度(High/Medium/Low)、'
                  '发布时间和受影响的货币对。请避免任何政治敏感、战争冲突、法律、医疗等内容，仅关注市场、经济和金融方面的资讯。'
                  '请不要包含任何图片URL或图片相关内容。请确保返回的是有效的JSON格式。'
            },
            {
              'role': 'user',
              'content': '请提供今日最新的虚拟货币和加密货币资讯，格式为JSON数组，不要包含任何图片URL。'
            }
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];

        // 提取JSON内容
        final jsonContent = _extractJsonFromText(content);
        if (jsonContent != null) {
          final List<dynamic> newsItems = jsonDecode(jsonContent);

          // 转换为NewsEvent对象并过滤敏感内容
          return _convertToNewsEvents(newsItems);
        }
      }

      throw Exception('获取资讯失败: ${response.statusCode}');
    } catch (e) {
      throw Exception('API请求错误: $e');
    }
  }

  /// 获取特定货币对的详细分析
  Future<Map<String, dynamic>> getCurrencyPairAnalysis(String pair) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一个专业的金融分析师，请提供指定货币对的详细市场分析，包括技术面、基本面因素、'
                  '近期重要事件和未来展望。请以JSON格式返回分析结果，包含分析摘要、技术指标、影响因素、'
                  '短期和中期预测等信息。请避免任何政治敏感、战争冲突等内容，仅关注市场、经济和金融方面的分析。'
            },
            {'role': 'user', 'content': '请提供$pair的详细市场分析，格式为JSON。'}
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];

        // 提取JSON内容
        final jsonContent = _extractJsonFromText(content);
        if (jsonContent != null) {
          return jsonDecode(jsonContent);
        }
      }

      throw Exception('获取分析失败: ${response.statusCode}');
    } catch (e) {
      throw Exception('API请求错误: $e');
    }
  }

  /// 获取市场热点话题
  Future<List<Map<String, dynamic>>> getMarketTrends() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一个专业的金融市场趋势分析师，请提供当前货币市场和加密货币市场的热点话题和趋势。'
                  '请以JSON格式返回3-5个热点话题，每个包含话题名称、简短描述、热度指数(1-10)和相关资产。'
                  '请避免任何政治敏感、战争冲突等内容，仅关注市场、经济和金融方面的趋势。'
            },
            {'role': 'user', 'content': '请提供当前货币市场和加密货币市场的热点话题和趋势，格式为JSON数组。'}
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];

        // 提取JSON内容
        final jsonContent = _extractJsonFromText(content);
        if (jsonContent != null) {
          final List<dynamic> trends = jsonDecode(jsonContent);
          return trends.cast<Map<String, dynamic>>();
        }
      }

      throw Exception('获取趋势失败: ${response.statusCode}');
    } catch (e) {
      throw Exception('API请求错误: $e');
    }
  }

  /// 从文本中提取JSON内容
  String? _extractJsonFromText(String text) {
    // 尝试找到JSON内容的开始和结束位置
    final startIndex = text.indexOf('{');
    final startArrayIndex = text.indexOf('[');

    // 确定JSON是对象还是数组
    int realStartIndex;
    if (startIndex == -1 && startArrayIndex == -1) {
      return null;
    } else if (startIndex == -1) {
      realStartIndex = startArrayIndex;
    } else if (startArrayIndex == -1) {
      realStartIndex = startIndex;
    } else {
      realStartIndex =
          startIndex < startArrayIndex ? startIndex : startArrayIndex;
    }

    // 提取并验证JSON
    try {
      // 简单方法：假设整个剩余文本都是JSON
      final jsonText = text.substring(realStartIndex);

      // 尝试解析以验证
      jsonDecode(jsonText);
      return jsonText;
    } catch (e) {
      // 如果解析失败，尝试更复杂的方法
      try {
        // 查找匹配的括号来提取JSON
        if (realStartIndex == startArrayIndex) {
          // 数组类型JSON
          return _extractBalancedJson(text, '[', ']', realStartIndex);
        } else {
          // 对象类型JSON
          return _extractBalancedJson(text, '{', '}', realStartIndex);
        }
      } catch (e) {
        return null;
      }
    }
  }

  /// 提取平衡的JSON字符串
  String _extractBalancedJson(
      String text, String open, String close, int startIndex) {
    int balance = 0;
    int endIndex = startIndex;

    for (int i = startIndex; i < text.length; i++) {
      if (text[i] == open) {
        balance++;
      } else if (text[i] == close) {
        balance--;
        if (balance == 0) {
          endIndex = i + 1;
          break;
        }
      }
    }

    return text.substring(startIndex, endIndex);
  }

  /// 将API返回的数据转换为NewsEvent对象并过滤敏感内容
  List<NewsEvent> _convertToNewsEvents(List<dynamic> newsItems) {
    final List<NewsEvent> events = [];

    for (var item in newsItems) {
      // 检查是否包含敏感内容
      if (_containsSensitiveContent(item['title'] as String) ||
          _containsSensitiveContent(item['summary'] as String)) {
        continue; // 跳过包含敏感内容的资讯
      }

      // 处理时间
      String timeAgo;
      if (item.containsKey('publishTime')) {
        try {
          final publishTime = DateTime.parse(item['publishTime']);
          timeAgo = _getTimeAgo(publishTime);
        } catch (e) {
          timeAgo = item['publishTime'] ?? '最新';
        }
      } else {
        timeAgo = '最新';
      }

      // 处理影响程度
      String impact = item['impact'] ?? 'Medium';

      // 处理受影响的货币对
      List<String> affectedPairs;
      if (item.containsKey('affectedPairs') && item['affectedPairs'] is List) {
        affectedPairs = (item['affectedPairs'] as List).cast<String>();
      } else if (item.containsKey('affectedAssets') &&
          item['affectedAssets'] is List) {
        affectedPairs = (item['affectedAssets'] as List).cast<String>();
      } else {
        // 如果没有提供受影响的货币对，尝试从标题和摘要中提取
        affectedPairs = _extractCurrencyPairs(
            item['title'] as String, item['summary'] as String);
      }

      // 创建NewsEvent对象
      events.add(NewsEvent(
        title: item['title'],
        timeAgo: timeAgo,
        summary: item['summary'],
        impact: impact,
        affectedPairs: affectedPairs,
        source: item['source'] ?? '金融市场资讯',
        url: item['url'] ?? '',
        imageUrl: '', // 不使用图片
      ));
    }

    return events;
  }

  /// 检查内容是否包含敏感关键词
  bool _containsSensitiveContent(String content) {
    final lowerContent = content.toLowerCase();
    for (var keyword in _sensitiveKeywords) {
      if (lowerContent.contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// 从标题和摘要中提取可能的货币对
  List<String> _extractCurrencyPairs(String title, String summary) {
    final Set<String> pairs = {};
    final combinedText = '$title $summary';

    // 常见货币对正则表达式
    final fiatRegex = RegExp(
        r'(EUR/USD|USD/JPY|GBP/USD|USD/CHF|AUD/USD|USD/CAD|NZD/USD|EUR/GBP|EUR/JPY|GBP/JPY)');
    final cryptoRegex =
        RegExp(r'(BTC|ETH|XRP|LTC|BCH|ADA|DOT|LINK|XLM|DOGE|比特币|以太坊)');

    // 提取法定货币对
    final fiatMatches = fiatRegex.allMatches(combinedText);
    for (var match in fiatMatches) {
      pairs.add(match.group(0)!);
    }

    // 提取加密货币
    final cryptoMatches = cryptoRegex.allMatches(combinedText);
    for (var match in cryptoMatches) {
      final crypto = match.group(0)!;
      if (crypto == '比特币') {
        pairs.add('BTC/USD');
      } else if (crypto == '以太坊') {
        pairs.add('ETH/USD');
      } else {
        pairs.add('$crypto/USD');
      }
    }

    // 如果没有找到任何货币对，添加一个默认的
    if (pairs.isEmpty) {
      pairs.add('全球市场');
    }

    return pairs.toList();
  }

  /// 获取时间的相对描述（如"2小时前"）
  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return DateFormat('MM-dd HH:mm').format(dateTime);
    }
  }
}
