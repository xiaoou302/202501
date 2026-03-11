import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'sk-9e0faeacac134521b595e910fdeb1b2e';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';

  Future<String> getRecommendations() async {
    final DateTime now = DateTime.now();
    final String season = _getSeason(now);

    final String prompt =
        '''
    As an expert astrophotographer, recommend 3 best deep-sky targets for the current season ($season) in the Northern Hemisphere.
    For each target, provide:
    1. Name & Catalog Number (e.g., M42 Orion Nebula)
    2. Best Time to Shoot (e.g., 22:00 - 02:00)
    3. Suggested Focal Length (e.g., 300mm - 600mm)
    4. Recommended Exposure (e.g., 180s x 60 frames)
    5. Brief Description (1 sentence)
    
    Format the response as a clean, structured list. Do not use Markdown code blocks.
    ''';

    return _callDeepSeek(prompt);
  }

  Future<String> getTargetPlan(String targetName) async {
    final String prompt =
        '''
    As an expert astrophotographer, provide a detailed shooting plan for the target: "$targetName".
    Include:
    1. Optimal Shooting Window (Local Time)
    2. Suggested Equipment (Focal Length, Filter type)
    3. Camera Settings (Gain/ISO, Exposure Time)
    4. Framing Advice (Composition)
    5. Expected Challenges (e.g., low altitude, moon interference)
    
    Format the response clearly with headings.
    ''';

    return _callDeepSeek(prompt);
  }

  Future<String> _callDeepSeek(String userPrompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a professional astrophotography assistant. Provide accurate, technical, and helpful advice for deep-sky imaging.',
            },
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: Failed to fetch data (Status ${response.statusCode})';
      }
    } catch (e) {
      return 'Error: Connection failed ($e)';
    }
  }

  String _getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'Spring';
    if (month >= 6 && month <= 8) return 'Summer';
    if (month >= 9 && month <= 11) return 'Autumn';
    return 'Winter';
  }
}
