import 'package:soli/data/models/community_post_model.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:soli/data/models/proposal_plan_model.dart';
import 'package:soli/data/models/user_model.dart';

/// 模拟数据源
class MockData {
  // 用户数据
  static final UserModel currentUser = UserModel(
    id: 'user1',
    name: '张小明',
    avatarUrl: null,
    memoryCount: 147,
    albumCount: 28,
    proposalCount: 3,
  );

  // 回忆数据
  static final List<MemoryModel> memories = [
    MemoryModel(
      id: 'mem1',
      title: '巴厘岛之旅',
      imageUrl:
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      date: DateTime(2023, 6, 12),
      tags: ['旅行', '海滩'],
      description: '在巴厘岛度过的美好时光',
    ),
    MemoryModel(
      id: 'mem2',
      title: '周年纪念',
      imageUrl:
          'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      date: DateTime(2023, 3, 24),
      tags: ['纪念日', '浪漫'],
      description: '我们的一周年纪念日',
    ),
    MemoryModel(
      id: 'mem3',
      title: '浪漫晚餐',
      imageUrl:
          'https://images.unsplash.com/photo-1529254479751-fbacb4c3b6e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      date: DateTime(2023, 5, 18),
      tags: ['美食', '浪漫'],
      description: '在高级餐厅享用的浪漫晚餐',
    ),
    MemoryModel(
      id: 'mem4',
      title: '周末徒步',
      imageUrl:
          'https://images.unsplash.com/photo-1542037104857-ffbb0b9155fb?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      date: DateTime(2023, 7, 8),
      tags: ['旅行', '户外'],
      description: '周末徒步旅行的美好时光',
    ),
    MemoryModel(
      id: 'mem5',
      title: '生日惊喜',
      imageUrl:
          'https://images.unsplash.com/photo-1519415711931-702deacf5be2?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      date: DateTime(2023, 4, 15),
      tags: ['纪念日', '惊喜'],
      description: '为她准备的生日惊喜派对',
    ),
  ];

  // 社区帖子
  static final List<CommunityPostModel> communityPosts = [
    CommunityPostModel(
      id: 'post1',
      author: 'L',
      title: '如何平衡工作与感情？',
      content: '和伴侣工作时间完全不同，感觉越来越疏远，大家有什么建议吗？',
      replyCount: 128,
      likeCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      tags: ['婚姻智慧'],
    ),
    CommunityPostModel(
      id: 'post2',
      author: 'M',
      title: '惊喜约会创意分享',
      content: '收集了一些超棒的约会创意，让平凡的日子也变得特别！',
      replyCount: 76,
      likeCount: 62,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['恋爱瞬间'],
    ),
  ];

  // 求婚方案
  static final List<ProposalPlanModel> proposalPlans = [
    ProposalPlanModel(
      id: 'plan1',
      title: '浪漫餐厅求婚',
      type: '餐厅',
      description: '在高级餐厅的私密环境中，用戒指和鲜花给她一个惊喜。',
      steps: ['预订高级餐厅的私人包间', '安排鲜花和香槟', '准备求婚戒指和告白词', '安排摄影师记录瞬间'],
      materials: ['戒指', '鲜花', '香槟', '蜡烛'],
      location: '高级餐厅的私人包间',
      timing: '晚餐时间',
      budget: '¥5000-¥10000',
      createdAt: DateTime.now(),
    ),
    ProposalPlanModel(
      id: 'plan2',
      title: '自然风光求婚',
      type: '户外',
      description: '在山顶、海边或星空下，让大自然见证你们的爱情。',
      steps: ['选择一个风景优美的地点', '准备野餐和香槟', '在日落时分求婚', '准备烛光和鲜花'],
      materials: ['戒指', '野餐篮', '香槟', '蜡烛', '便携音箱'],
      location: '山顶或海边风景区',
      timing: '日落时分',
      budget: '¥3000-¥8000',
      createdAt: DateTime.now(),
    ),
    ProposalPlanModel(
      id: 'plan3',
      title: '家庭温馨求婚',
      type: '家庭',
      description: '在家中精心布置，创造温馨而难忘的求婚时刻。',
      steps: ['用蜡烛和鲜花装饰家里', '准备浪漫晚餐', '播放你们喜欢的音乐', '在甜点后求婚'],
      materials: ['戒指', '蜡烛', '鲜花', '食材', '装饰品'],
      location: '温馨的家',
      timing: '晚餐后',
      budget: '¥2000-¥5000',
      createdAt: DateTime.now(),
    ),
  ];

  // AI聊天消息
  static final List<Map<String, dynamic>> chatMessages = [
    {'isAi': true, 'content': '你好，我是Soli的情感助手。今天有什么想分享的吗？无论是快乐还是烦恼，我都在这里倾听。'},
    {'isAi': false, 'content': '最近和伴侣有些小摩擦，不知道该如何处理...'},
    {
      'isAi': true,
      'content': '感谢你愿意分享。关系中出现摩擦是正常的，重要的是如何沟通解决。可以告诉我更多细节吗？我会尽力提供一些建议。',
    },
  ];

  // 用户最近活动
  static final List<Map<String, dynamic>> recentActivities = [
    {'type': 'memory', 'title': '添加了新回忆', 'time': '2小时前', 'icon': 'add'},
    {'type': 'like', 'title': '点赞了社区帖子', 'time': '昨天', 'icon': 'favorite'},
    {'type': 'proposal', 'title': '创建了求婚方案', 'time': '3天前', 'icon': 'diamond'},
  ];
}
