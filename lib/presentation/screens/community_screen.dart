import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/hot_topic_model.dart';
import 'package:soli/data/repositories/community_repository.dart';
import 'package:soli/presentation/widgets/chat_bubble.dart';
import 'package:soli/presentation/widgets/hot_topic_card.dart';

/// 社区页面
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, this.proposalPlan});

  // 传入的求婚方案，如果有的话
  final dynamic proposalPlan;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final CommunityRepository _communityRepository = CommunityRepository();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  List<Map<String, dynamic>> _chatMessages = [];
  List<HotTopicModel> _hotTopics = [];
  bool _isLoading = true;
  bool _isTyping = false;
  bool _isSending = false;
  String _selectedCategory = '';

  @override
  bool get wantKeepAlive => true;

  // 用户是否正在手动滚动
  bool _userScrolling = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    // Initialize typing animation controller
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _typingAnimation = CurvedAnimation(
      parent: _typingAnimationController,
      curve: Curves.easeInOut,
    );

    // Make it repeat
    _typingAnimationController.repeat(reverse: true);

    // 添加滚动监听器，检测用户是否正在手动滚动
    _scrollController.addListener(_scrollListener);

    // Clear any existing chat messages when entering the screen
    _clearChatHistory();

    _loadData();

    // 处理传入的求婚方案
    _handleProposalPlan();
  }

  // 处理传入的求婚方案
  void _handleProposalPlan() {
    // 如果有传入求婚方案，则切换到聊天标签并显示方案
    if (widget.proposalPlan != null) {
      // 延迟执行，确保界面已经构建完成
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        // 切换到聊天标签
        _tabController.animateTo(0);

        // 清空现有聊天记录
        _clearChatHistory().then((_) {
          // 添加AI欢迎消息
          _communityRepository.addAiReply(AppConstants.aiWelcomeMessage);

          // 构建方案内容
          final plan = widget.proposalPlan;
          final planMessage =
              '''
Here's a proposal plan I've created for you:

**${plan.title}**

**Type:** ${plan.type}

**Description:**
${plan.description}

**Steps:**
${plan.steps.asMap().entries.map((e) => "${e.key + 1}. ${e.value}").join("\n")}

**Materials Needed:**
${plan.materials.map((e) => "- $e").join("\n")}

**Location:** ${plan.location}
**Timing:** ${plan.timing}
**Budget:** ${plan.budget}

I hope this helps with your proposal planning! Would you like me to modify any part of this plan?
''';

          // 添加方案消息
          _communityRepository.addAiReply(planMessage);

          // 添加点击查看详情的提示
          _communityRepository.addAiReply(
            "You can tap on this message to see a detailed view of the proposal plan.",
          );

          // 重新加载消息
          _loadChatMessages();
        });
      });
    }
  }

  // Clear chat history on screen entry
  Future<void> _clearChatHistory() async {
    await _communityRepository.clearChatMessages();
  }

  // 滚动监听器
  void _scrollListener() {
    // 检测用户是否正在滚动
    if (_scrollController.position.userScrollDirection !=
        ScrollDirection.idle) {
      _userScrolling = true;
    } else {
      // 如果滚动停止，且已经接近底部，标记为非手动滚动状态
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 80) {
        _userScrolling = false;
      }
    }

    // 当用户滚动到底部时，重置滚动状态
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      _userScrolling = false;
    }
  }

  @override
  void dispose() {
    // Make sure to dispose all controllers
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();

    // Stop and dispose the animation controller
    _typingAnimationController.stop();
    _typingAnimationController.dispose();

    super.dispose();
  }

  // 控制打字动画
  void _controlTypingAnimation(bool isTyping) {
    if (isTyping) {
      if (!_typingAnimationController.isAnimating) {
        _typingAnimationController.repeat(reverse: true);
      }
    } else {
      _typingAnimationController.stop();
    }
  }

  // 隐藏键盘
  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // 加载数据
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 加载聊天消息
      await _loadChatMessages();

      // 加载热门话题
      _loadHotTopics();
    } catch (e) {
      // 处理错误，不向用户显示
      print('加载数据错误: $e');

      // 确保热门话题至少有一些数据
      if (_hotTopics.isEmpty) {
        _hotTopics = _communityRepository.getRandomHotTopics(count: 8);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 加载热门话题
  void _loadHotTopics() {
    // 获取随机热门话题
    _hotTopics = _communityRepository.getRandomHotTopics(count: 8);

    // 如果有选定的分类，则按分类筛选
    if (_selectedCategory.isNotEmpty) {
      _hotTopics = _communityRepository.getTopicsByCategory(_selectedCategory);
    }

    // 如果话题数量超过8个，随机选择8个显示
    if (_hotTopics.length > 8) {
      _hotTopics.shuffle();
      _hotTopics = _hotTopics.sublist(0, 8);
    }
  }

  // 加载聊天消息
  Future<void> _loadChatMessages() async {
    final messages = await _communityRepository.getChatMessages();

    if (mounted) {
      setState(() {
        _chatMessages = messages;
      });

      // 加载消息后自动滚动到底部
      if (_chatMessages.isNotEmpty) {
        _scrollToBottom();
      }
    }
  }

  // 发送消息
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    // 隐藏键盘
    _hideKeyboard();

    // 防止重复发送
    setState(() {
      _isSending = true;
    });

    // 清空输入框
    _messageController.clear();

    // 添加用户消息
    await _communityRepository.addUserMessage(message);

    // 重新加载消息
    await _loadChatMessages();

    // 滚动到底部
    _scrollToBottom();

    // 显示AI正在输入
    setState(() {
      _isTyping = true;
    });

    // 启动打字动画
    _controlTypingAnimation(true);

    try {
      // 生成AI回复
      await _communityRepository.generateAiReply(message);

      // 隐藏AI正在输入
      if (mounted) {
        setState(() {
          _isTyping = false;
          _isSending = false;
        });

        // 停止打字动画
        _controlTypingAnimation(false);
      }

      // 重新加载消息
      await _loadChatMessages();

      // 滚动到底部
      _scrollToBottom();
    } catch (e) {
      // 处理错误
      print('发送消息错误: $e');
      if (mounted) {
        setState(() {
          _isTyping = false;
          _isSending = false;
        });

        // 停止打字动画
        _controlTypingAnimation(false);

        // 自动添加一个通用回复而不是显示错误
        _communityRepository.addAiReply(
          'I understand your question. Let me think about how to answer...',
        );

        // 重新加载消息
        _loadChatMessages();
      }
    }
  }

  // 滚动到底部
  void _scrollToBottom() {
    // 使用更短的延迟以提高响应速度
    Future.delayed(const Duration(milliseconds: 30), () {
      // 如果控制器未附加到滚动视图，则直接返回
      if (!_scrollController.hasClients) {
        return;
      }

      // 如果用户正在手动滚动，且不是在底部附近，则不自动滚动
      if (_userScrolling &&
          _scrollController.position.pixels <
              _scrollController.position.maxScrollExtent - 150) {
        return;
      }

      // 检查当前位置是否已经接近底部，如果是则使用更平滑的动画
      final bool isNearBottom =
          _scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 100;

      // 如果已经在底部，不需要滚动
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _userScrolling = false;
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: isNearBottom ? 50 : 200),
        curve: isNearBottom ? Curves.easeOut : Curves.easeInOut,
      );

      // 重置用户滚动状态
      _userScrolling = false;
    });
  }

  // 构建AI正在输入的指示器
  Widget _buildTypingIndicator() {
    return Animations.fadeIn(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, left: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: ColorUtils.withOpacity(AppTheme.silverstone, 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ColorUtils.withOpacity(AppTheme.champagne, 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated dots
              AnimatedBuilder(
                animation: _typingAnimation,
                builder: (context, child) {
                  return Row(
                    children: List.generate(3, (index) {
                      // Stagger the animations
                      final delay = index * 0.2;
                      final animationValue = (_typingAnimation.value - delay)
                          .clamp(0.0, 1.0);

                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: ColorUtils.withOpacity(
                            AppTheme.champagne,
                            0.4 + (animationValue * 0.6),
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                'Typing...',
                style: TextStyle(
                  color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 开始新聊天
  Future<void> _startNewChat() async {
    // 清空聊天记录
    await _communityRepository.clearChatMessages();

    // 添加AI欢迎消息
    await _communityRepository.addAiReply(AppConstants.aiWelcomeMessage);

    // 重新加载消息并自动滚动到底部
    await _loadChatMessages();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: _hideKeyboard,
      child: Scaffold(
        backgroundColor: AppTheme.deepSpace,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Animations.fadeSlideIn(
                  child: Text(
                    AppConstants.titleCommunity,
                    style: const TextStyle(
                      color: AppTheme.moonlight,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 标签页 - 优化设计
                Animations.fadeSlideIn(
                  delay: 100,
                  child: Container(
                    height: 56, // 减小高度以避免溢出
                    decoration: BoxDecoration(
                      color: ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent, // 移除底部白线
                      // 使用全宽指示器
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.champagne,
                            Color(0xFFE6D2B8), // 稍微浅一点的香槟色
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.champagne.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: AppTheme.deepSpace,
                      unselectedLabelColor: AppTheme.moonlight,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // 减小字体大小
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14, // 减小字体大小
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2, // 减小内边距
                      ),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4, // 减小内边距
                      ),
                      indicatorWeight: 0, // 使用自定义indicator
                      indicatorSize: TabBarIndicatorSize.tab, // 使指示器与整个标签同宽
                      tabs: [
                        Tab(
                          height: 40, // 减小高度
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
                            children: const [
                              Icon(Icons.chat_rounded, size: 18), // 减小图标大小
                              SizedBox(height: 2), // 减小间距
                              Text('Chat'),
                            ],
                          ),
                        ),
                        Tab(
                          height: 40, // 减小高度
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
                            children: const [
                              Icon(Icons.topic_rounded, size: 18), // 减小图标大小
                              SizedBox(height: 2), // 减小间距
                              Text('Topics'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 标签页内容
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.champagne,
                          ),
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            // AI助手页面
                            _chatMessages.isEmpty
                                ? _buildEmptyChatState()
                                : _buildChatScreen(),

                            // 热门话题页面
                            _buildCommunityPosts(),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建聊天界面
  Widget _buildChatScreen() {
    return Column(
      children: [
        // 消息列表
        Expanded(
          child: GestureDetector(
            onTap: _hideKeyboard, // 点击聊天区域也隐藏键盘
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.withOpacity(AppTheme.deepSpace, 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
                  width: 1,
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = _chatMessages[index];
                    final isLastMessage = index == _chatMessages.length - 1;
                    final isFirstMessage = index == 0;
                    final isAi = message['isAi'];
                    final showAvatar =
                        isAi ||
                        isFirstMessage ||
                        (index > 0 && _chatMessages[index - 1]['isAi'] != isAi);

                    // Group messages by sender
                    final isNextSameSender =
                        index < _chatMessages.length - 1 &&
                        _chatMessages[index + 1]['isAi'] == isAi;
                    final spacing = isNextSameSender ? 6.0 : 16.0;

                    return Animations.fadeSlideIn(
                      delay: isLastMessage ? 100 : 0, // 只为最新消息添加动画
                      slideBegin: const Offset(0.0, 0.1),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: spacing),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isAi
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            // Left spacing for user messages
                            if (!isAi) const SizedBox(width: 40),

                            // Avatar for AI message (left side)
                            if (isAi && showAvatar)
                              Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(top: 4, right: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorUtils.withOpacity(
                                    AppTheme.champagne,
                                    0.2,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.champagne,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.chat_rounded,
                                  color: AppTheme.champagne,
                                  size: 16,
                                ),
                              )
                            else if (isAi)
                              const SizedBox(
                                width: 40,
                              ), // Space for alignment for AI messages
                            // Message bubble
                            Flexible(
                              child: ChatBubble(
                                message: message['content'],
                                isAi: isAi,
                                // 检测是否是方案消息
                                isProposalMessage:
                                    isAi &&
                                    _isProposalMessage(message['content']),
                                onTap:
                                    isAi &&
                                        _isProposalMessage(message['content'])
                                    ? () => _showProposalDetails(
                                        _extractProposalData(
                                          message['content'],
                                        ),
                                      )
                                    : null,
                                onDelete: () async {
                                  // 删除消息并保存到存储中，确保永久删除
                                  setState(() {
                                    _chatMessages.removeAt(index);
                                  });
                                  // 将更新后的消息列表保存到存储中
                                  await _communityRepository.saveChatMessages(
                                    _chatMessages,
                                  );
                                },
                              ),
                            ),

                            // Avatar for user message (right side)
                            if (!isAi && showAvatar)
                              Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(top: 4, left: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorUtils.withOpacity(
                                    AppTheme.coral,
                                    0.2,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.coral,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.coral,
                                  size: 16,
                                ),
                              )
                            else if (!isAi)
                              const SizedBox(
                                width: 40,
                              ), // Space for alignment for user messages
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // AI正在输入提示
        if (_isTyping) _buildTypingIndicator(),

        // 消息输入框
        Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: ColorUtils.withOpacity(AppTheme.silverstone, 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 左侧边距
              const SizedBox(width: 16),

              // Text input
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(
                    color: AppTheme.moonlight,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  maxLines: null, // 允许无限行数，自动扩展
                  minLines: 1,
                  maxLength: 300, // 限制最大长度为300个字符
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  onTap: () {
                    // 确保滚动到底部，避免键盘弹出时遮挡输入框
                    Future.delayed(const Duration(milliseconds: 200), () {
                      _scrollToBottom();
                    });
                  },
                  onChanged: (_) {
                    // 当用户输入时，确保输入框可见
                    if (_chatMessages.isNotEmpty) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _scrollToBottom();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Ask about relationships and marriage...',
                    hintStyle: TextStyle(
                      color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    counterText: '', // 隐藏字数计数器
                    isDense: true,
                  ),
                ),
              ),

              // Send button
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: _isSending
                      ? Container(
                          key: const ValueKey('loading'),
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorUtils.withOpacity(
                              AppTheme.champagne,
                              0.2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.champagne,
                          ),
                        )
                      : Material(
                          key: const ValueKey('send'),
                          color: AppTheme.champagne,
                          shape: const CircleBorder(),
                          elevation: 2,
                          shadowColor: ColorUtils.withOpacity(
                            AppTheme.champagne,
                            0.5,
                          ),
                          child: InkWell(
                            onTap: _sendMessage,
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: AppTheme.deepSpace,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建空聊天状态
  Widget _buildEmptyChatState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: ColorUtils.withOpacity(AppTheme.deepSpace, 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 顶部装饰元素
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          ColorUtils.withOpacity(AppTheme.champagne, 0.3),
                          ColorUtils.withOpacity(AppTheme.champagne, 0.0),
                        ],
                        radius: 0.8,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorUtils.withOpacity(AppTheme.champagne, 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorUtils.withOpacity(
                            AppTheme.champagne,
                            0.2,
                          ),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 50,
                      color: AppTheme.champagne,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Relationship & Marriage Advisor',
                  style: TextStyle(
                    color: AppTheme.champagne,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // 描述
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: ColorUtils.withOpacity(AppTheme.silverstone, 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'I can provide advice and support on relationships and marriage, helping you resolve emotional confusion and relationship issues. Whether it\'s communication skills, conflict resolution, or how to enhance your connection, feel free to ask me.',
                  style: TextStyle(
                    color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // 示例问题提示
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'You can try asking me:',
                  style: TextStyle(
                    color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // 示例问题卡片
              _buildExampleQuestionCard(
                'How can I improve communication with my partner?',
              ),
              _buildExampleQuestionCard(
                'How should I plan a romantic proposal?',
              ),
              _buildExampleQuestionCard(
                'How to maintain a long-distance relationship?',
              ),

              const SizedBox(height: 40),

              // 开始聊天按钮
              ElevatedButton.icon(
                onPressed: _startNewChat,
                icon: const Icon(Icons.chat_rounded),
                label: const Text('Start Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.champagne,
                  foregroundColor: AppTheme.deepSpace,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 4,
                  shadowColor: AppTheme.champagne.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 构建示例问题卡片
  Widget _buildExampleQuestionCard(String question) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
      decoration: BoxDecoration(
        color: ColorUtils.withOpacity(AppTheme.champagne, 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorUtils.withOpacity(AppTheme.champagne, 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _messageController.text = question;
            _startNewChat();
            // 延迟一下再发送，确保聊天已经开始
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                _sendMessage();
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: AppTheme.champagne,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建热门话题列表
  Widget _buildCommunityPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分类选择器
        _buildCategorySelector(),

        // 话题列表
        Expanded(
          child: _hotTopics.isEmpty
              ? _buildEmptyTopicsState()
              : _buildTopicsList(),
        ),
      ],
    );
  }

  // 构建分类选择器
  Widget _buildCategorySelector() {
    final categories = [
      '',
      'Dating',
      'Marriage',
      'Conflict',
      'Communication',
      'Growth',
    ];

    // 定义分类图标和副图标
    final Map<String, List<IconData>> categoryIcons = {
      '': [Icons.apps_rounded, Icons.grid_view_rounded],
      'Dating': [Icons.favorite_rounded, Icons.favorite_border_rounded],
      'Marriage': [
        Icons.volunteer_activism_rounded,
        Icons.favorite_border_rounded,
      ],
      'Conflict': [Icons.psychology_rounded, Icons.psychology_alt_rounded],
      'Communication': [Icons.forum_rounded, Icons.chat_bubble_outline_rounded],
      'Growth': [Icons.trending_up_rounded, Icons.auto_graph_rounded],
    };

    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          // 获取分类对应的颜色
          Color categoryColor = AppTheme.champagne;
          switch (category) {
            case 'Dating':
              categoryColor = const Color(0xFFFF6B8B); // Soft pink
              break;
            case 'Marriage':
              categoryColor = const Color(0xFF9C89FF); // Soft purple
              break;
            case 'Conflict':
              categoryColor = const Color(0xFFFF9F45); // Soft orange
              break;
            case 'Communication':
              categoryColor = const Color(0xFF5EBBFF); // Soft blue
              break;
            case 'Growth':
              categoryColor = const Color(0xFF5BD6B8); // Soft teal
              break;
          }

          // 创建渐变效果
          final LinearGradient gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    categoryColor,
                    categoryColor.withOpacity(0.8),
                    categoryColor.withOpacity(0.7),
                  ]
                : [
                    ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
                    ColorUtils.withOpacity(AppTheme.silverstone, 0.5),
                    ColorUtils.withOpacity(AppTheme.silverstone, 0.4),
                  ],
            stops: const [0.0, 0.6, 1.0],
          );

          // 创建阴影效果
          final List<BoxShadow> boxShadows = isSelected
              ? [
                  BoxShadow(
                    color: categoryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: categoryColor.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = category == _selectedCategory
                        ? ''
                        : category;
                    _loadHotTopics();
                  });
                },
                borderRadius: BorderRadius.circular(20),
                splashColor: categoryColor.withOpacity(0.1),
                highlightColor: categoryColor.withOpacity(0.2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuint,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: boxShadows,
                    border: Border.all(
                      color: isSelected
                          ? categoryColor.withOpacity(0.5)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // 图标容器
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : ColorUtils.withOpacity(AppTheme.deepSpace, 0.3),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: categoryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 主图标
                            Icon(
                              categoryIcons[category]![0],
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.moonlight.withOpacity(0.8),
                              size: 18,
                            ),
                            // 副图标 (只在选中时显示)
                            if (isSelected)
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: 0.5,
                                child: Icon(
                                  categoryIcons[category]![1],
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 文本
                      Text(
                        category.isEmpty ? 'All' : category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.moonlight,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.2,
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

  // 构建话题列表
  Widget _buildTopicsList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loadHotTopics();
        });
      },
      color: AppTheme.champagne,
      backgroundColor: AppTheme.silverstone,
      child: GestureDetector(
        onTap: _hideKeyboard, // 点击话题区域也隐藏键盘
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: _hotTopics.length,
            itemBuilder: (context, index) {
              // 为偶数和奇数索引设置不同的动画延迟和方向，创建交错效果
              final bool isEven = index % 2 == 0;
              final int staggerDelay = 70 + (index ~/ 2 * 100); // 每对卡片增加延迟
              final Offset slideOffset = isEven
                  ? const Offset(-0.15, 0.1) // 偶数从左侧滑入
                  : const Offset(0.15, 0.1); // 奇数从右侧滑入

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Animations.fadeSlideIn(
                  delay: staggerDelay,
                  slideBegin: slideOffset,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuint,
                  child: Hero(
                    tag: 'topic_${_hotTopics[index].id}',
                    child: HotTopicCard(
                      topic: _hotTopics[index],
                      onTap: () => _selectTopic(_hotTopics[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // 选择话题
  void _selectTopic(HotTopicModel topic) {
    // 设置输入框文本
    _messageController.text = topic.title;

    // 如果聊天记录为空，先创建新聊天
    if (_chatMessages.isEmpty) {
      _startNewChat().then((_) {
        // 切换到聊天标签页
        _tabController.animateTo(0);

        // 延迟一下再发送，确保聊天已经开始
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _sendMessage();
          }
        });
      });
    } else {
      // 切换到聊天标签页
      _tabController.animateTo(0);

      // 延迟一下再发送，确保标签页已经切换
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _sendMessage();
        }
      });
    }
  }

  // 构建空话题状态
  Widget _buildEmptyTopicsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 80,
            color: ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
          ),
          const SizedBox(height: 24),
          Text(
            'No hot topics available',
            style: TextStyle(
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category or refresh',
            style: TextStyle(
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedCategory = '';
                _loadHotTopics();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Topics'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.champagne,
              foregroundColor: AppTheme.deepSpace,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  // 检查消息是否是方案消息
  bool _isProposalMessage(String message) {
    return message.contains("Here's a proposal plan I've created for you:") &&
        message.contains("**Steps:**") &&
        message.contains("**Materials Needed:**");
  }

  // 从消息中提取方案数据
  dynamic _extractProposalData(String message) {
    try {
      // 提取标题
      final titleRegex = RegExp(r'\*\*(.*?)\*\*');
      final titleMatch = titleRegex.firstMatch(message);
      final title = titleMatch?.group(1) ?? 'Proposal Plan';

      // 提取类型
      final typeRegex = RegExp(r'\*\*Type:\*\* (.*?)\n');
      final typeMatch = typeRegex.firstMatch(message);
      final type = typeMatch?.group(1) ?? 'Romantic';

      // 提取描述
      final descRegex = RegExp(
        r'\*\*Description:\*\*\n(.*?)\n\n\*\*Steps:\*\*',
        dotAll: true,
      );
      final descMatch = descRegex.firstMatch(message);
      final description = descMatch?.group(1)?.trim() ?? '';

      // 提取步骤
      final stepsRegex = RegExp(
        r'\*\*Steps:\*\*\n(.*?)\n\n\*\*Materials Needed:\*\*',
        dotAll: true,
      );
      final stepsMatch = stepsRegex.firstMatch(message);
      final stepsText = stepsMatch?.group(1) ?? '';
      final steps = stepsText
          .split('\n')
          .map((step) => step.replaceAll(RegExp(r'^\d+\. '), '').trim())
          .where((step) => step.isNotEmpty)
          .toList();

      // 提取材料
      final materialsRegex = RegExp(
        r'\*\*Materials Needed:\*\*\n(.*?)\n\n\*\*Location:',
        dotAll: true,
      );
      final materialsMatch = materialsRegex.firstMatch(message);
      final materialsText = materialsMatch?.group(1) ?? '';
      final materials = materialsText
          .split('\n')
          .map((material) => material.replaceAll('- ', '').trim())
          .where((material) => material.isNotEmpty)
          .toList();

      // 提取地点
      final locationRegex = RegExp(r'\*\*Location:\*\* (.*?)\n');
      final locationMatch = locationRegex.firstMatch(message);
      final location = locationMatch?.group(1) ?? '';

      // 提取时间
      final timingRegex = RegExp(r'\*\*Timing:\*\* (.*?)\n');
      final timingMatch = timingRegex.firstMatch(message);
      final timing = timingMatch?.group(1) ?? '';

      // 提取预算
      final budgetRegex = RegExp(r'\*\*Budget:\*\* (.*?)(\n|$)');
      final budgetMatch = budgetRegex.firstMatch(message);
      final budget = budgetMatch?.group(1) ?? '';

      // 创建一个简单的Map对象，包含方案数据
      return {
        'title': title,
        'type': type,
        'description': description,
        'steps': steps,
        'materials': materials,
        'location': location,
        'timing': timing,
        'budget': budget,
      };
    } catch (e) {
      print('提取方案数据错误: $e');
      return {
        'title': 'Proposal Plan',
        'type': 'Romantic',
        'description': 'A beautiful proposal plan for your special day.',
        'steps': ['Plan a special day', 'Prepare the ring', 'Pop the question'],
        'materials': ['Engagement ring', 'Flowers', 'Champagne'],
        'location': 'A meaningful place',
        'timing': 'Evening, around sunset',
        'budget': 'Varies based on your choices',
      };
    }
  }

  // 显示方案详情
  void _showProposalDetails(dynamic proposalData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.deepSpace,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部拖动条
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ColorUtils.withOpacity(AppTheme.moonlight, 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // 标题部分
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.champagne,
                          AppTheme.champagne.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                proposalData['title'],
                                style: const TextStyle(
                                  color: AppTheme.deepSpace,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                proposalData['type'],
                                style: const TextStyle(
                                  color: AppTheme.deepSpace,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          proposalData['description'],
                          style: TextStyle(
                            color: AppTheme.deepSpace.withOpacity(0.8),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 内容部分
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 步骤
                        _buildSectionTitle('Steps'),
                        const SizedBox(height: 12),
                        ...List.generate(proposalData['steps'].length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  margin: const EdgeInsets.only(
                                    right: 12,
                                    top: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.withOpacity(
                                      AppTheme.champagne,
                                      0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: AppTheme.champagne,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    proposalData['steps'][index],
                                    style: TextStyle(
                                      color: ColorUtils.withOpacity(
                                        AppTheme.moonlight,
                                        0.9,
                                      ),
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 24),

                        // 所需物品
                        _buildSectionTitle('Materials Needed'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: proposalData['materials'].map<Widget>((
                            material,
                          ) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: ColorUtils.withOpacity(
                                  AppTheme.silverstone,
                                  0.7,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ColorUtils.withOpacity(
                                    AppTheme.champagne,
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                material,
                                style: TextStyle(
                                  color: ColorUtils.withOpacity(
                                    AppTheme.moonlight,
                                    0.9,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // 地点和时间
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Location',
                                proposalData['location'],
                                Icons.place,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoItem(
                                'Timing',
                                proposalData['timing'],
                                Icons.access_time,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // 预算
                        _buildInfoItem(
                          'Budget',
                          proposalData['budget'],
                          Icons.account_balance_wallet,
                        ),

                        const SizedBox(height: 32),

                        // 关闭按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.champagne,
                              foregroundColor: AppTheme.deepSpace,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 构建部分标题
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.champagne,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: ColorUtils.withOpacity(AppTheme.champagne, 0.3),
          ),
        ),
      ],
    );
  }

  // 构建信息项
  Widget _buildInfoItem(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.champagne, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.champagne,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
