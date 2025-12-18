import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../services/mock_data_service.dart';
import '../services/storage_service.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../widgets/poem_card.dart';
import 'author_profile_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> with AutomaticKeepAliveClientMixin {
  List<Poem> poems = [];
  List<Poem> filteredPoems = [];
  final StorageService _storage = StorageService();
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Set<String> _blockedAuthorIds = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadPoems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面依赖变化时（包括从其他页面返回），刷新收藏状态
    if (!_isLoading && poems.isNotEmpty) {
      _refreshBookmarkStatus();
    }
  }

  // 刷新收藏状态（不重新加载整个列表）
  void _refreshBookmarkStatus() async {
    final bookmarks = await _storage.loadBookmarks();
    if (mounted) {
      setState(() {
        for (var poem in poems) {
          poem.isBookmarked = bookmarks.contains(poem.id);
        }
      });
    }
  }

  void _loadPoems() async {
    // 模拟加载延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 加载收藏状态和拉黑列表
    final bookmarks = await _storage.loadBookmarks();
    final blocked = await _storage.loadBlockedAuthors();
    
    setState(() {
      _blockedAuthorIds = blocked.toSet();
      poems = MockDataService.getMockPoems()
          .where((poem) => !_blockedAuthorIds.contains(poem.authorId))
          .toList();
      filteredPoems = poems;
      // 同步收藏状态
      for (var poem in poems) {
        poem.isBookmarked = bookmarks.contains(poem.id);
      }
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPoems = poems;
      } else {
        filteredPoems = poems.where((poem) {
          return poem.title.toLowerCase().contains(query) ||
              poem.content.toLowerCase().contains(query) ||
              poem.authorName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleLike(Poem poem) {
    setState(() {
      poem.isLiked = !poem.isLiked;
      poem.likes += poem.isLiked ? 1 : -1;
    });
  }

  void _toggleBookmark(Poem poem) async {
    setState(() {
      poem.isBookmarked = !poem.isBookmarked;
    });
    
    if (poem.isBookmarked) {
      await _storage.addBookmark(poem.id);
    } else {
      await _storage.removeBookmark(poem.id);
    }
  }

  void _openAuthorProfile(String authorId) async {
    // 导航到作者主页，并在返回时重新加载收藏状态
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthorProfileScreen(authorId: authorId),
      ),
    );
    
    // 返回后重新加载收藏状态
    final bookmarks = await _storage.loadBookmarks();
    setState(() {
      for (var poem in poems) {
        poem.isBookmarked = bookmarks.contains(poem.id);
      }
    });
  }

  void _showPoemOptions(Poem poem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.paperLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.ribbon.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flag, color: AppColors.ribbon),
              ),
              title: const Text('Report'),
              subtitle: const Text('Report inappropriate content'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(poem);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.block, color: AppColors.ink),
              ),
              title: const Text('Block'),
              subtitle: const Text('Hide all content from this author'),
              onTap: () {
                Navigator.pop(context);
                _blockAuthor(poem);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(Poem poem) {
    final TextEditingController reportController = TextEditingController();
    final FocusNode reportFocusNode = FocusNode();
    String? selectedReason;
    final reasons = ['Spam', 'Inappropriate', 'Illegal', 'Copyright', 'Other'];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => reportFocusNode.unfocus(),
        child: StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    AppColors.paperLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.ribbon.withValues(alpha: 0.15),
                                AppColors.olive.withValues(alpha: 0.15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.flag, color: AppColors.ribbon, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Report Content',
                            style: AppTextStyles.poemTitle.copyWith(fontSize: 22),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () {
                            reportController.dispose();
                            reportFocusNode.dispose();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Report Type',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reasons.map((reason) {
                        final isSelected = selectedReason == reason;
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedReason = reason),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.ribbon.withValues(alpha: 0.2),
                                        AppColors.olive.withValues(alpha: 0.2),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : AppColors.paper,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.ribbon
                                    : AppColors.cardBorder,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              reason,
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? AppColors.ribbon : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Details',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.paper,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: TextField(
                        controller: reportController,
                        focusNode: reportFocusNode,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Please describe the reason for reporting...',
                          hintStyle: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: AppTextStyles.bodyText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              reportController.dispose();
                              reportFocusNode.dispose();
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: AppColors.cardBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.bodyText.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: selectedReason == null
                                ? null
                                : () {
                                    reportController.dispose();
                                    reportFocusNode.dispose();
                                    Navigator.pop(context);
                                    _submitReport(poem, selectedReason!, reportController.text);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.ribbon,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              disabledBackgroundColor: AppColors.textTertiary,
                            ),
                            child: const Text('Submit Report'),
                          ),
                        ),
                      ],
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

  void _submitReport(Poem poem, String reason, String details) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paperLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.ribbon.withValues(alpha: 0.15),
                      AppColors.olive.withValues(alpha: 0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.ribbon,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Report Submitted',
                style: AppTextStyles.poemTitle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 16),
              Text(
                'We will review the reported content. If the report is verified, we will take action against the reported user within 24 hours. Thank you for helping us maintain a safe community.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: AppColors.ribbon,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Got it'),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  void _blockAuthor(Poem poem) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paperLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block,
                  color: AppColors.ink,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Confirm Block?',
                style: AppTextStyles.poemTitle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 16),
              Text(
                'After blocking, all content from this author will be permanently hidden. This action cannot be undone.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        final authorName = poem.authorName;
                        
                        navigator.pop();
                        await _storage.blockAuthor(poem.authorId);
                        setState(() {
                          _blockedAuthorIds.add(poem.authorId);
                          poems.removeWhere((p) => p.authorId == poem.authorId);
                          filteredPoems.removeWhere((p) => p.authorId == poem.authorId);
                        });
                        
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Blocked $authorName. Their content will no longer be shown.'),
                            backgroundColor: AppColors.ink,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.ink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Confirm Block'),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paperLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.ribbon.withValues(alpha: 0.15),
                          AppColors.olive.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.help_outline, color: AppColors.ribbon, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Features Guide',
                      style: AppTextStyles.poemTitle.copyWith(fontSize: 22),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHelpItem(
                        Icons.search,
                        'Search',
                        'Tap the search icon to search for poems by title, content, or author name',
                        AppColors.ribbon,
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.touch_app,
                        'Tap Card',
                        'Tap a poem card to visit the author\'s profile and view more works',
                        AppColors.olive,
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.touch_app_outlined,
                        'Long Press Card',
                        'Long press a poem card to view details or choose report/block options',
                        AppColors.ribbon,
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.flag,
                        'Report Feature',
                        'If you find inappropriate content, you can report it. We will review and take action within 24 hours',
                        AppColors.ribbon,
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.block,
                        'Block Feature',
                        'After blocking, all content from this author will be permanently hidden. This action cannot be undone',
                        AppColors.ink,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: AppColors.ribbon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以支持 AutomaticKeepAliveClientMixin
    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.paperLight,
              AppColors.paper,
              AppColors.paper.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ribbon.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const CircularProgressIndicator(
                          color: AppColors.ribbon,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading inspiration...',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            AppColors.ribbon,
                                            AppColors.olive,
                                          ],
                                        ).createShader(bounds),
                                        child: Text(
                                          'Zina',
                                          style: AppTextStyles.heading1.copyWith(
                                            fontFamily: 'serif',
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.ribbon.withValues(alpha: 0.15),
                                              AppColors.olive.withValues(alpha: 0.15),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'DAILY INSPIRATION',
                                          style: AppTextStyles.caption.copyWith(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ribbon,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: _showHelpDialog,
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.olive.withValues(alpha: 0.1),
                                              AppColors.ribbon.withValues(alpha: 0.1),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.olive.withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.help_outline,
                                          size: 22,
                                          color: AppColors.olive,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSearching = !_isSearching;
                                          if (!_isSearching) {
                                            _searchController.clear();
                                            _searchFocusNode.unfocus();
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.ribbon.withValues(alpha: 0.1),
                                              AppColors.olive.withValues(alpha: 0.1),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.ribbon.withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Icon(
                                          _isSearching ? Icons.close : Icons.search,
                                          size: 22,
                                          color: AppColors.ribbon,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.ribbon.withValues(alpha: 0.3),
                                    AppColors.olive.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_isSearching)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.paper,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.ribbon.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Search poems, authors...',
                                    hintStyle: AppTextStyles.caption.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: AppColors.ribbon,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  style: AppTextStyles.bodyText,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.ribbon,
                                          AppColors.olive,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${filteredPoems.length} poets sharing their voices',
                                      style: AppTextStyles.bodyText.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: filteredPoems.isEmpty
                          ? SliverToBoxAdapter(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 40),
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.8),
                                      AppColors.paperLight.withValues(alpha: 0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: AppColors.textTertiary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No Results Found',
                                      style: AppTextStyles.poemTitle.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try different keywords',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final poem = filteredPoems[index];
                                  return TweenAnimationBuilder<double>(
                                    duration: Duration(milliseconds: 300 + (index * 50)),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () => _openAuthorProfile(poem.authorId),
                                      onLongPress: () => _showPoemOptions(poem),
                                      child: PoemCard(
                                        poem: poem,
                                        onTap: () => _openAuthorProfile(poem.authorId),
                                        onLike: () => _toggleLike(poem),
                                        onBookmark: () => _toggleBookmark(poem),
                                      ),
                                    ),
                                  );
                                },
                                childCount: filteredPoems.length,
                              ),
                            ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                ),
        ),
      ),
      ),
    );
  }
}
