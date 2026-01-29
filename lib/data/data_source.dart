import 'package:oravie/data/models/inspiration_post.dart';
import 'dart:math';

final List<String> _userNames = [
  "Elena Y.",
  "Marcus Chen",
  "Sarah Jenkins",
  "David Kim",
  "Olivia Wu",
  "James Wright",
  "Sophia Liu",
  "Daniel Park",
  "Emma Thompson",
  "Michael Chang",
  "Isabella Garcia",
  "William Lee",
  "Ava Martinez",
  "Alexander Wang",
  "Mia Robinson",
  "Benjamin Clark",
  "Charlotte Rodriguez",
  "Henry Lewis",
  "Amelia Walker",
  "Lucas Hall",
  "Harper Allen",
  "Mason Young",
  "Evelyn King",
  "Logan Scott",
  "Abigail Green",
  "Ethan Baker",
  "Emily Adams",
  "Jacob Nelson",
  "Elizabeth Hill",
  "Sebastian Carter",
  "Avery Mitchell",
  "Jack Roberts",
];

final List<InspirationPost> dummyPosts = List.generate(32, (index) {
  final id = (index + 1).toString();
  final imagePath = 'assets/jz/jz$id.jpg';
  final avatarPath = 'assets/rw/rw$id.jpg';

  // Randomly assign height ratio for variety
  final random = Random(index);
  final heightRatio = 1.0 + (random.nextDouble() * 0.6); // 1.0 to 1.6

  // Define Categories (English)
  String category;
  if (index < 8)
    category = 'Living Room';
  else if (index < 16)
    category = 'Bedroom';
  else if (index < 22)
    category = 'Dining & Kitchen';
  else if (index < 27)
    category = 'Office';
  else
    category = 'Bathroom';

  String title;
  String subtitle;
  String description;
  String styleTag;
  String location;
  String pros;
  String cons;
  String userName = _userNames[index % _userNames.length];

  // Generate rich content based on Category (English)
  switch (category) {
    case 'Living Room':
      styleTag = index % 2 == 0 ? 'Minimalist' : 'Modern';
      title = [
        'Sunlit Afternoon Lounge',
        'Pure White Space',
        'Charm of No Main Light',
        'Airy & Spacious Feel',
        'Calm Black & White',
        'Creamy Healing Vibe',
        'New Living Concept',
        'Beauty of Lines',
      ][index];
      subtitle = '$styleTag · 1${20 + index}m²';
      description =
          'The living room is the heart of the home, carrying multiple functions of leisure, hospitality, and interaction. In this design, we deliberately removed complex background wall decorations, choosing large areas of warm white latex paint matched with low-saturation technical cloth sofas to create a visual sense of openness.\n\n'
          'Sunlight spills in through the white gauze curtains, light and shadow jumping on the wooden floor, every moment like a movie scene. The design without a main light combined with hidden light strips makes the night atmosphere more warm and soft. Whether reading alone or chatting with family, this is the most relaxing corner.';
      pros =
          '1. Smooth circulation design, safe for kids.\n2. Hidden storage keeps the space tidy.';
      cons = 'Light-colored carpets require regular professional cleaning.';
      break;
    case 'Bedroom':
      styleTag = index % 2 == 0 ? 'Wabi-sabi' : 'Vintage French';
      title = [
        'Quiet Bedroom Moments',
        'Dreamy Bedroom',
        'French Romance',
        'Wabi-sabi Retreat',
        'Vintage Green Dream',
        'Warm Wood Tones',
        'Minimalist Sleep Zone',
        'Back to Basics',
      ][index - 8];
      subtitle = '$styleTag · ${15 + index}m²';
      description =
          'The bedroom is not just a place to sleep, but a haven for the soul. We chose rich-textured linen bedding paired with vintage walnut bedside tables to fill the space with the warmth of time.\n\n'
          'The walls feature artistic paint with a slightly granular texture that looks charming under warm light. A vintage table lamp by the bed is the gentlest companion at night. Removing the TV and replacing it with a favorite painting allows the time before sleep to return to purity and tranquility.';
      pros =
          '1. Excellent blackout curtains for lazy weekends.\n2. Perfectly placed bedside sockets.';
      cons = 'The dresser at the foot of the bed takes up some aisle width.';
      break;
    case 'Dining & Kitchen':
      styleTag = 'Modern Simple';
      title = [
        'Open Kitchen Joy',
        'Scent of Home',
        'Minimalist Dining',
        'East Meets West',
        'Vintage White Tiles',
        'Walnut Texture',
      ][index - 16];
      subtitle = '$styleTag · ${10 + index}m²';
      description =
          'We opened up the originally cramped kitchen partition to create an L-shaped open kitchen + island design. It not only increases the operation surface but also turns cooking into a social activity.\n\n'
          'Minimalist white cabinets paired with embedded appliances look neat and unified visually. A linear pendant light above the island provides ample lighting and adds spatial layers. Making breakfast here to start a vigorous day is a definitive happiness in life.';
      pros =
          '1. Amazing storage under the island.\n2. Rational flow for washing, cutting, and cooking.';
      cons = 'Open design requires a high-power range hood.';
      break;
    case 'Office':
      styleTag = 'Wood & White';
      title = [
        'Dialogue of Books & Wood',
        'Ideal Home Office',
        '1m² Reading Corner',
        'Sunroom Study',
        'Immersive Reading',
      ][index - 22];
      subtitle = '$styleTag · ${8 + index}m²';
      description =
          'Converted the original secondary bedroom into an independent study. The entire wall of open bookshelves carries years of reading collections and is also the most beautiful background wall in the home.\n\n'
          'A large wooden desk facing the greenery outside the window helps dissipate fatigue. Blinds cut the light into stripes; as time flows, the space seems to come alive. This is a habitat for the spirit and a source of inspiration.';
      pros =
          '1. Enhanced soundproofing, very quiet.\n2. Deep desk fits two monitors easily.';
      cons =
          'Open shelves gather dust, recommend air purification or regular dusting.';
      break;
    default: // Bathroom
      styleTag = 'Industrial';
      title = [
        'Minimalist Bath',
        'Dry & Wet Separation',
        'Healing Bath Time',
        'Micro-cement Style',
        'Smart Bath Experience',
      ][index - 27];
      subtitle = '$styleTag · ${5 + index}m²';
      description =
          'Although the bathroom space is small, details determine quality. Micro-cement is used throughout, and the seamless design extends the sense of space, making it visually more advanced and easier to clean.\n\n'
          'The floating vanity avoids hygiene dead corners, and the niche above the wall-hung toilet perfectly stores toiletries. The shower area has a sunken design for faster drainage. A comfortable hot bath after a busy day is the best reward for body and mind.';
      pros =
          '1. Thermostatic shower is a perfect experience.\n2. Smart toilet features are very practical.';
      cons = 'Micro-cement requires high-quality construction to avoid cracks.';
      break;
  }

  // Common location logic
  final cities = [
    'Shanghai',
    'Beijing',
    'Hangzhou',
    'Shenzhen',
    'Chengdu',
    'Guangzhou',
  ];
  location = '${cities[index % cities.length]}';

  return InspirationPost(
    id: id,
    imagePath: imagePath,
    title: title,
    subtitle: subtitle,
    heightRatio: heightRatio,
    avatarPath: avatarPath,
    userName: userName,
    description: description,
    location: location,
    styleTag: styleTag,
    category: category,
    pros: pros,
    cons: cons,
  );
});
