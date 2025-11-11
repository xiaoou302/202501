import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isTyping;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const ChatBubble({
    Key? key,
    required this.message,
    this.isTyping = false,
    this.onDelete,
    this.onReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: isTyping ? null : () => _showMessageOptions(context),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstants.softCoral,
                          Color(0xFFFF6B7A),
                        ],
                      )
                    : null,
                color: message.isUser
                    ? null
                    : (isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(6),
                  bottomRight: message.isUser
                      ? const Radius.circular(6)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: message.isUser
                        ? AppConstants.softCoral.withOpacity(0.3)
                        : Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                    blurRadius: message.isUser ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isTyping
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TypingDot(delay: 0),
                        const SizedBox(width: 4),
                        _TypingDot(delay: 200),
                        const SizedBox(width: 4),
                        _TypingDot(delay: 400),
                      ],
                    )
                  : Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: message.isUser ? Colors.white : null,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: const Text('Report'),
              subtitle: const Text('Report inappropriate content'),
              onTap: () {
                Navigator.pop(context);
                if (onReport != null) {
                  onReport!();
                }
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete'),
              subtitle: const Text('Remove this message'),
              onTap: () {
                Navigator.pop(context);
                if (onDelete != null) {
                  onDelete!();
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppConstants.mediumGray,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
