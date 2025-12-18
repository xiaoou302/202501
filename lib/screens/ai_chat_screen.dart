import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../widgets/chat_bubble.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final AIService _aiService = AIService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showTopicTemplates = true;
  bool _topicTemplatesExpanded = true;
  List<Map<String, String>> _displayedTopics = [];

  // 完整的话题模板库（20个）
  final List<Map<String, String>> _allTopicTemplates = [
    // 诗歌技巧类
    {'icon': '🎨', 'title': 'Imagery', 'message': 'How can I create more vivid imagery in my poetry?'},
    {'icon': '🎵', 'title': 'Rhythm', 'message': 'Can you help me understand poetic rhythm and meter?'},
    {'icon': '💭', 'title': 'Metaphor', 'message': 'How do I use metaphors effectively in my poems?'},
    {'icon': '�', 'title': 'Personification', 'message': 'What are some creative ways to use personification?'},
    {'icon': '🔤', 'title': 'Alliteration', 'message': 'How can I use alliteration without overdoing it?'},
    {'icon': '📝', 'title': 'Line Breaks', 'message': 'How do I decide where to break lines in my poems?'},
    {'icon': '🎪', 'title': 'Symbolism', 'message': 'How can I incorporate symbolism naturally in my writing?'},
    {'icon': '🌊', 'title': 'Flow', 'message': 'How do I improve the flow and pacing of my poems?'},
    
    // 诗歌与生活类
    {'icon': '✨', 'title': 'Inspiration', 'message': 'I\'m feeling stuck. How can I find inspiration for writing?'},
    {'icon': '🌅', 'title': 'Daily Life', 'message': 'How can I turn everyday moments into poetry?'},
    {'icon': '💔', 'title': 'Emotions', 'message': 'How do I express deep emotions without being cliché?'},
    {'icon': '🌍', 'title': 'Nature', 'message': 'What are fresh ways to write about nature and seasons?'},
    {'icon': '👥', 'title': 'Relationships', 'message': 'How can I write about relationships in a unique way?'},
    {'icon': '🕰️', 'title': 'Memory', 'message': 'How do I capture memories and nostalgia in verse?'},
    {'icon': '🌃', 'title': 'Urban Life', 'message': 'How can I find poetry in city life and modern settings?'},
    {'icon': '🎯', 'title': 'Purpose', 'message': 'How does poetry help us understand life better?'},
    
    // 创作过程类
    {'icon': '📖', 'title': 'Reading', 'message': 'How can reading other poets improve my own writing?'},
    {'icon': '✏️', 'title': 'Revision', 'message': 'What should I focus on when revising my poems?'},
    {'icon': '🎓', 'title': 'Learning', 'message': 'What are the essential skills every poet should develop?'},
    {'icon': '🌱', 'title': 'Growth', 'message': 'How can I develop my unique poetic voice over time?'},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _shuffleTopics();
  }

  void _shuffleTopics() {
    // 随机选择4-5个话题
    final shuffled = List<Map<String, String>>.from(_allTopicTemplates)..shuffle();
    final count = 4 + (DateTime.now().millisecond % 2); // 随机4或5个
    setState(() {
      _displayedTopics = shuffled.take(count).toList();
    });
  }

  void _toggleTopicTemplates() {
    setState(() {
      _topicTemplatesExpanded = !_topicTemplatesExpanded;
      if (_topicTemplatesExpanded) {
        _shuffleTopics(); // 展开时重新随机选择话题
      }
    });
  }

  void _loadInitialMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '0',
          sender: MessageSender.system,
          content: 'Welcome to AI Muse, your poetic guide. I\'m here to help you explore imagery, discuss techniques, and refine your craft.\n\nI won\'t write poems for you, but I\'ll guide you to discover your own voice. What would you like to explore today?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      ]);
    });
  }

  void _sendMessage({String? customMessage}) async {
    final messageContent = customMessage ?? _controller.text.trim();
    if (messageContent.isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.user,
      content: messageContent,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _topicTemplatesExpanded = false; // 收起话题模板
    });

    if (customMessage == null) {
      _controller.clear();
    }
    _scrollToBottom();

    try {
      final response = await _aiService.sendMessage(messageContent, context: _messages);
      
      setState(() {
        _messages.add(response);
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: AppColors.ribbon,
          ),
        );
      }
    }
  }

  void _deleteMessage(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paperLight,
        title: Text('Delete Message?', style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
        content: Text('This message will be removed from the conversation.', style: AppTextStyles.bodyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.bodyText.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.removeWhere((msg) => msg.id == messageId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Delete', style: AppTextStyles.bodyText.copyWith(color: AppColors.ribbon)),
          ),
        ],
      ),
    );
  }

  void _reportMessage(String messageId) {
    showDialog(
      context: context,
      builder: (context) => _ReportDialog(messageId: messageId),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paperLight,
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.olive, size: 24),
            const SizedBox(width: 8),
            Text('AI Muse Guide', style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, fontFamily: 'serif')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What AI Muse Can Do',
                style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: AppColors.olive),
              ),
              const SizedBox(height: 8),
              Text(
                '• Discuss imagery and symbolism\n'
                '• Analyze poetic techniques\n'
                '• Suggest improvements to your drafts\n'
                '• Explore themes and emotions\n'
                '• Teach about meter, rhyme, and structure\n'
                '• Provide writing prompts and exercises',
                style: AppTextStyles.bodyText.copyWith(height: 1.6),
              ),
              const SizedBox(height: 16),
              Text(
                'Ethical Boundaries',
                style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: AppColors.ribbon),
              ),
              const SizedBox(height: 8),
              Text(
                'AI Muse will NOT write complete poems for you. The creative journey must be yours. This ensures you develop your own voice and skills.',
                style: AppTextStyles.bodyText.copyWith(height: 1.6),
              ),
              const SizedBox(height: 16),
              Text(
                'Message Actions',
                style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: AppColors.ink),
              ),
              const SizedBox(height: 8),
              Text(
                '• Long press any message to see options\n'
                '• Report: Flag inappropriate content\n'
                '• Delete: Remove message from conversation',
                style: AppTextStyles.bodyText.copyWith(height: 1.6),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it', style: AppTextStyles.bodyText.copyWith(color: AppColors.olive, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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

  void _clearConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paperLight,
        title: Text('Clear Conversation?', style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
        content: Text('This will delete all messages in the current conversation.', style: AppTextStyles.bodyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.bodyText.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _aiService.clearHistory();
                _loadInitialMessages();
              });
              Navigator.pop(context);
            },
            child: Text('Clear', style: AppTextStyles.bodyText.copyWith(color: AppColors.ribbon)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击非输入框区域时收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _messages.length) {
                      return ChatBubble(
                        message: _messages[index],
                        onDelete: () => _deleteMessage(_messages[index].id),
                        onReport: () => _reportMessage(_messages[index].id),
                      );
                    } else {
                      return _buildLoadingIndicator();
                    }
                  },
                ),
              ),
              if (_showTopicTemplates) _buildTopicTemplates(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.paperLight,
            AppColors.paper,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6B8E23),
                      AppColors.olive,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.olive.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Muse',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.olive,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.olive.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'POETIC GUIDE',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.olive,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.olive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.help_outline, color: AppColors.olive, size: 22),
                  onPressed: _showHelpDialog,
                  tooltip: 'Help & Guidelines',
                ),
              ),
              const SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 20),
                  onPressed: _clearConversation,
                  tooltip: 'Clear conversation',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicTemplates() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.paperLight.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.olive.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.olive.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleTopicTemplates,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.olive.withValues(alpha: 0.08),
                    AppColors.olive.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.olive.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _topicTemplatesExpanded ? Icons.lightbulb : Icons.lightbulb_outline,
                      color: AppColors.olive,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'SUGGESTED TOPICS',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.olive,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.olive.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _topicTemplatesExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.olive,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_topicTemplatesExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(14),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _displayedTopics.map((template) {
                  return InkWell(
                    onTap: () => _sendMessage(customMessage: template['message']),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            AppColors.paperLight.withValues(alpha: 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.cardBorder.withValues(alpha: 0.6),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.olive.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              template['icon']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            template['title']!,
                            style: AppTextStyles.bodyText.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: InkWell(
                  onTap: _shuffleTopics,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.olive.withValues(alpha: 0.12),
                          AppColors.olive.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.olive.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 16, color: AppColors.olive),
                        const SizedBox(width: 6),
                        Text(
                          'Refresh Topics',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.olive,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.paperLight.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: AppColors.olive.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.olive.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.olive.withValues(alpha: 0.15),
                    AppColors.olive.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.olive),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'AI Muse is thinking...',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Crafting a thoughtful response',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.paper,
            AppColors.paperLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.cardBorder.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  maxLength: 300,
                  maxLines: null,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  enabled: !_isLoading,
                  style: AppTextStyles.bodyText.copyWith(height: 1.4),
                  decoration: InputDecoration(
                    hintText: 'Discuss imagery, rhyme, or technique...',
                    hintStyle: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                    filled: false,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: AppColors.olive, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _isLoading ? null : _sendMessage,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: _isLoading
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.olive.withValues(alpha: 0.5),
                            AppColors.olive.withValues(alpha: 0.4),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6B8E23),
                            AppColors.olive,
                          ],
                        ),
                  shape: BoxShape.circle,
                  boxShadow: _isLoading
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.olive.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(14),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// 举报对话框组件
class _ReportDialog extends StatefulWidget {
  final String messageId;

  const _ReportDialog({required this.messageId});

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedReason;

  final List<Map<String, String>> _reportReasons = [
    {'value': 'inappropriate', 'label': 'Inappropriate Content', 'icon': '🚫'},
    {'value': 'spam', 'label': 'Spam or Advertising', 'icon': '📢'},
    {'value': 'harassment', 'label': 'Harassment or Bullying', 'icon': '⚠️'},
    {'value': 'misinformation', 'label': 'Misinformation', 'icon': '❌'},
    {'value': 'other', 'label': 'Other', 'icon': '📝'},
  ];

  void _submitReport() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for reporting'),
          backgroundColor: AppColors.ribbon,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 这里可以添加实际的举报提交逻辑
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you. Your report has been submitted.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击对话框外部区域收起键盘
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        backgroundColor: AppColors.paperLight,
        title: Row(
          children: [
            const Icon(Icons.flag_outlined, color: AppColors.ribbon, size: 24),
            const SizedBox(width: 8),
            Text(
              'Report Message',
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help us keep the community safe by reporting inappropriate content.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reason for reporting',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              ..._reportReasons.map((reason) {
                final isSelected = _selectedReason == reason['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedReason = reason['value'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.olive.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.olive
                            : AppColors.cardBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          reason['icon']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reason['label']!,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.olive
                                  : AppColors.ink,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.olive,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Text(
                'Additional details (optional)',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // 点击输入框时不收起键盘
                },
                child: TextField(
                  controller: _detailsController,
                  maxLength: 200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Provide more context about this report...',
                    hintStyle: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterStyle: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.olive,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _submitReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ribbon,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Submit Report',
              style: AppTextStyles.bodyText.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}
