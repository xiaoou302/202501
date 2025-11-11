import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/pet_model.dart';
import '../models/reminder_model.dart';
import '../models/growth_track_model.dart';
import '../models/timeline_story_model.dart';

class MockDataService {
  static List<User> getSampleUsers() {
    return [
      User(
        id: 'user1',
        username: '@SunnyDaysWithPaws',
        displayName: 'Emma Wilson',
        avatarUrl: LocalAssets.avatars[0],
        bio:
            'Living my best life with my furry soulmate 🌟 Every day is an adventure when you have a best friend who never judges and always listens. We explore, we play, we grow together.',
        quote: 'Home is wherever my four-legged sunshine is.',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      User(
        id: 'user2',
        username: '@AdventureWithMyBuddy',
        displayName: 'Mike Johnson',
        avatarUrl: LocalAssets.avatars[1],
        bio:
            'Outdoor enthusiast and proud pet parent 🏔️ My buddy and I chase sunsets, climb mountains, and create memories that last forever. Life is too short to stay indoors!',
        quote: 'The best therapist has fur and four legs.',
        createdAt: DateTime.now().subtract(const Duration(days: 320)),
      ),
      User(
        id: 'user3',
        username: '@FluffyLifeStyle',
        displayName: 'Sophia Chen',
        avatarUrl: LocalAssets.avatars[2],
        bio:
            'Fashion meets furry love 💕 My little one teaches me about unconditional love every single day. We believe every moment deserves to be celebrated in style!',
        quote: 'Life is better when you\'re dressed up with your best friend.',
        createdAt: DateTime.now().subtract(const Duration(days: 280)),
      ),
      User(
        id: 'user4',
        username: '@SmallButMighty',
        displayName: 'David Lee',
        avatarUrl: LocalAssets.avatars[3],
        bio:
            'Documenting the daily joys of pet parenthood 📸 My little companion has the biggest heart and the brightest smile. Together, we prove that the best things come in small packages!',
        quote: 'Tiny paws, giant love, endless happiness.',
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
      ),
      User(
        id: 'user5',
        username: '@WaterBabyAndMe',
        displayName: 'Sarah Martinez',
        avatarUrl: LocalAssets.avatars[4],
        bio:
            'Beach lover and water enthusiast 🌊 My water-loving companion and I spend every weekend by the ocean. Swimming, playing, and soaking up the sun - that\'s our perfect day!',
        quote: 'Saltwater heals everything, especially with paws beside you.',
        createdAt: DateTime.now().subtract(const Duration(days: 220)),
      ),
      User(
        id: 'user6',
        username: '@CuriousNoseAdventures',
        displayName: 'James Anderson',
        avatarUrl: LocalAssets.avatars[5],
        bio:
            'Following my curious friend\'s nose to new discoveries 🐾 Every walk is an adventure, every smell tells a story. We explore the world one sniff at a time!',
        quote:
            'Not all who wander are lost, some are just following their nose.',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
      User(
        id: 'user7',
        username: '@SnuggleBugLife',
        displayName: 'Lisa Taylor',
        avatarUrl: LocalAssets.avatars[6],
        bio:
            'Professional cuddler and snuggle enthusiast 🤗 My wrinkly friend is the ultimate couch companion. We believe the best moments in life are spent snuggled up together!',
        quote: 'Happiness is a warm puppy on a lazy Sunday.',
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
      User(
        id: 'user8',
        username: '@LoyalCompanionLife',
        displayName: 'Robert Brown',
        avatarUrl: LocalAssets.avatars[7],
        bio:
            'Training, bonding, and growing together 🎓 My loyal friend is not just a pet, but a guardian, a teacher, and a family member. Every day we learn something new from each other.',
        quote: 'True loyalty has four paws and a wagging tail.',
        createdAt: DateTime.now().subtract(const Duration(days: 160)),
      ),
      User(
        id: 'user9',
        username: '@LongAndLovely',
        displayName: 'Emily White',
        avatarUrl: LocalAssets.avatars[8],
        bio:
            'Celebrating uniqueness and personality 🌈 My long-bodied friend has taught me that being different is beautiful. We embrace our quirks and live life to the fullest!',
        quote: 'Perfect is boring, unique is beautiful.',
        createdAt: DateTime.now().subtract(const Duration(days: 140)),
      ),
      User(
        id: 'user10',
        username: '@CloudOfJoy',
        displayName: 'Chris Garcia',
        avatarUrl: LocalAssets.avatars[9],
        bio:
            'Living with a fluffy ball of energy ☁️ My tiny cloud brings so much joy and laughter into my life. Small in size, unlimited in love and personality!',
        quote: 'Some angels have wings, mine has fur.',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      User(
        id: 'user11',
        username: '@PlayfulHeartbeat',
        displayName: 'Amanda Rodriguez',
        avatarUrl: LocalAssets.avatars[10],
        bio:
            'Energy, enthusiasm, and endless kisses 💋 My playful companion reminds me to live in the moment. We dance, we play, we celebrate life every single day!',
        quote: 'Life is too short not to play every day.',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
      User(
        id: 'user12',
        username: '@MightyHeart',
        displayName: 'Daniel Kim',
        avatarUrl: LocalAssets.avatars[11],
        bio:
            'Proving that size doesn\'t matter when it comes to love 💪 My tiny warrior has the courage of a lion. Together, we face the world with confidence and sass!',
        quote: 'The smallest package can hold the biggest love.',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      User(
        id: 'user13',
        username: '@IndependentSpirit',
        displayName: 'Jessica Park',
        avatarUrl: LocalAssets.avatars[12],
        bio:
            'Respecting independence while cherishing companionship 🦊 My independent friend has taught me about boundaries and mutual respect. We\'re partners, not just pet and owner.',
        quote: 'True friendship respects independence.',
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
      ),
      User(
        id: 'user14',
        username: '@SnortAndSmile',
        displayName: 'Kevin Thompson',
        avatarUrl: LocalAssets.avatars[13],
        bio:
            'Celebrating imperfections and silly moments 😄 My snorty friend makes me laugh every single day. Life is too serious - we choose giggles and snuggles!',
        quote: 'Perfect is overrated, quirky is adorable.',
        createdAt: DateTime.now().subtract(const Duration(days: 70)),
      ),
      User(
        id: 'user15',
        username: '@ElegantMoments',
        displayName: 'Rachel Green',
        avatarUrl: LocalAssets.avatars[14],
        bio:
            'Finding beauty in everyday moments ✨ My gentle companion moves through life with grace and elegance. We believe every day deserves to be lived beautifully.',
        quote: 'Elegance is when the inside is as beautiful as the outside.',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      User(
        id: 'user16',
        username: '@GentleGiantHeart',
        displayName: 'Mark Davis',
        avatarUrl: LocalAssets.avatars[15],
        bio:
            'Big size, bigger heart, biggest love 💖 My gentle giant proves that strength and tenderness can coexist. We\'re breaking stereotypes one cuddle at a time!',
        quote: 'The strongest hearts are the gentlest ones.',
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
      ),
      User(
        id: 'user17',
        username: '@SassyAndSweet',
        displayName: 'Nicole Miller',
        avatarUrl: LocalAssets.avatars[16],
        bio:
            'Tiny size, huge attitude, infinite love 👑 My sassy little one rules the house with charm and confidence. We believe in living life with style and spunk!',
        quote: 'Confidence is the best accessory.',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      User(
        id: 'user18',
        username: '@SmartCookie',
        displayName: 'Andrew Wilson',
        avatarUrl: LocalAssets.avatars[17],
        bio:
            'Training, learning, growing together 🧠 My brilliant companion amazes me every day with new tricks and understanding. Intelligence is the ultimate bond!',
        quote: 'A smart pet is a happy pet.',
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
      ),
      User(
        id: 'user19',
        username: '@ForeverSmiling',
        displayName: 'Olivia Martinez',
        avatarUrl: LocalAssets.avatars[18],
        bio:
            'Living with a permanent smile ☺️ My fluffy friend\'s smile is contagious. We spread joy wherever we go and believe happiness is meant to be shared!',
        quote: 'A smile is the prettiest thing you can wear.',
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
      ),
      User(
        id: 'user20',
        username: '@MajesticMoments',
        displayName: 'Brian Lee',
        avatarUrl: LocalAssets.avatars[19],
        bio:
            'Dignity, loyalty, and timeless companionship 🏯 My majestic friend carries himself with such grace. Together, we honor tradition while creating new memories.',
        quote: 'True nobility comes from within.',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      User(
        id: 'user21',
        username: '@RoyalCuddles',
        displayName: 'Jennifer Taylor',
        avatarUrl: LocalAssets.avatars[20],
        bio:
            'Living a life of gentle affection and royal treatment 👑 My sweet companion deserves nothing but the best. We believe in treating every day like a special occasion!',
        quote: 'Every pet deserves to be treated like royalty.',
        createdAt: DateTime.now().subtract(const Duration(days: 28)),
      ),
      User(
        id: 'user22',
        username: '@ActiveLifestyle',
        displayName: 'Tyler Anderson',
        avatarUrl: LocalAssets.avatars[21],
        bio:
            'High energy, high spirits, high on life! 🏃 My energetic partner keeps me moving and motivated. We believe the best way to live is to never stop exploring!',
        quote: 'Life is an adventure, let\'s run towards it!',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      User(
        id: 'user23',
        username: '@DapperDays',
        displayName: 'Megan Brown',
        avatarUrl: LocalAssets.avatars[22],
        bio:
            'Style, charm, and timeless elegance 🎩 My dapper friend always looks put-together. We believe presentation matters, but personality matters more!',
        quote: 'Class never goes out of style.',
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
      ),
      User(
        id: 'user24',
        username: '@BrightSpirit',
        displayName: 'Patrick White',
        avatarUrl: LocalAssets.avatars[23],
        bio:
            'Radiating positivity and pure joy ☀️ My bright-spirited friend lights up every room. We choose happiness, laughter, and optimism every single day!',
        quote: 'Be the light in someone\'s day.',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      User(
        id: 'user25',
        username: '@ElegantPower',
        displayName: 'Christina Garcia',
        avatarUrl: LocalAssets.avatars[24],
        bio:
            'Grace meets strength in perfect harmony ⚡ My elegant companion shows that you can be both powerful and graceful. We redefine what it means to be strong!',
        quote: 'True power is knowing when to be gentle.',
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      User(
        id: 'user26',
        username: '@SoftEarsAndHeart',
        displayName: 'Steven Rodriguez',
        avatarUrl: LocalAssets.avatars[25],
        bio:
            'Gentle souls and tender moments 💝 My soft-hearted friend reminds me to slow down and appreciate the little things. We find magic in quiet moments together.',
        quote: 'The gentlest touch leaves the deepest mark.',
        createdAt: DateTime.now().subtract(const Duration(days: 16)),
      ),
      User(
        id: 'user27',
        username: '@BeardedCharm',
        displayName: 'Laura Kim',
        avatarUrl: LocalAssets.avatars[26],
        bio:
            'Distinguished looks, playful personality 🧔 My bearded buddy combines sophistication with silliness. We prove you can be classy and fun at the same time!',
        quote: 'Style is knowing who you are and owning it.',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      User(
        id: 'user28',
        username: '@GentleGiantLove',
        displayName: 'Michael Park',
        avatarUrl: LocalAssets.avatars[27],
        bio:
            'Massive size, massive heart, massive love 🏔️ My towering friend is the gentlest soul I know. We show the world that big can be beautiful and tender!',
        quote: 'The biggest hearts come in the biggest packages.',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      User(
        id: 'user29',
        username: '@CottonBallJoy',
        displayName: 'Ashley Thompson',
        avatarUrl: LocalAssets.avatars[28],
        bio:
            'Fluffy, cheerful, and always happy! ☁️ My cotton ball companion is pure sunshine. We believe every day should start and end with a smile!',
        quote: 'Happiness is contagious, spread it everywhere.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      User(
        id: 'user30',
        username: '@MisunderstoodLove',
        displayName: 'Jason Green',
        avatarUrl: LocalAssets.avatars[29],
        bio:
            'Breaking stereotypes with love and patience 💪 My misunderstood friend is the sweetest soul. We\'re on a mission to show the world that love conquers prejudice!',
        quote: 'Don\'t judge a book by its cover, or a pet by its breed.',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      User(
        id: 'user31',
        username: '@MiniShepherdLife',
        displayName: 'Michelle Davis',
        avatarUrl: LocalAssets.avatars[30],
        bio:
            'Small size, big responsibilities, huge heart 🐑 My mini guardian takes their job seriously. We prove that dedication and love come in all sizes!',
        quote: 'Size doesn\'t define your ability to love and protect.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      User(
        id: 'user32',
        username: '@RescueHeroLove',
        displayName: 'Thomas Miller',
        avatarUrl: LocalAssets.avatars[31],
        bio:
            'Gentle giants and rescue heroes 🦸 My heroic friend has the kindest soul. We believe in helping others and spreading love wherever we go!',
        quote: 'Heroes don\'t always wear capes, sometimes they have paws.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  static List<Post> getSamplePosts() {
    final users = getSampleUsers();

    return [
      Post(
        id: 'post1',
        userId: users[0].id,
        content:
            'Morning sunshine with my golden baby! 🌅 Her smile is the first thing I see every morning, and it makes everything worth it. We conquered our training goals today!',
        imageUrls: [LocalAssets.pets[0]],
        tags: ['#DailyMoments', '#TrainingTips'],
        likes: 234,
        comments: 45,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Post(
        id: 'post2',
        userId: users[1].id,
        content:
            'My adventure buddy absolutely loves our mountain hikes! ❄️ Those sparkling eyes and boundless energy - we covered 10 miles today and created memories that will last forever.',
        imageUrls: [LocalAssets.pets[1]],
        tags: ['#AdventureTime', '#HappyMoments'],
        likes: 456,
        comments: 78,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Post(
        id: 'post3',
        userId: users[2].id,
        content:
            'Fresh from our spa day! ✨ My fluffy angel is looking absolutely fabulous. Taking care of that beautiful coat is a labor of love, and every moment is worth it!',
        imageUrls: [LocalAssets.pets[2]],
        tags: ['#PetCare', '#HappyMoments'],
        likes: 389,
        comments: 62,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Post(
        id: 'post4',
        userId: users[3].id,
        content:
            'My little guardian on duty! 😂 Those short legs don\'t stop this brave heart from protecting our home. Every day brings new reasons to smile!',
        imageUrls: [LocalAssets.pets[3]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 567,
        comments: 89,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      Post(
        id: 'post5',
        userId: users[4].id,
        content:
            'Beach day with my water baby! 🏖️ Watching my companion swim and play in the waves is pure joy. These are the moments that make life beautiful!',
        imageUrls: [LocalAssets.pets[4]],
        tags: ['#AdventureTime', '#HappyMoments'],
        likes: 445,
        comments: 71,
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      Post(
        id: 'post6',
        userId: users[5].id,
        content:
            'My curious explorer found the most amazing spot today! 🐾 That nose never stops working, and every walk is a new adventure. Life is beautiful through their eyes!',
        imageUrls: [LocalAssets.pets[5]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 312,
        comments: 54,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      Post(
        id: 'post7',
        userId: users[6].id,
        content:
            'Lazy Sunday with my snuggle bug! 💕 Those adorable wrinkles and gentle snorts - this is what happiness sounds like. Perfect day for cuddles!',
        imageUrls: [LocalAssets.pets[6]],
        tags: ['#DailyMoments', '#HappyMoments'],
        likes: 498,
        comments: 82,
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      ),
      Post(
        id: 'post8',
        userId: users[7].id,
        content:
            'Training session with my brilliant companion! 🎓 Their focus and dedication never cease to amaze me. We\'re learning and growing together every day!',
        imageUrls: [LocalAssets.pets[7]],
        tags: ['#TrainingTips', '#PetCareTips'],
        likes: 521,
        comments: 95,
        createdAt: DateTime.now().subtract(const Duration(hours: 16)),
      ),
      Post(
        id: 'post9',
        userId: users[8].id,
        content:
            'My unique little explorer on an adventure! 🌳 That special body shape doesn\'t slow down this fearless heart. We celebrate our differences every day!',
        imageUrls: [LocalAssets.pets[8]],
        tags: ['#AdventureTime', '#HappyMoments'],
        likes: 376,
        comments: 58,
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      Post(
        id: 'post10',
        userId: users[9].id,
        content:
            'My tiny cloud thinks they\'re a lion! 👑 That fluffy mane and big personality in such a small package. They rule our hearts and our home!',
        imageUrls: [LocalAssets.pets[9]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 423,
        comments: 67,
        createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      Post(
        id: 'post11',
        userId: users[10].id,
        content:
            'Zoomies in the backyard! 🎉 My energetic baby\'s enthusiasm is absolutely contagious. This is what pure joy looks like in motion!',
        imageUrls: [LocalAssets.pets[10]],
        tags: ['#FunnyMoments', '#DailyMoments'],
        likes: 389,
        comments: 61,
        createdAt: DateTime.now().subtract(const Duration(hours: 22)),
      ),
      Post(
        id: 'post12',
        userId: users[11].id,
        content:
            'My tiny warrior with a huge personality! 😎 Small in size but mighty in spirit. They\'re the boss of this house and everyone knows it!',
        imageUrls: [LocalAssets.pets[11]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 298,
        comments: 49,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Post(
        id: 'post13',
        userId: users[12].id,
        content:
            'That independent spirit shining through! 🦊 My free-spirited friend reminds me that respect goes both ways. We\'re partners in this beautiful journey!',
        imageUrls: [LocalAssets.pets[12]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 612,
        comments: 103,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      Post(
        id: 'post14',
        userId: users[13].id,
        content:
            'My snorty angel making me laugh again! 😄 Those adorable sounds and that precious face - life is too short not to giggle every day!',
        imageUrls: [LocalAssets.pets[13]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 478,
        comments: 76,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      ),
      Post(
        id: 'post15',
        userId: users[14].id,
        content:
            'After our pampering session! ✨ My elegant companion moves through life with such grace. Every moment together feels like a beautiful dance!',
        imageUrls: [LocalAssets.pets[14]],
        tags: ['#PetCare', '#HappyMoments'],
        likes: 356,
        comments: 52,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      ),
      Post(
        id: 'post16',
        userId: users[15].id,
        content:
            'My gentle giant showing that big can be beautiful! 💖 The softest heart in the strongest body. We\'re proving stereotypes wrong every day!',
        imageUrls: [LocalAssets.pets[15]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 534,
        comments: 91,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      ),
      Post(
        id: 'post17',
        userId: users[16].id,
        content:
            'My sassy little ruler! 💁‍♀️ Tiny but fierce, sweet but spunky. This household runs on their schedule and we wouldn\'t have it any other way!',
        imageUrls: [LocalAssets.pets[16]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 401,
        comments: 64,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      ),
      Post(
        id: 'post18',
        userId: users[17].id,
        content:
            'Learned three new tricks today! 🧠 My brilliant baby\'s intelligence never stops amazing me. Every day is a new opportunity to grow together!',
        imageUrls: [LocalAssets.pets[17]],
        tags: ['#TrainingTips', '#PetCareTips'],
        likes: 489,
        comments: 79,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
      ),
      Post(
        id: 'post19',
        userId: users[18].id,
        content:
            'That permanent smile brightens every moment! ☁️ My fluffy angel spreads joy wherever we go. Happiness looks good on everyone!',
        imageUrls: [LocalAssets.pets[18]],
        tags: ['#HappyMoments', '#DailyMoments'],
        likes: 678,
        comments: 112,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
      ),
      Post(
        id: 'post20',
        userId: users[19].id,
        content:
            'My majestic companion carrying themselves with such dignity! 🏯 Grace, loyalty, and timeless love - that\'s what we\'re all about!',
        imageUrls: [LocalAssets.pets[19]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 445,
        comments: 73,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 16)),
      ),
      Post(
        id: 'post21',
        userId: users[20].id,
        content:
            'Royal treatment for my royal baby! 👑 The most affectionate soul I\'ve ever known. Every day feels like a fairy tale with them!',
        imageUrls: [LocalAssets.pets[20]],
        tags: ['#PetCare', '#HappyMoments'],
        likes: 412,
        comments: 68,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 18)),
      ),
      Post(
        id: 'post22',
        userId: users[21].id,
        content:
            'Agility training success! 🏃 My energetic partner aced every obstacle today. We work hard, play harder, and love the hardest!',
        imageUrls: [LocalAssets.pets[21]],
        tags: ['#TrainingTips', '#AdventureTime'],
        likes: 523,
        comments: 87,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
      ),
      Post(
        id: 'post23',
        userId: users[22].id,
        content:
            'My dapper friend looking absolutely charming! 🎩 Style and personality in perfect harmony. We believe in making every day special!',
        imageUrls: [LocalAssets.pets[22]],
        tags: ['#DailyMoments', '#HappyMoments'],
        likes: 367,
        comments: 56,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
      ),
      Post(
        id: 'post24',
        userId: users[23].id,
        content:
            'My bright spirit lighting up the day! 🌟 That spunky personality and positive energy - we choose joy and laughter every single time!',
        imageUrls: [LocalAssets.pets[23]],
        tags: ['#HappyMoments', '#DailyMoments'],
        likes: 334,
        comments: 51,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Post(
        id: 'post25',
        userId: users[24].id,
        content:
            'Grace and power in perfect balance! 💪 My elegant warrior shows that you can be both strong and gentle. We redefine strength every day!',
        imageUrls: [LocalAssets.pets[24]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 498,
        comments: 81,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      ),
      Post(
        id: 'post26',
        userId: users[25].id,
        content:
            'Quiet moments with my gentle soul! 💝 Those soft eyes remind me to slow down and appreciate life\'s simple pleasures. Magic happens in stillness!',
        imageUrls: [LocalAssets.pets[25]],
        tags: ['#DailyMoments', '#HappyMoments'],
        likes: 423,
        comments: 69,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      ),
      Post(
        id: 'post27',
        userId: users[26].id,
        content:
            'My bearded buddy being both classy and silly! 🧔 That distinguished look with a playful heart - we prove you can have it all!',
        imageUrls: [LocalAssets.pets[26]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 389,
        comments: 62,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
      ),
      Post(
        id: 'post28',
        userId: users[27].id,
        content:
            'My towering gentle giant! 💕 Huge in size, even huger in heart. They think they\'re a lap companion and honestly, we let them believe it!',
        imageUrls: [LocalAssets.pets[27]],
        tags: ['#FunnyMoments', '#HappyMoments'],
        likes: 612,
        comments: 98,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      ),
      Post(
        id: 'post29',
        userId: users[28].id,
        content:
            'My cotton ball of pure happiness! ☁️ That cheerful spirit is absolutely contagious. We spread smiles wherever we go!',
        imageUrls: [LocalAssets.pets[28]],
        tags: ['#HappyMoments', '#DailyMoments'],
        likes: 445,
        comments: 72,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      ),
      Post(
        id: 'post30',
        userId: users[29].id,
        content:
            'Breaking hearts and stereotypes! ❤️ My misunderstood sweetheart is the gentlest soul. Love always wins, and we\'re proof of that!',
        imageUrls: [LocalAssets.pets[29]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 589,
        comments: 105,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      ),
      Post(
        id: 'post31',
        userId: users[30].id,
        content:
            'My mini guardian taking their job seriously! 🐑 Small in size but huge in dedication. We prove that love and protection know no size limits!',
        imageUrls: [LocalAssets.pets[30]],
        tags: ['#TrainingTips', '#DailyMoments'],
        likes: 412,
        comments: 66,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 14)),
      ),
      Post(
        id: 'post32',
        userId: users[31].id,
        content:
            'My gentle hero with the kindest heart! 🦸 True heroes don\'t need capes, just paws and unconditional love. We\'re spreading kindness everywhere!',
        imageUrls: [LocalAssets.pets[31]],
        tags: ['#DailyMoments', '#PetCareTips'],
        likes: 534,
        comments: 88,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 16)),
      ),
    ];
  }

  static List<Pet> getSamplePets() {
    return [
      Pet(
        id: 'pet1',
        name: 'Buddy',
        species: 'Dog',
        breed: 'Golden Retriever',
        gender: 'Male',
        birthday: DateTime(2023, 10, 10),
        gotchaDay: DateTime(2023, 12, 25),
        avatarUrl: LocalAssets.pets[0],
        hobbies: 'Chasing tennis balls, belly rubs, and naps.',
        isActive: true,
        createdAt: DateTime(2023, 12, 25),
      ),
      Pet(
        id: 'pet2',
        name: 'Smokey',
        species: 'Cat',
        breed: 'British Shorthair',
        gender: 'Male',
        birthday: DateTime(2022, 5, 15),
        gotchaDay: DateTime(2022, 7, 1),
        avatarUrl: LocalAssets.pets[1],
        hobbies: 'Sleeping in sunbeams, knocking things off tables.',
        isActive: true,
        createdAt: DateTime(2022, 7, 1),
      ),
    ];
  }

  static List<Reminder> getSampleReminders(String petId) {
    return [
      Reminder(
        id: 'reminder1',
        petId: petId,
        title: 'Monthly Deworming',
        description: 'Give deworming medication',
        dueDate: DateTime.now().add(const Duration(days: 6)),
        isCompleted: false,
        type: ReminderType.deworming,
        createdAt: DateTime.now().subtract(const Duration(days: 24)),
      ),
      Reminder(
        id: 'reminder2',
        petId: petId,
        title: 'Annual Vet Checkup',
        description: 'Schedule yearly health examination',
        dueDate: DateTime.now().add(const Duration(days: 72)),
        isCompleted: false,
        type: ReminderType.vetCheckup,
        createdAt: DateTime.now().subtract(const Duration(days: 293)),
      ),
    ];
  }

  static List<GrowthTrack> getSampleGrowthTracks(String petId) {
    return [
      GrowthTrack(
        id: 'track1',
        petId: petId,
        title: 'First Beach Trip!',
        description:
            'He was nervous about the waves at first, but then he loved digging in the sand!',
        date: DateTime(2025, 10, 2),
        imageUrls: [LocalAssets.pets[4]],
        isArchived: false,
        createdAt: DateTime(2025, 10, 2),
      ),
      GrowthTrack(
        id: 'track2',
        petId: petId,
        title: 'Learned "Shake"',
        description:
            'Took him 3 days, but my smart boy finally got it. So proud!',
        date: DateTime(2025, 9, 15),
        imageUrls: [],
        isArchived: false,
        createdAt: DateTime(2025, 9, 15),
      ),
      GrowthTrack(
        id: 'track3',
        petId: petId,
        title: 'Welcome Home, Buddy',
        description: 'The best Christmas gift ever. Our family is complete.',
        date: DateTime(2023, 12, 25),
        imageUrls: [LocalAssets.pets[0]],
        isArchived: false,
        createdAt: DateTime(2023, 12, 25),
      ),
    ];
  }

  static User? getUserById(String userId) {
    try {
      return getSampleUsers().firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  static List<TimelineStory> getTimelineStoriesForUser(String userId) {
    final userIndex = getSampleUsers().indexWhere((u) => u.id == userId);
    if (userIndex == -1) return [];

    // Create 5-8 timeline stories for each user
    final baseDate = DateTime.now();

    // Generic story template for all users
    final genericStories = [
      TimelineStory(
        id: 'story_${userId}_1',
        userId: userId,
        title: 'The Day We Met',
        content:
            'I still remember the first time we locked eyes. It was love at first sight. My heart knew immediately that this was my soulmate, my companion, my family. Life hasn\'t been the same since - it\'s been so much better.',
        date: baseDate.subtract(Duration(days: 300 + userIndex * 10)),
        imageUrl: LocalAssets.pets[userIndex],
      ),
      TimelineStory(
        id: 'story_${userId}_2',
        userId: userId,
        title: 'Building Our Routine',
        content:
            'We\'ve developed our own special routines. Morning cuddles, afternoon walks, evening playtime. These daily rituals have become the highlights of my day. There\'s something magical about having a rhythm together.',
        date: baseDate.subtract(Duration(days: 250 + userIndex * 8)),
        imageUrl: null,
      ),
      TimelineStory(
        id: 'story_${userId}_3',
        userId: userId,
        title: 'A Lesson in Patience',
        content:
            'Today taught me patience in the most beautiful way. We worked on a new skill together, and though it took time, seeing that moment of understanding was worth every second. We\'re both learning and growing.',
        date: baseDate.subtract(Duration(days: 180 + userIndex * 6)),
        imageUrl: null,
      ),
      TimelineStory(
        id: 'story_${userId}_4',
        userId: userId,
        title: 'Rainy Day Comfort',
        content:
            'Stormy weather outside, but inside we\'re cozy and warm. Spent the whole day just being together - no agenda, no rush. Sometimes the best adventures are the ones at home.',
        date: baseDate.subtract(Duration(days: 140 + userIndex * 5)),
        imageUrl: null,
      ),
      TimelineStory(
        id: 'story_${userId}_5',
        userId: userId,
        title: 'Making New Friends',
        content:
            'Met some wonderful friends at the park today! Watching my little one socialize and play with others fills my heart with joy. It\'s amazing to see that confident, happy personality shine through.',
        date: baseDate.subtract(Duration(days: 100 + userIndex * 4)),
        imageUrl: null,
      ),
      TimelineStory(
        id: 'story_${userId}_6',
        userId: userId,
        title: 'Health Scare',
        content:
            'Had a scary moment this week with a health concern. But we got through it together, and it reminded me how precious every moment is. Grateful for modern veterinary care and for having such a strong little fighter.',
        date: baseDate.subtract(Duration(days: 70 + userIndex * 3)),
        imageUrl: null,
      ),
      TimelineStory(
        id: 'story_${userId}_7',
        userId: userId,
        title: 'Seasonal Changes',
        content:
            'Experiencing the changing seasons together has been beautiful. Each season brings new adventures, new sights, new smells to explore. Watching the world through fresh eyes is a gift.',
        date: baseDate.subtract(Duration(days: 40 + userIndex * 2)),
        imageUrl: null,
      ),
      TimelineStory(
        id: 'story_${userId}_8',
        userId: userId,
        title: 'Unconditional Love',
        content:
            'Had a rough day, but coming home to that wagging tail and excited greeting made everything better. This is what unconditional love looks like. No matter what, we have each other.',
        date: baseDate.subtract(Duration(days: 15 + userIndex)),
        imageUrl: null,
      ),
    ];

    return genericStories;
  }
}
