import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/core/services/ai_service.dart';

class AIDiscourseScreen extends StatefulWidget {
  const AIDiscourseScreen({super.key});

  @override
  State<AIDiscourseScreen> createState() => _AIDiscourseScreenState();
}

class _AIDiscourseScreenState extends State<AIDiscourseScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  final ImagePicker _picker = ImagePicker();

  // Chat history format:
  // {
  //   'role': 'user' | 'assistant',
  //   'content': [
  //     {'type': 'text', 'text': '...'},
  //     {'type': 'image_url', 'image_url': '...'} // For display purposes
  //   ]
  // }

  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  File? _selectedImage;

  // Selection Mode State
  bool _isSelectionMode = false;
  final Set<int> _selectedIndices = {};

  final List<String> _allTopics = [
    "Minimalist Living Room Layout",
    "Nordic Style Bedroom Colors",
    "Modern Kitchen Storage Hacks",
    "Cozy Balcony Reading Nook",
    "Industrial Style Lighting",
    "Selecting Curtains for Privacy",
    "Small Bathroom Space Saving",
    "Warm Entryway Decor",
    "Dining Room Wall Art Ideas",
    "Home Office Setup Ideas",
    "Choosing Rug Patterns",
    "Japandi Style Essentials",
    "Open Concept Kitchen Tips",
    "Bedroom Mood Lighting",
    "Mixing Wood Tones",
    "Indoor Plant Styling",
    "Gallery Wall Arrangement",
    "Kids Playroom Organization",
    "Smart Home Lighting Scenes",
    "Vintage Furniture Styling",
    "Neutral Color Palette Guide",
    "Accent Wall Materials",
    "Coffee Table Styling",
    "Bookshelf Decor Tips",
    "Closet Organization Systems",
    "Pet-Friendly Furniture Fabrics",
    "Bohemian Style Textures",
    "Maximizing Natural Light",
    "Mirror Placement for Depth",
    "Seasonal Cushion Swaps",
  ];

  List<String> _displayTopics = [];

  // Palette for topics to make them colorful but high-end
  final List<Color> _topicColors = [
    AppColors.warmBeige,
    AppColors.softSage,
    AppColors.dustyBlue,
    AppColors.terracotta.withOpacity(0.7),
    AppColors.mutedLavender,
  ];

  // Darker icon colors corresponding to the palette above for contrast
  final List<Color> _topicIconColors = [
    const Color(0xFF8D6E63), // Brown for Warm Beige
    AppColors.slateGreen, // Slate Green for Soft Sage
    const Color(0xFF455A64), // Blue Grey for Dusty Blue
    const Color(0xFFD84315), // Deep Orange for Terracotta
    const Color(0xFF5E35B1), // Deep Purple for Muted Lavender
  ];

  @override
  void initState() {
    super.initState();
    // Add initial greeting
    _resetHistory();
    _refreshTopics();
  }

  void _refreshTopics() {
    setState(() {
      _displayTopics = (_allTopics..shuffle()).take(4).toList();
    });
  }

  // Helper to get icon for a topic
  IconData _getTopicIcon(String topic) {
    final lowerTopic = topic.toLowerCase();
    if (lowerTopic.contains('living room') || lowerTopic.contains('sofa')) {
      return FontAwesomeIcons.couch;
    } else if (lowerTopic.contains('kitchen') ||
        lowerTopic.contains('dining')) {
      return FontAwesomeIcons.utensils;
    } else if (lowerTopic.contains('bedroom') || lowerTopic.contains('bed')) {
      return FontAwesomeIcons.bed;
    } else if (lowerTopic.contains('bathroom') || lowerTopic.contains('bath')) {
      return FontAwesomeIcons.bath;
    } else if (lowerTopic.contains('light')) {
      return FontAwesomeIcons.lightbulb;
    } else if (lowerTopic.contains('plant') || lowerTopic.contains('green')) {
      return FontAwesomeIcons.plantWilt;
    } else if (lowerTopic.contains('wall') ||
        lowerTopic.contains('art') ||
        lowerTopic.contains('gallery')) {
      return FontAwesomeIcons.palette;
    } else if (lowerTopic.contains('rug') || lowerTopic.contains('floor')) {
      return FontAwesomeIcons.rug;
    } else if (lowerTopic.contains('storage') ||
        lowerTopic.contains('closet') ||
        lowerTopic.contains('bookshelf')) {
      return FontAwesomeIcons.boxOpen;
    } else if (lowerTopic.contains('window') ||
        lowerTopic.contains('curtain') ||
        lowerTopic.contains('mirror')) {
      return FontAwesomeIcons.windowMaximize; // Approximate
    } else if (lowerTopic.contains('office') || lowerTopic.contains('desk')) {
      return FontAwesomeIcons.computer;
    }
    return FontAwesomeIcons.house;
  }

  // Show Help Dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.slateGreen),
            SizedBox(width: 8),
            Text(
              'About AI Consultant',
              style: TextStyle(
                color: AppColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to your personal AI Interior Design Assistant!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.charcoal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGreen,
                ),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem(
                Icons.chat_bubble_outline,
                'Chat & Discuss',
                'Ask any questions about home decoration, styles, and layouts.',
              ),
              _buildFeatureItem(
                Icons.image_outlined,
                'Image Analysis',
                'Upload photos of your room for personalized renovation suggestions.',
              ),
              _buildFeatureItem(
                Icons.lightbulb_outline,
                'Inspiration',
                'Get fresh ideas from our curated hot topics.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Tips:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGreen,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '• Tap on topics to quickly start a conversation.\n• Long press messages for more options.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.coolGray,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(
                color: AppColors.slateGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.slateGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.coolGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetHistory() {
    _messages.clear();
    _messages.add({
      'role': 'assistant',
      'content': <Map<String, dynamic>>[
        {
          'type': 'text',
          'text':
              'Hello! I am your AI Interior Design Consultant. I can analyze your room photos, suggest renovation ideas, and discuss decoration styles. How can I help you today?',
        },
      ],
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _sendMessage({String? predefinedText}) async {
    final text = predefinedText ?? _textController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    final userMessageContent = <Map<String, dynamic>>[];
    String? base64Image;

    // Handle Image
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);

      // For UI display, we use the file path or a placeholder
      // We'll store the local file path for rendering in UI
      userMessageContent.add({
        'type': 'local_image',
        'file_path': _selectedImage!.path,
      });
    }

    // Handle Text
    if (text.isNotEmpty) {
      userMessageContent.add({'type': 'text', 'text': text});
    }

    setState(() {
      _messages.add({'role': 'user', 'content': userMessageContent});
      _isLoading = true;
      _textController.clear();
      _selectedImage = null;
    });

    _scrollToBottom();

    // Prepare history for API (excluding the local image paths, converting to what API expects)
    final List<Map<String, dynamic>> apiHistory = [];

    for (var i = 1; i < _messages.length - 1; i++) {
      // Skip the last one (current user msg) and first one
      final msg = _messages[i];
      final role = msg['role'];
      final contentList = msg['content'] as List;

      final List<Map<String, dynamic>> apiContent = [];
      for (var item in contentList) {
        if (item['type'] == 'text') {
          apiContent.add({'type': 'text', 'text': item['text']});
        }
        // We skip images in history for now to save tokens/bandwidth unless necessary
      }

      if (apiContent.isNotEmpty) {
        apiHistory.add({'role': role, 'content': apiContent});
      }
    }

    try {
      final responseText = await _aiService.FindOtherLayoutHandler(
        history: apiHistory,
        newText: text,
        newImageBase64: base64Image,
      );

      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': [
              {'type': 'text', 'text': responseText},
            ],
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Optionally add an error message to chat
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Selection Mode Methods
  void _startSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedIndices.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIndices.clear();
    });
  }

  void _toggleMessageSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.snowWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear History',
          style: TextStyle(color: AppColors.charcoal),
        ),
        content: const Text(
          'Are you sure you want to clear all chat history?',
          style: TextStyle(color: AppColors.charcoal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.coolGray),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _resetHistory();
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copySelectedMessages() async {
    final selectedText = _selectedIndices
        .map((index) {
          final msg = _messages[index];
          final content = msg['content'] as List;
          // Extract text parts
          final textParts = content
              .where((item) => item['type'] == 'text')
              .map((item) => item['text'] as String)
              .join(' ');
          return "${msg['role'] == 'user' ? 'User' : 'AI'}: $textParts";
        })
        .join('\n\n');

    if (selectedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: selectedText));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selected messages copied to clipboard'),
            backgroundColor: AppColors.slateGreen,
          ),
        );
      }
    }
    _exitSelectionMode();
  }

  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  void _showReportDialog() {
    String selectedType = 'Spam';
    final TextEditingController reportContentController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Report Message',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reason:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.slateGreen,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items:
                            [
                              'Spam',
                              'Inappropriate Content',
                              'Harassment',
                              'Other',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: reportContentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.slateGreen,
                            ),
                          ),
                          hintText: 'Please describe the issue...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.coolGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'We will review your report within 24 hours and take appropriate action.',
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.slateGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.slateGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
                actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              ),
            );
          },
        );
      },
    );
  }

  void _showMessageOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Delete Message',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteMessage(index);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: Colors.grey[100], height: 1),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flag_outlined,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Report',
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // New Background Decor Widget similar to InspirationGalleryScreen
  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        // Top Left Blob
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.slateGreen.withOpacity(0.15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateGreen.withOpacity(0.15),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Center Right Blob (Warm tone)
        Positioned(
          top: 200,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0C3A5).withOpacity(0.2), // Warm beige
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE0C3A5).withOpacity(0.2),
                  blurRadius: 80,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        // Blur Filter to smooth everything out
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            color: Colors.white.withOpacity(0.3), // Glass effect base
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF9FAFB,
      ), // Match InspirationGalleryScreen base
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // 1. Background Decor
            _buildBackgroundDecor(),

            // 2. Main Content
            Column(
              children: [
                // Styled Header
                Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left:
                        24, // Matched to InspirationGalleryScreen horizontal padding
                    right: 24,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.8,
                    ), // Slight transparency for glass effect
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withOpacity(0.5)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_isSelectionMode) ...[
                            TextButton(
                              onPressed: _exitSelectionMode,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.coolGray,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              'Selected: ${_selectedIndices.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.slateGreen,
                              ),
                            ),
                            TextButton(
                              onPressed: _copySelectedMessages,
                              child: const Text(
                                'Copy',
                                style: TextStyle(
                                  color: AppColors.slateGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                // Logo style indicator
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: const BoxDecoration(
                                    color: AppColors.slateGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Consultant',
                                      style: TextStyle(
                                        fontFamily:
                                            'Playfair Display', // Use custom font
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.charcoal,
                                        letterSpacing: -0.5,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Interior Design Expert',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.coolGray,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Help Icon with glass style
                                GestureDetector(
                                  onTap: _showHelpDialog,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.help_outline,
                                      color: AppColors.charcoal,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Menu Button
                                PopupMenuButton<String>(
                                  icon: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.ellipsis,
                                      size: 18,
                                      color: AppColors.charcoal,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    if (value == 'clear') {
                                      _clearHistory();
                                    } else if (value == 'select') {
                                      _startSelectionMode();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'clear',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                                color: Colors.redAccent,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Clear History',
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'select',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle_outline,
                                                size: 18,
                                                color: AppColors.charcoal,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Select Messages'),
                                            ],
                                          ),
                                        ),
                                      ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Chat Area
                Expanded(
                  child: Container(
                    color: Colors.transparent, // Transparent to show background
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isUser = msg['role'] == 'user';
                        final content = msg['content'] as List;
                        final isSelected = _selectedIndices.contains(index);

                        return GestureDetector(
                          onTap: _isSelectionMode
                              ? () => _toggleMessageSelection(index)
                              : null,
                          onLongPress: () {
                            if (!_isSelectionMode) {
                              _showMessageOptions(index);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 24.0),
                            color: isSelected
                                ? AppColors.slateGreen.withOpacity(0.1)
                                : Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_isSelectionMode)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                      top: 12,
                                    ),
                                    child: Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? AppColors.slateGreen
                                          : Colors.grey,
                                    ),
                                  ),
                                Expanded(
                                  child: isUser
                                      ? UserMessageBubble(content: content)
                                      : AIMessageBubble(content: content),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                if (_isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.white.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.slateGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "AI is designing...",
                          style: TextStyle(
                            color: AppColors.coolGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Input Area
                if (!_isSelectionMode)
                  Builder(
                    builder: (context) {
                      // Check if keyboard is visible
                      final bottomInset = MediaQuery.of(
                        context,
                      ).viewInsets.bottom;
                      final isKeyboardOpen = bottomInset > 0;
                      final double bottomPadding = isKeyboardOpen
                          ? 16.0
                          : 100.0;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9), // Glass effect
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            ),
                          ],
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
                        child: Column(
                          children: [
                            // Topic Chips with improved design
                            if (_displayTopics.isNotEmpty)
                              Container(
                                height: 36,
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _displayTopics.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final topic = _displayTopics[index];
                                    final colorIndex =
                                        index % _topicColors.length;
                                    final color = _topicColors[colorIndex];
                                    final iconColor =
                                        _topicIconColors[colorIndex]; // Use darker icon color
                                    final icon = _getTopicIcon(topic);

                                    return InkWell(
                                      onTap: () {
                                        _sendMessage(predefinedText: topic);
                                        _refreshTopics();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(
                                            0.2,
                                          ), // More subtle background
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: color.withOpacity(0.4),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              icon,
                                              size: 14,
                                              color: iconColor,
                                            ), // Colorful Icon
                                            const SizedBox(width: 6),
                                            Text(
                                              topic,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.charcoal
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            if (_selectedImage != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.softSage),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImage = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Text Input
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: _pickImage,
                                    icon: const Icon(
                                      FontAwesomeIcons.image,
                                      color: AppColors.slateGreen,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.slateGreen
                                              .withOpacity(0.08),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _textController,
                                      maxLength: 300,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        hintText: 'Ask about decoration...',
                                        hintStyle: TextStyle(
                                          color: AppColors.coolGray,
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                        counterText: "",
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.slateGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _isLoading ? null : _sendMessage,
                                    icon: const Icon(
                                      FontAwesomeIcons.paperPlane,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AIMessageBubble extends StatelessWidget {
  final List<dynamic> content;

  const AIMessageBubble({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // Safely cast to List<Map<String, dynamic>>
    final safeContent = content
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final textItem = safeContent.firstWhere(
      (e) => e['type'] == 'text',
      orElse: () => <String, dynamic>{},
    );
    final String text = textItem.isNotEmpty ? textItem['text'] : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/icons/app_icon.png', // Fallback to icon if available or just text
              errorBuilder: (context, error, stackTrace) => const Text(
                'AI',
                style: TextStyle(
                  color: AppColors.slateGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              width: 20,
              height: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateGreen.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: AppColors.slateGreen.withOpacity(0.05)),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.charcoal,
                fontSize: 15,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40), // Spacing to prevent full width
      ],
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final List<dynamic> content;

  const UserMessageBubble({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // Safely cast to List<Map<String, dynamic>>
    final safeContent = content
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final textItem = safeContent.firstWhere(
      (e) => e['type'] == 'text',
      orElse: () => <String, dynamic>{},
    );
    final imageItem = safeContent.firstWhere(
      (e) => e['type'] == 'local_image',
      orElse: () => <String, dynamic>{},
    );

    final String text = textItem.isNotEmpty ? textItem['text'] : '';
    final String? imagePath = imageItem.isNotEmpty
        ? imageItem['file_path']
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 40), // Spacing to prevent full width
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imagePath),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.slateGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.slateGreen.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // 3. YOU Avatar
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: AppColors.slateGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'YOU',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 9, // Small text to fit
              ),
            ),
          ),
        ),
      ],
    );
  }
}
