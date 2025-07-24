import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../services/journal_repository.dart';
import '../services/journal_share_service.dart';
import '../widgets/color_picker.dart';

import 'journal_detail_screen.dart';
import '../theme/app_theme.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final JournalRepository _repository = JournalRepository();
  final JournalShareService _shareService = JournalShareService();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _animation;

  Color _selectedColor = AppTheme.primaryColor; // Default color
  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Text input limits
  final int _maxTitleLength = 50;
  final int _maxTextLength = 500;

  @override
  void initState() {
    super.initState();
    _loadEntries();

    // Setup animation for color picker
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
    });

    final entries = await _repository.getAllEntries();

    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadEntries();
      } else {
        // Focus on search field when opened
        Future.delayed(Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(_searchFocusNode);
        });
      }
    });
  }

  void _searchEntries(String query) async {
    if (query.isEmpty) {
      await _loadEntries();
      return;
    }

    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });

    final results = await _repository.searchEntries(query);

    setState(() {
      _entries = results;
      _isLoading = false;
    });
  }

  Future<void> _saveEntry() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Please enter content');
      return;
    }

    if (text.length > _maxTextLength) {
      _showSnackBar('Content cannot exceed $_maxTextLength characters');
      return;
    }

    final title = _titleController.text.trim();
    if (title.length > _maxTitleLength) {
      _showSnackBar('Title cannot exceed $_maxTitleLength characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final entry = JournalEntry(
      id: Uuid().v4(),
      text: text,
      title: title.isEmpty ? null : title,
      colorHex: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      date: DateTime.now(),
      tags: [],
      mood: null,
      isFavorite: false,
    );

    await _repository.saveEntry(entry);
    _textController.clear();
    _titleController.clear();

    // Clear focus after saving
    FocusScope.of(context).unfocus();

    await _loadEntries();

    _showSnackBar('Entry saved');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _viewEntryDetails(JournalEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailScreen(entry: entry),
      ),
    );

    if (result == true) {
      await _loadEntries();
    }
  }

  Future<void> _shareEntry(JournalEntry entry) async {
    _showSnackBar('Creating share card...');

    await _shareService.convertJournalToShareCard(entry);

    _showSnackBar('Share card created, please go to "Share" tab to view');
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    try {
      await _repository.deleteEntry(entry.id);
      await _loadEntries();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Entry deleted'),
              ],
            ),
            backgroundColor: AppTheme.accentRed.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                await _repository.saveEntry(entry);
                await _loadEntries();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete entry: $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Journal Entry',
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this entry?',
              style: TextStyle(color: AppTheme.textColor.withOpacity(0.9)),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(
                  int.parse(entry.colorHex.replaceAll('#', '0xFF')),
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(
                    int.parse(entry.colorHex.replaceAll('#', '0xFF')),
                  ).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.title != null && entry.title!.isNotEmpty) ...[
                    Text(
                      entry.title!,
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  Text(
                    entry.text,
                    style: TextStyle(
                      color: AppTheme.textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
            onPressed: () {
              Navigator.pop(context);
              _deleteEntry(entry);
            },
            child: Text('Delete', style: TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    _searchController.dispose();
    _textFocusNode.dispose();
    _titleFocusNode.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(
        context,
      ).unfocus(), // Dismiss keyboard when tapping outside
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and search
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!_isSearching)
                      Text('Journal', style: AppTheme.headingStyle)
                    else
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppTheme.accentGreen.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: TextStyle(color: AppTheme.textColor),
                            decoration: InputDecoration(
                              hintText: 'Search entries...',
                              hintStyle: TextStyle(
                                color: AppTheme.textColor.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppTheme.accentGreen,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            onChanged: _searchEntries,
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                      ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _isSearching
                            ? AppTheme.surfaceColor
                            : AppTheme.surfaceColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isSearching ? Icons.close : Icons.search,
                          color: _isSearching
                              ? AppTheme.accentGreen
                              : AppTheme.textColor,
                        ),
                        onPressed: _toggleSearch,
                      ),
                    ),
                  ],
                ),
              ),

              if (!_isSearching) ...[
                SizedBox(height: 24),

                // Title input
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _selectedColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add title (optional)',
                      hintStyle: TextStyle(
                        color: AppTheme.textColor.withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceColor,
                      contentPadding: EdgeInsets.all(16),
                      counterText:
                          '${_titleController.text.length}/$_maxTitleLength',
                      counterStyle: TextStyle(
                        color: _titleController.text.length > _maxTitleLength
                            ? Colors.red
                            : AppTheme.textColor.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(Icons.title, color: _selectedColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: _selectedColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    maxLength: _maxTitleLength,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_textFocusNode),
                    onChanged: (text) {
                      // Force counter update
                      setState(() {});
                    },
                  ),
                ),

                SizedBox(height: 16),

                // Main content input
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _selectedColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _textController,
                    focusNode: _textFocusNode,
                    maxLines: 6,
                    style: TextStyle(color: AppTheme.textColor),
                    decoration: InputDecoration(
                      hintText: 'Write your thoughts...',
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
                          color: _selectedColor,
                          width: 1.5,
                        ),
                      ),
                      counterText:
                          '${_textController.text.length}/$_maxTextLength',
                      counterStyle: TextStyle(
                        color: _textController.text.length > _maxTextLength
                            ? Colors.red
                            : AppTheme.textColor.withOpacity(0.5),
                      ),
                    ),
                    maxLength: _maxTextLength,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    onChanged: (text) {
                      // Force counter update
                      setState(() {});
                    },
                  ),
                ),

                SizedBox(height: 24),

                // Color selection
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.palette,
                              color: _selectedColor,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Choose color scheme',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ColorPicker(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.accentGreen,
                            AppTheme.accentPurple,
                            AppTheme.accentPink,
                            AppTheme.accentYellow,
                            AppTheme.accentBlue,
                          ],
                          selectedColor: _selectedColor,
                          onColorSelected: (color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Save button
                Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: _selectedColor.withOpacity(0.5),
                        minimumSize: Size(200, 50),
                      ),
                      child: _isLoading
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
                                Icon(Icons.save),
                                SizedBox(width: 8),
                                Text(
                                  'Save Entry',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 32),

              // Recent entries title
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        FontAwesomeIcons.history,
                        color: AppTheme.accentGreen,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      _isSearching ? 'Search Results' : 'Recent Entries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Entries list
              _isLoading && !_isSearching
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    )
                  : _entries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              _isSearching
                                  ? Icons.search_off
                                  : FontAwesomeIcons.bookOpen,
                              color: AppTheme.textColor.withOpacity(0.5),
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _isSearching
                                  ? 'No matching entries found'
                                  : 'No entries yet',
                              style: TextStyle(
                                color: AppTheme.textColor.withOpacity(0.7),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!_isSearching) ...[
                              SizedBox(height: 24),
                              Text(
                                'Write your first journal entry above',
                                style: TextStyle(
                                  color: AppTheme.accentGreen,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        final color = Color(
                          int.parse(entry.colorHex.replaceAll('#', '0xFF')),
                        );

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(bottom: 16),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: AppTheme.surfaceColor,
                            elevation: 4,
                            shadowColor: Colors.black.withOpacity(0.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card top color bar
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title and date
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              entry.title ?? 'Untitled',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}',
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),

                                      // Content preview
                                      Text(
                                        entry.text,
                                        style: TextStyle(
                                          color: AppTheme.textColor.withOpacity(
                                            0.9,
                                          ),
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),

                                      // Action buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Delete button
                                          Material(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              onTap: () =>
                                                  _showDeleteConfirmation(
                                                    entry,
                                                  ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: AppTheme.accentRed,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.delete_outline,
                                                      size: 16,
                                                      color: AppTheme.accentRed,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color:
                                                            AppTheme.accentRed,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),

                                          // View button
                                          Material(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              onTap: () =>
                                                  _viewEntryDetails(entry),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: AppTheme.accentGreen,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.visibility,
                                                      size: 16,
                                                      color:
                                                          AppTheme.accentGreen,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'View',
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .accentGreen,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),

                                          // Share button
                                          Material(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              onTap: () => _shareEntry(entry),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: color,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.share,
                                                      size: 16,
                                                      color: color,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Share',
                                                      style: TextStyle(
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
