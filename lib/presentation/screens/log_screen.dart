import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import '../../core/constants/app_constants.dart';
import '../../data/models/practice_log_model.dart';
import '../widgets/calendar_widget.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, PracticeLog> _logs = {};
  bool _isLoading = true;
  bool _isCalendarExpanded = true; // 默认展开
  final Map<String, Timer> _reviewTimers = {}; // 存储审核定时器

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  void dispose() {
    // 清理所有定时器
    for (var timer in _reviewTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getString('practice_logs');
    if (logsJson != null) {
      final Map<String, dynamic> decoded = json.decode(logsJson);
      setState(() {
        _logs = decoded.map((key, value) => 
          MapEntry(key, PracticeLog.fromJson(value as Map<String, dynamic>))
        );
        _isLoading = false;
      });

      // 为pending状态的日志重新启动定时器
      _logs.forEach((dateKey, log) {
        if (log.reviewStatus == ReviewStatus.pending) {
          // 计算剩余时间（假设审核时间为15秒）
          final elapsed = DateTime.now().difference(log.createdAt).inSeconds;
          final remaining = 15 - elapsed;
          
          if (remaining > 0) {
            // 还有剩余时间，继续等待
            _reviewTimers[log.id]?.cancel();
            _reviewTimers[log.id] = Timer(Duration(seconds: remaining), () {
              if (!mounted) return;
              
              final currentLog = _logs[dateKey];
              if (currentLog != null && currentLog.reviewStatus == ReviewStatus.pending) {
                final approvedLog = currentLog.copyWith(
                  reviewStatus: ReviewStatus.approved,
                  reviewedAt: DateTime.now(),
                );

                setState(() {
                  _logs[dateKey] = approvedLog;
                });
                _saveLogs();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Review Approved! Your practice log has been published.',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      duration: const Duration(seconds: 3),
                      padding: const EdgeInsets.all(16),
                    ),
                  );
                }
              }
              _reviewTimers.remove(log.id);
            });
          } else {
            // 时间已过，直接标记为通过
            final approvedLog = log.copyWith(
              reviewStatus: ReviewStatus.approved,
              reviewedAt: DateTime.now(),
            );
            _logs[dateKey] = approvedLog;
            _saveLogs();
          }
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = json.encode(_logs.map((key, value) => 
      MapEntry(key, value.toJson())
    ));
    await prefs.setString('practice_logs', logsJson);
  }

  List<DateTime> get _loggedDates {
    return _logs.values.map((log) => log.date).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppConstants.ebony,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppConstants.theatreRed, AppConstants.balletPink],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.theatreRed.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: AppConstants.theatreRed,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.ebony,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildStats()),
            SliverToBoxAdapter(child: _buildCalendar()),
            SliverToBoxAdapter(child: _buildSelectedDateLog()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.theatreRed,
                      AppConstants.balletPink,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.theatreRed.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Practice Log',
                      style: TextStyle(
                        color: AppConstants.offWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppConstants.graphite.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                size: 12,
                                color: AppConstants.theatreRed.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Private',
                                style: TextStyle(
                                  color: AppConstants.theatreRed.withValues(alpha: 0.9),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Your dance diary',
                          style: TextStyle(
                            color: AppConstants.midGray.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.graphite.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: AppConstants.offWhite,
                    size: 24,
                  ),
                  onPressed: _showFeatureGuide,
                  tooltip: 'Feature Guide',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFeatureGuide() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppConstants.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 650),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.theatreRed.withValues(alpha: 0.2),
                      AppConstants.graphite,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.theatreRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppConstants.theatreRed,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Practice Log Guide',
                            style: TextStyle(
                              color: AppConstants.offWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'How to use this feature',
                            style: TextStyle(
                              color: AppConstants.midGray,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppConstants.midGray),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGuideSection(
                        '📅 Select a Date',
                        'Use the calendar to select any date. You can only add logs for today or past dates.',
                        Icons.calendar_today_rounded,
                        AppConstants.techBlue,
                      ),
                      const SizedBox(height: 16),
                      _buildGuideSection(
                        '✍️ Add Practice Log',
                        'Tap the "Add" button to record your practice:\n\n'
                        '• Duration: How long you practiced (1-1440 minutes)\n'
                        '• Photos: Add up to 9 photos of your practice\n'
                        '• Notes: Write private notes about your session',
                        Icons.add_circle_outline_rounded,
                        AppConstants.balletPink,
                      ),
                      const SizedBox(height: 16),
                      _buildGuideSection(
                        '🔍 Content Review Process',
                        'After submitting your practice log:\n\n'
                        '• Your content will be reviewed by our team\n'
                        '• You\'ll see a "审核中" (Under Review) badge\n'
                        '• Review typically takes 10-20 seconds\n'
                        '• You\'ll be notified when approved\n'
                        '• The badge will disappear after approval',
                        Icons.verified_user_rounded,
                        AppConstants.energyYellow,
                      ),
                      const SizedBox(height: 16),
                      _buildGuideSection(
                        '🗑️ Delete a Log',
                        'Long press on any practice log card to delete it. This action cannot be undone.',
                        Icons.delete_outline_rounded,
                        AppConstants.theatreRed,
                      ),
                      const SizedBox(height: 16),
                      _buildGuideSection(
                        '🔒 Privacy',
                        'All your practice logs are private and only visible to you. They are stored securely on your device.',
                        Icons.lock_outline_rounded,
                        const Color(0xFF9B59B6),
                      ),
                      const SizedBox(height: 16),
                      _buildGuideSection(
                        '📊 Track Progress',
                        'View your statistics at the top:\n\n'
                        '• Total practice days\n'
                        '• Total hours practiced\n'
                        '• This month\'s practice count',
                        Icons.trending_up_rounded,
                        const Color(0xFF4CAF50),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppConstants.ebony.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppConstants.theatreRed.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates_rounded,
                              color: AppConstants.energyYellow.withValues(alpha: 0.8),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Tip: Consistent practice tracking helps you stay motivated and see your progress over time!',
                                style: TextStyle(
                                  color: AppConstants.midGray,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppConstants.midGray.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.theatreRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Got It!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideSection(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final totalLogs = _logs.length;
    final totalMinutes = _logs.values.fold<int>(0, (sum, log) => sum + log.durationMinutes);
    final thisMonthLogs = _logs.values.where((log) => 
      log.date.year == DateTime.now().year && 
      log.date.month == DateTime.now().month
    ).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactStatCard(
              icon: Icons.calendar_today_rounded,
              value: '$totalLogs',
              label: 'Days',
              gradient: const LinearGradient(
                colors: [AppConstants.theatreRed, AppConstants.balletPink],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCompactStatCard(
              icon: Icons.access_time_rounded,
              value: '${(totalMinutes / 60).toStringAsFixed(1)}h',
              label: 'Hours',
              gradient: const LinearGradient(
                colors: [AppConstants.techBlue, AppConstants.balletPink],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCompactStatCard(
              icon: Icons.trending_up_rounded,
              value: '$thisMonthLogs',
              label: 'Month',
              gradient: const LinearGradient(
                colors: [AppConstants.balletPink, AppConstants.theatreRed],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.theatreRed.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppConstants.midGray.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.graphite.withValues(alpha: 0.4),
              AppConstants.graphite.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.midGray.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 日历标题和展开/收起按钮
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCalendarExpanded = !_isCalendarExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCalendarExpanded 
                      ? AppConstants.graphite.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppConstants.theatreRed,
                                AppConstants.balletPink,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.theatreRed.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatMonthYear(_selectedDate),
                              style: const TextStyle(
                                color: AppConstants.offWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              '${_logs.length} practice days',
                              style: TextStyle(
                                color: AppConstants.midGray.withValues(alpha: 0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConstants.ebony.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _isCalendarExpanded ? 'Hide' : 'Show',
                            style: TextStyle(
                              color: AppConstants.theatreRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: _isCalendarExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppConstants.theatreRed,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 日历内容（可展开/收起）
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isCalendarExpanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: CalendarWidget(
                        selectedDate: _selectedDate,
                        loggedDates: _loggedDates,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildSelectedDateLog() {
    final dateKey = _getDateKey(_selectedDate);
    final log = _logs[dateKey];
    final isToday = _isSameDay(_selectedDate, DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatSelectedDate(_selectedDate),
                          style: const TextStyle(
                            color: AppConstants.offWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppConstants.theatreRed,
                                  AppConstants.balletPink,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.theatreRed.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log != null ? 'Practice recorded' : 'No practice yet',
                      style: TextStyle(
                        color: log != null
                            ? AppConstants.theatreRed.withValues(alpha: 0.8)
                            : AppConstants.midGray.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (log == null)
                Container(
                  decoration: BoxDecoration(
                    gradient: _canAddLog(_selectedDate)
                        ? const LinearGradient(
                            colors: [
                              AppConstants.theatreRed,
                              AppConstants.balletPink,
                            ],
                          )
                        : null,
                    color: _canAddLog(_selectedDate)
                        ? null
                        : AppConstants.midGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: _canAddLog(_selectedDate)
                        ? [
                            BoxShadow(
                              color: AppConstants.theatreRed.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _canAddLog(_selectedDate) ? () => _showAddLogDialog() : null,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (log != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogCard(log),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppConstants.graphite.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppConstants.midGray.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 14,
                          color: AppConstants.midGray.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Long press card to delete',
                          style: TextStyle(
                            color: AppConstants.midGray.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildLogCard(PracticeLog log) {
    return GestureDetector(
      onLongPress: () => _showDeleteConfirmDialog(log),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.graphite.withValues(alpha: 0.6),
              AppConstants.graphite.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppConstants.midGray.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.theatreRed,
                      AppConstants.balletPink,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.theatreRed.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration',
                      style: TextStyle(
                        color: AppConstants.midGray.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${log.durationMinutes} minutes',
                      style: const TextStyle(
                        color: AppConstants.offWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              // 审核状态标签
              if (log.reviewStatus == ReviewStatus.pending)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppConstants.energyYellow,
                        Color(0xFFFFA726),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.energyYellow.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
'Under Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (log.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.ebony.withValues(alpha: 0.6),
                    AppConstants.ebony.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppConstants.midGray.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppConstants.theatreRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.notes_rounded,
                          size: 14,
                          color: AppConstants.theatreRed.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Notes',
                        style: TextStyle(
                          color: AppConstants.midGray.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    log.notes,
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 15,
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (log.photos.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.graphite.withValues(alpha: 0.4),
                    AppConstants.graphite.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppConstants.midGray.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppConstants.techBlue, AppConstants.balletPink],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.photo_library_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Photos',
                        style: TextStyle(
                          color: AppConstants.midGray.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppConstants.techBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${log.photos.length}',
                          style: const TextStyle(
                            color: AppConstants.techBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: log.photos.map((photo) {
                      return GestureDetector(
                        onTap: () => _showPhotoDialog(photo),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(photo),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppConstants.graphite.withValues(alpha: 0.6),
                                        AppConstants.graphite.withValues(alpha: 0.4),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.image_rounded,
                                    color: AppConstants.midGray,
                                    size: 36,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final canAdd = _canAddLog(_selectedDate);
    
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.4),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: canAdd
                    ? [
                        AppConstants.graphite.withValues(alpha: 0.6),
                        AppConstants.graphite.withValues(alpha: 0.4),
                      ]
                    : [
                        AppConstants.midGray.withValues(alpha: 0.3),
                        AppConstants.midGray.withValues(alpha: 0.2),
                      ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              canAdd ? Icons.edit_note_rounded : Icons.event_busy_rounded,
              size: 48,
              color: canAdd
                  ? AppConstants.theatreRed.withValues(alpha: 0.8)
                  : AppConstants.midGray.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            canAdd ? 'No practice log yet' : 'Future date',
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            canAdd
                ? 'Tap "Add Log" to record your practice'
                : 'Cannot add logs for future dates',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: canAdd
                  ? AppConstants.midGray.withValues(alpha: 0.8)
                  : AppConstants.theatreRed.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  bool _canAddLog(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);
    return !selectedDay.isAfter(today);
  }

  void _showAddLogDialog() {
    if (!_canAddLog(_selectedDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Cannot add logs for future dates'),
            ],
          ),
          backgroundColor: AppConstants.graphite,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddPracticeLogScreen(
          selectedDate: _selectedDate,
          onSave: (duration, notes, photos) {
            _saveLog(null, duration, notes, photos);
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _showDeleteConfirmDialog(PracticeLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Delete Practice Log',
          style: TextStyle(
            color: AppConstants.offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this practice log? This action cannot be undone.',
          style: TextStyle(
            color: AppConstants.midGray,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteLog(log);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppConstants.theatreRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveLog(String? id, int duration, String notes, List<String> photos) {
    final dateKey = _getDateKey(_selectedDate);
    final logId = id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final log = PracticeLog(
      id: logId,
      date: _selectedDate,
      durationMinutes: duration,
      notes: notes,
      photos: photos,
      createdAt: DateTime.now(),
      reviewStatus: ReviewStatus.pending,
    );

    setState(() {
      _logs[dateKey] = log;
    });
    _saveLogs();

    // 显示审核提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Practice log submitted!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppConstants.energyYellow,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'We will review your content and publish it after approval.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppConstants.graphite,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(16),
      ),
    );

    // 启动审核定时器（10-20秒后自动通过）
    _startReviewTimer(logId, dateKey);
  }

  void _startReviewTimer(String logId, String dateKey) {
    // 取消之前的定时器（如果存在）
    _reviewTimers[logId]?.cancel();

    // 随机10-20秒
    final random = Random();
    final seconds = 10 + random.nextInt(11); // 10到20秒之间

    _reviewTimers[logId] = Timer(Duration(seconds: seconds), () {
      if (!mounted) return;

      final log = _logs[dateKey];
      if (log != null && log.reviewStatus == ReviewStatus.pending) {
        // 更新审核状态为通过
        final approvedLog = log.copyWith(
          reviewStatus: ReviewStatus.approved,
          reviewedAt: DateTime.now(),
        );

        setState(() {
          _logs[dateKey] = approvedLog;
        });
        _saveLogs();

        // 显示审核通过提示
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Review Approved!',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your practice log has been approved and published.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              duration: const Duration(seconds: 4),
              padding: const EdgeInsets.all(16),
            ),
          );
        }
      }

      // 清理定时器
      _reviewTimers.remove(logId);
    });
  }

  void _deleteLog(PracticeLog log) {
    final dateKey = _getDateKey(log.date);
    setState(() {
      _logs.remove(dateKey);
    });
    _saveLogs();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Practice log deleted'),
          ],
        ),
        backgroundColor: AppConstants.graphite,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatSelectedDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showPhotoDialog(String photoPath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(photoPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.graphite.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppConstants.offWhite,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 添加练习记录的全屏界面
class _AddPracticeLogScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(int duration, String notes, List<String> photos) onSave;

  const _AddPracticeLogScreen({
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<_AddPracticeLogScreen> createState() => _AddPracticeLogScreenState();
}

class _AddPracticeLogScreenState extends State<_AddPracticeLogScreen> {
  late TextEditingController _durationController;
  late TextEditingController _notesController;
  final List<String> _photos = [];
  final ImagePicker _picker = ImagePicker();
  static const int _maxPhotos = 9; // 最多9张照片

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_photos.length >= _maxPhotos) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maximum $_maxPhotos photos allowed'),
            backgroundColor: AppConstants.theatreRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      return;
    }

    final remainingSlots = _maxPhotos - _photos.length;
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      
      if (images.isNotEmpty && mounted) {
        final imagesToAdd = images.take(remainingSlots).toList();
        setState(() {
          _photos.addAll(imagesToAdd.map((img) => img.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to pick images'),
            backgroundColor: AppConstants.theatreRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _save() {
    final duration = int.tryParse(_durationController.text) ?? 0;
    
    // 验证时长范围
    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Please enter practice duration')),
            ],
          ),
          backgroundColor: AppConstants.theatreRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (duration > 1440) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Duration cannot exceed 1440 minutes (24 hours)')),
            ],
          ),
          backgroundColor: AppConstants.theatreRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    widget.onSave(duration, _notesController.text, _photos);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白区域收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppConstants.ebony,
        appBar: AppBar(
          backgroundColor: AppConstants.ebony,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppConstants.offWhite),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add Practice',
            style: TextStyle(
              color: AppConstants.offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Date display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.graphite.withValues(alpha: 0.5),
                    AppConstants.graphite.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppConstants.theatreRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      color: AppConstants.theatreRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDate(widget.selectedDate),
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Duration input
            Text(
              'Practice Duration',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // 只允许数字
                LengthLimitingTextInputFormatter(4), // 最多4位数字（最大9999分钟）
                _DurationInputFormatter(), // 自定义格式化器，限制范围
              ],
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'e.g., 60',
                hintStyle: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.5),
                ),
                suffixText: 'minutes',
                suffixStyle: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.7),
                ),
                helperText: 'Range: 1-1440 minutes (1 min - 24 hours)',
                helperStyle: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
                filled: true,
                fillColor: AppConstants.graphite.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 24),

            // Photos section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Practice Photos',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${_photos.length}/$_maxPhotos',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.graphite.withValues(alpha: 0.5),
                    AppConstants.graphite.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppConstants.midGray.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  if (_photos.isEmpty)
                    Column(
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          size: 48,
                          color: AppConstants.midGray.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No photos added yet',
                          style: TextStyle(
                            color: AppConstants.midGray.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Capture your real practice moments',
                          style: TextStyle(
                            color: AppConstants.midGray.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._photos.asMap().entries.map((entry) {
                          final index = entry.key;
                          final photo = entry.value;
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(photo),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removePhoto(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppConstants.theatreRed,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _photos.length < _maxPhotos ? _pickImages : null,
                      icon: const Icon(Icons.add_photo_alternate_rounded, size: 20),
                      label: Text(_photos.isEmpty ? 'Add Photos' : 'Add More Photos'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.theatreRed,
                        side: BorderSide(
                          color: _photos.length < _maxPhotos 
                              ? AppConstants.theatreRed 
                              : AppConstants.midGray.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notes input
            Text(
              'Private Notes',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 6,
              maxLength: 500, // 最多500个字符
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 15,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: 'How was your practice today?\n\ne.g., "Today teacher corrected my hand position, still unstable on my feet."',
                hintStyle: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.5),
                  height: 1.6,
                ),
                helperText: 'Optional, max 500 characters',
                helperStyle: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
                counterStyle: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
                filled: true,
                fillColor: AppConstants.graphite.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.theatreRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'Save Practice Log',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// 自定义输入格式化器，用于限制练习时长的输入范围
class _DurationInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    // 限制最大值为1440分钟（24小时）
    if (value > 1440) {
      return oldValue;
    }

    return newValue;
  }
}
