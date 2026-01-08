import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';
import '../../data/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent,
                    AppColors.accent.withValues(alpha: 0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: message.isUser
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.text,
                                AppColors.text.withValues(alpha: 0.9),
                              ],
                            )
                          : null,
                      color: message.isUser ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: message.isUser
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                        topRight: message.isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                      ),
                      border: message.isUser
                          ? null
                          : Border.all(
                              color: AppColors.gray.withValues(alpha: 0.15),
                              width: 1,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: message.isUser
                              ? AppColors.text.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: message.isUser ? Colors.white : AppColors.text,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
                if (message.suggestedImageUrls != null &&
                    message.suggestedImageUrls!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: message.suggestedImageUrls!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.gray),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                message.suggestedImageUrls![index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message.isUser) const SizedBox(width: 12),
        ],
      ),
    );
  }
}
