import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI服务类，用于处理与DeepSeek API的通信
class AIService {
  static const String _apiKey = 'sk-0df218a7fbc349608af69ad59bfb7476';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String _proposalApiUrl =
      'https://api.deepseek.com/v1/chat/completions';

  // 单例模式
  static final AIService _instance = AIService._internal();

  factory AIService() {
    return _instance;
  }

  AIService._internal();

  /// 发送消息到AI并获取回复
  Future<String> GetPrevNameBase(
    String message,
    List<Map<String, dynamic>> history,
  ) async {
    try {
      // 构建系统提示，限制AI只回答恋爱和婚姻相关话题，并使用英文回复
      const String systemPrompt = '''
You are an AI assistant focused on relationships and marriage, answering only questions related to dating, marriage, and emotional relationships.

You should:
- Provide advice and support on dating, marriage, and emotional relationships
- Help users resolve emotional confusion and relationship issues
- Share healthy perspectives on love and marriage
- Encourage users to handle relationship issues in positive and healthy ways

You should not:
- Answer topics unrelated to relationships such as medical, health, legal, political, religious, or superstitious topics
- Provide professional medical, legal, or mental health advice
- Encourage unhealthy or harmful relationship behaviors
- Discuss sensitive or inappropriate topics

If users ask about topics unrelated to relationships and marriage, politely explain that you can only answer questions about relationships and marriage, and guide them back to relevant topics.

IMPORTANT: Always respond in English only, using a friendly and warm tone, and provide constructive advice.
''';

      // 构建消息历史
      final List<Map<String, dynamic>> messages = [
        {"role": "system", "content": systemPrompt},
      ];

      // 添加历史消息
      for (final chat in history) {
        final role = chat['isAi'] ? 'assistant' : 'user';
        messages.add({"role": role, "content": chat['content']});
      }

      // 添加当前用户消息
      messages.add({"role": "user", "content": message});

      // 构建请求体
      final Map<String, dynamic> requestBody = {
        "model": "deepseek-chat",
        "messages": messages,
        "temperature": 0.7,
        "max_tokens": 800,
      };

      // 发送请求
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      );

      // 检查响应状态
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print('API错误: ${response.statusCode} - ${response.body}');
        return _getFallbackResponse(message);
      }
    } catch (e) {
      print('AI服务错误: $e');
      return _getFallbackResponse(message);
    }
  }

  /// 检查消息是否与恋爱婚姻相关
  bool isRelationshipTopic(String message) {
    // 恋爱婚姻相关关键词 (Chinese and English)
    final List<String> relationshipKeywords = [
      // English keywords
      'love',
      'relationship',
      'marriage',
      'dating',
      'partner',
      'boyfriend',
      'girlfriend',
      'husband',
      'wife',
      'spouse',
      'couple',
      'date',
      'confession',
      'breakup',
      'reconcile',
      'argument',
      'fight',
      'conflict',
      'misunderstanding',
      'communication',
      'getting along',
      'wedding',
      'proposal',
      'ring',
      'gift',
      'surprise',
      'anniversary',
      'romantic',
      'jealousy',
      'trust',
      'affair',
      'betrayal',
      'loyalty',
      'win back',
      'separation',
      'divorce',
      'remarriage',
      'matchmaking',
      'flash marriage',
      'prenuptial',
      'marital',
      'long-distance',
      'online dating',
      'flirting',
      'crush',
      'commitment',
      'engagement',

      // Chinese keywords (kept for backward compatibility)
      '恋爱',
      '婚姻',
      '感情',
      '爱情',
      '伴侣',
      '男友',
      '女友',
      '丈夫',
      '妻子',
      '老公',
      '老婆',
      '约会',
      '表白',
      '分手',
      '复合',
      '吵架',
      '争吵',
      '矛盾',
      '误会',
      '沟通',
      '相处',
      '婚礼',
      '求婚',
      '戒指',
      '礼物',
      '惊喜',
      '纪念日',
      '浪漫',
      '吃醋',
      '信任',
      '出轨',
      '背叛',
      '忠诚',
      '挽回',
      '挽留',
      '分居',
      '离婚',
      '复婚',
      '相亲',
      '闪婚',
      '闪离',
      '婚前',
      '婚后',
      '婚检',
      '彩礼',
      '嫁妆',
      '异地恋',
      '姐弟恋',
      '忘年恋',
      '网恋',
      '暧昧',
      '暗恋',
      '告白',
      '表白',
      '相爱',
      '相处',
      '相识',
      '相知',
      '相恋',
      '相守',
      '相伴',
      '相依',
    ];

    // 检查消息中是否包含恋爱婚姻相关关键词
    final lowerMessage = message.toLowerCase();
    for (final keyword in relationshipKeywords) {
      if (lowerMessage.contains(keyword)) {
        return true;
      }
    }

    // 默认返回true，让AI自己判断
    return true;
  }

  // 获取备用回复（当API请求失败时）
  String _getFallbackResponse(String message) {
    if (!isRelationshipTopic(message)) {
      return 'I\'m sorry, I can only answer questions related to dating and marriage. If you have any questions about emotional relationships, I\'d be happy to help.';
    }

    // Check for English keywords first
    if (message.toLowerCase().contains('conflict') ||
        message.toLowerCase().contains('argument') ||
        message.toLowerCase().contains('fight')) {
      return 'Friction in relationships is normal. I suggest finding a quiet time to sit down and communicate openly, expressing your feelings rather than blaming each other. Remember, it\'s both of you facing the problem together, not opposing each other.';
    } else if (message.toLowerCase().contains('anniversary') ||
        message.toLowerCase().contains('surprise') ||
        message.toLowerCase().contains('gift')) {
      return 'Preparing a surprise for your anniversary is very thoughtful! You might consider revisiting your first date, or preparing meaningful small gifts. The most important thing is expressing your sincerity and thoughtfulness.';
    } else if (message.toLowerCase().contains('proposal') ||
        message.toLowerCase().contains('propose')) {
      return 'A proposal is an important moment in life! Consider your partner\'s personality and preferences - some people like romantic public proposals, while others prefer private settings. The most important thing is sincerity and careful preparation.';
    } else if (message.toLowerCase().contains('breakup') ||
        message.toLowerCase().contains('reconcile')) {
      return 'Separation in relationships is always painful. Before considering reconciliation, think about whether the reasons for the breakup can be resolved, and whether you truly are right for each other. Sometimes, giving each other space and time is necessary.';
    } else {
      return 'Thank you for sharing! I understand how you feel. Each relationship has its unique challenges and beauty, and sincere communication and mutual understanding are key. Do you have any specific questions you\'d like to discuss?';
    }
  }

  /// 生成求婚方案
  Future<String> generateProposalPlan(String prompt) async {
    try {
      // 构建系统提示
      const String systemPrompt = '''
You are a professional wedding and proposal planner with years of experience. 
Your task is to create detailed, creative, and personalized marriage proposal plans.
Provide specific, actionable advice tailored to the user's preferences.
Structure your response clearly with sections for title, description, steps, materials needed, location, timing, and budget.
Be creative, thoughtful, and consider the emotional significance of this important life event.
Always respond in English only.
''';

      // 构建消息
      final List<Map<String, dynamic>> messages = [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": prompt},
      ];

      // 构建请求体
      final Map<String, dynamic> requestBody = {
        "model": "deepseek-chat",
        "messages": messages,
        "temperature": 0.7,
        "max_tokens": 1200,
      };

      // 发送请求
      final response = await http.post(
        Uri.parse(_proposalApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      );

      // 检查响应状态
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print('生成求婚方案API错误: ${response.statusCode} - ${response.body}');
        return _getDefaultProposalResponse(prompt);
      }
    } catch (e) {
      print('生成求婚方案错误: $e');
      return _getDefaultProposalResponse(prompt);
    }
  }

  /// 获取默认求婚方案响应（当API请求失败时）
  String _getDefaultProposalResponse(String prompt) {
    // 提取方案类型
    String type = 'romantic';
    if (prompt.toLowerCase().contains('intimate')) {
      type = 'intimate';
    } else if (prompt.toLowerCase().contains('adventurous')) {
      type = 'adventurous';
    } else if (prompt.toLowerCase().contains('elaborate')) {
      type = 'elaborate';
    } else if (prompt.toLowerCase().contains('creative')) {
      type = 'creative';
    }

    // 根据类型返回默认方案
    switch (type) {
      case 'intimate':
        return '''
# Intimate Candlelit Home Proposal

## Description
Create a deeply personal and intimate proposal in the comfort of your own home, transformed into a romantic haven with soft lighting, meaningful mementos, and heartfelt moments.

## Steps
1. Decorate your home with fairy lights, candles, and photos of your journey together
2. Prepare a homemade dinner with your partner's favorite dishes
3. Create a timeline of your relationship with photos and mementos
4. Write a heartfelt letter expressing your feelings and journey together
5. Play "your song" as you get down on one knee and propose
6. Have champagne ready to celebrate after they say yes

## Materials Needed
- Engagement ring
- Candles (lots of them!)
- Fairy lights
- Photo frames or a digital slideshow
- Ingredients for a special dinner
- Champagne and glasses
- Bluetooth speaker for music
- Flowers (their favorite kind)

## Location
Your home, specifically the living room or another meaningful space where you can create an intimate atmosphere

## Timing
Evening, after dinner when the candles and lights create the perfect ambiance

## Budget
\$500-\$1,500 (excluding the ring) depending on decoration choices and dinner ingredients
''';

      case 'adventurous':
        return '''
# Sunrise Mountain Peak Proposal

## Description
An exhilarating proposal that combines adventure, breathtaking views, and the symbolism of a new beginning with the sunrise, perfect for couples who love the outdoors and meaningful experiences.

## Steps
1. Plan a hiking trip to a scenic mountain viewpoint, telling your partner it's just a regular adventure
2. Start hiking before dawn to reach the summit for sunrise
3. Pack a thermos of hot chocolate or coffee and some breakfast treats
4. Arrive at the viewpoint and set up a small picnic blanket
5. As the sun begins to rise, share your feelings about your journey together
6. Get down on one knee as the first rays of sunlight appear
7. Capture the moment with pre-set camera or ask a fellow hiker to help photograph

## Materials Needed
- Engagement ring (secured in a safe pocket or container)
- Hiking gear appropriate for the trail
- Thermos with hot drinks
- Small picnic with breakfast treats
- Camera or phone with tripod
- Small blanket to sit on
- Headlamps for the early morning hike

## Location
A scenic mountain peak or viewpoint accessible by hiking, ideally facing east for the sunrise

## Timing
Early morning, timed to reach the summit 15-20 minutes before sunrise

## Budget
\$200-\$500 (excluding the ring) for hiking gear, special breakfast items, and transportation
''';

      case 'elaborate':
        return '''
# Grand Orchestrated Flash Mob Proposal

## Description
A spectacular public proposal featuring a choreographed flash mob performance, creating an unforgettable moment that celebrates your love story in a grand, cinematic way.

## Steps
1. Hire a professional flash mob company or organize friends and family to learn a choreographed dance
2. Choose a song that has special meaning to your relationship
3. Select a public location that has significance to your relationship
4. Coordinate with a videographer to capture multiple angles of the event
5. Have friends position themselves as "regular people" in the area
6. Create a reason to bring your partner to the location at the specific time
7. Signal the flash mob to begin their performance
8. Join in the dance at a predetermined moment
9. Have the dancers form an aisle for you to walk down
10. Deliver your proposal speech and get down on one knee

## Materials Needed
- Engagement ring
- Professional dancers or willing friends/family
- Sound system or portable speakers
- Videographer and photographer
- Microphone (optional)
- Champagne for celebration
- Flowers or other props for dancers
- Coordinated outfits for participants

## Location
A significant public space like the place you first met, a favorite park, plaza, or landmark with good acoustics and space for dancing

## Timing
Weekend afternoon when the location has good foot traffic but isn't too crowded

## Budget
\$2,000-\$5,000 (excluding the ring) depending on professional services hired and number of participants
''';

      case 'creative':
        return '''
# Personalized Treasure Hunt Proposal

## Description
An interactive and personalized adventure that takes your partner on a journey through significant moments in your relationship, building anticipation and ending with a heartfelt proposal.

## Steps
1. Create 5-7 clues that lead to meaningful locations in your relationship (where you met, first date, etc.)
2. At each location, hide a clue and a small gift or memento
3. Start the treasure hunt with breakfast in bed and the first clue
4. Coordinate with friends or family to be "clue keepers" at some locations
5. Have the final clue lead to a beautifully decorated setting where you'll be waiting
6. Create a small photo album or digital presentation of your relationship to share
7. When they arrive, share your prepared speech and propose

## Materials Needed
- Engagement ring
- Clues (written on nice paper, possibly in envelopes)
- Small gifts for each location
- Photo album or digital presentation of your relationship
- Decorations for the final location (flowers, candles, etc.)
- Champagne and glasses
- Camera to document their journey (or ask friends to take photos at each stop)

## Location
Multiple locations significant to your relationship, with a special final destination (could be a restSolint, scenic spot, or decorated home)

## Timing
Start in the morning to allow enough time for the entire hunt without rushing, ending around sunset for the proposal

## Budget
\$500-\$1,500 (excluding the ring) depending on the gifts, decorations, and final location
''';

      default: // Romantic
        return '''
# Enchanted Garden Twilight Proposal

## Description
A magical evening proposal set in a beautifully decorated garden space, featuring thousands of twinkling lights, floral arrangements, and personalized touches that create a fairytale atmosphere.

## Steps
1. Select a garden location that can be privately reserved or a section of a public garden that can be temporarily decorated
2. Decorate the space with string lights, lanterns, and candles to create a magical atmosphere
3. Arrange for a string quartet or acoustic musician to play your special song
4. Create a pathway lined with rose petals and photos of your journey together
5. Set up a small table with champagne and dessert for after the proposal
6. Have a photographer hidden nearby to capture the moment
7. Walk your partner through the garden, reminiscing about your relationship
8. Lead them to the center of the decorated area for the proposal

## Materials Needed
- Engagement ring
- String lights and/or fairy lights (hundreds!)
- Rose petals
- Candles in hurricane glasses (for outdoor safety)
- Framed photos of your relationship
- Champagne and dessert
- Bluetooth speaker or live musicians
- Flowers and greenery for additional decoration

## Location
A botanical garden, private garden, rooftop garden, or a beautifully landscaped area that can be decorated

## Timing
Just before sunset, so the proposal happens during the "golden hour" and continues as the lights become more visible in the twilight

## Budget
\$1,000-\$3,000 (excluding the ring) depending on location rental, decorations, and whether you hire musicians
''';
    }
  }
}
