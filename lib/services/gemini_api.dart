import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/game_state.dart';
import '../services/game_logic.dart';

class GeminiAPI {
  static Future<String> generateHint(GameState state) async {
    if (state.handTile == null) return "The spirits are silent...";

    final validMove = GameLogic.findValidMove(state.handTile!, state.gridTiles);

    String prompt;
    if (validMove == null) {
      prompt = "You are a Mahjong sage. The player is stuck. Tell them to wait for a reshuffle or use shuffle manually. Max 15 words.";
    } else {
      final col = validMove.id % GameConstants.gridColumns;
      final row = validMove.id ~/ GameConstants.gridColumns;
      
      String locHint = "";
      if (row < 2) {
        locHint = "skyward";
      } else if (row > 2) {
        locHint = "earthward";
      } else {
        locHint = "middle";
      }
      
      if (col < 2) {
        locHint += " left";
      } else if (col > 2) {
        locHint += " right";
      }

      prompt = "Mahjong memory game. Player needs ${state.handTile!.number}. Hidden match is at $locHint. Give cryptic hint. Max 15 words.";
    }

    return await _callGeminiAPI(prompt);
  }

  static Future<String> generateVictoryFortune(int score) async {
    final prompt = "Short zen fortune for mahjong winner. Score: $score. Max 15 words.";
    return await _callGeminiAPI(prompt);
  }

  static Future<String> _callGeminiAPI(String prompt) async {
    if (GameConstants.geminiApiKey.isEmpty) {
      return "Configure API key to enable AI features.";
    }

    try {
      final url = Uri.parse('${GameConstants.geminiEndpoint}?key=${GameConstants.geminiApiKey}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "The spirits are silent...";
      }
    } catch (e) {
      return "The spirits are silent...";
    }
  }
}
