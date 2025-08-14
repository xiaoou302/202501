import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mission.dart';
import '../models/milestone.dart';
import '../models/action_item.dart';
import '../models/pack_item.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// DeepSeek AI服务，提供智能计划生成和建议功能
class DeepseekAIService {
  // 单例模式
  static final DeepseekAIService _instance = DeepseekAIService._internal();
  factory DeepseekAIService() => _instance;
  DeepseekAIService._internal();

  // API配置
  static const String _apiKey = 'sk-a4abb25bbf5e4cb59387fcaa3048420f';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  final Random _random = Random();

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        _random.nextInt(10000).toString();
  }

  /// 获取目的地天气信息
  Future<Map<String, dynamic>> _getWeatherInfo(String destination) async {
    try {
      // 使用OpenWeatherMap API获取天气信息
      // 注意：这里使用了免费API，实际应用中可能需要使用付费API或替代方案
      const apiKey = ''; // 实际应用中需要填入有效的API密钥

      if (apiKey.isEmpty) {
        return _getDefaultWeatherInfo(destination);
      }

      final encodedDest = Uri.encodeComponent(destination);
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$encodedDest&appid=$apiKey&units=metric&lang=zh_cn';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'temperature': data['main']['temp'],
          'condition': data['weather'][0]['main'],
          'description': data['weather'][0]['description'],
          'success': true,
        };
      } else {
        debugPrint('获取天气信息失败: ${response.statusCode}');
        return _getDefaultWeatherInfo(destination);
      }
    } catch (e) {
      debugPrint('获取天气信息时出错: $e');
      return _getDefaultWeatherInfo(destination);
    }
  }

  /// 获取默认天气信息（当API调用失败时）
  Map<String, dynamic> _getDefaultWeatherInfo(String destination) {
    // 根据目的地名称猜测可能的天气
    final now = DateTime.now();
    final month = now.month;

    // 简单的季节判断
    String season;
    if (month >= 3 && month <= 5) {
      season = '春季';
    } else if (month >= 6 && month <= 8) {
      season = '夏季';
    } else if (month >= 9 && month <= 11) {
      season = '秋季';
    } else {
      season = '冬季';
    }

    // 根据目的地名称和季节猜测可能的天气
    String condition;
    String description;
    double temperature;

    if (destination.contains('北') ||
        destination.contains('哈尔滨') ||
        destination.contains('长春')) {
      // 北方城市
      if (season == '冬季') {
        condition = 'Cold';
        description = '寒冷';
        temperature = -5;
      } else if (season == '夏季') {
        condition = 'Hot';
        description = '炎热';
        temperature = 28;
      } else {
        condition = 'Mild';
        description = '温和';
        temperature = 15;
      }
    } else if (destination.contains('南') ||
        destination.contains('广州') ||
        destination.contains('深圳') ||
        destination.contains('海南')) {
      // 南方城市
      if (season == '冬季') {
        condition = 'Mild';
        description = '温和';
        temperature = 15;
      } else if (season == '夏季') {
        condition = 'Hot';
        description = '炎热潮湿';
        temperature = 32;
      } else {
        condition = 'Warm';
        description = '温暖';
        temperature = 22;
      }
    } else if (destination.contains('西') ||
        destination.contains('新疆') ||
        destination.contains('西藏')) {
      // 西部地区
      if (season == '冬季') {
        condition = 'Cold';
        description = '寒冷干燥';
        temperature = -8;
      } else if (season == '夏季') {
        condition = 'Hot';
        description = '炎热干燥';
        temperature = 30;
      } else {
        condition = 'Mild';
        description = '温和干燥';
        temperature = 18;
      }
    } else {
      // 默认
      if (season == '冬季') {
        condition = 'Cold';
        description = '寒冷';
        temperature = 5;
      } else if (season == '夏季') {
        condition = 'Hot';
        description = '炎热';
        temperature = 28;
      } else {
        condition = 'Mild';
        description = '温和';
        temperature = 20;
      }
    }

    return {
      'temperature': temperature,
      'condition': condition,
      'description': description,
      'season': season,
      'success': false,
    };
  }

  /// 根据天气信息生成季节性物品
  List<PackItem> _generateWeatherBasedItems(
    String id,
    Map<String, dynamic> weatherInfo,
    String destination,
  ) {
    final items = <PackItem>[];
    final condition = weatherInfo['condition'];
    final temperature = weatherInfo['temperature'];
    final description = weatherInfo['description'];

    // 添加季节性物品
    if (condition == 'Cold' || temperature < 10) {
      // 寒冷天气物品
      items.add(
        PackItem(
          id: '${id}_w1',
          name: 'Heavy Coat/Down Jacket',
          category: PackCategory.seasonal,
          isPacked: false,
          quantity: 1,
          description: 'Destination is cold, bring warm clothing',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w2',
          name: 'Thermal Underwear',
          category: PackCategory.clothing,
          isPacked: false,
          quantity: 2,
          description: 'Suitable for cold weather',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w3',
          name: 'Scarf/Gloves/Hat',
          category: PackCategory.accessories,
          isPacked: false,
          quantity: 1,
          description: 'For cold protection',
        ),
      );
    } else if (condition == 'Hot' || temperature > 25) {
      // 炎热天气物品
      items.add(
        PackItem(
          id: '${id}_w1',
          name: 'Sunscreen',
          category: PackCategory.toiletries,
          isPacked: false,
          quantity: 1,
          description: 'SPF30+ to prevent sunburn',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w2',
          name: 'Sun Hat',
          category: PackCategory.accessories,
          isPacked: false,
          quantity: 1,
          description: 'Essential for sun protection',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w3',
          name: 'Light Breathable Clothing',
          category: PackCategory.clothing,
          isPacked: false,
          quantity: 5,
          description: 'Suitable for hot weather',
        ),
      );
    }

    // 根据天气描述添加特定物品
    if (description.contains('雨') ||
        description.contains('阵雨') ||
        description.contains('雷阵雨') ||
        description.toLowerCase().contains('rain') ||
        description.toLowerCase().contains('shower')) {
      items.add(
        PackItem(
          id: '${id}_w4',
          name: 'Umbrella/Raincoat',
          category: PackCategory.seasonal,
          isPacked: false,
          quantity: 1,
          description: 'Rain is expected at your destination',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w5',
          name: 'Waterproof Shoe Covers',
          category: PackCategory.footwear,
          isPacked: false,
          quantity: 1,
          description: 'Keep your shoes dry',
        ),
      );
    }

    if (description.contains('雪') ||
        description.toLowerCase().contains('snow') ||
        destination.contains('雪') ||
        destination.toLowerCase().contains('snow')) {
      items.add(
        PackItem(
          id: '${id}_w6',
          name: 'Snow Boots',
          category: PackCategory.footwear,
          isPacked: false,
          quantity: 1,
          description: 'Suitable for walking in snow',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w7',
          name: 'Waterproof Gloves',
          category: PackCategory.accessories,
          isPacked: false,
          quantity: 1,
          description: 'Prevent snow from wetting your hands',
        ),
      );
    }

    if (description.contains('干燥') ||
        description.toLowerCase().contains('dry') ||
        destination.contains('沙漠') ||
        destination.toLowerCase().contains('desert')) {
      items.add(
        PackItem(
          id: '${id}_w8',
          name: 'Moisturizer',
          category: PackCategory.toiletries,
          isPacked: false,
          quantity: 1,
          description: 'Essential for dry climates',
        ),
      );
      items.add(
        PackItem(
          id: '${id}_w9',
          name: 'Lip Balm',
          category: PackCategory.toiletries,
          isPacked: false,
          quantity: 1,
          description: 'Prevents chapped lips',
        ),
      );
    }

    return items;
  }

  /// 根据用户输入生成任务
  Future<Mission> generateMission(String input) async {
    try {
      // 提取目的地、时间和人数信息
      String destination = '未知目的地';
      String duration = '未知时间';
      String people = '未知人数';

      // 尝试提取目的地
      if (input.contains('去') && input.contains('旅行') || input.contains('旅游')) {
        final parts = input.split('去');
        if (parts.length > 1) {
          final destParts = parts[1].split('旅行');
          if (destParts.length > 0) {
            destination = destParts[0].trim();
          }
        }
      }

      // 尝试提取时间
      final durationRegex = RegExp(r'(\d+)天|(\d+)周|(\d+)个月');
      final durationMatch = durationRegex.firstMatch(input);
      if (durationMatch != null) {
        duration = durationMatch.group(0) ?? '7天';
      }

      // 尝试提取人数
      final peopleRegex = RegExp(r'(\d+)人');
      final peopleMatch = peopleRegex.firstMatch(input);
      if (peopleMatch != null) {
        people = peopleMatch.group(0) ?? '1人';
      }

      // 获取目的地天气信息
      final weatherInfo = await _getWeatherInfo(destination);

      // 构建请求体
      final prompt =
          '''
As a professional travel planning assistant, please create a detailed packing list for the following trip:

Destination: $destination
Duration: $duration
People: $people

Based on the destination, season, trip duration, and number of people, generate a comprehensive packing list with all necessary items. Include items from different categories such as documents, clothing, electronics, toiletries, medications, etc.

IMPORTANT FORMATTING REQUIREMENTS:
1. Return ONLY a valid JSON object with no comments, no explanations, and no extra text
2. Do NOT include any control characters (newlines, tabs, etc.) within string values
3. Properly escape all quotes and special characters in strings
4. Use simple URLs without special characters (e.g., use https://example.com instead of complex URLs)
5. Keep all string values on a single line
6. Do not use trailing commas in arrays or objects

The JSON structure should be:
{
  "title": "Trip title",
  "description": "Trip description",
  "resources": [
    {
      "name": "Item name",
      "category": "documents/clothing/electronics/toiletries/accessories/equipment/medications/footwear/seasonal/food/childcare/other",
      "quantity": number,
      "description": "Item description (optional)"
    }
  ],
  "knowledge": [
    {"title": "Resource title", "url": "https://example.com/resource", "description": "Resource description"}
  ]
}

Ensure you provide a variety of items for different categories, especially appropriate clothing and equipment based on the destination and season. For family trips, include items suitable for children.
''';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = responseData['choices'][0]['message']['content'];

        // 提取JSON部分
        String jsonContent;
        Map<String, dynamic> missionData;

        try {
          // First try to parse the entire content as JSON
          missionData = jsonDecode(content);
        } catch (e) {
          // If that fails, try to extract JSON from the content
          final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
          if (jsonMatch == null) {
            print('AI response does not contain valid JSON: $content');
            throw Exception('Unable to parse JSON data returned by AI');
          }

          jsonContent = jsonMatch.group(0)!;

          // Clean up the JSON string to remove comments and ensure it's valid
          jsonContent = jsonContent.replaceAll(
            RegExp(r'//.*'),
            '',
          ); // Remove single-line comments
          jsonContent = jsonContent.replaceAll(
            RegExp(r'/\*[\s\S]*?\*/'),
            '',
          ); // Remove multi-line comments

          // Replace control characters and escape sequences that might cause issues
          jsonContent = jsonContent.replaceAll(
            RegExp(r'[\u0000-\u001F]'),
            '',
          ); // Remove control characters
          jsonContent = jsonContent.replaceAll(
            RegExp(r'\\(?!["\\/bfnrtu])'),
            '\\\\',
          ); // Escape backslashes

          // Try to fix common JSON formatting issues
          try {
            // First attempt to parse as is
            missionData = jsonDecode(jsonContent);
          } catch (e) {
            print('First parse attempt failed: $e');

            try {
              // Try to sanitize the JSON further
              final sanitizedJson = _sanitizeJsonString(jsonContent);
              missionData = jsonDecode(sanitizedJson);
            } catch (e2) {
              print('Failed to parse extracted JSON after sanitizing');
              print('Error: $e2');

              // As a last resort, try to extract a valid portion of the JSON
              try {
                final partialJsonMatch = RegExp(
                  r'\{\s*"title"[^}]*\}',
                ).firstMatch(jsonContent);
                if (partialJsonMatch != null) {
                  final partialJson = '${partialJsonMatch.group(0)}';
                  // Create a minimal valid JSON with just the title
                  final minimalJson =
                      '{' +
                      partialJson.substring(1, partialJson.length - 1) +
                      ', "resources": [], "knowledge": []}';
                  missionData = jsonDecode(minimalJson);
                } else {
                  throw Exception('Could not extract any valid JSON');
                }
              } catch (e3) {
                print('All JSON parsing attempts failed');
                print('Original error: $e');
                print('Sanitized error: $e2');
                print('Partial error: $e3');
                throw Exception('Invalid JSON format in AI response');
              }
            }
          }
        }

        // 生成任务
        final mission = _createMissionFromAIResponse(missionData);

        // 添加天气相关物品
        final weatherItems = _generateWeatherBasedItems(
          mission.id,
          weatherInfo,
          destination,
        );

        // 合并所有物品
        final allItems = [...mission.packItems, ...weatherItems];

        // 添加天气信息到描述
        String weatherDesc = '';
        if (weatherInfo['success']) {
          weatherDesc =
              '，当前温度${weatherInfo['temperature']}°C，${weatherInfo['description']}';
        } else {
          final season = weatherInfo['season'];
          weatherDesc = '，${season}季节，预计${weatherInfo['description']}';
        }

        // 返回更新后的任务
        return mission.copyWith(
          description: '${mission.description}$weatherDesc',
          packItems: allItems,
        );
      } else {
        print('API错误: ${response.statusCode} - ${response.body}');
        // 如果API调用失败，回退到本地生成
        return await _generateLocalMission(input);
      }
    } catch (e) {
      print('生成任务时出错: $e');
      // 出错时回退到本地生成
      return await _generateLocalMission(input);
    }
  }

  /// 从AI响应创建任务对象
  Mission _createMissionFromAIResponse(Map<String, dynamic> data) {
    try {
      final id = _generateId();
      final now = DateTime.now();

      // 创建里程碑和行动项
      final milestones = <Milestone>[];
      if (data['milestones'] != null && data['milestones'] is List) {
        for (int i = 0; i < data['milestones'].length; i++) {
          try {
            final m = data['milestones'][i];
            if (m is! Map<String, dynamic>) continue;

            final milestoneId = '${id}_m${i + 1}';
            final actions = <ActionItem>[];

            if (m['actions'] != null && m['actions'] is List) {
              for (int j = 0; j < m['actions'].length; j++) {
                try {
                  final a = m['actions'][j];
                  if (a is! Map<String, dynamic>) continue;

                  actions.add(
                    ActionItem(
                      id: '${milestoneId}_a${j + 1}',
                      title: a['title']?.toString() ?? 'Action Item',
                      isCompleted: false,
                      description: a['description']?.toString(),
                      dueDate: now.add(Duration(days: 7 + (7 * i) + j)),
                    ),
                  );
                } catch (e) {
                  print('Error creating action item: $e');
                  // Continue with next action item
                }
              }
            }

            milestones.add(
              Milestone(
                id: milestoneId,
                title: m['title']?.toString() ?? 'Milestone ${i + 1}',
                description: m['description']?.toString() ?? '',
                dueDate: now.add(Duration(days: 7 * (i + 1))),
                status: MilestoneStatus.notStarted,
                actions: actions,
              ),
            );
          } catch (e) {
            print('Error creating milestone: $e');
            // Continue with next milestone
          }
        }
      }

      // 创建资源/物品
      final packItems = <PackItem>[];
      if (data['resources'] != null && data['resources'] is List) {
        for (int i = 0; i < data['resources'].length; i++) {
          try {
            final r = data['resources'][i];
            if (r is! Map<String, dynamic>) continue;

            final category = _getPackCategory(
              r['category']?.toString() ?? 'other',
            );
            final quantity = r['quantity'] is int ? r['quantity'] as int : 1;

            packItems.add(
              PackItem(
                id: '${id}_p${i + 1}',
                name: r['name']?.toString() ?? 'Item ${i + 1}',
                category: category,
                isPacked: false,
                quantity: quantity,
                description: r['description']?.toString(),
              ),
            );
          } catch (e) {
            print('Error creating pack item: $e');
            // Continue with next pack item
          }
        }
      }

      // 创建知识资源
      final knowledgePods = <KnowledgePod>[];
      if (data['knowledge'] != null && data['knowledge'] is List) {
        for (int i = 0; i < data['knowledge'].length; i++) {
          try {
            final k = data['knowledge'][i];
            if (k is! Map<String, dynamic>) continue;

            knowledgePods.add(
              KnowledgePod(
                id: '${id}_k${i + 1}',
                title: k['title']?.toString() ?? 'Resource ${i + 1}',
                url: k['url']?.toString() ?? 'https://example.com',
                description: k['description']?.toString(),
              ),
            );
          } catch (e) {
            print('Error creating knowledge pod: $e');
            // Continue with next knowledge pod
          }
        }
      }

      // Ensure we always have at least one milestone
      if (milestones.isEmpty) {
        milestones.add(
          Milestone(
            id: '${id}_m1',
            title: 'Prepare for Trip',
            description: 'Get ready for your journey',
            dueDate: now.add(const Duration(days: 7)),
            status: MilestoneStatus.notStarted,
            actions: [
              ActionItem(
                id: '${id}_m1_a1',
                title: 'Pack Your Items',
                isCompleted: false,
                description: 'Pack all the items in your packing list',
                dueDate: now.add(const Duration(days: 5)),
              ),
              ActionItem(
                id: '${id}_m1_a2',
                title: 'Check Documents',
                isCompleted: false,
                description: 'Make sure you have all necessary documents',
                dueDate: now.add(const Duration(days: 3)),
              ),
            ],
          ),
        );
      }

      return Mission(
        id: id,
        title: data['title']?.toString() ?? 'New Trip',
        description: data['description']?.toString() ?? 'Trip Description',
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        milestones: milestones,
        packItems: packItems,
        knowledgePods: knowledgePods,
      );
    } catch (e) {
      print('Error creating mission from AI response: $e');
      // Return a default mission if something goes wrong
      return _createDefaultMission();
    }
  }

  /// 创建默认任务（当解析AI响应失败时）
  Mission _createDefaultMission() {
    final id = _generateId();
    final now = DateTime.now();

    return Mission(
      id: id,
      title: 'My Trip',
      description: 'A packing list for your trip',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      milestones: [
        Milestone(
          id: '${id}_m1',
          title: 'Prepare for Trip',
          description: 'Get ready for your journey',
          dueDate: now.add(const Duration(days: 7)),
          status: MilestoneStatus.notStarted,
          actions: [
            ActionItem(
              id: '${id}_m1_a1',
              title: 'Pack Your Items',
              isCompleted: false,
              description: 'Pack all the items in your packing list',
              dueDate: now.add(const Duration(days: 5)),
            ),
            ActionItem(
              id: '${id}_m1_a2',
              title: 'Check Documents',
              isCompleted: false,
              description: 'Make sure you have all necessary documents',
              dueDate: now.add(const Duration(days: 3)),
            ),
          ],
        ),
      ],
      packItems: [
        PackItem(
          id: '${id}_p1',
          name: 'Passport',
          category: PackCategory.documents,
          isPacked: false,
          quantity: 1,
          description: 'Essential for international travel',
        ),
        PackItem(
          id: '${id}_p2',
          name: 'Clothing',
          category: PackCategory.clothing,
          isPacked: false,
          quantity: 5,
          description: 'Pack according to your destination weather',
        ),
        PackItem(
          id: '${id}_p3',
          name: 'Toiletries',
          category: PackCategory.toiletries,
          isPacked: false,
          quantity: 1,
          description: 'Toothbrush, toothpaste, etc.',
        ),
      ],
      knowledgePods: [],
    );
  }

  /// 将字符串类别转换为枚举类型
  PackCategory _getPackCategory(String category) {
    switch (category.toLowerCase()) {
      case 'documents':
        return PackCategory.documents;
      case 'clothing':
        return PackCategory.clothing;
      case 'electronics':
        return PackCategory.electronics;
      case 'toiletries':
        return PackCategory.toiletries;
      case 'accessories':
        return PackCategory.accessories;
      case 'equipment':
        return PackCategory.equipment;
      case 'medications':
        return PackCategory.medications;
      case 'footwear':
        return PackCategory.footwear;
      case 'seasonal':
        return PackCategory.seasonal;
      case 'food':
        return PackCategory.food;
      case 'childcare':
        return PackCategory.childcare;
      default:
        return PackCategory.other;
    }
  }

  /// 本地生成任务（当API调用失败时的备选方案）
  Future<Mission> _generateLocalMission(String input) async {
    // 根据输入确定任务类型
    bool isTravel =
        input.contains('旅行') ||
        input.contains('旅游') ||
        input.contains('游') ||
        input.contains('行程');

    if (isTravel) {
      return _generateTravelMission(input);
    } else {
      return _generateLearningMission(input);
    }
  }

  /// 生成旅行类任务
  Future<Mission> _generateTravelMission(String input) async {
    final id = _generateId();
    final now = DateTime.now();

    // Extract destination (simplified processing)
    String destination = '旅行目的地';
    String duration = '7天';
    String people = '2人';

    // 尝试提取目的地
    if (input.contains('去')) {
      final parts = input.split('去');
      if (parts.length > 1) {
        final destParts = parts[1].split('旅行');
        if (destParts.length > 0) {
          destination = destParts[0].trim();
        }
      }
    }

    // 尝试提取时间
    final durationRegex = RegExp(r'(\d+)天|(\d+)周|(\d+)个月');
    final durationMatch = durationRegex.firstMatch(input);
    if (durationMatch != null) {
      duration = durationMatch.group(0) ?? '7天';
    }

    // 尝试提取人数
    final peopleRegex = RegExp(r'(\d+)人');
    final peopleMatch = peopleRegex.firstMatch(input);
    if (peopleMatch != null) {
      people = peopleMatch.group(0) ?? '2人';
    }

    // 获取天气信息
    final weatherInfo = await _getWeatherInfo(destination);

    // 创建里程碑
    final milestones = [
      Milestone(
        id: '${id}_m1',
        title: 'Pre-Trip Preparation',
        description: 'Prepare items and documents needed for travel',
        dueDate: now.add(const Duration(days: 7)),
        status: MilestoneStatus.notStarted,
        actions: [
          ActionItem(
            id: '${id}_m1_a1',
            title: 'Book Flights/Tickets',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m1_a2',
            title: 'Book Hotel',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m1_a3',
            title: 'Prepare Travel Documents',
            isCompleted: false,
          ),
        ],
      ),
      Milestone(
        id: '${id}_m2',
        title: 'Plan Itinerary',
        description: 'Plan daily activities and attractions',
        dueDate: now.add(const Duration(days: 14)),
        status: MilestoneStatus.notStarted,
        actions: [
          ActionItem(
            id: '${id}_m2_a1',
            title: 'Research Destination Attractions',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m2_a2',
            title: 'Schedule Daily Activities',
            isCompleted: false,
          ),
        ],
      ),
      Milestone(
        id: '${id}_m3',
        title: 'Start Journey',
        description: 'Enjoy the travel experience',
        dueDate: now.add(const Duration(days: 21)),
        status: MilestoneStatus.notStarted,
        actions: [
          ActionItem(
            id: '${id}_m3_a1',
            title: 'Confirm All Reservations',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m3_a2',
            title: 'Pack Luggage',
            isCompleted: false,
          ),
        ],
      ),
    ];

    // 创建打包物品
    final packItems = [
      // 证件类
      PackItem(
        id: '${id}_p1',
        name: 'Passport',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
        description: 'Essential for international travel',
      ),
      PackItem(
        id: '${id}_p2',
        name: 'Visa',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
        description: 'Ensure validity covers your entire trip',
      ),
      PackItem(
        id: '${id}_p3',
        name: 'ID Card',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p4',
        name: 'Driver\'s License',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
        description: 'Required if you plan to rent a car',
      ),
      PackItem(
        id: '${id}_p5',
        name: 'Hotel Reservations',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p6',
        name: 'Flight/Train Tickets',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
      ),

      // 衣物类
      PackItem(
        id: '${id}_p7',
        name: 'Jacket',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 1,
        description: 'Windproof and waterproof',
      ),
      PackItem(
        id: '${id}_p8',
        name: 'T-shirts',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 5,
      ),
      PackItem(
        id: '${id}_p9',
        name: 'Pants',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 2,
      ),
      PackItem(
        id: '${id}_p10',
        name: 'Shorts',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 2,
      ),
      PackItem(
        id: '${id}_p11',
        name: 'Underwear',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 7,
      ),
      PackItem(
        id: '${id}_p12',
        name: 'Socks',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 7,
      ),
      PackItem(
        id: '${id}_p13',
        name: 'Pajamas',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 1,
      ),

      // 电子产品
      PackItem(
        id: '${id}_p14',
        name: 'Phone Charger',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p15',
        name: 'Power Bank',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
        description: 'Ensure capacity meets airline requirements',
      ),
      PackItem(
        id: '${id}_p16',
        name: 'Travel Adapter',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
        description: 'Compatible with destination power standards',
      ),
      PackItem(
        id: '${id}_p17',
        name: 'Camera/Phone',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p18',
        name: 'Headphones',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
      ),

      // 洗漱用品
      PackItem(
        id: '${id}_p19',
        name: 'Toothbrush & Toothpaste',
        category: PackCategory.toiletries,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p20',
        name: 'Shampoo & Body Wash',
        category: PackCategory.toiletries,
        isPacked: false,
        quantity: 1,
        description: 'Travel size',
      ),
      PackItem(
        id: '${id}_p21',
        name: 'Towel',
        category: PackCategory.toiletries,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p22',
        name: 'Razor/Shaver',
        category: PackCategory.toiletries,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p23',
        name: 'Sunscreen',
        category: PackCategory.toiletries,
        isPacked: false,
        quantity: 1,
      ),

      // 药品
      PackItem(
        id: '${id}_p24',
        name: 'Common Medications',
        category: PackCategory.medications,
        isPacked: false,
        quantity: 1,
        description: 'Cold medicine, stomach medicine, etc.',
      ),
      PackItem(
        id: '${id}_p25',
        name: 'Band-Aids',
        category: PackCategory.medications,
        isPacked: false,
        quantity: 5,
      ),
      PackItem(
        id: '${id}_p26',
        name: 'Motion Sickness Pills',
        category: PackCategory.medications,
        isPacked: false,
        quantity: 1,
      ),

      // 鞋类
      PackItem(
        id: '${id}_p27',
        name: 'Comfortable Walking Shoes',
        category: PackCategory.footwear,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p28',
        name: 'Slippers',
        category: PackCategory.footwear,
        isPacked: false,
        quantity: 1,
      ),

      // 季节性物品
      PackItem(
        id: '${id}_p29',
        name: 'Umbrella',
        category: PackCategory.seasonal,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p30',
        name: 'Sunglasses',
        category: PackCategory.seasonal,
        isPacked: false,
        quantity: 1,
      ),

      // 配件
      PackItem(
        id: '${id}_p31',
        name: 'Backpack/Shoulder Bag',
        category: PackCategory.accessories,
        isPacked: false,
        quantity: 1,
        description: 'For daily outings',
      ),
      PackItem(
        id: '${id}_p32',
        name: 'Travel Pillow',
        category: PackCategory.accessories,
        isPacked: false,
        quantity: 1,
      ),
      PackItem(
        id: '${id}_p33',
        name: 'Eye Mask & Ear Plugs',
        category: PackCategory.accessories,
        isPacked: false,
        quantity: 1,
      ),
    ];

    // 创建知识胶囊
    final knowledgePods = [
      KnowledgePod(
        id: '${id}_k1',
        title: '$destination Travel Guide',
        url: 'https://www.tripadvisor.com/Search?q=$destination',
        description: 'Detailed travel guide for $destination',
      ),
      KnowledgePod(
        id: '${id}_k2',
        title: 'Efficient Packing Tips',
        url: 'https://www.travelandleisure.com/travel-tips/packing-tips',
        description: 'How to organize your suitcase efficiently',
      ),
      KnowledgePod(
        id: '${id}_k3',
        title: '$destination Weather Forecast',
        url:
            'https://www.accuweather.com/en/search-locations?query=$destination',
        description:
            'Weather forecast for your destination to help pack appropriate clothing',
      ),
      KnowledgePod(
        id: '${id}_k4',
        title: 'Essential Travel Checklist',
        url:
            'https://www.ricksteves.com/travel-tips/packing-light/packing-checklist',
        description: 'Popular travel essentials checklist',
      ),
      KnowledgePod(
        id: '${id}_k5',
        title: 'International Travel Tips',
        url:
            'https://travel.state.gov/content/travel/en/international-travel/before-you-go/travelers-checklist.html',
        description:
            'Safety tips and important information for international travel',
      ),
    ];

    // 获取天气相关物品
    final weatherItems = _generateWeatherBasedItems(
      id,
      weatherInfo,
      destination,
    );

    // 合并所有物品
    final allItems = [...packItems, ...weatherItems];

    // 添加天气信息到描述
    String weatherDesc = '';
    if (weatherInfo['success']) {
      weatherDesc =
          ', current temperature ${weatherInfo['temperature']}°C, ${weatherInfo['description']}';
    } else {
      final season = weatherInfo['season'];
      String englishSeason = '';
      switch (season) {
        case '春季':
          englishSeason = 'Spring';
          break;
        case '夏季':
          englishSeason = 'Summer';
          break;
        case '秋季':
          englishSeason = 'Fall';
          break;
        case '冬季':
          englishSeason = 'Winter';
          break;
        default:
          englishSeason = season;
      }

      String englishDescription = '';
      switch (weatherInfo['description']) {
        case '寒冷':
          englishDescription = 'cold';
          break;
        case '炎热':
          englishDescription = 'hot';
          break;
        case '温和':
          englishDescription = 'mild';
          break;
        case '温暖':
          englishDescription = 'warm';
          break;
        case '炎热潮湿':
          englishDescription = 'hot and humid';
          break;
        case '寒冷干燥':
          englishDescription = 'cold and dry';
          break;
        case '炎热干燥':
          englishDescription = 'hot and dry';
          break;
        case '温和干燥':
          englishDescription = 'mild and dry';
          break;
        default:
          englishDescription = weatherInfo['description'];
      }

      weatherDesc =
          ', $englishSeason season, expected to be $englishDescription';
    }

    return Mission(
      id: id,
      title: 'Trip to $destination',
      description:
          'Packing list for a $duration trip to $destination with $people$weatherDesc',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      milestones: milestones,
      packItems: allItems,
      knowledgePods: knowledgePods,
    );
  }

  /// 生成学习类任务
  Mission _generateLearningMission(String input) {
    final id = _generateId();
    final now = DateTime.now();

    // Extract learning subject (simplified processing)
    String subject = 'Learning Subject';
    if (input.contains('learn')) {
      final parts = input.split('learn');
      if (parts.length > 1) {
        subject = parts[1].trim().split(' ')[0];
      }
    } else if (input.contains('study')) {
      final parts = input.split('study');
      if (parts.length > 1) {
        subject = parts[1].trim().split(' ')[0];
      }
    }

    // 创建里程碑
    final milestones = [
      Milestone(
        id: '${id}_m1',
        title: 'Week 1: Basics',
        description: 'Master the basic concepts of $subject',
        dueDate: now.add(const Duration(days: 7)),
        status: MilestoneStatus.notStarted,
        actions: [
          ActionItem(
            id: '${id}_m1_a1',
            title: 'Gather Learning Materials',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m1_a2',
            title: 'Study Basic Concepts',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m1_a3',
            title: 'Complete Beginner Exercises',
            isCompleted: false,
          ),
        ],
      ),
      Milestone(
        id: '${id}_m2',
        title: 'Week 2: Advanced Techniques',
        description: 'Deep dive into core techniques of $subject',
        dueDate: now.add(const Duration(days: 14)),
        status: MilestoneStatus.notStarted,
        actions: [
          ActionItem(
            id: '${id}_m2_a1',
            title: 'Practice 30 Minutes Daily',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m2_a2',
            title: 'Complete Advanced Project',
            isCompleted: false,
          ),
        ],
      ),
      Milestone(
        id: '${id}_m3',
        title: 'Week 3: Practical Application',
        description: 'Apply $subject to real-world scenarios',
        dueDate: now.add(const Duration(days: 21)),
        status: MilestoneStatus.notStarted,
        actions: [
          ActionItem(
            id: '${id}_m3_a1',
            title: 'Complete Practical Project',
            isCompleted: false,
          ),
          ActionItem(
            id: '${id}_m3_a2',
            title: 'Document Learning Results',
            isCompleted: false,
          ),
        ],
      ),
    ];

    // 创建装备物品（基于学习主题）
    final packItems = [
      PackItem(
        id: '${id}_p1',
        name: 'Learning Materials',
        category: PackCategory.equipment,
        isPacked: false,
        quantity: 1,
        icon: 'book',
      ),
      PackItem(
        id: '${id}_p2',
        name: 'Practice Tools',
        category: PackCategory.equipment,
        isPacked: false,
        quantity: 1,
        icon: 'tools',
      ),
      PackItem(
        id: '${id}_p3',
        name: 'Notebook',
        category: PackCategory.equipment,
        isPacked: false,
        quantity: 1,
        icon: 'notebook',
      ),
    ];

    // 创建知识胶囊
    final knowledgePods = [
      KnowledgePod(
        id: '${id}_k1',
        title: 'Ultimate Beginner Guide to $subject',
        url: 'https://example.com/guide',
        description: 'Detailed learning guide for $subject',
      ),
      KnowledgePod(
        id: '${id}_k2',
        title: 'How to Learn $subject Efficiently',
        url: 'https://example.com/learning',
        description: 'Efficient learning methods',
      ),
    ];

    return Mission(
      id: id,
      title: 'Learn $subject',
      description: 'Systematic plan to learn $subject',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      milestones: milestones,
      packItems: packItems,
      knowledgePods: knowledgePods,
    );
  }

  /// 生成AI回复
  Future<String> generateAIResponse(
    String userInput,
    Mission? currentMission,
  ) async {
    try {
      // 构建上下文
      String context = '';
      if (currentMission != null) {
        context =
            '''
Current Mission: ${currentMission.title}
Mission Description: ${currentMission.description}
''';
      }

      // Build prompt
      final prompt =
          '''
$context
User Question: $userInput

Please provide a brief, helpful response to assist the user in completing their mission.
''';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print('API错误: ${response.statusCode} - ${response.body}');
        // 如果API调用失败，回退到本地生成
        return _generateLocalAIResponse(userInput, currentMission);
      }
    } catch (e) {
      print('生成AI回复时出错: $e');
      // 出错时回退到本地生成
      return _generateLocalAIResponse(userInput, currentMission);
    }
  }

  /// 本地生成AI回复（当API调用失败时的备选方案）
  String _generateLocalAIResponse(String userInput, Mission? currentMission) {
    // 模拟AI回复
    if (userInput.contains('tired') &&
        userInput.contains('running') &&
        userInput.contains('stretch')) {
      return 'No problem, I have changed your running task to stretching. Stretching helps with muscle recovery, especially when you feel tired.';
    }

    if (userInput.contains('weather') || userInput.contains('rain')) {
      return 'Tomorrow\'s weather forecast shows rain. I recommend bringing rain gear. I\'ve added an umbrella to your smart pack.';
    }

    if (userInput.contains('suggestion') || userInput.contains('recommend')) {
      return 'Based on your interests and current mission, I recommend spending 15 minutes each morning organizing your plan. This can improve your daily efficiency.';
    }

    // Default response
    return 'I understand. Is there anything specific I can help you with?';
  }

  /// 生成快速建议
  Future<List<String>> generateQuickSuggestions(Mission? currentMission) async {
    try {
      // 如果没有当前任务，返回默认建议
      if (currentMission == null) {
        return [
          '"Help me create a new mission"',
          '"Any learning suggestions?"',
          '"How to improve efficiency?"',
        ];
      }

      // Build prompt
      final prompt =
          '''
Current Mission: ${currentMission.title}
Mission Description: ${currentMission.description}

Please generate 3 question suggestions related to this mission that the user might ask the AI assistant. Each suggestion should be brief and targeted.
Return format: ["Question 1", "Question 2", "Question 3"]
''';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = responseData['choices'][0]['message']['content'];

        // 尝试解析JSON数组
        try {
          final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(content);
          if (jsonMatch != null) {
            final jsonArray = jsonDecode(jsonMatch.group(0)!);
            if (jsonArray is List) {
              return jsonArray.map((item) => '"$item"').toList().cast<String>();
            }
          }
        } catch (e) {
          print('解析建议时出错: $e');
        }

        // 如果解析失败，回退到本地生成
        return _generateLocalQuickSuggestions(currentMission);
      } else {
        print('API错误: ${response.statusCode} - ${response.body}');
        // 如果API调用失败，回退到本地生成
        return _generateLocalQuickSuggestions(currentMission);
      }
    } catch (e) {
      print('生成快速建议时出错: $e');
      // 出错时回退到本地生成
      return _generateLocalQuickSuggestions(currentMission);
    }
  }

  /// 清理JSON字符串，修复常见格式问题
  String _sanitizeJsonString(String jsonString) {
    // Replace any unescaped quotes in strings
    var result = jsonString;

    // Fix URLs with unescaped control characters
    final urlPattern = RegExp(r'"(https?://[^"]*)"');
    final matches = urlPattern.allMatches(result).toList();

    // Process URLs from end to start to avoid index issues
    for (int i = matches.length - 1; i >= 0; i--) {
      final match = matches[i];
      final url = match.group(1)!;
      final sanitizedUrl = url
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .replaceAll('\t', '')
          .replaceAll(RegExp(r'[^\x20-\x7E]'), ''); // Keep only printable ASCII

      result = result.replaceRange(
        match.start + 1,
        match.end - 1,
        sanitizedUrl,
      );
    }

    // Fix common JSON syntax errors
    result = result
        // Fix trailing commas in arrays
        .replaceAll(RegExp(r',\s*]'), ']')
        // Fix trailing commas in objects
        .replaceAll(RegExp(r',\s*}'), '}')
        // Ensure property names are quoted
        .replaceAll(RegExp(r'([{,]\s*)([a-zA-Z0-9_]+)(\s*:)'), r'$1"$2"$3')
        // Ensure proper boolean values
        .replaceAll(RegExp(r':\s*True\b'), ': true')
        .replaceAll(RegExp(r':\s*False\b'), ': false')
        // Ensure proper null values
        .replaceAll(RegExp(r':\s*None\b'), ': null')
        // Fix missing quotes around string values
        .replaceAll(
          RegExp(r':\s*([a-zA-Z][a-zA-Z0-9_\s]+)([,}])'),
          r': "$1"$2',
        );

    return result;
  }

  /// 本地生成快速建议（当API调用失败时的备选方案）
  List<String> _generateLocalQuickSuggestions(Mission? currentMission) {
    // Travel suggestions
    List<String> travelSuggestions = [
      '"Help me plan a 7-day trip to Japan"',
      '"What should I pack for a beach vacation?"',
      '"Recommend activities for a family trip"',
      '"How to travel on a budget?"',
      '"Tips for solo traveling safely"',
      '"Best destinations for winter travel"',
    ];

    // Self-discipline suggestions
    List<String> selfDisciplineSuggestions = [
      '"How to build a morning routine?"',
      '"Tips for maintaining a daily exercise habit"',
      '"Help me create a productivity system"',
      '"Strategies to avoid procrastination"',
      '"How to track my goals effectively?"',
      '"Ways to improve focus and concentration"',
    ];

    if (currentMission == null) {
      // Mix of travel and self-discipline suggestions
      return [
        travelSuggestions[0],
        selfDisciplineSuggestions[0],
        travelSuggestions[1],
        selfDisciplineSuggestions[1],
      ];
    }

    if (currentMission.title.toLowerCase().contains('trip') ||
        currentMission.title.toLowerCase().contains('travel') ||
        currentMission.title.contains('旅行') ||
        currentMission.title.contains('旅游')) {
      // Return travel-focused suggestions
      return travelSuggestions;
    } else if (currentMission.title.toLowerCase().contains('habit') ||
        currentMission.title.toLowerCase().contains('routine') ||
        currentMission.title.toLowerCase().contains('discipline') ||
        currentMission.title.contains('习惯') ||
        currentMission.title.contains('自律')) {
      // Return self-discipline focused suggestions
      return selfDisciplineSuggestions;
    }

    // Mix of both for other missions
    return [
      travelSuggestions[0],
      travelSuggestions[3],
      selfDisciplineSuggestions[0],
      selfDisciplineSuggestions[2],
    ];
  }
}
