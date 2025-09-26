import 'package:soli/data/datasources/storage_service.dart';
import 'package:soli/data/models/shared_memory_model.dart';

/// 网友分享的幸福时刻数据
class SharedMemoriesData {
  static final StorageService _storageService = StorageService();

  // 预设的网友分享数据
  static final List<SharedMemoryModel> _defaultSharedMemories = [
    SharedMemoryModel(
      id: 'shared1',
      imageAsset: 'assets/WechatIMG546.jpg',
      title: 'Sunset by the Sea',
      content:
          'On this tranquil evening, we held hands and watched the sun slowly sink into the horizon. In that moment, time seemed to stand still. The sea breeze gently caressed our faces, and we could hear each other\'s heartbeats clearly. This was our fifth anniversary, and it remains one of my most precious memories.',
      author: 'EveningBreeze',
      likeCount: 328,
    ),
    SharedMemoryModel(
      id: 'shared2',
      imageAsset: 'assets/WechatIMG547.jpg',
      title: 'Rainbow After Rain',
      content:
          'We were trapped in a coffee shop during a heavy downpour. When the rain stopped, we stepped outside and saw this magnificent rainbow stretching across the sky. You said it was a gift from heaven, but I believe that sharing this beautiful sight with you was the real gift.',
      author: 'CloudWalker',
      likeCount: 256,
    ),
    SharedMemoryModel(
      id: 'shared3',
      imageAsset: 'assets/WechatIMG548.jpg',
      title: 'Promise Under the Stars',
      content:
          'Under this brilliant starry sky, we made a promise to spend our lives together. Far from the city\'s noise, it was just the two of us and the countless stars above. At that moment, I understood what true romance is—not fancy words, but companionship and a sincere heart.',
      author: 'StarGazer',
      likeCount: 412,
    ),
    SharedMemoryModel(
      id: 'shared4',
      imageAsset: 'assets/WechatIMG549.jpg',
      title: 'Smile in the Flower Field',
      content:
          'The spring flower field is our favorite place, with colorful blooms complementing your radiant smile. That day, you ran through the flowers, turning back to smile at me. The sunlight fell on your face, and I wanted to treasure that beautiful moment forever in my heart.',
      author: 'FlowerWhisper',
      likeCount: 378,
    ),
    SharedMemoryModel(
      id: 'shared5',
      imageAsset: 'assets/WechatIMG550.jpg',
      title: 'First Snow Surprise',
      content:
          'It was our first winter together, and the season\'s first snow began to fall outside our window. You grabbed my hand and excitedly ran outside like a child, leaving our footprints in the snow. You said you hoped our love would be as pure as the first snow, and as enduring as the accumulated snow over time.',
      author: 'SnowWalker',
      likeCount: 289,
    ),
    SharedMemoryModel(
      id: 'shared6',
      imageAsset: 'assets/WechatIMG551.jpg',
      title: 'Ancient Town Moments',
      content:
          'In this ancient town, time seemed to slow down. We strolled along the cobblestone paths, listening to distant melodies. You said you hoped our love would be like this old town—weathering the years while maintaining its original charm.',
      author: 'TimelessJoy',
      likeCount: 342,
    ),
    SharedMemoryModel(
      id: 'shared7',
      imageAsset: 'assets/WechatIMG552.jpg',
      title: 'Sunrise at the Peak',
      content:
          'We began climbing at 3 AM, just to greet the sunrise at the summit. When the first ray of light broke through the clouds and illuminated the entire valley, you squeezed my hand and said, "No matter how difficult the future may be, we will face it with hope, just like this rising sun."',
      author: 'SunSeeker',
      likeCount: 405,
    ),
    // New shared memories
    SharedMemoryModel(
      id: 'shared8',
      imageAsset: 'assets/wy_18.jpg',
      title: 'Dance in the Rain',
      content:
          'Everyone was rushing for shelter when the summer shower began, but you grabbed my hand and pulled me into the rain. "Let\'s dance," you said with that mischievous smile I fell in love with. We twirled and laughed as the warm raindrops soaked us completely. Passersby thought we were crazy, but in that moment, we created a memory more precious than staying dry.',
      author: 'RainDancer',
      likeCount: 367,
    ),
    SharedMemoryModel(
      id: 'shared9',
      imageAsset: 'assets/wy_19.jpg',
      title: 'Candlelit Surprise',
      content:
          'I came home exhausted after the most difficult day at work, only to find our apartment transformed. You had created a path of candles leading to the balcony where a small table was set with my favorite meal. "You mentioned this morning that today would be tough," you said, "so I wanted to end it beautifully." It wasn\'t our anniversary or any special occasion—just your way of showing love in everyday moments.',
      author: 'GentleFlame',
      likeCount: 422,
    ),
    SharedMemoryModel(
      id: 'shared10',
      imageAsset: 'assets/wy_110.jpg',
      title: 'Letters Across Oceans',
      content:
          'During our year apart while you studied abroad, we wrote letters—real paper letters—despite having all the digital tools to communicate instantly. There was something magical about holding paper you had touched, seeing your handwriting change with your moods. When we finally reunited at the airport, you handed me one last letter. Inside was a photo of us and the words: "Distance taught us that love isn\'t measured in miles, but in heartbeats."',
      author: 'OceanWriter',
      likeCount: 389,
    ),
    SharedMemoryModel(
      id: 'shared11',
      imageAsset: 'assets/wy_111.jpg',
      title: 'Midnight Picnic',
      content:
          'It was 2 AM when you woke me up with a whisper: "I have a surprise." You led me to the rooftop of our building where you had set up a small picnic under the stars. We ate strawberries and chocolate while wrapped in blankets, talking about our dreams until the sky began to lighten. Years later, whenever I can\'t sleep, you still suggest midnight picnics—even if it\'s just on our living room floor.',
      author: 'NightSky',
      likeCount: 356,
    ),
    SharedMemoryModel(
      id: 'shared12',
      imageAsset: 'assets/wy_112.jpg',
      title: 'The Hidden Waterfall',
      content:
          'We got completely lost on our hiking trip, taking a wrong turn that wasn\'t on any map. Just as frustration was setting in, we heard the sound of rushing water. Following it led us to a secluded waterfall that seemed untouched by other visitors. We spent hours there, swimming in the clear pool and carving our initials on a nearby rock. Sometimes the best discoveries come from getting lost together.',
      author: 'WildExplorer',
      likeCount: 411,
    ),
    SharedMemoryModel(
      id: 'shared13',
      imageAsset: 'assets/wy_113.jpg',
      title: 'Lantern Festival Wishes',
      content:
          'We wrote our wishes on paper lanterns at the festival—a tradition we\'ve kept for five years now. As we watched our lantern rise into the night sky, joining hundreds of others like stars returning home, you whispered that you didn\'t need to write wishes anymore. "Everything I\'ve wished for is already here," you said, squeezing my hand. That night, I understood that true happiness isn\'t about wishing for more, but recognizing the magic we already have.',
      author: 'WishMaker',
      likeCount: 437,
    ),
  ];

  // 获取共享回忆列表，包含持久化的点赞状态和点赞数
  static Future<List<SharedMemoryModel>> getSharedMemories() async {
    // 获取保存的点赞状态和点赞数
    final likedMemories = await _storageService.getLikedMemories();
    final likeCounts = await _storageService.getLikeCounts();

    // 创建共享回忆的副本，并应用保存的点赞状态和点赞数
    final List<SharedMemoryModel> memories = _defaultSharedMemories.map((
      memory,
    ) {
      // 如果存在保存的点赞状态，则使用它，否则使用默认值
      final isLiked = likedMemories.containsKey(memory.id)
          ? likedMemories[memory.id]!
          : memory.isLiked;

      // 如果存在保存的点赞数，则使用它，否则使用默认值
      final likeCount = likeCounts.containsKey(memory.id)
          ? likeCounts[memory.id]!
          : memory.likeCount;

      return memory.copyWith(isLiked: isLiked, likeCount: likeCount);
    }).toList();

    return memories;
  }

  // 更新共享回忆的点赞状态和点赞数并保存
  static Future<void> updateLikeStatus(
    String memoryId,
    bool isLiked,
    int likeCount,
  ) async {
    await _storageService.updateMemoryLike(memoryId, isLiked, likeCount);
  }

  // 初始化默认点赞数据到存储
  static Future<void> initializeDefaultLikeCounts() async {
    final likeCounts = await _storageService.getLikeCounts();

    // 只有当没有保存的点赞数据时，才初始化默认值
    if (likeCounts.isEmpty) {
      final Map<String, int> defaultLikeCounts = {};

      // 将默认的点赞数保存到Map
      for (var memory in _defaultSharedMemories) {
        defaultLikeCounts[memory.id] = memory.likeCount;
      }

      // 保存默认点赞数
      await _storageService.saveLikeCounts(defaultLikeCounts);
    }
  }

  // 获取当前的共享回忆列表（不从存储加载）
  static List<SharedMemoryModel> get sharedMemories => _defaultSharedMemories;
}
