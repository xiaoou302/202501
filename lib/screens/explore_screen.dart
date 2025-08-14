import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/mission.dart';
import '../services/ai_service.dart';
import '../services/deepseek_ai_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 探索屏幕，现在作为AI助手界面
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final AIService _aiService = AIService();
  final DeepseekAIService _deepseekAIService = DeepseekAIService();
  final StorageService _storageService = StorageService();

  List<Message> _messages = [];
  Mission? _currentMission;
  bool _isLoading = true;
  bool _isProcessing = false;
  List<String> _quickSuggestions = [];
  bool _mounted = true;

  // 动画控制器
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();

    // 初始化动画控制器
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingAnimationController.dispose();
    _mounted = false;
    super.dispose();
  }

  /// 加载数据
  Future<void> _loadData() async {
    if (!_mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 加载任务
      final missions = await _storageService.getMissions(MissionType.plan);
      if (missions.isNotEmpty) {
        _currentMission = missions[0];
      }

      // 加载保存的消息历史
      await _loadMessageHistory();

      // 如果没有历史消息，则初始化默认消息
      if (_messages.isEmpty) {
        _initializeMessages();
      }

      // 生成快速建议
      _quickSuggestions = await _deepseekAIService.generateQuickSuggestions(
        _currentMission,
      );
    } catch (e) {
      print('Failed to load data: $e');

      // 回退到本地生成的建议
      _initializeMessages();
      _quickSuggestions = _aiService.generateQuickSuggestions(_currentMission);
    } finally {
      if (!_mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 加载消息历史
  Future<void> _loadMessageHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if messages were explicitly deleted
      final wasDeleted = prefs.getBool('chat_messages_deleted') ?? false;
      if (wasDeleted) {
        // User previously deleted messages, don't load history
        return;
      }

      final messagesJson = prefs.getStringList('chat_messages');

      if (messagesJson != null && messagesJson.isNotEmpty) {
        _messages = messagesJson
            .map((json) => Message.fromJson(jsonDecode(json)))
            .toList();
      }
    } catch (e) {
      print('Failed to load message history: $e');
      // If loading fails, we'll initialize with default messages
    }
  }

  /// 保存消息历史
  Future<void> _saveMessageHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert messages to JSON
      final messagesJson = _messages
          .where((message) => !message.isTyping) // Don't save typing indicators
          .map((message) => jsonEncode(message.toJson()))
          .toList();

      // Save to SharedPreferences
      await prefs.setStringList('chat_messages', messagesJson);

      // Reset deletion flag since we're actively saving messages
      await prefs.setBool('chat_messages_deleted', false);

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversation saved'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to save message history: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save conversation: $e'),
          backgroundColor: AppTheme.errorRed,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// 初始化消息
  void _initializeMessages() {
    _messages = [
      Message(
        text:
            'Hello! I\'m Virelia AI, your personal assistant. How can I help you today?',
        isFromAI: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    if (_currentMission != null) {
      _messages.add(
        Message(
          text:
              'I notice you\'re planning "${_currentMission!.title}". Would you like help adjusting your plan or some suggestions?',
          isFromAI: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );
    }
  }

  /// 发送消息
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // 收起键盘
    FocusScope.of(context).unfocus();

    // 添加用户消息
    final userMessage = Message(
      text: text,
      isFromAI: false,
      timestamp: DateTime.now(),
    );

    if (!_mounted) return;

    setState(() {
      _messages.add(userMessage);
      _isProcessing = true;
      _messageController.clear();
    });

    // 滚动到底部
    _scrollToBottom();

    // 添加临时"正在输入"消息
    final typingMessage = Message(
      text: '正在思考...',
      isFromAI: true,
      timestamp: DateTime.now(),
      isTyping: true,
    );

    if (!_mounted) return;

    setState(() {
      _messages.add(typingMessage);
    });

    // 滚动到底部
    _scrollToBottom();

    // 生成AI回复
    try {
      final response = await _deepseekAIService.generateAIResponse(
        text,
        _currentMission,
      );

      if (!_mounted) return;

      // 移除临时消息
      setState(() {
        _messages.removeLast();
      });

      // 添加AI回复
      final aiMessage = Message(
        text: response,
        isFromAI: true,
        timestamp: DateTime.now(),
      );

      if (!_mounted) return;

      setState(() {
        _messages.add(aiMessage);
        _isProcessing = false;
      });

      // 更新快速建议
      _updateQuickSuggestions();

      // 滚动到底部
      _scrollToBottom();

      // 提供触觉反馈
      HapticFeedback.mediumImpact();

      // 自动保存对话历史
      _saveMessageHistory();
    } catch (e) {
      print('生成回复失败: $e');

      if (!_mounted) return;

      // 移除临时消息
      setState(() {
        _messages.removeLast();
      });

      // 添加错误消息
      final errorMessage = Message(
        text: '抱歉，我遇到了一些问题。请稍后再试。',
        isFromAI: true,
        timestamp: DateTime.now(),
      );

      if (!_mounted) return;

      setState(() {
        _messages.add(errorMessage);
        _isProcessing = false;
      });

      // 滚动到底部
      _scrollToBottom();
    }
  }

  /// 更新快速建议
  Future<void> _updateQuickSuggestions() async {
    try {
      final suggestions = await _deepseekAIService.generateQuickSuggestions(
        _currentMission,
      );

      if (!_mounted) return;

      setState(() {
        _quickSuggestions = suggestions;
      });
    } catch (e) {
      print('更新快速建议失败: $e');
    }
  }

  /// 使用快速建议
  void _useQuickSuggestion(String suggestion) {
    _messageController.text = suggestion.replaceAll('"', '');
    _sendMessage();
  }

  /// 滚动到底部
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

  /// 清除对话历史
  void _clearConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear Conversation',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to clear all conversation history? This action cannot be undone.',
          style: TextStyle(color: AppTheme.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (!_mounted) return;

              // Clear messages in UI
              setState(() {
                _initializeMessages();
              });

              // Delete messages from persistent storage
              _deleteMessageHistory();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Delete message history from persistent storage
  Future<void> _deleteMessageHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove the stored messages
      await prefs.remove('chat_messages');

      // Set flag indicating messages were explicitly deleted
      await prefs.setBool('chat_messages_deleted', true);

      // Show confirmation
      if (!_mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversation permanently deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to delete message history: $e');

      if (!_mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete conversation: $e'),
          backgroundColor: AppTheme.errorRed,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildHeader(),
                    if (_currentMission != null) _buildContextBanner(),
                    Expanded(child: _buildMessageList()),
                    _buildQuickSuggestions(),
                    _buildInputArea(),
                  ],
                ),
        ),
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.brandBlue, AppTheme.accentOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'Virelia AI',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Clear conversation button
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppTheme.secondaryText),
            onPressed: _clearConversation,
            tooltip: 'Clear conversation',
          ),
        ],
      ),
    );
  }

  /// 构建情境横幅
  Widget _buildContextBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppTheme.primaryBackground.withOpacity(0.4),
      child: Text(
        'Current context: ${_currentMission!.title}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.secondaryText, fontSize: 14),
      ),
    );
  }

  /// 构建消息列表
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(Message message) {
    // Format timestamp
    final timeString = _formatMessageTime(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isFromAI
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: message.isFromAI
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.isFromAI) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppTheme.brandBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isFromAI
                        ? AppTheme.surfaceBackground
                        : AppTheme.accentOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: message.isFromAI
                          ? Radius.zero
                          : const Radius.circular(16),
                      bottomRight: message.isFromAI
                          ? const Radius.circular(16)
                          : Radius.zero,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: message.isTyping
                      ? _buildTypingIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              message.text,
                              style: const TextStyle(
                                color: AppTheme.primaryText,
                              ),
                            ),
                            if (message.imageUrl != null) ...[
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  message.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 200,
                                      height: 100,
                                      color: AppTheme.surfaceBackground,
                                      child: const Center(
                                        child: Icon(Icons.error_outline),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ),
              if (!message.isFromAI) ...[
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ],
          ),

          // Timestamp
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: message.isFromAI ? 38 : 0,
              right: message.isFromAI ? 0 : 38,
            ),
            child: Text(
              timeString,
              style: TextStyle(
                color: AppTheme.secondaryText.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format message timestamp
  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      // Today, show time only
      return 'Today at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // Other days
      return '${timestamp.month}/${timestamp.day} at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  /// 构建输入中指示器
  Widget _buildTypingIndicator() {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(_typingAnimation.value > 0.3),
            const SizedBox(width: 4),
            _buildDot(_typingAnimation.value > 0.5),
            const SizedBox(width: 4),
            _buildDot(_typingAnimation.value > 0.7),
          ],
        );
      },
    );
  }

  /// 构建点
  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppTheme.brandBlue
            : AppTheme.secondaryText.withOpacity(0.5),
      ),
    );
  }

  /// 构建快速建议
  Widget _buildQuickSuggestions() {
    if (_quickSuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Suggestions',
              style: TextStyle(
                color: AppTheme.secondaryText.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickSuggestions
                  .map(
                    (suggestion) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () => _useQuickSuggestion(suggestion),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.surfaceBackground,
                            foregroundColor: AppTheme.primaryText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            suggestion.replaceAll('"', ''),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration(
                hintText: 'Chat with your AI assistant...',
                hintStyle: const TextStyle(color: AppTheme.secondaryText),
                filled: true,
                fillColor: AppTheme.surfaceBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabled: !_isProcessing,
                // Hide counter
                counterText: '',
              ),
              style: const TextStyle(color: AppTheme.primaryText),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
              // 限制输入长度
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              // Enable smart suggestions
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              // Track changes for character count
              onChanged: (value) {
                setState(() {
                  // Trigger UI update for character count
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  _isProcessing ? AppTheme.secondaryText : AppTheme.brandBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isProcessing
                  ? const SpinKitDoubleBounce(color: Colors.white, size: 24)
                  : const Icon(Icons.send, color: Colors.white),
              onPressed: _isProcessing ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

/// 消息模型
class Message {
  final String text;
  final bool isFromAI;
  final DateTime timestamp;
  final bool isTyping;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  Message({
    required this.text,
    required this.isFromAI,
    required this.timestamp,
    this.isTyping = false,
    this.imageUrl,
    this.metadata,
  });

  /// Create a copy of this message with updated properties
  Message copyWith({
    String? text,
    bool? isFromAI,
    DateTime? timestamp,
    bool? isTyping,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      text: text ?? this.text,
      isFromAI: isFromAI ?? this.isFromAI,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert message to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isFromAI': isFromAI,
      'timestamp': timestamp.toIso8601String(),
      'isTyping': isTyping,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }

  /// Create message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] as String,
      isFromAI: json['isFromAI'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isTyping: json['isTyping'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
