import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/share_card.dart';
import '../services/share_service.dart';
import '../theme/app_theme.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ShareService _service = ShareService();
  List<ShareCard> _shareCards = [];
  bool _isLoading = true;
  bool _isGenerating = false;
  bool _isSaving = false;
  bool _isSharing = false;
  ShareCard? _currentCard;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Track image loading errors
  final Map<String, bool> _imageLoadErrors = {};

  // Track expanded state for each section
  bool _isInputExpanded = true;
  bool _isHistoryExpanded = true;

  // 添加一个GlobalKey用于获取QR码widget
  final GlobalKey qrKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  // 添加文本长度限制
  static const int maxTextLength = 200;

  @override
  void initState() {
    super.initState();
    _loadShareCards();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // 监听文本变化
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_textController.text.length > maxTextLength) {
      _textController.text = _textController.text.substring(0, maxTextLength);
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: maxTextLength),
      );
    }
  }

  Future<void> _loadShareCards() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final cards = await _service.getAllShareCards();

      if (mounted) {
        setState(() {
          _shareCards = cards;
          _isLoading = false;

          // If there are share cards, display the most recent one by default
          if (_shareCards.isNotEmpty) {
            _currentCard = _shareCards.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load share cards: $e');
      }
    }
  }

  Future<void> _generateShareCard() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      _showErrorSnackBar('Please enter content');
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // Choose a color from the theme
      final colors = [
        AppTheme.primaryColor,
        AppTheme.accentPurple,
        AppTheme.accentPink,
        AppTheme.accentBlue,
        AppTheme.accentGreen,
      ];
      final randomColor = colors[DateTime.now().millisecond % colors.length];
      final colorHex = '#${randomColor.value.toRadixString(16).substring(2)}';

      // Generate QR code URL
      final qrCodeUrl = _service.generateQrCodeUrl(text);

      // Create share card
      final card = ShareCard(
        id: Uuid().v4(),
        text: text,
        qrCodeUrl: qrCodeUrl,
        createdAt: DateTime.now(),
        colorHex: colorHex,
      );

      // Save to storage
      await _service.saveShareCard(card);
      _textController.clear();

      if (mounted) {
        setState(() {
          _currentCard = card;
          _isGenerating = false;

          // 自动折叠输入区域，展示生成的卡片
          _isInputExpanded = false;
        });

        _animationController.reset();
        _animationController.forward();

        await _loadShareCards();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        _showErrorSnackBar('Failed to generate share card: $e');
      }
    }
  }

  Future<void> _saveQrCodeToGallery() async {
    if (_currentCard == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.saveQrCodeToGallery(
        context,
        _currentCard!.qrCodeUrl,
        qrKey,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _shareQrCode() async {
    if (_currentCard == null) return;

    setState(() {
      _isSharing = true;
    });

    try {
      await _service.shareQrCode(context, _currentCard!, qrKey);
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _selectCard(ShareCard card) {
    setState(() {
      _currentCard = card;
    });

    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _deleteCard(ShareCard card) async {
    try {
      await _service.deleteShareCard(card.id);

      // If the deleted card is the currently displayed one, clear the current card
      if (_currentCard?.id == card.id) {
        setState(() {
          _currentCard = null;
        });
      }

      await _loadShareCards();
      _showSuccessSnackBar('Share card deleted');
    } catch (e) {
      _showErrorSnackBar('Failed to delete share card: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // This is called outside of build to safely update state
  void _retryLoadingImage(String url) {
    setState(() {
      _imageLoadErrors.remove(url);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share Moments', style: AppTheme.headingStyle),
              SizedBox(height: 24),

              // Input section with expandable header
              _buildExpandableSection(
                title: 'Create New Share',
                icon: Icons.create,
                isExpanded: _isInputExpanded,
                onToggle: () =>
                    setState(() => _isInputExpanded = !_isInputExpanded),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            maxLines: 4,
                            maxLength: maxTextLength,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              // 提交时收起键盘
                              FocusScope.of(context).unfocus();
                            },
                            style: TextStyle(color: AppTheme.textColor),
                            decoration: InputDecoration(
                              hintText:
                                  'Share something meaningful (max 200 characters)...',
                              hintStyle: TextStyle(
                                color: AppTheme.textColor.withOpacity(0.5),
                              ),
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: AppTheme.accentPurple,
                                  width: 1.5,
                                ),
                              ),
                              counterStyle: TextStyle(
                                color: AppTheme.textColor.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Generate button
                    Center(
                      child: ElevatedButton(
                        onPressed:
                            _isGenerating || _textController.text.trim().isEmpty
                            ? null
                            : _generateShareCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: AppTheme.accentPurple.withOpacity(0.5),
                          minimumSize: Size(200, 50),
                          disabledBackgroundColor: AppTheme.accentPurple
                              .withOpacity(0.3),
                        ),
                        child: _isGenerating
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.qr_code),
                                  SizedBox(width: 8),
                                  Text(
                                    'Generate Share Card',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Display current selected card
              if (_currentCard != null) ...[
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      children: [
                        // Card header with date
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppTheme.textColor.withOpacity(0.7),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${_currentCard!.createdAt.day}/${_currentCard!.createdAt.month}/${_currentCard!.createdAt.year} ${_currentCard!.createdAt.hour}:${_currentCard!.createdAt.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: AppTheme.textColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.qr_code,
                                    color: AppTheme.accentPurple,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Local QR Code',
                                    style: TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Content container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(
                                  int.parse(
                                    _currentCard!.colorHex.replaceAll(
                                      '#',
                                      '0xFF',
                                    ),
                                  ),
                                ),
                                Color(
                                  int.parse(
                                    _currentCard!.colorHex.replaceAll(
                                      '#',
                                      '0xFF',
                                    ),
                                  ),
                                ).withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  int.parse(
                                    _currentCard!.colorHex.replaceAll(
                                      '#',
                                      '0xFF',
                                    ),
                                  ),
                                ).withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.quoteLeft,
                                color: Colors.white.withOpacity(0.3),
                                size: 24,
                              ),
                              SizedBox(height: 12),
                              Text(
                                '"${_currentCard!.text}"',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              Icon(
                                FontAwesomeIcons.quoteRight,
                                color: Colors.white.withOpacity(0.3),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        // QR Code with error handling
                        _buildQrCodeWidget(_currentCard!),

                        SizedBox(height: 12),
                        Text(
                          'Scan QR code to feel this moment',
                          style: TextStyle(
                            color: AppTheme.textColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Action buttons
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            // Copy text button
                            _buildActionButton(
                              icon: Icons.copy,
                              label: 'Copy',
                              color: AppTheme.accentGreen,
                              onPressed: () => _service.copyToClipboard(
                                _currentCard!.text,
                                context,
                              ),
                            ),

                            // Save button
                            _buildActionButton(
                              icon: Icons.save_alt,
                              label: 'Save',
                              color: AppTheme.accentBlue,
                              isLoading: _isSaving,
                              onPressed: _saveQrCodeToGallery,
                            ),

                            // Share button
                            _buildActionButton(
                              icon: Icons.share,
                              label: 'Share',
                              color: AppTheme.accentPurple,
                              isLoading: _isSharing,
                              onPressed: _shareQrCode,
                            ),

                            // Delete button
                            _buildActionButton(
                              icon: Icons.delete_outline,
                              label: 'Delete',
                              color: AppTheme.accentRed,
                              onPressed: () => _deleteCard(_currentCard!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],

              // Share card list section with expandable header
              _buildExpandableSection(
                title: 'My Shares',
                icon: FontAwesomeIcons.history,
                isExpanded: _isHistoryExpanded,
                onToggle: () =>
                    setState(() => _isHistoryExpanded = !_isHistoryExpanded),
                child: _isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            color: AppTheme.accentPurple,
                          ),
                        ),
                      )
                    : _shareCards.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidComment,
                                color: AppTheme.textColor.withOpacity(0.5),
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No share cards yet\nYou can create from "Journal" page',
                                style: TextStyle(
                                  color: AppTheme.textColor.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: _shareCards.length,
                        itemBuilder: (context, index) {
                          final card = _shareCards[index];
                          final color = Color(
                            int.parse(card.colorHex.replaceAll('#', '0xFF')),
                          );
                          final isSelected = _currentCard?.id == card.id;

                          return GestureDetector(
                            onTap: () => _selectCard(card),
                            onLongPress: () => _showDeleteConfirmation(card),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [color, color.withOpacity(0.7)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: color.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Delete hint overlay
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _selectCard(card),
                                        onLongPress: () =>
                                            _showDeleteConfirmation(card),
                                        splashColor: Colors.red.withOpacity(
                                          0.3,
                                        ),
                                        highlightColor: Colors.transparent,
                                        child: Container(),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        card.text,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: color,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with toggle
        GestureDetector(
          onTap: onToggle,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.accentPurple, size: 16),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              Spacer(),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textColor,
                ),
              ),
            ],
          ),
        ),

        // Expandable content
        AnimatedCrossFade(
          firstChild: child,
          secondChild: SizedBox(height: 0),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildQrCodeWidget(ShareCard card) {
    final hasError = _imageLoadErrors[card.qrCodeUrl] == true;

    return RepaintBoundary(
      key: qrKey,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: hasError
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppTheme.accentRed,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Failed to generate QR code',
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error: QR code generation failed',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _retryLoadingImage(card.qrCodeUrl),
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: 180,
                height: 180,
                child: _QrImageWithErrorHandling(
                  url: card.qrCodeUrl,
                  data: card.text,
                  onError: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _imageLoadErrors[card.qrCodeUrl] = true;
                      });
                    });
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return ElevatedButton.icon(
      icon: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(color: color, strokeWidth: 2),
            )
          : Icon(icon, size: 16),
      label: Text(label),
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 2,
      ),
    );
  }

  void _showDeleteConfirmation(ShareCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Share Card',
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this share card?',
              style: TextStyle(color: AppTheme.textColor.withOpacity(0.9)),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(
                  int.parse(card.colorHex.replaceAll('#', '0xFF')),
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(
                    int.parse(card.colorHex.replaceAll('#', '0xFF')),
                  ).withOpacity(0.3),
                ),
              ),
              child: Text(
                card.text,
                style: TextStyle(
                  color: AppTheme.textColor.withOpacity(0.7),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteCard(card);

              // If the deleted card was the current card, clear it
              if (_currentCard?.id == card.id) {
                setState(() {
                  _currentCard = null;
                });
              }
            },
            child: Text('Delete', style: TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );
  }
}

// Separate stateful widget to handle image errors without setState during build
class _QrImageWithErrorHandling extends StatelessWidget {
  final String url;
  final VoidCallback onError;
  final String data;

  const _QrImageWithErrorHandling({
    required this.url,
    required this.onError,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 180.0,
      backgroundColor: Colors.white,
      padding: EdgeInsets.zero,
      errorStateBuilder: (context, error) {
        onError();
        return const SizedBox.shrink();
      },
    );
  }
}
