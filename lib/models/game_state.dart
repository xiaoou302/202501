import 'revelation.dart';
import 'attempt_record.dart';
import 'recipe.dart';

class GameState {
  final int currentAttempt;
  final List<AttemptRecord> craftingLog;
  final List<Revelation> revelations;
  final bool soundEnabled;
  final bool musicEnabled;
  final String textSpeed;
  final Recipe? currentRecipe;
  final int? currentRecipeVariantId;

  GameState({
    required this.currentAttempt,
    required this.craftingLog,
    required this.revelations,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.textSpeed = 'normal',
    this.currentRecipe,
    this.currentRecipeVariantId,
  });

  factory GameState.initial() {
    return GameState(
      currentAttempt: 1,
      craftingLog: [],
      revelations: _createInitialRevelations(),
      soundEnabled: true,
      musicEnabled: true,
      textSpeed: 'normal',
    );
  }

  static List<Revelation> _createInitialRevelations() {
    return [
      Revelation(
        title: 'First Revelation: The Beginning Point',
        description:
            'Your first attempt has taught you this truth: The Green Lion is indeed the starting point. Step 1 must be [Dissolve] + [Green Lion]. This volatile beast must be tamed first, or chaos ensues. All paths begin here.',
        isUnlocked: false,
        unlockRequirement: 1,
      ),
      Revelation(
        title: 'Second Revelation: The Royal Order',
        description:
            'After multiple failures, the pattern emerges: The Sacred Marriage occurs at steps 2 and 3. Step 2: [Combine] + [Red King]. Step 3: [Combine] + [White Queen]. The King MUST come before the Queen. This is absolute.',
        isUnlocked: false,
        unlockRequirement: 2,
      ),
      Revelation(
        title: 'Third Revelation: Celestial Positions',
        description:
            'The stars have spoken through your failures. The celestial bodies occupy positions 4 and 5. Step 4: [Calcify] + [Sulfur]. Step 5: [Dissolve] + [Mercury]. The order is astronomical, not arbitrary.',
        isUnlocked: false,
        unlockRequirement: 3,
      ),
      Revelation(
        title: 'Fourth Revelation: The Eagle\'s Sequence',
        description:
            'Your persistence reveals a crucial sequence: Steps 6 and 7 are linked. Step 6: [Sublimate] + [White Eagle]. Step 7: [Calcify] + [Red Lion]. The Eagle\'s flight prepares for the Lion\'s solidification. They are inseparable.',
        isUnlocked: false,
        unlockRequirement: 4,
      ),
      Revelation(
        title: 'Fifth Revelation: The Second Synthesis',
        description:
            'Through pain comes wisdom. Step 8 is a crucial synthesis: [Combine] + [Sulfur]. This is Sulfur\'s second appearance (it was calcified at step 4). The pattern of return becomes clearer.',
        isUnlocked: false,
        unlockRequirement: 5,
      ),
      Revelation(
        title: 'Sixth Revelation: The Mirror of Materials',
        description:
            'A profound pattern emerges: Materials appear twice except White Eagle and Red Lion (which appear once). The final steps mirror the beginning. Step 9: [Dissolve] + [White Queen]. Step 10: [Sublimate] + [Mercury]. Step 11: [Calcify] + [Green Lion]. Step 12: [Combine] + [Red King].',
        isUnlocked: false,
        unlockRequirement: 6,
      ),
      Revelation(
        title: 'Seventh Revelation: The Complete Truth',
        description:
            'You have suffered enough. Here is the complete sequence:\n1. Dissolve + Green Lion\n2. Combine + Red King\n3. Combine + White Queen\n4. Calcify + Sulfur\n5. Dissolve + Mercury\n6. Sublimate + White Eagle\n7. Calcify + Red Lion\n8. Combine + Sulfur\n9. Dissolve + White Queen\n10. Sublimate + Mercury\n11. Calcify + Green Lion\n12. Combine + Red King\n\nThe circle is complete. May you succeed where your mentor failed.',
        isUnlocked: false,
        unlockRequirement: 10,
      ),
    ];
  }

  GameState copyWith({
    int? currentAttempt,
    List<AttemptRecord>? craftingLog,
    List<Revelation>? revelations,
    bool? soundEnabled,
    bool? musicEnabled,
    String? textSpeed,
    Recipe? currentRecipe,
    int? currentRecipeVariantId,
    bool clearCurrentRecipe = false,
    bool clearVariantId = false,
  }) {
    return GameState(
      currentAttempt: currentAttempt ?? this.currentAttempt,
      craftingLog: craftingLog ?? this.craftingLog,
      revelations: revelations ?? this.revelations,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      textSpeed: textSpeed ?? this.textSpeed,
      currentRecipe: clearCurrentRecipe
          ? null
          : (currentRecipe ?? this.currentRecipe),
      currentRecipeVariantId: clearVariantId
          ? null
          : (currentRecipeVariantId ?? this.currentRecipeVariantId),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentAttempt': currentAttempt,
      'craftingLog': craftingLog.map((r) => r.toJson()).toList(),
      'revelations': revelations.map((r) => r.toJson()).toList(),
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'textSpeed': textSpeed,
      'currentRecipe': currentRecipe?.toJson(),
      'currentRecipeVariantId': currentRecipeVariantId,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      currentAttempt: json['currentAttempt'] as int? ?? 1,
      craftingLog:
          (json['craftingLog'] as List?)
              ?.map((r) => AttemptRecord.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      revelations:
          (json['revelations'] as List?)
              ?.map((r) => Revelation.fromJson(r as Map<String, dynamic>))
              .toList() ??
          _createInitialRevelations(),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      textSpeed: json['textSpeed'] as String? ?? 'normal',
      currentRecipe: json['currentRecipe'] != null
          ? Recipe.fromJson(json['currentRecipe'] as Map<String, dynamic>)
          : null,
      currentRecipeVariantId: json['currentRecipeVariantId'] as int?,
    );
  }

  AttemptRecord? get lastAttempt =>
      craftingLog.isNotEmpty ? craftingLog.last : null;
}
