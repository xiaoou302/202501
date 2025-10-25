/// Text parser utility for handling keyword extraction and story reconstruction
class TextParser {
  /// Parse text and extract words with keyword markers
  static List<ParsedWord> parseText(String content) {
    final words = <ParsedWord>[];
    final regex = RegExp(r'\[([^\]]+)\]|(\S+)');
    final matches = regex.allMatches(content);

    for (final match in matches) {
      if (match.group(1) != null) {
        // This is a keyword (within brackets)
        words.add(ParsedWord(text: match.group(1)!, isKeyword: true));
      } else if (match.group(2) != null) {
        // This is a regular word
        words.add(ParsedWord(text: match.group(2)!, isKeyword: false));
      }
    }

    return words;
  }

  /// Reconstruct story with saved keywords
  static String reconstructStory(
    String originalContent,
    Set<String> savedKeywords,
  ) {
    String result = originalContent;

    // Remove all bracket markers first
    result = result.replaceAll('[', '').replaceAll(']', '');

    // Replace words not in savedKeywords with underscores
    final words = result.split(RegExp(r'\s+'));
    final reconstructed = words
        .map((word) {
          // Remove punctuation for comparison
          final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
          final punctuation = word.substring(cleanWord.length);

          if (savedKeywords.contains(cleanWord)) {
            return word;
          } else {
            return '___$punctuation';
          }
        })
        .join(' ');

    return reconstructed;
  }

  /// Extract keywords from content
  static List<String> extractKeywords(String content) {
    final regex = RegExp(r'\[([^\]]+)\]');
    final matches = regex.allMatches(content);
    return matches.map((m) => m.group(1)!).toList();
  }

  /// Clean text of keyword markers
  static String cleanText(String content) {
    return content.replaceAll('[', '').replaceAll(']', '');
  }
}

/// Parsed word model
class ParsedWord {
  final String text;
  final bool isKeyword;

  ParsedWord({required this.text, required this.isKeyword});
}
