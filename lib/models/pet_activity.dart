import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PetActivity {
  final String title;
  final String shortDesc;
  final String category;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String benefits;
  final List<String> steps;

  const PetActivity({
    required this.title,
    required this.shortDesc,
    required this.category,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.benefits,
    required this.steps,
  });
}

const List<PetActivity> activityLibrary = [
  // ==========================================
  // Category: Training & Skills
  // ==========================================
  PetActivity(
    title: 'Sit & Stay',
    shortDesc: 'The foundation of all training',
    category: 'Training & Skills',
    icon: Icons.pan_tool,
    color: AppColors.peachFuzz,
    bgColor: AppColors.morningPeach,
    benefits:
        'Builds impulse control and establishes basic communication. Essential for safety in outdoor environments.',
    steps: [
      'Hold a treat close to their nose.',
      'Move your hand up, allowing their head to follow the treat and causing their bottom to lower.',
      'Once they\'re in a sitting position, say "Sit", give them the treat, and share affection.',
      'Gradually introduce the "Stay" command by taking a step back while holding your hand out.',
    ],
  ),
  PetActivity(
    title: 'High Five',
    shortDesc: 'A cute trick to bond with your pet',
    category: 'Training & Skills',
    icon: Icons.front_hand,
    color: AppColors.seafoam,
    bgColor: AppColors.mistyFoam,
    benefits:
        'Encourages gentle physical contact and improves their coordination while providing mental stimulation.',
    steps: [
      'Ask your pet to sit.',
      'Hold a treat in your closed fist and present it to them.',
      'Wait for them to paw at your hand to get the treat. When they do, say "High Five" and reward them.',
      'Gradually raise your hand higher and present an open palm instead of a fist.',
    ],
  ),
  PetActivity(
    title: 'Recall (Come Here)',
    shortDesc: 'The most important safety command',
    category: 'Training & Skills',
    icon: Icons.record_voice_over,
    color: AppColors.warmSun,
    bgColor: AppColors.oatMilk,
    benefits:
        'Could save your pet\'s life. Builds immense trust and reliability in distracting environments.',
    steps: [
      'Start in a quiet, distraction-free room.',
      'Crouch down, open your arms, and say "Come" in a happy, enthusiastic tone.',
      'If they come to you, reward them immediately with a high-value treat and praise.',
      'Slowly increase the distance and eventually practice in safe, enclosed outdoor spaces.',
    ],
  ),
  PetActivity(
    title: 'Target Touch',
    shortDesc: 'Touch your hand with their nose',
    category: 'Training & Skills',
    icon: Icons.touch_app,
    color: AppColors.peachFuzz,
    bgColor: AppColors.morningPeach,
    benefits:
        'A great foundation for complex tricks and a helpful way to guide them without physical force.',
    steps: [
      'Hold your hand out flat near their nose.',
      'When they naturally sniff or touch your palm with their nose, say "Yes" or click, and reward.',
      'Move your hand slightly further away and repeat.',
      'Add the cue word "Touch" right before you present your hand.',
    ],
  ),
  PetActivity(
    title: 'Leave It',
    shortDesc: 'Mastering impulse control',
    category: 'Training & Skills',
    icon: Icons.do_not_touch,
    color: AppColors.chestnutGray,
    bgColor: AppColors.warmGauze,
    benefits:
        'Prevents them from eating dangerous items off the ground and teaches extreme patience.',
    steps: [
      'Hold a low-value treat in a closed fist and let them sniff it.',
      'Say "Leave it" and ignore their attempts to get it.',
      'The moment they stop trying and pull away, reward them with a DIFFERENT, higher-value treat from your other hand.',
      'Never give them the treat they were told to leave.',
    ],
  ),
  PetActivity(
    title: 'Spin Around',
    shortDesc: 'A fun, energetic circle trick',
    category: 'Training & Skills',
    icon: Icons.rotate_right,
    color: AppColors.seafoam,
    bgColor: AppColors.mistyFoam,
    benefits:
        'Enhances body awareness, flexibility, and provides a quick burst of mental energy release.',
    steps: [
      'Hold a treat right in front of their nose.',
      'Slowly move the treat in a large circle, luring them to spin their body.',
      'Once they complete the circle, reward them immediately.',
      'Add the verbal cue "Spin" and gradually reduce the hand motion until a simple finger point works.',
    ],
  ),

  // ==========================================
  // Category: Mental Stimulation
  // ==========================================
  PetActivity(
    title: 'Treasure Hunt',
    shortDesc: 'Hide treats for them to find',
    category: 'Mental Stimulation',
    icon: Icons.search,
    color: AppColors.warmSun,
    bgColor: AppColors.oatMilk,
    benefits:
        'Engages their powerful sense of smell. 15 minutes of sniffing is as exhausting as an hour\'s walk!',
    steps: [
      'Ask your pet to sit and stay in another room.',
      'Hide strongly scented treats around the room (behind doors, under safe furniture, on low shelves).',
      'Release them with an enthusiastic "Find it!"',
      'Help them out initially by pointing, then let their nose do the work.',
    ],
  ),
  PetActivity(
    title: 'Snuffle Mat DIY',
    shortDesc: 'Foraging for hidden kibble',
    category: 'Mental Stimulation',
    icon: Icons.cut,
    color: AppColors.peachFuzz,
    bgColor: AppColors.morningPeach,
    benefits:
        'Slows down fast eaters, reduces stress, and encourages natural foraging instincts.',
    steps: [
      'Prepare an old rubber sink mat and old fleece clothing.',
      'Cut the fabric into strips (1 inch wide, 6 inches long).',
      'Thread strips through adjacent holes and tie tight double knots until dense.',
      'Sprinkle their favorite dry kibble deep into the fleece and let them sniff it out.',
    ],
  ),
  PetActivity(
    title: 'Shell Game',
    shortDesc: 'The classic cup-and-treat puzzle',
    category: 'Mental Stimulation',
    icon: Icons.casino,
    color: AppColors.seafoam,
    bgColor: AppColors.mistyFoam,
    benefits:
        'Improves focus, problem-solving skills, and strengthens their visual tracking ability.',
    steps: [
      'Get three identical opaque cups and one treat.',
      'Let them watch you place the treat under one cup.',
      'Slowly shuffle the cups around.',
      'Ask them to "Find it". If they nose or paw the correct cup, lift it and let them eat.',
    ],
  ),
  PetActivity(
    title: 'Muffin Tin Puzzle',
    shortDesc: 'A cheap, effective brain teaser',
    category: 'Mental Stimulation',
    icon: Icons.grid_view,
    color: AppColors.chestnutGray,
    bgColor: AppColors.warmGauze,
    benefits:
        'Forces them to use their paws and mouth to solve a mechanical problem to get their reward.',
    steps: [
      'Take a standard metal muffin tin.',
      'Place small, high-value treats in a few of the cups.',
      'Cover all the cups (even the empty ones) with tennis balls.',
      'Let them figure out how to remove the balls to get the treats.',
    ],
  ),
  PetActivity(
    title: 'Name Game',
    shortDesc: 'Reinforce name recognition',
    category: 'Mental Stimulation',
    icon: Icons.badge,
    color: AppColors.warmSun,
    bgColor: AppColors.oatMilk,
    benefits:
        'Crucial for rescued pets to learn their new name and associate it with extreme positivity.',
    steps: [
      'Prepare 10-20 tiny, high-value treats.',
      'Wait until they look away, then say their name in a bright, happy tone.',
      'The exact millisecond they look at you, say "Yes!" and give a treat.',
      'Repeat in different rooms with increasing levels of distraction.',
    ],
  ),
  PetActivity(
    title: 'New Toy Discovery',
    shortDesc: 'Introduce a new texture or puzzle',
    category: 'Mental Stimulation',
    icon: Icons.toys,
    color: AppColors.peachFuzz,
    bgColor: AppColors.morningPeach,
    benefits:
        'Prevents boredom and destructive behavior by keeping their environment novel and engaging.',
    steps: [
      'Bring out a puzzle toy, Kong, or a safe new chew item.',
      'Show excitement to build their interest before handing it over.',
      'If it\'s a puzzle toy, demonstrate how it works first.',
      'Supervise their play and praise them when they figure it out.',
    ],
  ),

  // ==========================================
  // Category: Physical & Bonding
  // ==========================================
  PetActivity(
    title: 'Gentle Massage',
    shortDesc: 'Relaxation and health check',
    category: 'Physical & Bonding',
    icon: Icons.spa,
    color: AppColors.seafoam,
    bgColor: AppColors.mistyFoam,
    benefits:
        'Lowers stress hormones, builds immense trust, and allows you to check for hidden lumps or injuries.',
    steps: [
      'Wait until they are already relaxed and resting.',
      'Start with slow, flat-hand strokes down their back and sides.',
      'Use circular motions behind their ears and on their chest.',
      'Keep sessions short and stop immediately if they show signs of discomfort.',
    ],
  ),
  PetActivity(
    title: 'Tug of War',
    shortDesc: 'Build confidence and boundaries',
    category: 'Physical & Bonding',
    icon: Icons.sports_kabaddi,
    color: AppColors.peachFuzz,
    bgColor: AppColors.morningPeach,
    benefits:
        'An excellent physical workout that builds confidence in shy pets. Teaches the "Drop it" command safely.',
    steps: [
      'Use a long, soft rope toy. Initiate play by wiggling it on the ground.',
      'Let them grab it and pull back gently. Let them win sometimes!',
      'Stop moving, freeze completely, and say "Drop it". Wait until they let go.',
      'Reward them by immediately restarting the game.',
    ],
  ),
  PetActivity(
    title: 'Indoor Obstacle Course',
    shortDesc: 'Agility training in the living room',
    category: 'Physical & Bonding',
    icon: Icons.sports_score,
    color: AppColors.warmSun,
    bgColor: AppColors.oatMilk,
    benefits:
        'Boosts physical dexterity, burns off excess energy, and requires teamwork.',
    steps: [
      'Use pillows to create jumps, and a blanket draped over chairs as a tunnel.',
      'Use treats to lure them over the pillows and through the tunnel.',
      'Keep it low to the ground and safe to prevent slipping.',
      'Praise enthusiastically as they complete each obstacle.',
    ],
  ),
  PetActivity(
    title: 'Fetch & Retrieve',
    shortDesc: 'The classic energy burner',
    category: 'Physical & Bonding',
    icon: Icons.sports_tennis,
    color: AppColors.seafoam,
    bgColor: AppColors.mistyFoam,
    benefits:
        'Provides intense cardiovascular exercise without exhausting the owner.',
    steps: [
      'Start in a hallway or enclosed space. Throw a toy a short distance.',
      'When they pick it up, enthusiastically call them back.',
      'If they don\'t drop it, offer a treat in exchange for the toy.',
      'Repeat, gradually increasing the throwing distance.',
    ],
  ),
  PetActivity(
    title: 'Hide & Seek',
    shortDesc: 'You hide, they seek',
    category: 'Physical & Bonding',
    icon: Icons.visibility_off,
    color: AppColors.chestnutGray,
    bgColor: AppColors.warmGauze,
    benefits:
        'Taps into their tracking instincts and reinforces their recall training in a fun way.',
    steps: [
      'Have someone hold your pet, or tell them to "Stay".',
      'Hide in another room (start with easy spots like behind a door).',
      'Call their name enthusiastically once.',
      'When they find you, throw a mini party with treats and praise!',
    ],
  ),
  PetActivity(
    title: 'Follow the Leader',
    shortDesc: 'Leash-free indoor walking',
    category: 'Physical & Bonding',
    icon: Icons.directions_walk,
    color: AppColors.warmSun,
    bgColor: AppColors.oatMilk,
    benefits:
        'Encourages them to focus on you and follow your movements, preparing them for better outdoor walks.',
    steps: [
      'Hold a treat in your hand at your side.',
      'Walk around the house, changing directions frequently.',
      'Every time they catch up and walk nicely beside you, reward them.',
      'Add sudden stops, rewarding them if they stop with you.',
    ],
  ),
];
