import 'dart:math';
import 'package:soli/data/models/hot_topic_model.dart';

/// 热门话题数据源
class HotTopicsData {
  // 话题分类
  static const String categoryRelationship = 'Dating';
  static const String categoryMarriage = 'Marriage';
  static const String categoryConflict = 'Conflict';
  static const String categoryEmotion = 'Communication';
  static const String categoryGrowth = 'Growth';

  // 所有热门话题
  static final List<HotTopicModel> allTopics = [
    // Dating topics
    HotTopicModel(
      id: 'topic_1',
      title: 'How to keep long-term relationships fresh?',
      description:
          'Discussing methods and techniques to maintain passion and freshness in long-term relationships.',
      category: categoryRelationship,
      popularity: 128,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_2',
      title: 'How to maintain a long-distance relationship?',
      description:
          'Sharing experiences on how couples can maintain intimacy despite distance.',
      category: categoryRelationship,
      popularity: 156,
      isNew: true,
    ),
    HotTopicModel(
      id: 'topic_3',
      title: 'Setting boundaries in relationships',
      description:
          'Exploring how to maintain healthy personal boundaries and space in intimate relationships.',
      category: categoryRelationship,
      popularity: 98,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_4',
      title: 'First date topics and taboos',
      description:
          'Discussing what to talk about on a first date and which topics to avoid.',
      category: categoryRelationship,
      popularity: 142,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_5',
      title: 'How to know if someone is the right partner?',
      description:
          'Sharing standards and methods for determining if a relationship is worth developing long-term.',
      category: categoryRelationship,
      popularity: 187,
      isNew: false,
    ),

    // Marriage topics
    HotTopicModel(
      id: 'topic_6',
      title: 'Balancing marriage and family of origin',
      description:
          'Discussing how to handle relationships with both sets of parents after marriage.',
      category: categoryMarriage,
      popularity: 201,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_7',
      title: 'Financial planning in marriage',
      description:
          'Discussing methods for financial planning, allocation, and management between spouses.',
      category: categoryMarriage,
      popularity: 176,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_8',
      title: 'Maintaining passion in marriage',
      description:
          'Sharing methods and experiences for keeping love vibrant in long-term marriages.',
      category: categoryMarriage,
      popularity: 158,
      isNew: true,
    ),
    HotTopicModel(
      id: 'topic_9',
      title: 'Role division in married life',
      description:
          'Exploring topics such as household chore division and responsibility sharing in modern marriages.',
      category: categoryMarriage,
      popularity: 132,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_10',
      title: 'Personal growth within marriage',
      description:
          'Discussing how to maintain self-identity and continue personal growth in a marital relationship.',
      category: categoryMarriage,
      popularity: 145,
      isNew: false,
    ),

    // Conflict topics
    HotTopicModel(
      id: 'topic_11',
      title: 'How to reconcile after an argument?',
      description:
          'Sharing methods for couples to reconcile and restore their relationship after a fight.',
      category: categoryConflict,
      popularity: 213,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_12',
      title: 'Handling disagreements between partners',
      description:
          'Exploring techniques for reaching consensus when disagreements arise in major decisions.',
      category: categoryConflict,
      popularity: 167,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_13',
      title: 'Effective methods for handling relationship crises',
      description:
          'Discussing rescue and repair strategies when a relationship faces serious problems.',
      category: categoryConflict,
      popularity: 198,
      isNew: true,
    ),
    HotTopicModel(
      id: 'topic_14',
      title: 'How to avoid repeating the same mistakes?',
      description:
          'Exploring how to learn from past relationship issues and avoid similar conflicts.',
      category: categoryConflict,
      popularity: 124,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_15',
      title: 'Dealing with third-party interference',
      description:
          'Discussing methods and mindset adjustments when relationships face external interference.',
      category: categoryConflict,
      popularity: 231,
      isNew: false,
    ),

    // Communication topics
    HotTopicModel(
      id: 'topic_16',
      title: 'How to express love effectively?',
      description:
          'Sharing different ways and languages of expressing love to enhance emotional connection.',
      category: categoryEmotion,
      popularity: 178,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_17',
      title: 'Improving communication quality in intimate relationships',
      description:
          'Exploring how to engage in effective, deep communication in intimate relationships.',
      category: categoryEmotion,
      popularity: 165,
      isNew: true,
    ),
    HotTopicModel(
      id: 'topic_18',
      title: 'Understanding and meeting your partner\'s emotional needs',
      description:
          'Discussing methods and techniques for identifying and meeting a partner\'s emotional needs.',
      category: categoryEmotion,
      popularity: 189,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_19',
      title: 'Supporting a partner through emotional lows',
      description:
          'Sharing experiences on how to support and accompany a partner through emotional valleys.',
      category: categoryEmotion,
      popularity: 143,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_20',
      title: 'How to express dissatisfaction and needs?',
      description:
          'Exploring techniques for expressing negative emotions without damaging the relationship.',
      category: categoryEmotion,
      popularity: 156,
      isNew: false,
    ),

    // Growth topics
    HotTopicModel(
      id: 'topic_21',
      title: 'Setting and achieving couple goals',
      description:
          'Sharing methods for how partners can set common goals and work together to achieve them.',
      category: categoryGrowth,
      popularity: 134,
      isNew: true,
    ),
    HotTopicModel(
      id: 'topic_22',
      title: 'The importance of shared interests',
      description:
          'Exploring how common hobbies can enhance relationship quality and intimacy.',
      category: categoryGrowth,
      popularity: 121,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_23',
      title: 'Supporting your partner\'s career and dreams',
      description:
          'Discussing ways to support a partner\'s personal development without sacrificing the relationship.',
      category: categoryGrowth,
      popularity: 167,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_24',
      title: 'Core values for long-term relationships',
      description:
          'Exploring shared values and concepts needed to maintain a lasting relationship.',
      category: categoryGrowth,
      popularity: 189,
      isNew: false,
    ),
    HotTopicModel(
      id: 'topic_25',
      title: 'Facing life\'s challenges together',
      description:
          'Sharing experiences and methods for couples to jointly tackle life\'s difficulties and challenges.',
      category: categoryGrowth,
      popularity: 154,
      isNew: true,
    ),
  ];

  /// 获取随机热门话题
  static List<HotTopicModel> getRandomTopics({int count = 6}) {
    if (count >= allTopics.length) {
      return List.from(allTopics);
    }

    final random = Random();
    final List<HotTopicModel> result = [];
    final List<int> indices = List.generate(allTopics.length, (i) => i);

    // 随机打乱顺序
    indices.shuffle(random);

    // 取前count个
    for (int i = 0; i < count; i++) {
      result.add(allTopics[indices[i]]);
    }

    return result;
  }

  /// 按分类获取话题
  static List<HotTopicModel> getTopicsByCategory(String category) {
    return allTopics.where((topic) => topic.category == category).toList();
  }

  /// 获取热门话题（按人气排序）
  static List<HotTopicModel> getPopularTopics({int count = 10}) {
    final sortedTopics = List<HotTopicModel>.from(allTopics)
      ..sort((a, b) => b.popularity.compareTo(a.popularity));

    return sortedTopics.take(count).toList();
  }

  /// 获取最新话题
  static List<HotTopicModel> getNewTopics() {
    return allTopics.where((topic) => topic.isNew).toList();
  }
}
