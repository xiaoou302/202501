import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class AIService {
  static const String _systemPrompt = '''You are 
Leno's AI Pal, a friendly and knowledgeable pet care assistant. Your role is to help pet owners with questions and advice about their pets.

IMPORTANT RULES:
1. ONLY answer questions related to pets, animals, and pet care
2. You MUST REFUSE to answer ANY questions about:
   - Human health, medicine, or medical advice
   - Legal matters or legal advice
   - Politics or political opinions
   - Economics or financial advice
   - Any topic not related to pets or animals

3. If asked about forbidden topics, politely redirect the conversation back to pets with a response like:
   "I'm specifically designed to help with pet-related questions only. I can't provide advice on [topic]. However, I'd be happy to answer any questions you have about pet care! 🐾"

4. Be warm, friendly, and supportive
5. Provide practical, helpful advice
6. Keep responses concise but informative
7. Use emojis occasionally to be friendly (🐾 🐶 🐱 etc.)
8. If you're unsure about medical issues, always recommend consulting a veterinarian

Focus on topics like:
- Pet behavior and training
- Pet nutrition and diet
- Pet grooming and hygiene
- Pet toys and enrichment
- Pet breeds and characteristics
- Pet adoption and care basics
- Pet safety and wellness (general advice only)
''';

  static Future<String> getResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.deepseekApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.deepseekApiKey}',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        return _getFallbackResponse(userMessage);
      }
    } catch (e) {
      return _getFallbackResponse(userMessage);
    }
  }

  // Fallback responses if API fails
  static String _getFallbackResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    // Check for forbidden topics
    if (message.contains('health') ||
        message.contains('medical') ||
        message.contains('medicine') ||
        message.contains('doctor') ||
        message.contains('sick') && !message.contains('pet')) {
      return 'I\'m specifically designed to help with pet-related questions only. '
          'I can\'t provide medical advice for humans. However, I\'d be happy to '
          'answer any questions you have about pet care! 🐾';
    }

    if (message.contains('legal') ||
        message.contains('law') ||
        message.contains('lawyer') ||
        message.contains('court')) {
      return 'I\'m specifically designed to help with pet-related questions only. '
          'I can\'t provide legal advice. However, I\'d be happy to answer any '
          'questions you have about pet care! 🐾';
    }

    if (message.contains('politic') ||
        message.contains('election') ||
        message.contains('government') && !message.contains('pet')) {
      return 'I\'m specifically designed to help with pet-related questions only. '
          'I can\'t discuss political topics. However, I\'d be happy to answer '
          'any questions you have about pet care! 🐾';
    }

    if (message.contains('stock') ||
        message.contains('invest') ||
        message.contains('economy') ||
        message.contains('financial')) {
      return 'I\'m specifically designed to help with pet-related questions only. '
          'I can\'t provide financial advice. However, I\'d be happy to answer '
          'any questions you have about pet care! 🐾';
    }

    // Pet-related fallback responses
    if (message.contains('grass')) {
      return 'Dogs eat grass for various reasons: to aid digestion, '
          'because they like the taste, or due to nutritional deficiency. '
          'It\'s usually harmless unless they do it excessively. If your dog '
          'is eating grass frequently, consult your vet! 🐶';
    }

    if (message.contains('separation') || message.contains('anxiety')) {
      return 'To ease separation anxiety, try: gradual desensitization, '
          'leaving comfort items, creating a calm departure routine, '
          'and ensuring plenty of exercise before you leave. Consistency '
          'is key! 🐾';
    }

    if (message.contains('toy') || message.contains('play')) {
      return 'Great question! Cats love variety. Puzzle feeders engage '
          'their hunting instincts. Interactive wand toys are also a '
          'classic hit! Rotate toys weekly to keep things interesting. 🐱';
    }

    if (message.contains('train')) {
      return 'Training requires patience and consistency! Use positive '
          'reinforcement, keep sessions short (5-10 minutes), and always '
          'end on a positive note. Treats and praise work wonders! 🐶';
    }

    if (message.contains('food') || message.contains('eat')) {
      return 'Proper nutrition is crucial! Choose high-quality food appropriate '
          'for your pet\'s age and size. Avoid human food that can be toxic. '
          'Consult your vet for specific dietary recommendations. 🍖';
    }

    // Default response
    return 'I\'m here to help with pet care questions! Feel free to ask me about '
        'pet behavior, training, nutrition, grooming, or any other pet-related '
        'topics. What would you like to know? 🐾';
  }

  // AI-powered quiz analysis
  static Future<Map<String, String>> analyzeQuizResults(
    List<int> answers,
    List<Map<String, dynamic>> questions,
  ) async {
    // Build a detailed description of the user's answers
    final StringBuffer userProfile = StringBuffer();
    userProfile.writeln(
      'You are a professional pet matchmaker. Analyze the following comprehensive quiz answers and recommend the MOST SUITABLE pet for this person.',
    );
    userProfile.writeln();
    userProfile.writeln('IMPORTANT: Consider ALL factors holistically:');
    userProfile.writeln('- Living space and environment');
    userProfile.writeln('- Time availability and commitment');
    userProfile.writeln('- Activity level and lifestyle');
    userProfile.writeln('- Experience and skills');
    userProfile.writeln('- Budget and resources');
    userProfile.writeln('- Health and allergies');
    userProfile.writeln('- Personality and preferences');
    userProfile.writeln('- Social situation');
    userProfile.writeln();
    userProfile.writeln('USER PROFILE:');
    userProfile.writeln('=' * 50);

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i]['question'];
      final options = questions[i]['options'] as List<String>;
      final answer = answers[i];
      if (answer >= 0 && answer < options.length) {
        userProfile.writeln('${i + 1}. $question');
        userProfile.writeln('   Answer: ${options[answer]}');
        userProfile.writeln();
      }
    }

    userProfile.writeln('=' * 50);
    userProfile.writeln();
    userProfile.writeln('Based on this comprehensive profile, provide:');
    userProfile.writeln();
    userProfile.writeln('1. PRIMARY RECOMMENDATION:');
    userProfile.writeln('   - Specific pet type or breed (be specific!)');
    userProfile.writeln('   - Why this is the BEST match (3-4 sentences)');
    userProfile.writeln(
      '   - Consider their lifestyle, space, time, and preferences',
    );
    userProfile.writeln();
    userProfile.writeln('2. ALTERNATIVE OPTION:');
    userProfile.writeln('   - Another suitable pet type');
    userProfile.writeln('   - Why this could also work (2-3 sentences)');
    userProfile.writeln();
    userProfile.writeln('RESPONSE FORMAT (MUST FOLLOW EXACTLY):');
    userProfile.writeln('RECOMMENDED: [Specific pet type/breed]');
    userProfile.writeln('REASON: [Detailed 3-4 sentence explanation]');
    userProfile.writeln('ALTERNATIVE: [Alternative pet type]');
    userProfile.writeln('ALT_REASON: [2-3 sentence explanation]');
    userProfile.writeln();
    userProfile.writeln('Be specific with breeds when possible. Consider:');
    userProfile.writeln(
      '- Dogs: Specify breed based on size, energy, grooming needs',
    );
    userProfile.writeln(
      '- Cats: Consider breeds like Persian, Siamese, Maine Coon, etc.',
    );
    userProfile.writeln(
      '- Small pets: Rabbits, Guinea Pigs, Hamsters, Birds, Fish',
    );
    userProfile.writeln('- Exotic: Reptiles, Ferrets (if suitable)');
    userProfile.writeln();
    userProfile.writeln(
      'Make your recommendation PRACTICAL and REALISTIC for their situation.',
    );

    try {
      final response = await http.post(
        Uri.parse(AppConstants.deepseekApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.deepseekApiKey}',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userProfile.toString()},
          ],
          'temperature': 0.7,
          'max_tokens': 800,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        return _parseQuizResponse(content);
      } else {
        return _getFallbackQuizResult(answers);
      }
    } catch (e) {
      return _getFallbackQuizResult(answers);
    }
  }

  static Map<String, String> _parseQuizResponse(String content) {
    final Map<String, String> result = {};

    // Try to parse structured response
    final recommendedMatch = RegExp(
      r'RECOMMENDED:\s*(.+?)(?=\n|$)',
      caseSensitive: false,
    ).firstMatch(content);
    final reasonMatch = RegExp(
      r'REASON:\s*(.+?)(?=\n\n|\nALTERNATIVE|$)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(content);
    final alternativeMatch = RegExp(
      r'ALTERNATIVE:\s*(.+?)(?=\n|$)',
      caseSensitive: false,
    ).firstMatch(content);
    final altReasonMatch = RegExp(
      r'ALT_REASON:\s*(.+?)(?=\n|$)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(content);

    result['recommendedPet'] =
        recommendedMatch?.group(1)?.trim() ?? 'Cat or Dog';
    result['reason'] = reasonMatch?.group(1)?.trim() ?? content;
    result['alternativePet'] =
        alternativeMatch?.group(1)?.trim() ?? 'Small Pet';
    result['alternativeReason'] =
        altReasonMatch?.group(1)?.trim() ?? 'A great low-maintenance option!';

    return result;
  }

  static Map<String, String> _getFallbackQuizResult(List<int> answers) {
    // Calculate various scores from answers
    int spaceScore = answers.isNotEmpty ? answers[0] : 2;
    int timeScore = answers.length > 1 ? answers[1] : 2;
    int activityScore = answers.length > 2 ? answers[2] : 2;
    int experienceScore = answers.length > 3 ? answers[3] : 2;
    int budgetScore = answers.length > 4 ? answers[4] : 2;

    // Check for allergy concerns (if present in quiz)
    bool allergyConscious = answers.length > 5 && answers[5] <= 1;

    // Comprehensive decision tree

    // Case 1: Limited space + Limited time + Low activity
    if (spaceScore <= 1 && timeScore <= 1 && activityScore <= 1) {
      return {
        'recommendedPet': 'Cat (British Shorthair or Russian Blue)',
        'reason':
            'Perfect for your lifestyle! These cat breeds are independent, quiet, and '
            'thrive in apartments. They don\'t require constant attention and are content '
            'with indoor living. British Shorthairs are calm and low-maintenance, while '
            'Russian Blues are gentle and adapt well to small spaces.',
        'alternativePet': 'Small Fish Tank or Betta Fish',
        'alternativeReason':
            'If you want even lower maintenance, a small aquarium with a Betta fish '
            'provides calming companionship with minimal daily care requirements. '
            'Perfect for busy schedules and small spaces.',
      };
    }

    // Case 2: Good space + Good time + High activity
    if (spaceScore >= 3 && timeScore >= 3 && activityScore >= 3) {
      return {
        'recommendedPet':
            'Active Dog (Border Collie, Australian Shepherd, or Labrador)',
        'reason':
            'Your active lifestyle and available space are perfect for an energetic dog! '
            'Border Collies and Australian Shepherds are intelligent, trainable, and love '
            'outdoor activities. Labradors are friendly, loyal, and make excellent family '
            'companions. These breeds will thrive with your energy level and commitment.',
        'alternativePet': 'Active Cat (Bengal or Abyssinian)',
        'alternativeReason':
            'If you prefer more independence, Bengal or Abyssinian cats are highly active, '
            'playful, and intelligent. They enjoy interactive play and can even be trained '
            'for walks, giving you an active companion with feline independence.',
      };
    }

    // Case 3: Moderate everything - balanced lifestyle
    if (spaceScore == 2 && timeScore == 2 && activityScore == 2) {
      return {
        'recommendedPet':
            'Medium Dog (Cavalier King Charles Spaniel or Cocker Spaniel)',
        'reason':
            'These breeds perfectly match your balanced lifestyle. They\'re adaptable, '
            'affectionate, and moderate in energy. Cavaliers are gentle and love companionship, '
            'while Cocker Spaniels are playful but not overly demanding. Both are great for '
            'families and adapt well to various living situations.',
        'alternativePet': 'Domestic Shorthair Cat',
        'alternativeReason':
            'A mixed-breed cat offers wonderful companionship with lower maintenance. '
            'They\'re adaptable, affectionate, and their moderate activity level matches '
            'your lifestyle perfectly.',
      };
    }

    // Case 4: Allergy concerns
    if (allergyConscious) {
      return {
        'recommendedPet':
            'Hypoallergenic Dog (Poodle, Bichon Frise, or Portuguese Water Dog)',
        'reason':
            'These breeds are excellent for allergy sufferers! Poodles are highly intelligent '
            'and come in three sizes to fit your space. Bichon Frises are cheerful and produce '
            'less dander. Portuguese Water Dogs are active and hypoallergenic. All have hair '
            'instead of fur, significantly reducing allergic reactions.',
        'alternativePet': 'Sphynx Cat or Russian Blue',
        'alternativeReason':
            'Sphynx cats are hairless and produce minimal allergens. Russian Blues produce '
            'less Fel d 1 protein (the main allergen), making them better for sensitive individuals.',
      };
    }

    // Case 5: Limited experience + Low budget
    if (experienceScore <= 1 && budgetScore <= 1) {
      return {
        'recommendedPet': 'Guinea Pig or Hamster',
        'reason':
            'Perfect starter pets! Guinea pigs are social, gentle, and easy to care for. '
            'They\'re affordable, don\'t require extensive space, and are great for learning '
            'pet care basics. Hamsters are even more budget-friendly and can be kept in smaller '
            'spaces. Both are low-maintenance and rewarding companions.',
        'alternativePet': 'Budgerigar (Budgie) or Canary',
        'alternativeReason':
            'Small birds like budgies are social, entertaining, and relatively easy to care for. '
            'They\'re budget-friendly and don\'t require much space, making them ideal first pets.',
      };
    }

    // Case 6: High experience + High budget
    if (experienceScore >= 3 && budgetScore >= 3) {
      return {
        'recommendedPet': 'Specialized Breed Dog or Multiple Pets',
        'reason':
            'With your experience and resources, you can handle more demanding pets! Consider '
            'breeds like German Shepherds (loyal, trainable), Huskies (energetic, beautiful), '
            'or even multiple pets. Your expertise allows you to provide the specialized care '
            'these breeds need, and your budget supports their healthcare and training needs.',
        'alternativePet': 'Exotic Pet (Parrot, Reptile, or Rabbit)',
        'alternativeReason':
            'Your experience makes you suitable for exotic pets. African Grey Parrots are '
            'incredibly intelligent, bearded dragons are fascinating reptiles, or rabbits '
            'can be wonderful house pets with proper care.',
      };
    }

    // Case 7: Good space but limited time
    if (spaceScore >= 3 && timeScore <= 1) {
      return {
        'recommendedPet':
            'Low-Energy Dog (Basset Hound, Bulldog, or Greyhound)',
        'reason':
            'These breeds love space but are surprisingly low-energy! Basset Hounds are calm '
            'and content with short walks. Bulldogs are gentle couch potatoes. Greyhounds, '
            'despite their racing background, are actually quite lazy and happy to lounge. '
            'They\'ll enjoy your yard without demanding constant attention.',
        'alternativePet': 'Multiple Cats',
        'alternativeReason':
            'Cats can keep each other company when you\'re busy. With your space, multiple '
            'cats can coexist happily, providing companionship for each other and you.',
      };
    }

    // Default case - balanced recommendation
    return {
      'recommendedPet': 'Cat (Domestic Shorthair) or Small Dog (Beagle)',
      'reason':
          'Based on your profile, a versatile pet is best. Domestic Shorthair cats are '
          'adaptable, affectionate, and low-maintenance. Beagles are friendly, moderate in '
          'size and energy, and great companions. Both are suitable for various lifestyles '
          'and are relatively easy to care for, making them excellent choices.',
      'alternativePet': 'Rabbit',
      'alternativeReason':
          'Rabbits are wonderful middle-ground pets. They\'re social and affectionate like '
          'dogs but more independent like cats. They can be litter-trained and are quieter '
          'than most pets, making them versatile companions.',
    };
  }
}
