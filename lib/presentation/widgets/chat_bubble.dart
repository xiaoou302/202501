import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const ChatBubble({
    super.key,
    required this.message,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context, isUser),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          margin: const EdgeInsets.only(bottom: 4),
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppConstants.gold,
                            AppConstants.gold.withValues(alpha: 0.85),
                          ],
                        )
                      : null,
                  color: isUser ? null : AppConstants.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 6),
                    bottomRight: Radius.circular(isUser ? 6 : 20),
                  ),
                  border: isUser
                      ? null
                      : Border.all(
                          color: AppConstants.gold.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: isUser
                          ? AppConstants.gold.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUser ? AppConstants.midnight : AppConstants.offwhite,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppConstants.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      isUser ? 'You' : 'Art Mentor',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppConstants.metalgray.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
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

  void _showMessageOptions(BuildContext context, bool isUser) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete Message',
                  style: TextStyle(color: AppConstants.offwhite),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
              if (!isUser)
                ListTile(
                  leading: const Icon(Icons.flag_outlined, color: AppConstants.gold),
                  title: const Text(
                    'Report Message',
                    style: TextStyle(color: AppConstants.offwhite),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog(context);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text(
            'Delete Message',
            style: TextStyle(
              color: AppConstants.offwhite,
              fontFamily: 'PlayfairDisplay',
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this message? This action cannot be undone.',
            style: TextStyle(color: AppConstants.metalgray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConstants.metalgray),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onDelete != null) {
                  onDelete!();
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    String selectedReason = 'Inappropriate content';
    final TextEditingController reasonController = TextEditingController();
    
    // Get the ScaffoldMessenger before showing dialog
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (stateContext, setState) {
            return AlertDialog(
              backgroundColor: AppConstants.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white10),
              ),
              title: const Text(
                'Report Message',
                style: TextStyle(
                  color: AppConstants.offwhite,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a reason:',
                      style: TextStyle(
                        color: AppConstants.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildReasonOption(
                      'Inappropriate content',
                      selectedReason,
                      (value) => setState(() => selectedReason = value),
                    ),
                    _buildReasonOption(
                      'Offensive language',
                      selectedReason,
                      (value) => setState(() => selectedReason = value),
                    ),
                    _buildReasonOption(
                      'Misinformation',
                      selectedReason,
                      (value) => setState(() => selectedReason = value),
                    ),
                    _buildReasonOption(
                      'Spam',
                      selectedReason,
                      (value) => setState(() => selectedReason = value),
                    ),
                    _buildReasonOption(
                      'Other',
                      selectedReason,
                      (value) => setState(() => selectedReason = value),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional details (optional):',
                      style: TextStyle(
                        color: AppConstants.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLength: 200,
                      maxLines: 3,
                      style: const TextStyle(color: AppConstants.offwhite),
                      decoration: InputDecoration(
                        hintText: 'Describe the issue...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        filled: true,
                        fillColor: AppConstants.midnight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        counterStyle: const TextStyle(
                          color: AppConstants.metalgray,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppConstants.metalgray),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Capture values before closing
                    final details = reasonController.text.trim();
                    final reason = selectedReason;
                    
                    // Close dialog first
                    Navigator.of(dialogContext).pop();
                    
                    // Show confirmation after dialog is fully closed
                    Future.delayed(const Duration(milliseconds: 400), () {
                      _submitReport(scaffoldMessenger, reason, details);
                    });
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: AppConstants.gold),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dispose controller after dialog animation is completely finished
      // Dialog close animation takes about 200-300ms, so wait a bit longer
      Future.delayed(const Duration(milliseconds: 500), () {
        reasonController.dispose();
      });
    });
  }

  Widget _buildReasonOption(
    String reason,
    String selectedReason,
    Function(String) onSelect,
  ) {
    final isSelected = reason == selectedReason;
    return GestureDetector(
      onTap: () => onSelect(reason),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.gold.withValues(alpha: 0.1) : AppConstants.midnight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppConstants.gold : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppConstants.gold : AppConstants.metalgray,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              reason,
              style: TextStyle(
                color: isSelected ? AppConstants.gold : AppConstants.offwhite,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReport(ScaffoldMessengerState scaffoldMessenger, String reason, String details) {
    // Log the report
    debugPrint('═══════════════════════════════════════');
    debugPrint('📋 REPORT SUBMITTED');
    debugPrint('Reason: $reason');
    debugPrint('Details: ${details.isEmpty ? "(No additional details)" : details}');
    debugPrint('Timestamp: ${DateTime.now()}');
    debugPrint('═══════════════════════════════════════');
    
    // Show success message using the captured messenger
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppConstants.midnight,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                  

'Shōu dào nín de jǔbào'
'Your report has been received',
                    style: TextStyle(
                      color: AppConstants.midnight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'We will verify the report; if it is true, we will take effective action.',
                    style: TextStyle(
                      color: AppConstants.midnight.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppConstants.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppConstants.midnight,
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
    
    // Here you would typically send the report to your backend
    if (onReport != null) {
      onReport!();
    }
  }
}
