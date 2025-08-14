import '../models/mission.dart';
import '../models/milestone.dart';
import '../models/action_item.dart';
import '../models/pack_item.dart';
import 'dart:math';

/// AI服务，提供智能建议和生成功能
class AIService {
  // 单例模式
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Random _random = Random();

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        _random.nextInt(10000).toString();
  }

  /// 根据用户输入生成任务
  Future<Mission> generateMission(String input) async {
    // This is a simulated AI generation, in a real application you might call an external API

    // Determine task type based on input
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
  Mission _generateTravelMission(String input) {
    final id = _generateId();
    final now = DateTime.now();

    // Extract destination (simplified processing)
    String destination = 'Travel Destination';
    if (input.contains('去')) {
      final parts = input.split('去');
      if (parts.length > 1) {
        destination = parts[1].trim().split(' ')[0];
      }
    }

    // Create milestones
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

    // Create pack items
    final packItems = [
      PackItem(
        id: '${id}_p1',
        name: 'Passport',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
        icon: 'id-card',
      ),
      PackItem(
        id: '${id}_p2',
        name: 'Visa',
        category: PackCategory.documents,
        isPacked: false,
        quantity: 1,
        icon: 'file-lines',
      ),
      PackItem(
        id: '${id}_p3',
        name: 'Jacket',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 2,
        icon: 'shirt',
      ),
      PackItem(
        id: '${id}_p4',
        name: 'T-shirt',
        category: PackCategory.clothing,
        isPacked: false,
        quantity: 5,
        icon: 'shirt',
      ),
      PackItem(
        id: '${id}_p5',
        name: 'Phone Charger',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
        icon: 'plug',
      ),
      PackItem(
        id: '${id}_p6',
        name: 'Power Bank',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
        icon: 'battery-full',
      ),
      PackItem(
        id: '${id}_p7',
        name: 'Travel Adapter',
        category: PackCategory.electronics,
        isPacked: false,
        quantity: 1,
        icon: 'plug',
      ),
    ];

    // Create knowledge pods
    final knowledgePods = [
      KnowledgePod(
        id: '${id}_k1',
        title: '$destination Travel Guide',
        url: 'https://example.com/guide',
        description: 'Detailed travel guide for $destination',
      ),
      KnowledgePod(
        id: '${id}_k2',
        title: 'How to Pack Efficiently',
        url: 'https://example.com/packing',
        description: 'Travel packing tips',
      ),
    ];

    return Mission(
      id: id,
      title: 'Trip to $destination',
      description: 'Travel plan to $destination',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      milestones: milestones,
      packItems: packItems,
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

    // Create milestones
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

    // Create equipment items (based on learning subject)
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

    // Create knowledge pods
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
  String generateAIResponse(String userInput, Mission? currentMission) {
    // Simulate AI response
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
  List<String> generateQuickSuggestions(Mission? currentMission) {
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
