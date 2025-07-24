import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/share_card.dart';

class ShareService {
  static const String _storageKey = 'share_cards';

  // Generate a QR code URL for the given text (now just returns a unique identifier)
  String generateQrCodeUrl(String text) {
    return 'qr_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Save a share card
  Future<void> saveShareCard(ShareCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getStringList(_storageKey) ?? [];

    // Convert card to JSON string
    final cardJson = jsonEncode(card.toJson());

    // Add to list and save
    cardsJson.add(cardJson);
    await prefs.setStringList(_storageKey, cardsJson);
  }

  // Update an existing share card
  Future<void> updateShareCard(ShareCard card) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getStringList(_storageKey) ?? [];

      // Find the index of the card with the same id
      int cardIndex = -1;
      for (int i = 0; i < cardsJson.length; i++) {
        final Map<String, dynamic> cardMap = jsonDecode(cardsJson[i]);
        if (cardMap['id'] == card.id) {
          cardIndex = i;
          break;
        }
      }

      if (cardIndex != -1) {
        // Replace the card at the found index
        cardsJson[cardIndex] = jsonEncode(card.toJson());
        await prefs.setStringList(_storageKey, cardsJson);
      } else {
        // If not found, just add it as a new card
        await saveShareCard(card);
      }
    } catch (e) {
      debugPrint('Error updating share card: $e');
      throw Exception('Failed to update share card: $e');
    }
  }

  // Get all share cards
  Future<List<ShareCard>> getAllShareCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getStringList(_storageKey) ?? [];

      // Convert JSON strings to ShareCard objects
      return cardsJson.map((json) {
          final Map<String, dynamic> cardMap = jsonDecode(json);
          return ShareCard.fromJson(cardMap);
        }).toList()
        // Sort by date (newest first)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      // Handle any errors during retrieval
      debugPrint('Error retrieving share cards: $e');
      return [];
    }
  }

  // Get favorite share cards
  Future<List<ShareCard>> getFavoriteShareCards() async {
    try {
      final cards = await getAllShareCards();
      return cards.where((card) => card.isFavorite).toList();
    } catch (e) {
      debugPrint('Error retrieving favorite share cards: $e');
      return [];
    }
  }

  // Toggle favorite status for a share card
  Future<ShareCard> toggleFavorite(String id) async {
    try {
      final card = await getShareCardById(id);
      if (card == null) {
        throw Exception('Card not found');
      }

      final updatedCard = card.copyWith(isFavorite: !card.isFavorite);
      await updateShareCard(updatedCard);
      return updatedCard;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  // Get share cards by tag
  Future<List<ShareCard>> getShareCardsByTag(String tag) async {
    try {
      final cards = await getAllShareCards();
      return cards
          .where(
            (card) =>
                card.tags.any((t) => t.toLowerCase() == tag.toLowerCase()),
          )
          .toList();
    } catch (e) {
      debugPrint('Error retrieving share cards by tag: $e');
      return [];
    }
  }

  // Get all unique tags from share cards
  Future<List<String>> getAllTags() async {
    try {
      final cards = await getAllShareCards();
      final Set<String> uniqueTags = {};

      for (final card in cards) {
        uniqueTags.addAll(card.tags);
      }

      return uniqueTags.toList()..sort();
    } catch (e) {
      debugPrint('Error retrieving all tags: $e');
      return [];
    }
  }

  // Search share cards by text
  Future<List<ShareCard>> searchShareCards(String query) async {
    if (query.isEmpty) {
      return getAllShareCards();
    }

    try {
      final cards = await getAllShareCards();
      final lowerQuery = query.toLowerCase();

      return cards.where((card) {
        final lowerTitle = card.title?.toLowerCase() ?? '';
        final lowerText = card.text.toLowerCase();
        final matchesTags = card.tags.any(
          (tag) => tag.toLowerCase().contains(lowerQuery),
        );

        return lowerTitle.contains(lowerQuery) ||
            lowerText.contains(lowerQuery) ||
            matchesTags;
      }).toList();
    } catch (e) {
      debugPrint('Error searching share cards: $e');
      return [];
    }
  }

  // Get a share card by id
  Future<ShareCard?> getShareCardById(String id) async {
    try {
      final cards = await getAllShareCards();
      for (final card in cards) {
        if (card.id == id) {
          return card;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting share card by id: $e');
      return null;
    }
  }

  // Delete a share card
  Future<void> deleteShareCard(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getStringList(_storageKey) ?? [];

      // Filter out the card with matching ID
      final filteredCards = cardsJson.where((json) {
        final Map<String, dynamic> cardMap = jsonDecode(json);
        return cardMap['id'] != id;
      }).toList();

      await prefs.setStringList(_storageKey, filteredCards);
    } catch (e) {
      debugPrint('Error deleting share card: $e');
      throw Exception('Failed to delete share card: $e');
    }
  }

  // Add tag to a share card
  Future<ShareCard> addTagToShareCard(String id, String tag) async {
    try {
      final card = await getShareCardById(id);
      if (card == null) {
        throw Exception('Card not found');
      }

      // Don't add duplicate tags
      if (card.tags.contains(tag)) {
        return card;
      }

      final updatedTags = List<String>.from(card.tags)..add(tag);
      final updatedCard = card.copyWith(tags: updatedTags);

      await updateShareCard(updatedCard);
      return updatedCard;
    } catch (e) {
      debugPrint('Error adding tag to share card: $e');
      throw Exception('Failed to add tag: $e');
    }
  }

  // Remove tag from a share card
  Future<ShareCard> removeTagFromShareCard(String id, String tag) async {
    try {
      final card = await getShareCardById(id);
      if (card == null) {
        throw Exception('Card not found');
      }

      final updatedTags = List<String>.from(card.tags)
        ..removeWhere((t) => t == tag);
      final updatedCard = card.copyWith(tags: updatedTags);

      await updateShareCard(updatedCard);
      return updatedCard;
    } catch (e) {
      debugPrint('Error removing tag from share card: $e');
      throw Exception('Failed to remove tag: $e');
    }
  }

  // Copy text to clipboard
  Future<void> copyToClipboard(String text, BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Text copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to copy text: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Save QR code to gallery
  Future<bool> saveQrCodeToGallery(
    BuildContext context,
    String url,
    GlobalKey key,
  ) async {
    try {
      // Find the RenderRepaintBoundary using context
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Could not find QR code widget');
      }

      // Convert widget to image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert QR code to image');
      }

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100,
        name: "QR_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('QR code saved to gallery successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return true;
      } else {
        throw Exception('Failed to save image to gallery');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save QR code: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return false;
    }
  }

  // Share QR code
  Future<void> shareQrCode(
    BuildContext context,
    ShareCard card,
    GlobalKey key,
  ) async {
    try {
      // Find the RenderRepaintBoundary using context
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Could not find QR code widget');
      }

      // Convert widget to image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert QR code to image');
      }

      // Get temporary directory to save the image
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final fileName = 'qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '$tempPath/$fileName';

      // Save image to temporary file
      await File(filePath).writeAsBytes(byteData.buffer.asUint8List());

      // Share the image and text
      await Share.shareXFiles(
        [XFile(filePath)],
        text: card.text,
        subject: 'Share QR Code',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Share card shared successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
