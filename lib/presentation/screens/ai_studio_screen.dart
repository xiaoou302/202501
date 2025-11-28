import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../services/deepseek_service.dart';
import '../../data/models/dance_topic_model.dart';

class AIStudioScreen extends StatefulWidget {
  const AIStudioScreen({super.key});

  @override
  State<AIStudioScreen> createState() => _AIStudioScreenState();
}

class _AIStudioScreenState extends State<AIStudioScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持页面状态
  final DeepSeekService _aiService = DeepSeekService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _conversationHistory = [];
  bool _isAITyping = false;
  bool _showTopics = true;
  bool _isPageActive = true; // 跟踪页面是否活跃

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // 标记页面失活
    _isPageActive = false;
    
    // 页面切换时收起键盘
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
    
    // 注意：不再停止AI回复，让它在后台继续完成
    // 打字指示器会保持显示，直到AI回复完成
    
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 页面重新激活时标记并刷新UI
    if (!_isPageActive) {
      _isPageActive = true;
      // 强制刷新UI，确保显示后台完成的消息
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addWelcomeMessage() {
    if (_messages.isEmpty) {
      final welcomeMessage = ChatMessage(
        content: "Hello! I'm your personal dance master! 🩰✨\n\nI'm here to help you with:\n• Dance techniques and movements\n• Artistic expression and performance\n• Training tips and practice routines\n• Dance styles and history\n\nFeel free to ask me anything about dance, or tap on a topic below to get started!",
        isUser: false,
        timestamp: DateTime.now(),
      );
      // 直接添加到列表，不使用setState，因为这是在初始化时调用
      _messages.add(welcomeMessage);
    }
  }

  void _sendMessage(String text, {String? displayImage, String? category}) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;
    
    if (!mounted) return;
    
    // 检查字符长度
    if (trimmedText.length > 300) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Message too long. Maximum 300 characters.')),
            ],
          ),
          backgroundColor: AppConstants.theatreRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // 添加用户消息
    final userMessage = ChatMessage(
      content: trimmedText,
      isUser: true,
      timestamp: DateTime.now(),
      imagePath: displayImage,
      category: category,
    );

    if (!mounted) return;
    
    setState(() {
      _messages.add(userMessage);
      _textController.clear();
      _isAITyping = true;
      _showTopics = false;
    });

    // 收起键盘
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
    
    // 确保滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      // 调用AI服务 - 传递之前的对话历史（不包括当前消息）
      // sendMessage 方法会在内部添加当前用户消息到请求中
      print('Sending to AI with history length: ${_conversationHistory.length}');
      final aiResponse = await _aiService.sendMessage(trimmedText, _conversationHistory);
      print('AI response received');
      
      // AI回复完成后，添加用户消息和AI回复到历史
      _conversationHistory.add({'role': 'user', 'content': trimmedText});
      _conversationHistory.add({'role': 'assistant', 'content': aiResponse});

      // 添加AI消息
      final aiMessage = ChatMessage(
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // 只有在mounted时才更新UI
      if (mounted) {
        setState(() {
          _messages.add(aiMessage);
          _isAITyping = false;
        });

        // 确保滚动到底部
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        // 即使页面不在，也要更新状态
        _messages.add(aiMessage);
        _isAITyping = false;
      }
    } catch (e) {
      // 即使出错也要保存错误消息
      final errorMessage = ChatMessage(
        content: 'Sorry, I encountered an error. Please try again. Error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      // 只有在mounted时才更新UI
      if (mounted) {
        setState(() {
          _messages.add(errorMessage);
          _isAITyping = false;
        });
      } else {
        _messages.add(errorMessage);
        _isAITyping = false;
      }
    }
  }

  void _sendTopicQuestion(DanceTopic topic) {
    if (!mounted) return;
    
    setState(() {
      _showTopics = false; // 收起话题卡片
    });
    _sendMessage(topic.question, displayImage: topic.imagePath, category: topic.category);
  }

  void _toggleTopics() {
    if (!mounted) return;
    
    setState(() {
      _showTopics = !_showTopics;
    });
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.delete_sweep_rounded,
              color: AppConstants.theatreRed,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Clear All Messages',
              style: TextStyle(
                color: AppConstants.offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to clear all chat messages? This action cannot be undone.',
          style: TextStyle(
            color: AppConstants.midGray,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _clearAllMessages();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                color: AppConstants.theatreRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllMessages() {
    if (!mounted) return;
    
    setState(() {
      _messages.clear();
      _conversationHistory.clear();
      _showTopics = true;
      
      // 在setState中添加欢迎消息
      final welcomeMessage = ChatMessage(
        content: "Hi! I'm your personal AI dance coach! 🩰\n\nI can help you with:\n• Dance technique advice\n• Beginner guidance\n• Pose analysis from photos\n• Practice recommendations\n\nWhat would you like to know about dance?",
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(welcomeMessage);
    });
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('All messages cleared'),
          ],
        ),
        backgroundColor: AppConstants.graphite,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showMessageOptions(ChatMessage message, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppConstants.graphite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.midGray.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.theatreRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: AppConstants.theatreRed,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Delete Message',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Remove this message from chat',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(index);
                },
              ),
              if (!message.isUser)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.techBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: AppConstants.techBlue,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Report Message',
                    style: TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Report inappropriate content',
                    style: TextStyle(
                      color: AppConstants.midGray.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _reportMessage(message);
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMessage(int index) {
    if (!mounted) return;
    
    final message = _messages[index];
    
    setState(() {
      _messages.removeAt(index);
    });

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Message deleted'),
          ],
        ),
        backgroundColor: AppConstants.graphite,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppConstants.techBlue,
          onPressed: () {
            setState(() {
              _messages.insert(index, message);
            });
          },
        ),
      ),
    );
  }

  void _reportMessage(ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.flag_rounded,
              color: AppConstants.techBlue,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Report Message',
              style: TextStyle(
                color: AppConstants.offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this message?',
              style: TextStyle(
                color: AppConstants.midGray,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            _buildReportOption('Inappropriate content'),
            _buildReportOption('Incorrect information'),
            _buildReportOption('Offensive language'),
            _buildReportOption('Other'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(String reason) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _submitReport(reason);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppConstants.ebony.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.midGray.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.radio_button_unchecked,
              size: 20,
              color: AppConstants.midGray.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Text(
              reason,
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReport(String reason) {
    if (!mounted) return;
    
    // 这里可以实现实际的举报逻辑，比如发送到服务器
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Report submitted: $reason'),
            ),
          ],
        ),
        backgroundColor: AppConstants.techBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _scrollToBottom() {
    // 只检查mounted，不检查页面是否活跃
    // 这样当用户返回页面时，会自动滚动到最新消息
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 再次检查
      if (!mounted || !_scrollController.hasClients) return;
      
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，用于AutomaticKeepAliveClientMixin
    
    return GestureDetector(
      onTap: () {
        // 点击非输入框区域收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppConstants.ebony,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 点击聊天区域也收起键盘
                    FocusScope.of(context).unfocus();
                  },
                  child: _messages.isEmpty
                      ? _buildEmptyState()
                      : _buildChatList(),
                ),
              ),
              if (_messages.length > 1) _buildTopicsToggleButton(),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _showTopics && _messages.length > 1
                    ? _buildTopicsSection()
                    : (_messages.length <= 1 ? _buildTopicsSection() : const SizedBox.shrink()),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.ebony,
            AppConstants.graphite.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppConstants.techBlue, AppConstants.balletPink],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.techBlue.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Dance Master',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00FF00),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00FF00),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Online & Ready',
                      style: TextStyle(
                        color: AppConstants.midGray.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 清除按钮
          if (_messages.length > 1)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: AppConstants.theatreRed,
                size: 24,
              ),
              onPressed: _showClearConfirmDialog,
              tooltip: 'Clear all messages',
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppConstants.techBlue, AppConstants.balletPink],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.techBlue.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your AI Dance Master',
            style: TextStyle(
              color: AppConstants.offWhite,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Ask me anything about dance techniques, training, or performance!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (_isAITyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isAITyping) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final index = _messages.indexOf(message);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.techBlue, AppConstants.balletPink],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showMessageOptions(message, index),
              child: Column(
                crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // 如果有图片，显示为完整的话题卡片
                  if (message.imagePath != null && message.category != null)
                    Container(
                    width: 240,
                    height: 160,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            message.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppConstants.graphite,
                                child: const Icon(
                                  Icons.image_rounded,
                                  color: AppConstants.midGray,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.85),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppConstants.techBlue, AppConstants.balletPink],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppConstants.techBlue.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    message.category!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  message.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // 普通文字消息
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: message.isUser
                          ? const LinearGradient(
                              colors: [AppConstants.theatreRed, AppConstants.balletPink],
                            )
                          : LinearGradient(
                              colors: [
                                AppConstants.graphite.withValues(alpha: 0.6),
                                AppConstants.graphite.withValues(alpha: 0.4),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.content,
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
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.theatreRed, AppConstants.balletPink],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppConstants.techBlue, AppConstants.balletPink],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.graphite.withValues(alpha: 0.6),
                  AppConstants.graphite.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('dot_$index'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        final opacity = (animValue * 2).clamp(0.3, 1.0);
        
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            shape: BoxShape.circle,
          ),
        );
      },
      // 移除onEnd回调，避免无限循环
    );
  }

  Widget _buildTopicsToggleButton() {
    return GestureDetector(
      onTap: _toggleTopics,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.graphite.withValues(alpha: 0.6),
              AppConstants.graphite.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.midGray.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_rounded,
              color: AppConstants.techBlue,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _showTopics ? 'Hide Topics' : 'Show Topics',
              style: TextStyle(
                color: AppConstants.offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: _showTopics ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppConstants.techBlue,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicsSection() {
    final topics = DanceTopic.getAllTopics();
    
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.ebony.withValues(alpha: 0.0),
            AppConstants.ebony,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: AppConstants.techBlue,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Popular Topics',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '${topics.length} questions',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: topics.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _buildTopicCard(topics[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(DanceTopic topic) {
    return GestureDetector(
      onTap: () => _sendTopicQuestion(topic),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                topic.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppConstants.graphite,
                    child: const Icon(
                      Icons.image_rounded,
                      color: AppConstants.midGray,
                      size: 40,
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppConstants.techBlue.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        topic.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      topic.question,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.graphite.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: AppConstants.midGray.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppConstants.ebony,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppConstants.midGray.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask about dance...',
                      hintStyle: TextStyle(
                        color: AppConstants.midGray.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    maxLines: null,
                    maxLength: 300,
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      return null; // 隐藏默认计数器
                    },
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) => _sendMessage(text),
                    onChanged: (text) {
                      // 使用postFrameCallback避免在build期间调用setState
                      if (mounted && _isPageActive) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && _isPageActive) {
                            setState(() {}); // 更新字符计数显示
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppConstants.techBlue, AppConstants.balletPink],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.techBlue.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: () => _sendMessage(_textController.text),
                ),
              ),
            ],
          ),
          // 字符计数显示
          if (_textController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${_textController.text.length}/300',
                    style: TextStyle(
                      color: _textController.text.length > 300
                          ? AppConstants.theatreRed
                          : AppConstants.midGray.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;
  final String? category;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
    this.category,
  });
}
