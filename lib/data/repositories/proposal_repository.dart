import 'package:soli/core/services/ai_service.dart';
import 'package:soli/data/datasources/storage_service.dart';
import 'package:soli/data/models/proposal_plan_model.dart';
import 'package:uuid/uuid.dart';

/// 求婚方案数据仓库
class ProposalRepository {
  final StorageService _storageService = StorageService();
  final AIService _aiService = AIService();
  final Uuid _uuid = const Uuid();

  // 获取所有求婚方案
  Future<List<ProposalPlanModel>> getAllProposalPlans() async {
    return await _storageService.getProposalPlans();
  }

  // 按类型筛选求婚方案
  Future<List<ProposalPlanModel>> getProposalPlansByType(String type) async {
    final plans = await _storageService.getProposalPlans();
    if (type.isEmpty) {
      return plans;
    } else {
      return plans.where((plan) => plan.type == type).toList();
    }
  }

  // 获取求婚方案详情
  Future<ProposalPlanModel?> getProposalPlanById(String id) async {
    final plans = await _storageService.getProposalPlans();
    try {
      return plans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }

  // 生成求婚方案
  Future<ProposalPlanModel> generateProposalPlan({
    required String type,
    required String preferences,
    String? partnerName,
    String? relationship,
    String? budget,
  }) async {
    try {
      // 构建提示词
      final prompt = _buildPrompt(
        type: type,
        preferences: preferences,
        partnerName: partnerName,
        relationship: relationship,
        budget: budget,
      );

      // 调用AI服务生成方案
      final response = await _aiService.generateProposalPlan(prompt);

      // 解析AI响应，创建方案模型
      final plan = _parseAIResponse(response, type);

      // 返回生成的方案，但不立即保存
      return plan;
    } catch (e) {
      // 生成失败时记录错误并重新抛出
      print('生成求婚方案错误: $e');
      throw Exception('Failed to generate proposal plan: $e');
    }
  }

  // 保存方案
  Future<void> saveProposalPlan(ProposalPlanModel plan) async {
    await _storageService.addProposalPlan(plan);
  }

  // 删除求婚方案
  Future<void> deleteProposalPlan(String id) async {
    final plans = await _storageService.getProposalPlans();
    final filteredPlans = plans.where((plan) => plan.id != id).toList();

    if (filteredPlans.length < plans.length) {
      await _storageService.saveProposalPlans(filteredPlans);
    }
  }

  // 构建AI提示词
  String _buildPrompt({
    required String type,
    required String preferences,
    String? partnerName,
    String? relationship,
    String? budget,
  }) {
    String prompt =
        'Generate a detailed marriage proposal plan with the following requirements:\n';

    prompt += 'Type: $type\n';
    prompt += 'Preferences: $preferences\n';

    if (partnerName != null && partnerName.isNotEmpty) {
      prompt += 'Partner name: $partnerName\n';
    }

    if (relationship != null && relationship.isNotEmpty) {
      prompt += 'Relationship details: $relationship\n';
    }

    if (budget != null && budget.isNotEmpty) {
      prompt += 'Budget: $budget\n';
    }

    prompt +=
        '\nPlease provide a structured plan with the following sections:\n';
    prompt += '1. A catchy title\n';
    prompt += '2. A brief description of the overall plan\n';
    prompt += '3. Step-by-step instructions (at least 5 steps)\n';
    prompt += '4. Materials needed\n';
    prompt += '5. Suggested location\n';
    prompt += '6. Ideal timing\n';
    prompt += '7. Budget estimate\n';

    return prompt;
  }

  // 解析AI响应
  ProposalPlanModel _parseAIResponse(String response, String type) {
    try {
      // 尝试从AI响应中提取信息
      String title = '';
      String description = '';
      List<String> steps = [];
      List<String> materials = [];
      String location = '';
      String timing = '';
      String budget = '';

      // 提取标题
      final titleRegex = RegExp(r'(?:Title:|#)(.*?)(?:\n|$)', dotAll: true);
      final titleMatch = titleRegex.firstMatch(response);
      if (titleMatch != null) {
        title = titleMatch.group(1)?.trim() ?? 'Romantic Proposal Plan';
      } else {
        title = 'Romantic Proposal Plan';
      }

      // 提取描述
      final descRegex = RegExp(
        r'(?:Description:|Overview:)(.*?)(?:\n\n|\n#|\n\d\.)',
        dotAll: true,
      );
      final descMatch = descRegex.firstMatch(response);
      if (descMatch != null) {
        description = descMatch.group(1)?.trim() ?? '';
      }

      // 提取步骤
      final stepsRegex = RegExp(
        r'(?:Steps:|Step-by-step instructions:|Instructions:)(.*?)(?:\n\n|\nMaterials|\n#)',
        dotAll: true,
      );
      final stepsMatch = stepsRegex.firstMatch(response);
      if (stepsMatch != null) {
        final stepsText = stepsMatch.group(1)?.trim() ?? '';
        final stepLines = stepsText
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();

        for (var line in stepLines) {
          // 移除数字前缀和点
          final cleanLine = line
              .replaceAll(RegExp(r'^\d+[\.\)]\s*'), '')
              .trim();
          if (cleanLine.isNotEmpty) {
            steps.add(cleanLine);
          }
        }
      }

      // 提取所需物品
      final materialsRegex = RegExp(
        r'(?:Materials:|Materials needed:|Items needed:)(.*?)(?:\n\n|\nLocation|\n#)',
        dotAll: true,
      );
      final materialsMatch = materialsRegex.firstMatch(response);
      if (materialsMatch != null) {
        final materialsText = materialsMatch.group(1)?.trim() ?? '';
        final materialLines = materialsText
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();

        for (var line in materialLines) {
          // 移除数字前缀、点和破折号
          final cleanLine = line
              .replaceAll(RegExp(r'^\d+[\.\)]\s*|-\s*'), '')
              .trim();
          if (cleanLine.isNotEmpty) {
            materials.add(cleanLine);
          }
        }
      }

      // 提取地点
      final locationRegex = RegExp(
        r'(?:Location:|Suggested location:|Venue:)(.*?)(?:\n\n|\nTiming|\n#)',
        dotAll: true,
      );
      final locationMatch = locationRegex.firstMatch(response);
      if (locationMatch != null) {
        location = locationMatch.group(1)?.trim() ?? '';
      }

      // 提取时间
      final timingRegex = RegExp(
        r'(?:Timing:|Ideal timing:|When:)(.*?)(?:\n\n|\nBudget|\n#)',
        dotAll: true,
      );
      final timingMatch = timingRegex.firstMatch(response);
      if (timingMatch != null) {
        timing = timingMatch.group(1)?.trim() ?? '';
      }

      // 提取预算
      final budgetRegex = RegExp(
        r'(?:Budget:|Budget estimate:|Cost:)(.*?)(?:\n\n|\n#|$)',
        dotAll: true,
      );
      final budgetMatch = budgetRegex.firstMatch(response);
      if (budgetMatch != null) {
        budget = budgetMatch.group(1)?.trim() ?? '';
      }

      // 创建并返回方案模型
      return ProposalPlanModel(
        id: _uuid.v4(),
        title: title,
        type: type,
        description: description,
        steps: steps.isEmpty
            ? [
                'Prepare the venue',
                'Buy a ring',
                'Write a speech',
                'Arrange for photography',
                'Pop the question',
              ]
            : steps,
        materials: materials.isEmpty
            ? ['Engagement ring', 'Flowers', 'Champagne', 'Decorations']
            : materials,
        location: location.isEmpty
            ? 'A meaningful place for both of you'
            : location,
        timing: timing.isEmpty ? 'Evening, around sunset' : timing,
        budget: budget.isEmpty
            ? 'Varies based on ring and venue selection'
            : budget,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('解析AI响应错误: $e');
      return _getDefaultProposalPlan(type);
    }
  }

  // 获取默认求婚方案（当生成失败时）
  ProposalPlanModel _getDefaultProposalPlan(String type) {
    final title = 'Romantic $type Proposal Plan';
    final description =
        'A beautiful $type proposal plan that will create a memorable moment for both of you.';

    List<String> steps = [];
    List<String> materials = [];
    String location = '';

    switch (type.toLowerCase()) {
      case 'romantic':
        steps = [
          'Decorate the venue with rose petals and candles',
          'Prepare a playlist of your favorite songs',
          'Arrange for a photographer to capture the moment',
          'Write a heartfelt speech about your journey together',
          'Get down on one knee and propose',
        ];
        materials = [
          'Engagement ring',
          'Rose petals',
          'Candles',
          'Bluetooth speaker',
          'Champagne',
        ];
        location = 'A rooftop restSolint with a city view';
        break;

      case 'adventurous':
        steps = [
          'Plan a hiking trip to a scenic viewpoint',
          'Pack a picnic with your favorite foods',
          'Hide the ring in a special container',
          'Take photos throughout the journey',
          'Propose at the summit with a view',
        ];
        materials = [
          'Engagement ring',
          'Hiking gear',
          'Picnic basket',
          'Camera',
          'Water bottles',
        ];
        location = 'A mountain peak or scenic natural landmark';
        break;

      case 'intimate':
        steps = [
          'Cook a special dinner at home',
          'Set up ambient lighting and soft music',
          'Prepare a photo album of your memories',
          'Write a personal letter expressing your feelings',
          'Propose in the comfort of your home',
        ];
        materials = [
          'Engagement ring',
          'Ingredients for dinner',
          'Candles',
          'Photo album',
          'Wine',
        ];
        location = 'Your home, decorated specially for the occasion';
        break;

      case 'elaborate':
        steps = [
          'Hire a flash mob to perform your partner\'s favorite song',
          'Coordinate with friends and family to be present',
          'Arrange for a videographer to capture everything',
          'Prepare a speech that tells your love story',
          'Propose in front of everyone',
        ];
        materials = [
          'Engagement ring',
          'Microphone',
          'Decorations',
          'Champagne for toast',
          'Flowers',
        ];
        location = 'A public place with significance to your relationship';
        break;

      default:
        steps = [
          'Choose a meaningful location',
          'Prepare the perfect words to say',
          'Have the ring ready in an accessible pocket',
          'Create the right mood with music or ambiance',
          'Get down on one knee and speak from the heart',
        ];
        materials = ['Engagement ring', 'Flowers', 'Camera', 'Champagne'];
        location = 'A place with special meaning to your relationship';
    }

    return ProposalPlanModel(
      id: _uuid.v4(),
      title: title,
      type: type,
      description: description,
      steps: steps,
      materials: materials,
      location: location,
      timing: 'Evening, preferably around sunset',
      budget: 'Varies based on ring selection and venue',
      createdAt: DateTime.now(),
    );
  }
}
