import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/draft.dart';

class StorageService {
  static const String _draftsKey = 'drafts';
  static const String _bookmarksKey = 'bookmarks';
  static const String _blockedAuthorsKey = 'blocked_authors';
  static const String _eulaAgreedKey = 'eula_agreed';

  Future<List<Draft>> loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? draftsJson = prefs.getString(_draftsKey);
    if (draftsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(draftsJson);
    return decoded.map((json) => Draft.fromJson(json)).toList();
  }

  Future<void> saveDrafts(List<Draft> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(drafts.map((d) => d.toJson()).toList());
    await prefs.setString(_draftsKey, encoded);
  }

  Future<List<String>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  Future<void> saveBookmarks(List<String> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  Future<void> addBookmark(String poemId) async {
    final bookmarks = await loadBookmarks();
    if (!bookmarks.contains(poemId)) {
      bookmarks.add(poemId);
      await saveBookmarks(bookmarks);
    }
  }

  Future<void> removeBookmark(String poemId) async {
    final bookmarks = await loadBookmarks();
    bookmarks.remove(poemId);
    await saveBookmarks(bookmarks);
  }

  Future<List<String>> loadBlockedAuthors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_blockedAuthorsKey) ?? [];
  }

  Future<void> saveBlockedAuthors(List<String> blockedAuthors) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_blockedAuthorsKey, blockedAuthors);
  }

  Future<void> blockAuthor(String authorId) async {
    final blocked = await loadBlockedAuthors();
    if (!blocked.contains(authorId)) {
      blocked.add(authorId);
      await saveBlockedAuthors(blocked);
    }
  }

  Future<void> unblockAuthor(String authorId) async {
    final blocked = await loadBlockedAuthors();
    blocked.remove(authorId);
    await saveBlockedAuthors(blocked);
  }

  Future<bool> hasAgreedToEULA() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_eulaAgreedKey) ?? false;
  }

  Future<void> setEULAAgreed(bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eulaAgreedKey, agreed);
  }
}
