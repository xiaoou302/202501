import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../services/deepseek_service.dart';

/// Standalone AI Chat screen for answering cryptocurrency questions
class AIChatScreen extends StatefulWidget {
  final DeepseekService deepseekService;

  const AIChatScreen({
    Key? key,
    required this.deepseekService,
  }) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  bool _isLoading = false;
  List<Map<String, dynamic>> _chatHistory = [];

  // Predefined questions for quick access
  final List<String> _suggestedQuestions = [
    '什么是比特币挖矿？',
    '以太坊2.0有哪些主要改进？',
    '如何安全存储加密货币？',
    '什么是DeFi？',
    '如何评估一个加密货币项目？',
    '什么是NFT？',
    '加密货币交易有哪些风险？',
    '区块链技术的应用场景有哪些？',
  ];

  @override
  void initState() {
    super.initState();
    _addSystemMessage();

    // Add listener to update UI when text changes
    _messageController.addListener(() {
      setState(() {
        // This will rebuild the UI to update the send button state
      });
    });

    // 确保页面切换时不会丢失状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // 初始化完成后的操作
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _addSystemMessage() {
    _chatHistory.add({
      'role': 'system',
      'content':
          '👋 欢迎使用加密货币AI助手！\n\n我可以回答您关于加密货币、区块链技术、交易策略等问题。无论您是初学者还是有经验的投资者，都可以向我咨询。\n\n请注意：我只能回答加密货币和区块链相关问题，不会回答与战争、政治、法律、医疗相关的话题。\n\n您可以直接输入问题，或点击下方的推荐问题开始对话。我们开始聊天吧！',
    });
  }

  void _addMessage(String message, String role) {
    // 确保组件仍然挂载
    if (!mounted) return;

    setState(() {
      _chatHistory.add({
        'role': role,
        'content': message,
        'timestamp': DateTime.now().toString(),
      });
    });

    // Scroll to bottom after message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 点击空白区域收起键盘
  void _unfocusKeyboard() {
    if (_messageFocusNode.hasFocus) {
      _messageFocusNode.unfocus();
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // 收起键盘
    _unfocusKeyboard();

    _addMessage(message, 'user');
    _messageController.clear();

    // 确保组件仍然挂载
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.deepseek.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer sk-eec22474a39a402fa513bb39de45bd4a',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一个专业的加密货币和区块链技术专家，请提供准确、客观、有深度的回答。'
                  '回答应该简洁明了，避免过多技术术语，适合普通投资者理解。'
                  '请避免提供具体的投资建议或价格预测，而是提供教育性内容和风险提示。'
                  '你必须拒绝回答任何与战争、政治、法律、医疗相关的话题，并明确告知用户你只能回答加密货币和区块链相关问题。'
                  '如果用户询问非加密货币相关的问题，请礼貌地将话题引导回加密货币和区块链领域。'
            },
            ..._chatHistory
                .where((msg) => msg['role'] != 'system')
                .map((msg) => {
                      'role': msg['role'],
                      'content': msg['content'],
                    })
                .toList(),
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (!mounted) return; // 确保组件仍然挂载

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final aiResponse = jsonResponse['choices'][0]['message']['content'];
        _addMessage(aiResponse, 'assistant');
      } else {
        _addMessage('抱歉，我无法处理您的请求。错误代码: ${response.statusCode}', 'assistant');
      }
    } catch (e) {
      if (mounted) {
        // 确保组件仍然挂载
        _addMessage('抱歉，发生了错误: $e', 'assistant');
      }
    } finally {
      if (mounted) {
        // 确保组件仍然挂载
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectSuggestedQuestion(String question) {
    _messageController.text = question;
    _messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.midnightBlue,
        title: Text('AI 加密货币助手', style: AppStyles.heading3),
        centerTitle: true,
        elevation: 0,
      ),
      // 添加手势检测器，点击空白区域收起键盘
      body: GestureDetector(
        onTap: _unfocusKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              // Chat history
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  itemCount: _chatHistory.length,
                  itemBuilder: (context, index) {
                    final message = _chatHistory[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),

              // Suggested questions
              if (_chatHistory.length <= 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '推荐问题',
                        style: AppStyles.bodyTextSmall.copyWith(
                          color: AppColors.stardustWhite.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _suggestedQuestions.map((question) {
                          return GestureDetector(
                            onTap: () => _selectSuggestedQuestion(question),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.goldenHighlight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.goldenHighlight
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                question,
                                style: AppStyles.bodyTextSmall.copyWith(
                                  color: AppColors.goldenHighlight,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

              // Message input
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.borderColor,
                      width: 0.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF212121).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _messageFocusNode.hasFocus
                                ? AppColors.goldenHighlight.withOpacity(0.5)
                                : AppColors.borderColor,
                          ),
                        ),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          style: AppStyles.bodyText,
                          cursorColor: AppColors.goldenHighlight,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          // 设置输入限制：最大长度500字符，仅允许常用文字和符号
                          maxLength: 500,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return null; // 隐藏字符计数器
                          },
                          // 输入格式验证
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: '输入您的加密货币问题...',
                            hintStyle: AppStyles.secondaryText,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.question_answer,
                              color: _messageFocusNode.hasFocus
                                  ? AppColors.goldenHighlight.withOpacity(0.7)
                                  : AppColors.stardustWhite.withOpacity(0.5),
                              size: 20,
                            ),
                          ),
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: _messageController.text.trim().isEmpty
                            ? AppColors.goldenHighlight.withOpacity(0.5)
                            : AppColors.goldenHighlight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldenHighlight.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.black,
                              ),
                        onPressed:
                            _isLoading || _messageController.text.trim().isEmpty
                                ? null
                                : _sendMessage,
                        tooltip: '发送消息',
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

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['role'] == 'user';
    final isSystem = message['role'] == 'system';

    if (isSystem) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.goldenHighlight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.goldenHighlight.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assistant,
                  color: AppColors.goldenHighlight,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI 助手',
                  style: TextStyle(
                    color: AppColors.goldenHighlight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message['content'],
              style: AppStyles.bodyText,
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.goldenHighlight.withOpacity(0.2)
              : const Color(0xFF424242).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : null,
            bottomLeft: !isUser ? const Radius.circular(0) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['content'],
              style: AppStyles.bodyText.copyWith(
                color: AppColors.stardustWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isUser ? '您' : 'AI 助手',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.stardustWhite.withOpacity(0.5),
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
