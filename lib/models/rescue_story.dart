import 'package:uuid/uuid.dart';

class RescueStory {
  final String id;
  final String rescuerName;
  final String petName;
  final String petType; // 'Dog', 'Cat', etc.
  final String condition;
  final String story;
  final String imageUrl;
  final DateTime date;

  RescueStory({
    required this.id,
    required this.rescuerName,
    required this.petName,
    required this.petType,
    required this.condition,
    required this.story,
    required this.imageUrl,
    required this.date,
  });
}

// Mock Data
final List<RescueStory> mockRescueStories = [
  RescueStory(
    id: 'story_1',
    rescuerName: 'Sarah Jenkins',
    petName: 'Lucky',
    petType: 'Dog - Mixed Golden Retriever',
    condition: 'Shivering under an abandoned car in the rain.',
    story:
        'I found Lucky hiding under an abandoned car during a heavy rainstorm. He was shivering and terrified. It took me two hours with some treats to finally gain his trust enough to put a leash on him. After weeks of love and patience, Lucky has transformed into the happiest, most affectionate boy. He loves playing fetch and has even learned to swim! This journey has taught me so much about resilience and unconditional love.',
    imageUrl: 'assets/jz1.jpeg',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  RescueStory(
    id: 'story_2',
    rescuerName: 'David Chen',
    petName: 'Luna',
    petType: 'Cat - Domestic Shorthair',
    condition: 'Hiding behind a cardboard box in an alley.',
    story:
        'Heard tiny meows coming from a dumpster alley behind my apartment. Luna was just a tiny kitten, hiding behind a cardboard box. The first few nights were challenging as she was very shy, but seeing her open up to me and start purring was a moment I\'ll never forget. She\'s now a playful, curious little panther who rules the house and loves to sleep on my keyboard.',
    imageUrl: 'assets/jz2.jpeg',
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  RescueStory(
    id: 'story_3',
    rescuerName: 'Emily & Mark',
    petName: 'Barnaby',
    petType: 'Dog - Beagle Mix',
    condition: 'Wandering near a busy road, looking lost.',
    story:
        'We spotted Barnaby wandering near a busy road, looking completely lost and exhausted. We pulled over and slowly approached him. He didn\'t run; he just sat down and wagged his tail gently. Earning his trust was a beautiful process. He is now the most joyful companion, always ready for a hike or a cuddle on the sofa.',
    imageUrl: 'assets/jz3.jpeg',
    date: DateTime.now().subtract(const Duration(days: 12)),
  ),
  RescueStory(
    id: 'story_4',
    rescuerName: 'Jessica Taylor',
    petName: 'Oliver',
    petType: 'Cat - Orange Tabby',
    condition: 'Crying on my porch during a cold evening.',
    story:
        'During a cold winter evening, this orange boy showed up on my porch crying. I set up a warm shelter first, then managed to coax him inside the next day. He had probably been on his own for quite a while. Oliver is now a permanent resident on my sofa. He loves to chase feather toys and zoom around at 3 AM.',
    imageUrl: 'assets/jz4.jpeg',
    date: DateTime.now().subtract(const Duration(days: 20)),
  ),
  RescueStory(
    id: 'story_5',
    rescuerName: 'Michael Brown',
    petName: 'Bella',
    petType: 'Dog - Labrador Mix',
    condition: 'Sitting quietly at a park bench alone.',
    story:
        'Bella was sitting quietly at a park bench when I first saw her. She looked like she was waiting for someone who never came. I sat next to her for hours until she finally rested her head on my lap. Today, she is the sweetest dog I\'ve ever known, bringing so much sunshine and laughter into my everyday life.',
    imageUrl: 'assets/jz5.jpeg',
    date: DateTime.now().subtract(const Duration(days: 25)),
  ),
  RescueStory(
    id: 'story_6',
    rescuerName: 'Chloe Davis',
    petName: 'Milo',
    petType: 'Cat - Black',
    condition: 'Curled up inside an old flower pot.',
    story:
        'I found Milo curled up inside an old flower pot in my garden. He was just a small black fluff ball, completely startled by my presence. With slow movements and some tasty snacks, we became friends. Now, he follows me everywhere around the house and insists on sleeping right next to my pillow.',
    imageUrl: 'assets/jz6.jpeg',
    date: DateTime.now().subtract(const Duration(days: 30)),
  ),
  RescueStory(
    id: 'story_7',
    rescuerName: 'Daniel Wilson',
    petName: 'Charlie',
    petType: 'Dog - Terrier Mix',
    condition: 'Running around the neighborhood looking confused.',
    story:
        'Charlie was running around the neighborhood looking very confused. I followed him and eventually offered him some water. He drank eagerly and then leaned against my leg. Since that day, we have been inseparable. We go on long morning walks, and he always greets everyone with a happy tail wag.',
    imageUrl: 'assets/jz7.jpeg',
    date: DateTime.now().subtract(const Duration(days: 35)),
  ),
  RescueStory(
    id: 'story_8',
    rescuerName: 'Sophia Martinez',
    petName: 'Leo',
    petType: 'Cat - Tuxedo',
    condition: 'Wandering around a grocery store parking lot.',
    story:
        'Leo was wandering around a grocery store parking lot. He had a beautiful tuxedo coat but looked very dusty and tired. I called out to him, and surprisingly, he trotted right over. Now, he is a sophisticated gentleman who loves sitting by the window watching the birds and enjoying quiet afternoons.',
    imageUrl: 'assets/jz8.jpeg',
    date: DateTime.now().subtract(const Duration(days: 42)),
  ),
  RescueStory(
    id: 'story_9',
    rescuerName: 'James Anderson',
    petName: 'Max',
    petType: 'Dog - Poodle Mix',
    condition: 'Wandering around a campsite looking for his family.',
    story:
        'I saw Max wandering around a campsite during a weekend trip. He seemed to have been separated from his family. After searching for his owners without success, I decided to take him home. He has brought an incredible amount of energy and joy into my life, always ready for the next adventure.',
    imageUrl: 'assets/jz9.jpeg',
    date: DateTime.now().subtract(const Duration(days: 48)),
  ),
  RescueStory(
    id: 'story_10',
    rescuerName: 'Olivia Thomas',
    petName: 'Lily',
    petType: 'Cat - Calico',
    condition: 'Hiding in the bushes near my workplace.',
    story:
        'Lily was hiding in the bushes near my workplace. It took me several days of leaving food out for her before she let me pet her. The moment she started purring, my heart melted. She is incredibly gentle and loves to snuggle in my lap while I read.',
    imageUrl: 'assets/jz10.jpeg',
    date: DateTime.now().subtract(const Duration(days: 50)),
  ),
  RescueStory(
    id: 'story_11',
    rescuerName: 'Liam Jackson',
    petName: 'Rocky',
    petType: 'Dog - Dachshund Mix',
    condition: 'Found near an old barn, very timid.',
    story:
        'Rocky was found near an old barn, digging for scraps. He was very timid at first, avoiding eye contact. But with consistent love and a warm bed, his true personality shone through. He is a brave little explorer who loves to dig in the sand at the beach.',
    imageUrl: 'assets/jz11.jpeg',
    date: DateTime.now().subtract(const Duration(days: 55)),
  ),
  RescueStory(
    id: 'story_12',
    rescuerName: 'Ava White',
    petName: 'Chloe',
    petType: 'Cat - Siamese',
    condition: 'Stuck on a tree branch, crying for help.',
    story:
        'I heard Chloe crying from a tree branch where she got stuck. After a gentle rescue, she immediately started rubbing against my arms. She is very vocal and loves to "talk" to me all day long. Her presence has made my home feel so much more alive.',
    imageUrl: 'assets/jz12.jpeg',
    date: DateTime.now().subtract(const Duration(days: 62)),
  ),
  RescueStory(
    id: 'story_13',
    rescuerName: 'Noah Harris',
    petName: 'Buddy',
    petType: 'Dog - Corgi Mix',
    condition: 'Walking aimlessly on a hot summer day.',
    story:
        'Buddy was walking aimlessly around the neighborhood on a hot summer day. I brought him inside to cool down. He was so grateful and immediately fell asleep on my rug. We\'ve been best friends ever since, and he loves going on road trips with me.',
    imageUrl: 'assets/jz13.jpeg',
    date: DateTime.now().subtract(const Duration(days: 70)),
  ),
  RescueStory(
    id: 'story_14',
    rescuerName: 'Isabella Martin',
    petName: 'Nala',
    petType: 'Cat - Tortoiseshell',
    condition: 'A tiny furball found in a parking garage.',
    story:
        'Nala was just a tiny furball found in a parking garage. She was so small she fit in the palm of my hand. Watching her grow into a confident, graceful cat has been the most rewarding experience. She loves chasing laser pointers and lounging in the sun.',
    imageUrl: 'assets/jz14.jpeg',
    date: DateTime.now().subtract(const Duration(days: 75)),
  ),
  RescueStory(
    id: 'story_15',
    rescuerName: 'Lucas Thompson',
    petName: 'Jack',
    petType: 'Dog - Husky Mix',
    condition: 'Wandering in a forest trail.',
    story:
        'Jack was wandering in a forest trail when I was hiking. He looked like a wild spirit but was actually very gentle. We walked the rest of the trail together, and he jumped right into my car. He is my ultimate hiking buddy and brings out the adventurous side in me.',
    imageUrl: 'assets/jz15.jpeg',
    date: DateTime.now().subtract(const Duration(days: 82)),
  ),
  RescueStory(
    id: 'story_16',
    rescuerName: 'Mia Garcia',
    petName: 'Simba',
    petType: 'Cat - Ginger',
    condition: 'Sitting outside a café, looking inside.',
    story:
        'Simba was sitting outside a café, looking longingly at the people inside. I sat outside with him and shared my sandwich. He followed me all the way home. He is a vibrant, affectionate cat who loves to curl up in empty boxes and bring me his favorite toys.',
    imageUrl: 'assets/jz16.jpeg',
    date: DateTime.now().subtract(const Duration(days: 90)),
  ),
  RescueStory(
    id: 'story_17',
    rescuerName: 'Ethan Clark',
    petName: 'Cooper',
    petType: 'Dog - Shepherd Mix',
    condition: 'Found near a construction site, looking bewildered.',
    story:
        'Cooper was found near a construction site, looking completely bewildered. I approached him slowly with open arms, and he gently walked towards me. He has the softest eyes and the biggest heart. Our evening cuddles are the highlight of my day.',
    imageUrl: 'assets/jz17.jpeg',
    date: DateTime.now().subtract(const Duration(days: 95)),
  ),
  RescueStory(
    id: 'story_18',
    rescuerName: 'Harper Rodriguez',
    petName: 'Cleo',
    petType: 'Cat - White',
    condition: 'Hiding under a stairwell during a thunderstorm.',
    story:
        'Cleo was hiding under a stairwell during a thunderstorm. I wrapped her in my jacket and brought her inside. She was so scared but eventually fell asleep in my arms. Now, she is a serene and loving companion who enjoys watching the rain from the window.',
    imageUrl: 'assets/jz18.jpeg',
    date: DateTime.now().subtract(const Duration(days: 100)),
  ),
  RescueStory(
    id: 'story_19',
    rescuerName: 'Alexander Lewis',
    petName: 'Duke',
    petType: 'Dog - Boxer Mix',
    condition: 'Roaming a quiet street, eager for a friend.',
    story:
        'Duke was roaming a quiet street when I noticed him. He seemed so lost and eager for a friend. I called him over, and he immediately gave me a doggy hug. He is a big softie who thinks he is a lap dog and loves everyone he meets.',
    imageUrl: 'assets/jz19.jpeg',
    date: DateTime.now().subtract(const Duration(days: 110)),
  ),
  RescueStory(
    id: 'story_20',
    rescuerName: 'Amelia Lee',
    petName: 'Sophie',
    petType: 'Cat - Grey Tabby',
    condition: 'Wandering in a garden center, cautious but curious.',
    story:
        'Sophie was found wandering in a garden center. She was very curious but cautious. I spent an hour just sitting with her until she decided I was safe. She is now the queen of the household and loves taking long naps in the warmest spots.',
    imageUrl: 'assets/jz20.jpeg',
    date: DateTime.now().subtract(const Duration(days: 120)),
  ),
  RescueStory(
    id: 'story_21',
    rescuerName: 'Benjamin Walker',
    petName: 'Bear',
    petType: 'Dog - Pitbull Mix',
    condition: 'Sitting alone in an empty field.',
    story:
        'Bear was sitting alone in an empty field. He looked tough but was actually incredibly sweet. When I knelt down, he came over and rested his big head on my shoulder. He has brought so much love and loyalty into my life.',
    imageUrl: 'assets/jz21.jpeg',
    date: DateTime.now().subtract(const Duration(days: 125)),
  ),
  RescueStory(
    id: 'story_22',
    rescuerName: 'Evelyn Hall',
    petName: 'Peanut',
    petType: 'Cat - Fluffy',
    condition: 'Discovered inside a hollow log in a park.',
    story:
        'Peanut was discovered inside a hollow log in a park. She was tiny and fluffy, looking at me with big eyes. Gaining her trust took patience, but it was worth every second. She is a playful little joy who makes every day brighter.',
    imageUrl: 'assets/jz22.jpeg',
    date: DateTime.now().subtract(const Duration(days: 135)),
  ),
  RescueStory(
    id: 'story_23',
    rescuerName: 'William Allen',
    petName: 'Tucker',
    petType: 'Dog - Chihuahua Mix',
    condition: 'Running along a dirt road.',
    story:
        'Tucker was found running along a dirt road. I stopped my car and opened the door, and he hopped right in as if he was waiting for me. He is a little dog with a huge personality and brings endless entertainment to our family.',
    imageUrl: 'assets/jz23.jpeg',
    date: DateTime.now().subtract(const Duration(days: 140)),
  ),
  RescueStory(
    id: 'story_24',
    rescuerName: 'Abigail Young',
    petName: 'Willow',
    petType: 'Cat - Spotted',
    condition: 'Hiding in a shed behind my house.',
    story:
        'Willow was hiding in a shed behind my house. She was very stealthy and observant. Once she realized I only wanted to help, she became the most affectionate cat. She loves to sit on my shoulder while I work.',
    imageUrl: 'assets/jz24.jpeg',
    date: DateTime.now().subtract(const Duration(days: 150)),
  ),
  RescueStory(
    id: 'story_25',
    rescuerName: 'Samuel King',
    petName: 'Toby',
    petType: 'Dog - Spaniel Mix',
    condition: 'Wandering near a lake, looking at the water.',
    story:
        'Toby was wandering near a lake, looking at the water. I called him, and he trotted over with a wagging tail. We sat by the lake for a while before heading home together. He loves splashing in the water and is the perfect companion for outdoor fun.',
    imageUrl: 'assets/jz25.jpeg',
    date: DateTime.now().subtract(const Duration(days: 160)),
  ),
];
