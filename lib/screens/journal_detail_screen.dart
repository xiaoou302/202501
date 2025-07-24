import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/journal_entry.dart';
import '../services/journal_repository.dart';
import '../services/journal_share_service.dart';
import '../theme/app_theme.dart';

enum SnackBarType { success, error, info }

class JournalDetailScreen extends StatefulWidget {
  final JournalEntry entry;

  const JournalDetailScreen({Key? key, required this.entry}) : super(key: key);

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen>
    with SingleTickerProviderStateMixin {
  final JournalShareService _shareService = JournalShareService();
  late Color _selectedColor;
  bool _isSharing = false;
  bool _hasSharedOnce = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedColor = Color(
      int.parse(widget.entry.colorHex.replaceAll('#', '0xFF')),
    );

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _shareEntry() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final shareCard = await _shareService.convertJournalToShareCard(
        widget.entry,
      );

      if (mounted) {
        setState(() {
          _hasSharedOnce = true;
        });

        if (shareCard != null) {
          _showSuccessDialog();
        } else {
          _showSnackBar(
            'Failed to create share card',
            type: SnackBarType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          'An unexpected error occurred while sharing',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: _selectedColor,
                size: 48,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Share Card Created!',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your journal entry has been converted to a share card. You can find it in the Share tab.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: _selectedColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to Share tab
              Navigator.pop(context); // Return to previous screen
            },
            child: Text(
              'Go to Share Tab',
              style: TextStyle(color: _selectedColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {SnackBarType type = SnackBarType.info}) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = AppTheme.accentRed;
        icon = Icons.error_outline;
        break;
      case SnackBarType.info:
      default:
        backgroundColor = _selectedColor;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: backgroundColor.withOpacity(0.9),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: Duration(seconds: 3),
        action: type == SnackBarType.error
            ? SnackBarAction(
                label: 'Try Again',
                textColor: Colors.white,
                onPressed: _shareEntry,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: _selectedColor),
          titleTextStyle: TextStyle(
            color: _selectedColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: _selectedColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('View Entry', style: TextStyle(color: _selectedColor)),
          actions: [
            // Share button
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: _isSharing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: _selectedColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Stack(
                        children: [
                          Icon(Icons.share, color: _selectedColor),
                          if (_hasSharedOnce)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                onPressed: _isSharing ? null : _shareEntry,
                tooltip: 'Share Journal Entry',
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.backgroundColor,
                Color.lerp(AppTheme.backgroundColor, _selectedColor, 0.05) ??
                    AppTheme.backgroundColor,
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date display
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _selectedColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: _selectedColor,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${widget.entry.date.year}-${widget.entry.date.month.toString().padLeft(2, '0')}-${widget.entry.date.day.toString().padLeft(2, '0')} ${widget.entry.date.hour.toString().padLeft(2, '0')}:${widget.entry.date.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: _selectedColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Title
                    if (widget.entry.title != null &&
                        widget.entry.title!.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _selectedColor.withOpacity(0.7),
                              _selectedColor.withOpacity(0.4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _selectedColor.withOpacity(0.2),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.entry.title!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],

                    // Main content
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _selectedColor.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content text
                          Text(
                            widget.entry.text,
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 16,
                              height: 1.8,
                              letterSpacing: 0.3,
                            ),
                          ),

                          SizedBox(height: 20),

                          // Divider with color
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: _selectedColor.withOpacity(0.2),
                          ),

                          SizedBox(height: 20),

                          // Share button
                          Center(
                            child: ElevatedButton.icon(
                              icon: _isSharing
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.share),
                              label: Text(
                                _hasSharedOnce
                                    ? 'Share Again'
                                    : 'Share this entry',
                              ),
                              onPressed: _isSharing ? null : _shareEntry,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                                shadowColor: _selectedColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Quote decoration
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.quoteRight,
                          color: _selectedColor.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
