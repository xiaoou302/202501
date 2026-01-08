import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_palette.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/suggested_question.dart';
import '../../data/repositories/ai_repository.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/suggested_question_card.dart';

final aiRepositoryProvider = Provider((ref) => AiRepository());

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier(ref.watch(aiRepositoryProvider));
});

final isLoadingProvider = StateProvider<bool>((ref) => false);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final AiRepository _repository;

  ChatMessagesNotifier(this._repository) : super([
    ChatMessage(
      id: '1',
      type: MessageType.text,
      content: 'Hi! I\'m your street photography and fashion styling consultant 👋\n\nI can help you with street photography techniques, styling tips, color coordination, and more. Ask me anything or tap a suggested topic below!',
      timestamp: DateTime.now(),
      isUser: false,
    ),
  ]);

  Future<void> sendMessage(String content) async {
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.text,
      content: content,
      timestamp: DateTime.now(),
      isUser: true,
    );

    state = [...state, userMessage];

    try {
      final aiResponse = await _repository.sendMessage(content);
      state = [...state, aiResponse];
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.text,
        content: 'Sorry, an error occurred. Please try again later.',
        timestamp: DateTime.now(),
        isUser: false,
      );
      state = [...state, errorMessage];
    }
  }

  void deleteMessage(String messageId) {
    state = state.where((msg) => msg.id != messageId).toList();
  }

  void clearChat() {
    _repository.clearHistory();
    state = [
      ChatMessage(
        id: '1',
        type: MessageType.text,
        content: 'Hi! I\'m your street photography and fashion styling consultant 👋\n\nI can help you with street photography techniques, styling tips, color coordination, and more. Ask me anything or tap a suggested topic below!',
        timestamp: DateTime.now(),
        isUser: false,
      ),
    ];
  }
}

class AiChatScreen extends ConsumerStatefulWidget {
  final String? initialQuestion;
  
  const AiChatScreen({super.key, this.initialQuestion});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasInitialized = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    
    // Listen to message changes and auto-scroll
    ref.listenManual(chatMessagesProvider, (previous, next) {
      if (previous != null && next.length > previous.length) {
        _scrollToBottom();
      }
    });
    
    // Send initial question if provided
    if (widget.initialQuestion != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasInitialized) {
          _hasInitialized = true;
          _sendMessage(widget.initialQuestion);
        }
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
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
  }

  void _sendMessage([String? customMessage]) async {
    final message = customMessage ?? _controller.text.trim();
    if (message.isEmpty) return;
    
    if (customMessage == null) {
      _controller.clear();
    }
    
    // Scroll to bottom after user message
    _scrollToBottom();
    
    if (!_isDisposed) {
      ref.read(isLoadingProvider.notifier).state = true;
    }
    
    await ref.read(chatMessagesProvider.notifier).sendMessage(message);
    
    if (!_isDisposed) {
      ref.read(isLoadingProvider.notifier).state = false;
      
      // Scroll to bottom after AI response
      _scrollToBottom();
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!_isDisposed) {
                ref.read(chatMessagesProvider.notifier).clearChat();
              }
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: AppColors.accent),
            const SizedBox(width: 8),
            const Text('Chat Features'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                Icons.chat_bubble_outline,
                'Ask Questions',
                'Type your questions about street photography and fashion styling in the input field.',
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                Icons.touch_app,
                'Long Press Messages',
                'Long press any message bubble to see options.',
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                Icons.delete_outline,
                'Delete Message',
                'Long press a message and select "Delete" to remove it from the conversation.',
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                Icons.flag_outlined,
                'Report Message',
                'Long press a message and select "Report" if you find inappropriate content. This helps us improve the AI.',
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                Icons.cleaning_services_outlined,
                'Clear All',
                'Tap the trash icon in the header to clear all messages and start fresh.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grayDark.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMessageLongPress(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.flag_outlined, color: AppColors.warning),
                title: const Text('Report Message'),
                subtitle: const Text('Report inappropriate content'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(message);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Delete Message'),
                subtitle: const Text('Remove from conversation'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _reportMessage(ChatMessage message) {
    final reasonController = TextEditingController();
    final focusNode = FocusNode();
    String? selectedReason;
    
    final reasons = [
      'Inappropriate content',
      'Offensive language',
      'Misinformation',
      'Spam',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return GestureDetector(
            onTap: () {
              // 点击非输入框区域时收起键盘
              focusNode.unfocus();
            },
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.flag_outlined, color: AppColors.warning),
                  const SizedBox(width: 8),
                  const Text('Report Message'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Message content:'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message.content,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Report reason:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...reasons.map((reason) {
                      return RadioListTile<String>(
                        title: Text(reason, style: const TextStyle(fontSize: 14)),
                        value: reason,
                        groupValue: selectedReason,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: AppColors.accent,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedReason = value;
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    const Text(
                      'Additional details (optional):',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // 点击输入框时不关闭键盘
                      },
                      child: TextField(
                        controller: reasonController,
                        focusNode: focusNode,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: 'Describe the issue...',
                          hintStyle: TextStyle(
                            color: AppColors.grayDark.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.gray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.accent, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          counterStyle: TextStyle(
                            fontSize: 11,
                            color: AppColors.grayDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    reasonController.dispose();
                    focusNode.dispose();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: selectedReason == null
                      ? null
                      : () {
                          reasonController.dispose();
                          focusNode.dispose();
                          Navigator.pop(dialogContext);
                          
                          if (!_isDisposed && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text('Message reported. Thank you for your feedback.'),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  child: Text(
                    'Report',
                    style: TextStyle(
                      color: selectedReason == null
                          ? AppColors.grayDark.withValues(alpha: 0.4)
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) {
      // 确保对话框关闭时清理资源
      try {
        reasonController.dispose();
        focusNode.dispose();
      } catch (_) {
        // 资源已经被清理
      }
    });
  }

  void _deleteMessage(ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!_isDisposed) {
                ref.read(chatMessagesProvider.notifier).deleteMessage(message.id);
              }
              Navigator.pop(context);
              
              if (!_isDisposed && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Message deleted'),
                      ],
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildWelcomeSection();
                    }
                    if (index <= messages.length) {
                      return ChatBubble(
                        message: messages[index - 1],
                        onLongPress: () => _handleMessageLongPress(messages[index - 1]),
                      );
                    }
                    if (isLoading) {
                      return _buildLoadingIndicator();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              _buildSuggestedQuestions(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: AppColors.text,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent,
                            AppColors.accent.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Style Consultant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'AI ONLINE',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.grayDark,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline_rounded, size: 22),
              color: AppColors.accent,
              onPressed: _showHelpDialog,
              tooltip: 'Help',
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 22),
              color: AppColors.grayDark,
              onPressed: _showClearConfirmation,
              tooltip: 'Clear chat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Start conversation',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.grayDark.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.text,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16).copyWith(
                topLeft: Radius.zero,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.grayDark.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Thinking...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    final messages = ref.watch(chatMessagesProvider);
    
    // Only show suggested questions at the start of conversation
    if (messages.length > 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: suggestedQuestions.length,
        itemBuilder: (context, index) {
          return SuggestedQuestionCard(
            question: suggestedQuestions[index],
            onTap: () => _sendMessage(suggestedQuestions[index].question),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface.withValues(alpha: 0.95),
            AppColors.surface,
          ],
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 48, maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.gray.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                maxLength: 300,
                enabled: !isLoading,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  counterText: '',
                  hintText: isLoading ? 'AI is thinking...' : 'Ask about style & photography...',
                  hintStyle: TextStyle(
                    color: AppColors.grayDark.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isLoading ? null : () => _sendMessage(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: isLoading
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0.8),
                        ],
                      ),
                color: isLoading ? AppColors.gray : null,
                shape: BoxShape.circle,
                boxShadow: isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(
                isLoading ? Icons.hourglass_empty_rounded : Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
