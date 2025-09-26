import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';

/// 聊天气泡组件
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isAi;
  final Function()? onDelete; // 添加删除回调函数
  final Function()? onTap; // 添加点击回调函数
  final bool isProposalMessage; // 是否是方案消息

  const ChatBubble({
    super.key,
    required this.message,
    required this.isAi,
    this.onDelete,
    this.onTap,
    this.isProposalMessage = false,
  });

  // 显示举报对话框
  void _showReportDialog(BuildContext context) {
    final TextEditingController reportController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepSpace,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Report Message',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please tell us why you\'re reporting this message:',
                style: TextStyle(color: AppTheme.moonlight),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: reportController,
                style: const TextStyle(color: AppTheme.moonlight),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter your reason here...',
                  hintStyle: TextStyle(
                    color: AppTheme.moonlight.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: ColorUtils.withOpacity(AppTheme.silverstone, 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.champagne,
                      width: 1,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a reason';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.moonlight),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                // 显示举报成功提示
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Report submitted successfully'),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(10),
                    backgroundColor: Colors.orangeAccent,
                    action: SnackBarAction(
                      label: 'OK',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  // 显示删除确认对话框
  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepSpace,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Message',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this message? This action cannot be undone.',
          style: TextStyle(color: AppTheme.moonlight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.moonlight),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // 调用删除回调函数
              if (onDelete != null) {
                onDelete!();
              }
              // 显示删除成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message deleted'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(10),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      margin: EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: isAi ? 0 : 4,
        right: isAi ? 4 : 0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isAi
              ? [
                  ColorUtils.withOpacity(AppTheme.silverstone, 0.9),
                  ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
                ]
              : [
                  ColorUtils.withOpacity(AppTheme.champagne, 0.9),
                  ColorUtils.withOpacity(AppTheme.champagne, 0.7),
                ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: isAi
              ? const Radius.circular(4)
              : const Radius.circular(18),
          bottomRight: isAi
              ? const Radius.circular(18)
              : const Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isAi
              ? ColorUtils.withOpacity(AppTheme.silverstone, 0.5)
              : ColorUtils.withOpacity(AppTheme.champagne, 0.5),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isProposalMessage && onTap != null ? onTap : null,
          onLongPress: () {
            // 显示操作菜单
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: AppTheme.deepSpace,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 顶部装饰条
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: ColorUtils.withOpacity(AppTheme.moonlight, 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // 复制选项
                    ListTile(
                      leading: const Icon(
                        Icons.content_copy_rounded,
                        color: AppTheme.champagne,
                      ),
                      title: const Text(
                        'Copy',
                        style: TextStyle(
                          color: AppTheme.moonlight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        // 复制文本功能
                        Clipboard.setData(ClipboardData(text: message));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 1),
                            backgroundColor: AppTheme.champagne,
                          ),
                        );
                      },
                    ),

                    // 举报选项
                    ListTile(
                      leading: const Icon(
                        Icons.flag_rounded,
                        color: Colors.orangeAccent,
                      ),
                      title: const Text(
                        'Report',
                        style: TextStyle(
                          color: AppTheme.moonlight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // 显示举报弹窗
                        _showReportDialog(context);
                      },
                    ),

                    // 删除选项
                    ListTile(
                      leading: const Icon(
                        Icons.delete_rounded,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        'Delete',
                        style: TextStyle(
                          color: AppTheme.moonlight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // 显示删除确认对话框
                        _showDeleteConfirmDialog(context);
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isAi
                ? const Radius.circular(4)
                : const Radius.circular(18),
            bottomRight: isAi
                ? const Radius.circular(18)
                : const Radius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isAi ? AppTheme.moonlight : AppTheme.deepSpace,
                    fontSize: 15,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
                if (isProposalMessage && onTap != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 14,
                          color: isAi
                              ? AppTheme.moonlight.withOpacity(0.6)
                              : AppTheme.deepSpace.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            color: isAi
                                ? AppTheme.moonlight.withOpacity(0.6)
                                : AppTheme.deepSpace.withOpacity(0.6),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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
}
