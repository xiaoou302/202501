import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/services/ai_service.dart';
import '../../data/services/local_storage_service.dart';
import 'widgets/chat_bubble.dart';
import 'pet_test_screen.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAITyping = false;
  int _currentCharCount = 0;
  static const int _maxCharLimit = 300;

  static const List<Map<String, dynamic>> _presetTopics = [
    {
      'icon': Icons.restaurant,
      'title': 'Nutrition',
      'question': 'What are the best nutrition tips for my pet?',
    },
    {
      'icon': Icons.fitness_center,
      'title': 'Exercise',
      'question': 'How much exercise does my pet need daily?',
    },
    {
      'icon': Icons.psychology,
      'title': 'Behavior',
      'question': 'How can I understand my pet\'s behavior better?',
    },
    {
      'icon': Icons.cut,
      'title': 'Grooming',
      'question': 'What are essential grooming tips for my pet?',
    },
    {
      'icon': Icons.school,
      'title': 'Training',
      'question': 'What are the best training techniques for pets?',
    },
    {
      'icon': Icons.health_and_safety,
      'title': 'Health',
      'question': 'What health checks should I do regularly?',
    },
    {
      'icon': Icons.toys,
      'title': 'Play Time',
      'question': 'What are the best toys and activities for pets?',
    },
    {
      'icon': Icons.hotel,
      'title': 'Comfort',
      'question': 'How can I make my home more comfortable for my pet?',
    },
    {
      'icon': Icons.people,
      'title': 'Socialization',
      'question': 'How do I socialize my pet with other animals?',
    },
    {
      'icon': Icons.favorite,
      'title': 'Bonding',
      'question': 'How can I strengthen the bond with my pet?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    _loadChatHistory();
    _textController.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _currentCharCount = _textController.text.length;
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_updateCharCount);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content:
          'Hi there! I\'m Leno\'s AI Pal. Feel free to ask me '
          'anything about pet care, or just tell me about your day! 🐾',
      isUser: false,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(welcomeMsg);
    });
  }

  Future<void> _loadChatHistory() async {
    final storage = await LocalStorageService.getInstance();
    final json = await storage.getString(StorageKeys.chatHistory);

    if (json != null && json.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(json);
        final history = decoded
            .map((item) => ChatMessage.fromJson(item))
            .toList();
        if (mounted && history.isNotEmpty) {
          setState(() {
            _messages.clear();
            _messages.addAll(history);
          });
        }
      } catch (e) {
        // Ignore error
      }
    }
  }

  Future<void> _saveChatHistory() async {
    final storage = await LocalStorageService.getInstance();
    final json = jsonEncode(_messages.map((m) => m.toJson()).toList());
    await storage.setString(StorageKeys.chatHistory, json);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isAITyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    final response = await AIService.getResponse(text);

    final aiMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _messages.add(aiMsg);
        _isAITyping = false;
      });

      _scrollToBottom();
      await _saveChatHistory();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _showClearHistoryDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
          'Are you sure you want to delete all chat messages? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await _clearChatHistory();
    }
  }

  Future<void> _clearChatHistory() async {
    setState(() {
      _messages.clear();
    });

    final storage = await LocalStorageService.getInstance();
    await storage.remove(StorageKeys.chatHistory);

    // Add welcome message back
    _addWelcomeMessage();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat history cleared'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteMessage(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _messages.removeAt(index);
      });
      await _saveChatHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _reportMessage(ChatMessage message) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why are you reporting this message?'),
            const SizedBox(height: 16),
            _ReportOption(
              icon: Icons.warning_amber_outlined,
              title: 'Inappropriate Content',
              onTap: () => Navigator.pop(context, 'inappropriate'),
            ),
            const SizedBox(height: 8),
            _ReportOption(
              icon: Icons.error_outline,
              title: 'Spam or Misleading',
              onTap: () => Navigator.pop(context, 'spam'),
            ),
            const SizedBox(height: 8),
            _ReportOption(
              icon: Icons.block_outlined,
              title: 'Harmful or Dangerous',
              onTap: () => Navigator.pop(context, 'harmful'),
            ),
            const SizedBox(height: 8),
            _ReportOption(
              icon: Icons.info_outline,
              title: 'Other',
              onTap: () => Navigator.pop(context, 'other'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      // In a real app, this would send the report to a server
      // For now, we'll just show a confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message reported as: $result'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Modern Gradient Header with Clear Button
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
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spacingM,
                    AppConstants.spacingS,
                    AppConstants.spacingM,
                    AppConstants.spacingL,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'AI Pal',
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your Pet Care Assistant',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppConstants.mediumGray,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppConstants.darkGray.withOpacity(0.5)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_sweep_outlined),
                          color: AppConstants.softCoral,
                          onPressed: _showClearHistoryDialog,
                          tooltip: 'Clear chat history',
                          iconSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Quiz Card
              _buildQuizCard(),

              // Topic Cards (Horizontal Scroll)
              _buildTopicCards(),

              // Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  itemCount: _messages.length + (_isAITyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      return ChatBubble(
                        message: ChatMessage(
                          id: 'typing',
                          content: '...',
                          isUser: false,
                          timestamp: DateTime.now(),
                        ),
                        isTyping: true,
                      );
                    }
                    final message = _messages[index];
                    return ChatBubble(
                      message: message,
                      onDelete: () => _deleteMessage(index),
                      onReport: () => _reportMessage(message),
                    );
                  },
                ),
              ),

              // Input Bar
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppConstants.spacingM,
        AppConstants.spacingM,
        AppConstants.spacingM,
        AppConstants.spacingS,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PetTestScreen()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.softCoral.withOpacity(0.15),
                  AppConstants.softCoral.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.softCoral.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.softCoral.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppConstants.softCoral, Color(0xFFFF6B7A)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.softCoral.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Perfect Pet',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppConstants.softCoral,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Take our AI-powered quiz now!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppConstants.mediumGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.softCoral.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppConstants.softCoral,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCards() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: AppConstants.spacingS),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
        itemCount: _presetTopics.length,
        itemBuilder: (context, index) {
          final topic = _presetTopics[index];
          return Container(
            width: 95,
            margin: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _sendMessage(topic['question'] as String),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppConstants.darkGray,
                              AppConstants.darkGray.withOpacity(0.8),
                            ]
                          : [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark
                          ? AppConstants.softCoral.withOpacity(0.2)
                          : AppConstants.softCoral.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.softCoral.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppConstants.softCoral.withOpacity(0.2),
                              AppConstants.softCoral.withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          topic['icon'] as IconData,
                          color: AppConstants.softCoral,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          topic['title'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isNearLimit = _currentCharCount > _maxCharLimit * 0.8;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.deepPlum : AppConstants.shellWhite,
        border: Border(
          top: BorderSide(
            color: isDark ? AppConstants.darkGray : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Character count indicator
          if (_currentCharCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$_currentCharCount/$_maxCharLimit',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isNearLimit
                          ? Colors.orange
                          : AppConstants.mediumGray,
                      fontWeight: isNearLimit
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          // Input row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 120, // Max 5 lines approximately
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppConstants.darkGray
                        : AppConstants.panelWhite,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLength: _maxCharLimit,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      hintText: 'Ask AI Pal anything...',
                      border: InputBorder.none,
                      counterText: '', // Hide default counter
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) {
                      _sendMessage(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Container(
                decoration: BoxDecoration(
                  color: _currentCharCount == 0
                      ? AppConstants.mediumGray
                      : AppConstants.softCoral,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: _currentCharCount == 0
                      ? null
                      : () => _sendMessage(_textController.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ReportOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppConstants.mediumGray),
            const SizedBox(width: 12),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
