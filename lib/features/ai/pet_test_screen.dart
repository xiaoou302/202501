import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/ai_service.dart';

class PetTestScreen extends StatefulWidget {
  const PetTestScreen({Key? key}) : super(key: key);

  @override
  State<PetTestScreen> createState() => _PetTestScreenState();
}

class _PetTestScreenState extends State<PetTestScreen> {
  int _currentQuestionIndex = 0;
  List<int> _answers = [];
  Map<String, String>? _result;
  bool _isAnalyzing = false;
  late List<Map<String, dynamic>> _questions;
  late int _selectedQuizSet;

  // 6 different comprehensive quiz sets
  static final List<List<Map<String, dynamic>>> _quizSets = [
    // Quiz Set 1: Lifestyle & Environment Focus
    [
      {
        'question': 'What type of home do you live in?',
        'options': [
          'Small apartment (< 50 sqm)',
          'Medium apartment (50-100 sqm)',
          'House without yard',
          'House with small yard',
          'House with large yard',
        ],
      },
      {
        'question': 'How many hours per day are you away from home?',
        'options': [
          'Less than 2 hours',
          '2-4 hours',
          '4-6 hours',
          '6-8 hours',
          'More than 8 hours',
        ],
      },
      {
        'question': 'What\'s your daily activity level?',
        'options': [
          'Very sedentary (mostly indoors)',
          'Light activity (short walks)',
          'Moderately active (regular exercise)',
          'Very active (daily sports/outdoor activities)',
          'Extremely active (athlete lifestyle)',
        ],
      },
      {
        'question': 'Do you have experience with pets?',
        'options': [
          'No experience at all',
          'Had pets as a child',
          'Currently have/had one pet',
          'Experienced with multiple pets',
          'Professional experience (vet, trainer, etc.)',
        ],
      },
      {
        'question': 'What\'s your budget for monthly pet expenses?',
        'options': [
          'Under \$50',
          '\$50-\$100',
          '\$100-\$200',
          '\$200-\$500',
          'Over \$500',
        ],
      },
      {
        'question': 'How do you feel about pet hair and mess?',
        'options': [
          'Cannot tolerate any mess',
          'Prefer minimal shedding',
          'Can handle moderate shedding',
          'Don\'t mind regular cleaning',
          'Completely fine with mess',
        ],
      },
      {
        'question': 'Do you have children or plan to have children?',
        'options': [
          'No children, no plans',
          'No children, planning in future',
          'Young children (0-5 years)',
          'School-age children (6-12 years)',
          'Teenagers (13+ years)',
        ],
      },
      {
        'question': 'How important is pet trainability to you?',
        'options': [
          'Not important at all',
          'Slightly important',
          'Moderately important',
          'Very important',
          'Absolutely essential',
        ],
      },
      {
        'question': 'What\'s your noise tolerance level?',
        'options': [
          'Need complete quiet',
          'Prefer quiet environment',
          'Can handle occasional noise',
          'Don\'t mind regular noise',
          'Noise doesn\'t bother me',
        ],
      },
    ],
    // Quiz Set 2: Personality & Interaction Focus
    [
      {
        'question': 'What personality trait appeals to you most in a pet?',
        'options': [
          'Independent and low-maintenance',
          'Affectionate and cuddly',
          'Playful and energetic',
          'Calm and gentle',
          'Intelligent and trainable',
        ],
      },
      {
        'question': 'How much physical interaction do you want with your pet?',
        'options': [
          'Minimal (just feeding/basic care)',
          'Light (occasional petting)',
          'Moderate (daily play sessions)',
          'High (frequent cuddles and play)',
          'Constant (always together)',
        ],
      },
      {
        'question': 'What\'s your primary reason for getting a pet?',
        'options': [
          'Companionship',
          'Emotional support',
          'Family entertainment',
          'Teaching responsibility to children',
          'Security/protection',
        ],
      },
      {
        'question': 'How do you prefer to spend your free time?',
        'options': [
          'Reading, watching TV (indoor activities)',
          'Hobbies at home (crafts, gaming)',
          'Outdoor walks and nature',
          'Sports and physical activities',
          'Socializing with friends',
        ],
      },
      {
        'question': 'What size pet appeals to you most?',
        'options': [
          'Very small (can hold in hand)',
          'Small (lap-sized)',
          'Medium (moderate size)',
          'Large (substantial presence)',
          'Very large (imposing size)',
        ],
      },
      {
        'question': 'How do you handle stress and anxiety?',
        'options': [
          'Need complete calm and quiet',
          'Prefer soothing, gentle presence',
          'Like active distraction',
          'Enjoy playful interaction',
          'Thrive on high energy',
        ],
      },
      {
        'question': 'What\'s your work schedule like?',
        'options': [
          'Work from home full-time',
          'Hybrid (some days home)',
          'Regular 9-5 office job',
          'Irregular/shift work',
          'Frequent travel for work',
        ],
      },
      {
        'question': 'How patient are you with training and behavior issues?',
        'options': [
          'Very impatient, need easy pet',
          'Somewhat patient',
          'Moderately patient',
          'Very patient',
          'Extremely patient, love challenges',
        ],
      },
      {
        'question': 'Do you have other pets currently?',
        'options': [
          'No other pets',
          'One cat',
          'One dog',
          'Multiple cats',
          'Multiple dogs or mixed pets',
        ],
      },
    ],
    // Quiz Set 3: Practical Care & Commitment Focus
    [
      {
        'question': 'How much time can you dedicate to daily pet care?',
        'options': [
          'Less than 30 minutes',
          '30 minutes to 1 hour',
          '1-2 hours',
          '2-3 hours',
          'More than 3 hours',
        ],
      },
      {
        'question': 'Are you comfortable with grooming tasks?',
        'options': [
          'No grooming preferred',
          'Minimal grooming only',
          'Basic grooming (brushing)',
          'Regular grooming comfortable',
          'Professional grooming skills',
        ],
      },
      {
        'question': 'How do you feel about vet visits and medical care?',
        'options': [
          'Anxious, prefer minimal vet needs',
          'Okay with routine checkups only',
          'Comfortable with regular care',
          'Prepared for medical issues',
          'Experienced with complex care',
        ],
      },
      {
        'question': 'What\'s your climate like?',
        'options': [
          'Very cold (snow, freezing)',
          'Cold to moderate',
          'Temperate (mild seasons)',
          'Warm to hot',
          'Very hot (desert, tropical)',
        ],
      },
      {
        'question': 'Do you travel frequently?',
        'options': [
          'Never travel',
          'Rarely (1-2 times/year)',
          'Occasionally (3-4 times/year)',
          'Frequently (monthly)',
          'Very frequently (weekly)',
        ],
      },
      {
        'question': 'How long are you committed to pet ownership?',
        'options': [
          'Short-term (1-3 years)',
          'Medium-term (3-5 years)',
          'Long-term (5-10 years)',
          'Very long-term (10-15 years)',
          'Lifetime commitment (15+ years)',
        ],
      },
      {
        'question': 'What\'s your living situation stability?',
        'options': [
          'Temporary/uncertain',
          'Renting, may move soon',
          'Stable rental',
          'Own home, stable',
          'Permanent, very stable',
        ],
      },
      {
        'question': 'How do you feel about pet odors?',
        'options': [
          'Cannot tolerate any odor',
          'Very sensitive to odors',
          'Can handle mild odors',
          'Don\'t mind typical pet smells',
          'Not bothered by odors at all',
        ],
      },
      {
        'question': 'Are you prepared for emergency pet expenses?',
        'options': [
          'No emergency fund',
          'Small emergency fund (\$100-\$500)',
          'Moderate fund (\$500-\$1000)',
          'Good fund (\$1000-\$3000)',
          'Substantial fund (\$3000+)',
        ],
      },
    ],
    // Quiz Set 4: Health & Allergy Focus
    [
      {
        'question': 'Do you or family members have allergies?',
        'options': [
          'Severe pet allergies',
          'Moderate allergies',
          'Mild allergies',
          'No allergies but sensitive',
          'No allergies at all',
        ],
      },
      {
        'question': 'How concerned are you about hypoallergenic pets?',
        'options': [
          'Absolutely essential',
          'Very important',
          'Somewhat important',
          'Not very important',
          'Not important at all',
        ],
      },
      {
        'question': 'What\'s your physical fitness level?',
        'options': [
          'Limited mobility/health issues',
          'Low fitness, sedentary',
          'Average fitness',
          'Good fitness, active',
          'Excellent fitness, very active',
        ],
      },
      {
        'question': 'Can you handle a pet that requires daily exercise?',
        'options': [
          'No, need low-energy pet',
          'Light walks only',
          'Moderate daily walks',
          'Active daily exercise',
          'Intense daily activities',
        ],
      },
      {
        'question': 'How do you feel about pet dander and fur?',
        'options': [
          'Allergic, cannot be exposed',
          'Very sensitive',
          'Mildly sensitive',
          'Not sensitive',
          'No issues at all',
        ],
      },
      {
        'question': 'Are you comfortable handling pet waste?',
        'options': [
          'Very uncomfortable',
          'Somewhat uncomfortable',
          'Neutral',
          'Comfortable',
          'No problem at all',
        ],
      },
      {
        'question': 'What\'s your age group?',
        'options': ['Under 25', '25-35', '35-50', '50-65', 'Over 65'],
      },
      {
        'question': 'Do you have any physical limitations?',
        'options': [
          'Significant limitations',
          'Some limitations',
          'Minor limitations',
          'Very few limitations',
          'No limitations',
        ],
      },
      {
        'question': 'How important is pet lifespan to you?',
        'options': [
          'Prefer shorter lifespan (2-5 years)',
          'Short to medium (5-8 years)',
          'Medium lifespan (8-12 years)',
          'Long lifespan (12-15 years)',
          'Very long lifespan (15+ years)',
        ],
      },
    ],
    // Quiz Set 5: Social & Behavioral Focus
    [
      {
        'question': 'How social is your household?',
        'options': [
          'Very private, few visitors',
          'Occasional visitors',
          'Regular visitors',
          'Frequent social gatherings',
          'Constant flow of people',
        ],
      },
      {
        'question': 'How do you want your pet to behave with strangers?',
        'options': [
          'Shy and reserved',
          'Cautious but friendly',
          'Neutral',
          'Friendly and welcoming',
          'Extremely social and outgoing',
        ],
      },
      {
        'question': 'Do you want a pet that can be left alone?',
        'options': [
          'No, always need company',
          'Short periods only (1-2 hours)',
          'Half day (4-6 hours)',
          'Full workday (8 hours)',
          'Extended periods (10+ hours)',
        ],
      },
      {
        'question':
            'How important is it that your pet gets along with other animals?',
        'options': [
          'Not important (no other pets)',
          'Slightly important',
          'Moderately important',
          'Very important',
          'Absolutely essential',
        ],
      },
      {
        'question': 'What level of vocalization is acceptable?',
        'options': [
          'Silent only',
          'Very quiet',
          'Occasional sounds',
          'Regular vocalization',
          'Constant/loud sounds okay',
        ],
      },
      {
        'question':
            'How do you feel about destructive behavior during training?',
        'options': [
          'Cannot tolerate any destruction',
          'Very little acceptable',
          'Some acceptable during training',
          'Moderate amount okay',
          'Don\'t mind, part of learning',
        ],
      },
      {
        'question': 'What\'s your neighborhood like?',
        'options': [
          'Urban, high-density',
          'Suburban, moderate density',
          'Quiet residential area',
          'Rural, low density',
          'Remote/countryside',
        ],
      },
      {
        'question': 'Do you want a pet that can travel with you?',
        'options': [
          'Not important',
          'Slightly preferred',
          'Moderately important',
          'Very important',
          'Absolutely essential',
        ],
      },
      {
        'question': 'How do you handle pet behavioral challenges?',
        'options': [
          'Would give up easily',
          'Limited patience',
          'Moderate patience',
          'Very patient',
          'Committed to working through issues',
        ],
      },
    ],
    // Quiz Set 6: Lifestyle Compatibility Focus
    [
      {
        'question': 'What best describes your daily routine?',
        'options': [
          'Very structured and consistent',
          'Mostly consistent',
          'Somewhat flexible',
          'Very flexible',
          'Unpredictable/irregular',
        ],
      },
      {
        'question': 'How clean and organized is your home?',
        'options': [
          'Extremely tidy, minimalist',
          'Very clean and organized',
          'Moderately tidy',
          'Lived-in, casual',
          'Relaxed about cleanliness',
        ],
      },
      {
        'question': 'What\'s your sleeping schedule like?',
        'options': [
          'Early to bed, early to rise',
          'Regular schedule',
          'Flexible schedule',
          'Night owl',
          'Irregular/shift work',
        ],
      },
      {
        'question': 'How much outdoor space do you have access to?',
        'options': [
          'No outdoor space',
          'Balcony only',
          'Small yard/patio',
          'Medium yard',
          'Large yard or nearby parks',
        ],
      },
      {
        'question': 'What\'s your entertainment preference?',
        'options': [
          'Quiet activities (reading, TV)',
          'Creative hobbies',
          'Social activities',
          'Outdoor adventures',
          'Sports and physical activities',
        ],
      },
      {
        'question': 'How do you spend weekends?',
        'options': [
          'Relaxing at home',
          'Household chores and errands',
          'Mix of home and outings',
          'Outdoor activities',
          'Travel and adventures',
        ],
      },
      {
        'question': 'What\'s your stress level?',
        'options': [
          'Very high stress',
          'High stress',
          'Moderate stress',
          'Low stress',
          'Very low stress',
        ],
      },
      {
        'question': 'How spontaneous are you?',
        'options': [
          'Very planned, no spontaneity',
          'Mostly planned',
          'Balanced',
          'Fairly spontaneous',
          'Very spontaneous',
        ],
      },
      {
        'question': 'What\'s most important to you in a pet?',
        'options': [
          'Low maintenance',
          'Companionship',
          'Entertainment value',
          'Emotional support',
          'Active lifestyle partner',
        ],
      },
    ],
  ];

  @override
  void initState() {
    super.initState();
    // Randomly select one of the 6 quiz sets
    _selectedQuizSet = Random().nextInt(_quizSets.length);
    _questions = _quizSets[_selectedQuizSet];
    _answers = List.filled(_questions.length, -1);
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  Future<void> _submitQuiz() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await AIService.analyzeQuizResults(_answers, _questions);
      if (mounted) {
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to analyze results. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isAnalyzing) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppConstants.softCoral),
                const SizedBox(height: AppConstants.spacingL),
                Text(
                  'Analyzing your answers...',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  'AI is finding your perfect pet match! 🐾',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppConstants.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_result != null) {
      return _buildResultScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.softCoral.withOpacity(0.1),
                    AppConstants.softCoral.withOpacity(0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 22),
                            onPressed: () => Navigator.pop(context),
                            color: AppConstants.softCoral,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pet Match Quiz',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Find your perfect companion',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppConstants.mediumGray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    // Modern Progress Bar
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppConstants.softCoral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${((_currentQuestionIndex + 1) / _questions.length * 100).toInt()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppConstants.mediumGray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value:
                                (_currentQuestionIndex + 1) / _questions.length,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppConstants.softCoral,
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppConstants.spacingL),
                    ..._buildOptions(),
                  ],
                ),
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1
                        ? 'Next'
                        : 'Submit',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final options =
        _questions[_currentQuestionIndex]['options'] as List<String>;

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isSelected = _answers[_currentQuestionIndex] == index;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectAnswer(index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstants.softCoral.withOpacity(0.15),
                          AppConstants.softCoral.withOpacity(0.08),
                        ],
                      )
                    : null,
                color: isSelected
                    ? null
                    : (isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppConstants.softCoral
                      : Colors.grey.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppConstants.softCoral.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: isSelected ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppConstants.softCoral,
                                Color(0xFFFF6B7A),
                              ],
                            )
                          : null,
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppConstants.mediumGray,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      option,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected ? AppConstants.softCoral : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildResultScreen() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recommendedPet = _result!['recommendedPet'] ?? 'Pet';
    final reason = _result!['reason'] ?? '';
    final alternativePet = _result!['alternativePet'] ?? '';
    final alternativeReason = _result!['alternativeReason'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: AppConstants.spacingXL),
                      Text(
                        'Your Pet Match Report! 🎉',
                        style: theme.textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.spacingXL),

                      // Main Recommendation Card
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingL),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppConstants.darkGray
                              : AppConstants.panelWhite,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusL,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: AppConstants.softCoral,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.pets,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spacingM),
                            Text(
                              'Top Match',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppConstants.mediumGray,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spacingS),
                            Text(
                              recommendedPet,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: AppConstants.softCoral,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppConstants.spacingM),
                            Text(
                              reason,
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Alternative Option Card
                      if (alternativePet.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingL),
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingM),
                          decoration: BoxDecoration(
                            color:
                                (isDark
                                        ? AppConstants.darkGray
                                        : AppConstants.panelWhite)
                                    .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusM,
                            ),
                            border: Border.all(
                              color: AppConstants.mediumGray.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.lightbulb_outline,
                                    size: 20,
                                    color: AppConstants.mediumGray,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Alternative Option',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: AppConstants.mediumGray,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.spacingS),
                              Text(
                                alternativePet,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppConstants.spacingS),
                              Text(
                                alternativeReason,
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
