import '../models/alchemy_step.dart';
import '../models/game_state.dart';
import 'dart:math';

class RecipeVariant {
  final int id;
  final String name;
  final List<AlchemyStep> correctRecipe;
  final List<String> encryptedLogClues;

  RecipeVariant({
    required this.id,
    required this.name,
    required this.correctRecipe,
    required this.encryptedLogClues,
  });
}

class GameLogic {
  // Three different recipe variants
  static final List<RecipeVariant> recipeVariants = [
    // Variant 1: The Path of the Phoenix (Original recipe)
    RecipeVariant(
      id: 1,
      name: 'The Path of the Phoenix',
      correctRecipe: [
        AlchemyStep(stepNumber: 1, action: 'dissolve', material: 'green_lion'),
        AlchemyStep(stepNumber: 2, action: 'combine', material: 'red_king'),
        AlchemyStep(stepNumber: 3, action: 'combine', material: 'white_queen'),
        AlchemyStep(stepNumber: 4, action: 'calcify', material: 'sulfur'),
        AlchemyStep(stepNumber: 5, action: 'dissolve', material: 'mercury'),
        AlchemyStep(
          stepNumber: 6,
          action: 'sublimate',
          material: 'white_eagle',
        ),
        AlchemyStep(stepNumber: 7, action: 'calcify', material: 'red_lion'),
        AlchemyStep(stepNumber: 8, action: 'combine', material: 'sulfur'),
        AlchemyStep(stepNumber: 9, action: 'dissolve', material: 'white_queen'),
        AlchemyStep(stepNumber: 10, action: 'sublimate', material: 'mercury'),
        AlchemyStep(stepNumber: 11, action: 'calcify', material: 'green_lion'),
        AlchemyStep(stepNumber: 12, action: 'combine', material: 'red_king'),
      ],
      encryptedLogClues: [
        '═══ THE PATH OF THE PHOENIX ═══',
        '',
        '【Fragment I: The Volatile Beginning】',
        'The Green Lion, most volatile of beasts, must be [Dissolved] first. Step 1 begins with taming this fierce creature. Without this foundation, all crumbles.',
        '',
        '【Fragment II: The Royal Marriage】',
        'Steps 2 and 3 form the Sacred Marriage. The Red King must be [Combined] at step 2, followed by the White Queen [Combined] at step 3. The King before the Queen—this order is absolute.',
        '',
        '【Fragment III: Celestial Bodies】',
        'The heavens dictate: Sulfur at position 4 through [Calcification], Mercury at position 5 through [Dissolution]. The celestial order cannot be reversed.',
        '',
        '【Fragment IV: The Eagle\'s Flight】',
        'Step 6 belongs to the White Eagle, rising through [Sublimation]. Immediately after, step 7 demands the Red Lion be [Calcified]. These two steps are inseparable.',
        '',
        '【Fragment V: The Second Synthesis】',
        'Step 8 requires [Combining] Sulfur once more. This is Sulfur\'s second appearance, creating the bridge to later stages.',
        '',
        '【Fragment VI: The Queen\'s Return】',
        'At step 9, the White Queen returns, this time [Dissolved]. Her essence permeates the mixture.',
        '',
        '【Fragment VII: Mercury Ascends】',
        'Step 10: Mercury [Sublimates], rising as white smoke. The messenger\'s second transformation.',
        '',
        '【Fragment VIII: The Circle Closes】',
        'Step 11: The Green Lion returns, now [Calcified] for permanence. Step 12: The Red King returns for the final [Combination]. What began with the Lion ends with the King.',
        '',
        '【CRITICAL PATTERN】',
        'Materials appear twice except White Eagle and Red Lion (once each).',
        'Dissolution: steps 1, 5, 9',
        'Combination: steps 2, 3, 8, 12',
        'Calcification: steps 4, 7, 11',
        'Sublimation: steps 6, 10',
      ],
    ),

    // Variant 2: The Serpent's Coil
    RecipeVariant(
      id: 2,
      name: 'The Serpent\'s Coil',
      correctRecipe: [
        AlchemyStep(stepNumber: 1, action: 'sublimate', material: 'mercury'),
        AlchemyStep(stepNumber: 2, action: 'dissolve', material: 'white_eagle'),
        AlchemyStep(stepNumber: 3, action: 'calcify', material: 'red_king'),
        AlchemyStep(stepNumber: 4, action: 'combine', material: 'green_lion'),
        AlchemyStep(stepNumber: 5, action: 'sublimate', material: 'sulfur'),
        AlchemyStep(stepNumber: 6, action: 'dissolve', material: 'red_lion'),
        AlchemyStep(stepNumber: 7, action: 'combine', material: 'white_queen'),
        AlchemyStep(stepNumber: 8, action: 'calcify', material: 'mercury'),
        AlchemyStep(stepNumber: 9, action: 'sublimate', material: 'green_lion'),
        AlchemyStep(stepNumber: 10, action: 'dissolve', material: 'sulfur'),
        AlchemyStep(stepNumber: 11, action: 'combine', material: 'red_king'),
        AlchemyStep(stepNumber: 12, action: 'calcify', material: 'white_queen'),
      ],
      encryptedLogClues: [
        '═══ THE SERPENT\'S COIL ═══',
        '',
        '【Fragment I: The Messenger Rises】',
        'Unlike other paths, this work begins with ascension. Mercury must [Sublimate] at step 1, rising as vapor. The serpent uncoils from above, not below.',
        '',
        '【Fragment II: The Eagle\'s Dissolution】',
        'Step 2 demands the White Eagle be [Dissolved]—a reversal of nature. The bird of air becomes liquid essence.',
        '',
        '【Fragment III: The King\'s Hardening】',
        'At step 3, the Red King undergoes [Calcification]. Royal power solidifies early in this path.',
        '',
        '【Fragment IV: The Lion\'s First Union】',
        'Step 4: The Green Lion is [Combined] with the mixture. This volatile beast joins the work through synthesis, not dissolution.',
        '',
        '【Fragment V: Sulfur Ascends】',
        'Step 5 sees Sulfur [Sublimate]—the yellow element rises like morning sun. Mark this: Sulfur appears twice in this recipe.',
        '',
        '【Fragment VI: The Red Lion Dissolves】',
        'Step 6: The Red Lion, symbol of strength, is [Dissolved]. What was solid becomes fluid.',
        '',
        '【Fragment VII: The Queen\'s Combination】',
        'At step 7, the White Queen is [Combined]. She joins the work through union, her first of two appearances.',
        '',
        '【Fragment VIII: Mercury Returns】',
        'Step 8: Mercury appears again, this time [Calcified]. The messenger takes solid form. Mercury appears at steps 1 and 8.',
        '',
        '【Fragment IX: The Lion Rises】',
        'Step 9: The Green Lion returns, now [Sublimated]. From combination to vapor—the lion transforms twice.',
        '',
        '【Fragment X: Sulfur\'s Dissolution】',
        'Step 10: Sulfur\'s second appearance through [Dissolution]. What rose at step 5 now descends.',
        '',
        '【Fragment XI: The King\'s Return】',
        'Step 11: The Red King returns for [Combination]. His second appearance mirrors his royal nature—calcified then combined.',
        '',
        '【Fragment XII: The Final Calcification】',
        'Step 12: The White Queen returns, [Calcified] to seal the work. The serpent\'s coil completes.',
        '',
        '【PATTERN OF THE SERPENT】',
        'Sublimation: steps 1, 5, 9',
        'Dissolution: steps 2, 6, 10',
        'Calcification: steps 3, 8, 12',
        'Combination: steps 4, 7, 11',
        'Each material appears exactly twice.',
      ],
    ),

    // Variant 3: The Dragon's Breath
    RecipeVariant(
      id: 3,
      name: 'The Dragon\'s Breath',
      correctRecipe: [
        AlchemyStep(stepNumber: 1, action: 'calcify', material: 'sulfur'),
        AlchemyStep(
          stepNumber: 2,
          action: 'sublimate',
          material: 'white_queen',
        ),
        AlchemyStep(stepNumber: 3, action: 'dissolve', material: 'red_lion'),
        AlchemyStep(stepNumber: 4, action: 'combine', material: 'mercury'),
        AlchemyStep(stepNumber: 5, action: 'calcify', material: 'white_eagle'),
        AlchemyStep(stepNumber: 6, action: 'sublimate', material: 'green_lion'),
        AlchemyStep(stepNumber: 7, action: 'dissolve', material: 'red_king'),
        AlchemyStep(stepNumber: 8, action: 'combine', material: 'sulfur'),
        AlchemyStep(stepNumber: 9, action: 'calcify', material: 'white_queen'),
        AlchemyStep(stepNumber: 10, action: 'sublimate', material: 'mercury'),
        AlchemyStep(stepNumber: 11, action: 'dissolve', material: 'green_lion'),
        AlchemyStep(stepNumber: 12, action: 'combine', material: 'red_king'),
      ],
      encryptedLogClues: [
        '═══ THE DRAGON\'S BREATH ═══',
        '',
        '【Fragment I: Fire\'s Foundation】',
        'The dragon\'s path begins with flame. Sulfur must be [Calcified] at step 1—hardened by fire before all else. This is the foundation stone.',
        '',
        '【Fragment II: The Queen Rises】',
        'Step 2: The White Queen [Sublimates], ascending as ethereal vapor. Her first appearance is through air, not earth.',
        '',
        '【Fragment III: The Lion Melts】',
        'At step 3, the Red Lion is [Dissolved]. Strength becomes fluidity. The lion\'s only appearance in this path.',
        '',
        '【Fragment IV: Mercury\'s Union】',
        'Step 4 demands Mercury be [Combined]. The messenger joins through synthesis. Mercury appears twice—here and later.',
        '',
        '【Fragment V: The Eagle Hardens】',
        'Step 5: The White Eagle, bird of air, undergoes [Calcification]. A paradox—the bird becomes stone. This is its only appearance.',
        '',
        '【Fragment VI: The Green Lion Ascends】',
        'At step 6, the Green Lion [Sublimates]. The volatile beast rises as smoke. First of two appearances.',
        '',
        '【Fragment VII: The King Dissolves】',
        'Step 7: The Red King is [Dissolved]. Royal power becomes liquid essence. The king appears twice in this recipe.',
        '',
        '【Fragment VIII: Sulfur Returns】',
        'Step 8: Sulfur\'s second appearance through [Combination]. What was calcified at step 1 now joins through union.',
        '',
        '【Fragment IX: The Queen\'s Calcification】',
        'Step 9: The White Queen returns, this time [Calcified]. From vapor to stone—her transformation completes.',
        '',
        '【Fragment X: Mercury Ascends】',
        'Step 10: Mercury\'s second form—[Sublimated]. The messenger rises, having been combined earlier.',
        '',
        '【Fragment XI: The Lion\'s Dissolution】',
        'Step 11: The Green Lion returns through [Dissolution]. From sublimation to liquid—the beast\'s dual nature.',
        '',
        '【Fragment XII: The King\'s Final Union】',
        'Step 12: The Red King returns for [Combination]. The dragon\'s breath crystallizes into the stone.',
        '',
        '【THE DRAGON\'S PATTERN】',
        'Calcification: steps 1, 5, 9',
        'Sublimation: steps 2, 6, 10',
        'Dissolution: steps 3, 7, 11',
        'Combination: steps 4, 8, 12',
        'Red Lion and White Eagle appear once. All others appear twice.',
      ],
    ),
  ];

  int? _currentVariantId;

  int selectRandomVariant() {
    final random = Random();
    _currentVariantId =
        recipeVariants[random.nextInt(recipeVariants.length)].id;
    return _currentVariantId!;
  }

  void setVariant(int variantId) {
    _currentVariantId = variantId;
  }

  RecipeVariant getCurrentVariant() {
    if (_currentVariantId == null) {
      selectRandomVariant();
    }
    return recipeVariants.firstWhere((v) => v.id == _currentVariantId);
  }

  List<AlchemyStep> getCorrectRecipe() {
    return getCurrentVariant().correctRecipe;
  }

  AlchemyStep getCorrectStep(int stepIndex) {
    return getCorrectRecipe()[stepIndex];
  }

  bool validateStep(AlchemyStep userStep, int stepIndex) {
    final correctStep = getCorrectRecipe()[stepIndex];
    return userStep.action == correctStep.action &&
        userStep.material == correctStep.material;
  }

  bool validateCompleteRecipe(List<AlchemyStep> userRecipe) {
    final correctRecipe = getCorrectRecipe();
    if (userRecipe.length != correctRecipe.length) return false;

    for (int i = 0; i < userRecipe.length; i++) {
      if (userRecipe[i].action != correctRecipe[i].action ||
          userRecipe[i].material != correctRecipe[i].material) {
        return false;
      }
    }
    return true;
  }

  int? findFirstError(List<AlchemyStep> userRecipe) {
    final correctRecipe = getCorrectRecipe();
    for (int i = 0; i < userRecipe.length && i < correctRecipe.length; i++) {
      if (userRecipe[i].action != correctRecipe[i].action ||
          userRecipe[i].material != correctRecipe[i].material) {
        return i + 1; // Return 1-based step number
      }
    }
    return null;
  }

  String getFailureReason(AlchemyStep userStep, int stepIndex) {
    final correctStep = getCorrectRecipe()[stepIndex];

    if (userStep.action != correctStep.action &&
        userStep.material != correctStep.material) {
      return 'Wrong action and material at step ${stepIndex + 1}';
    } else if (userStep.action != correctStep.action) {
      return 'Step ${stepIndex + 1}: Used [${_formatAction(userStep.action)}] instead of [${_formatAction(correctStep.action)}]';
    } else {
      return 'Step ${stepIndex + 1}: Used [${_formatMaterial(userStep.material)}] instead of [${_formatMaterial(correctStep.material)}]';
    }
  }

  String _formatAction(String action) {
    return action[0].toUpperCase() + action.substring(1);
  }

  String _formatMaterial(String material) {
    return material
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  List<String> getEncryptedLogClues() {
    return getCurrentVariant().encryptedLogClues;
  }

  List<int> checkRevelationUnlocks(GameState state) {
    List<int> newlyUnlocked = [];
    final attemptCount = state.craftingLog.length;

    for (int i = 0; i < state.revelations.length; i++) {
      final revelation = state.revelations[i];
      if (!revelation.isUnlocked &&
          attemptCount >= revelation.unlockRequirement) {
        newlyUnlocked.add(i);
      }
    }

    return newlyUnlocked;
  }
}
