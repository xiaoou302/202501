import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/breath_mode.dart';
import '../services/breath_service.dart';
import '../theme/app_theme.dart';

class BreatheScreen extends StatefulWidget {
  const BreatheScreen({Key? key}) : super(key: key);

  @override
  State<BreatheScreen> createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with SingleTickerProviderStateMixin {
  final BreathService _breathService = BreathService();
  final List<BreathMode> _breathModes = BreathMode.getAllModes();

  // View states
  bool _isSelectionView = true;
  bool _isSessionView = false;
  bool _isSummaryView = false;

  // Session state
  String _currentInstruction = '';
  int _currentTimer = 0;
  int _currentRound = 1;
  int _totalRounds = 0;
  double _progress = 0.0;
  BreathMode? _selectedMode;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupBreathService();
    _loadServiceData();
  }

  Future<void> _loadServiceData() async {
    await _breathService.initialize();
    setState(() {});
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _setupBreathService() {
    _breathService.onInstructionChange = (instruction) {
      setState(() {
        _currentInstruction = instruction;
        if (instruction.toLowerCase().contains('inhale')) {
          _animationController.forward();
        } else if (instruction.toLowerCase().contains('exhale')) {
          _animationController.reverse();
        }
      });
    };

    _breathService.onTimerChange = (timer) {
      setState(() {
        _currentTimer = timer;
      });
    };

    _breathService.onRoundChange = (round, total) {
      setState(() {
        _currentRound = round;
        _totalRounds = total;
      });
    };

    _breathService.onProgressChange = (progress) {
      setState(() {
        _progress = progress;
      });
    };

    _breathService.onSessionComplete = () {
      _animationController.reset();
      setState(() {
        _isSelectionView = false;
        _isSessionView = false;
        _isSummaryView = true;
      });
    };
  }

  void _startBreathing(BreathMode mode) {
    setState(() {
      _selectedMode = mode;
      _isSelectionView = false;
      _isSessionView = true;
      _isSummaryView = false;
    });

    _breathService.startBreathing(mode);
  }

  void _endBreathing(bool completed) {
    _breathService.endBreathing();

    if (completed) {
      setState(() {
        _isSelectionView = false;
        _isSessionView = false;
        _isSummaryView = true;
      });
    } else {
      _showSelectionView();
    }
  }

  void _showSelectionView() {
    setState(() {
      _isSelectionView = true;
      _isSessionView = false;
      _isSummaryView = false;
    });
  }

  void _restartSession() {
    if (_selectedMode != null) {
      _startBreathing(_selectedMode!);
    }
  }

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
  }

  IconData _getIconFromName(String name) {
    switch (name) {
      case 'water':
        return FontAwesomeIcons.water;
      case 'crosshairs':
        return FontAwesomeIcons.crosshairs;
      case 'moon':
        return FontAwesomeIcons.moon;
      case 'sun':
        return FontAwesomeIcons.sun;
      case 'bed':
        return FontAwesomeIcons.bed;
      default:
        return FontAwesomeIcons.wind;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _breathService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selection View
            if (_isSelectionView) ...[
              Text('Breathing Exercise', style: AppTheme.headingStyle),
              SizedBox(height: 16),
              _buildStatisticsCard(),
              SizedBox(height: 24),
              Text(
                'Choose a mode to start a relaxing journey for your mind and body.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ..._breathModes
                  .map((mode) => _buildBreathModeCard(mode))
                  .toList(),
              SizedBox(height: 24),
            ],

            // Session View
            if (_isSessionView) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.surfaceColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.textColor),
                      onPressed: () => _endBreathing(false),
                    ),
                  ),
                  Text(
                    _selectedMode?.title ?? '',
                    style: AppTheme.subheadingStyle,
                  ),
                  SizedBox(width: 40),
                ],
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.darkGradient,
                  borderRadius: AppTheme.borderRadius,
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _selectedMode != null
                                    ? _getColorFromHex(_selectedMode!.colorHex)
                                    : AppTheme.primaryColor,
                                _selectedMode != null
                                    ? _getColorFromHex(
                                        _selectedMode!.colorHex,
                                      ).withOpacity(0.7)
                                    : AppTheme.primaryColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      _currentInstruction,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _selectedMode != null
                            ? _getColorFromHex(_selectedMode!.colorHex)
                            : AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _selectedMode != null
                                    ? _getColorFromHex(_selectedMode!.colorHex)
                                    : AppTheme.primaryColor,
                                _selectedMode != null
                                    ? _getColorFromHex(
                                        _selectedMode!.colorHex,
                                      ).withOpacity(0.7)
                                    : AppTheme.primaryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_currentTimer}s',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textColor.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          'Round $_currentRound / $_totalRounds',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              _buildTipsSection(),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => _endBreathing(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.buttonRadius,
                    ),
                    elevation: 8,
                    shadowColor: AppTheme.accentRed.withOpacity(0.3),
                  ),
                  child: Text(
                    'End Exercise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],

            // Summary View
            if (_isSummaryView) ...[
              SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _selectedMode != null
                                ? _getColorFromHex(_selectedMode!.colorHex)
                                : AppTheme.primaryColor,
                            _selectedMode != null
                                ? _getColorFromHex(
                                    _selectedMode!.colorHex,
                                  ).withOpacity(0.7)
                                : AppTheme.primaryColor.withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 48),
                    ),
                    SizedBox(height: 24),
                    Text('Exercise Complete!', style: AppTheme.headingStyle),
                    SizedBox(height: 8),
                    Text(
                      _selectedMode != null
                          ? 'You completed ${_selectedMode!.totalRounds} rounds of "${_selectedMode!.title}" exercise.'
                          : 'You completed the breathing exercise.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textColor.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    _buildSessionStats(),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _restartSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedMode != null
                            ? _getColorFromHex(
                                _selectedMode!.colorHex,
                              ).withOpacity(0.9)
                            : AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.buttonRadius,
                        ),
                      ),
                      child: Text('Practice Again'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _showSelectionView,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.surfaceColor,
                        foregroundColor: AppTheme.textColor,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.buttonRadius,
                        ),
                      ),
                      child: Text('Choose Another Mode'),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathModeCard(BreathMode mode) {
    final color = _getColorFromHex(mode.colorHex);
    final icon = _getIconFromName(mode.icon);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _startBreathing(mode),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2238), Color(0xFF12192D)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    Text(
                      mode.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE0E0E0).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFF606060)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: FontAwesomeIcons.chartLine,
                value: _breathService.totalSessionsCompleted.toString(),
                label: 'Sessions',
                color: AppTheme.accentBlue,
              ),
              _buildStatItem(
                icon: FontAwesomeIcons.clock,
                value: '${_breathService.totalMinutesPracticed}',
                label: 'Minutes',
                color: AppTheme.accentPink,
              ),
            ],
          ),
          if (_breathService.lastSessionDate != null) ...[
            Divider(color: AppTheme.textColor.withOpacity(0.1), height: 32),
            Text(
              'Last Session: ${_formatDate(_breathService.lastSessionDate!)}',
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textColor.withOpacity(0.7), size: 20),
          SizedBox(width: 12),
          Text(title, style: TextStyle(color: AppTheme.textColor)),
          Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accentPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats() {
    if (_selectedMode == null) return SizedBox.shrink();

    final totalTime =
        _selectedMode!.steps.reduce((a, b) => a + b) *
        _selectedMode!.totalRounds;
    final minutes = totalTime ~/ 60;
    final seconds = totalTime % 60;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: FontAwesomeIcons.stopwatch,
                value: '$minutes:${seconds.toString().padLeft(2, '0')}',
                label: 'Duration',
                color: AppTheme.accentBlue,
              ),
              _buildStatItem(
                icon: FontAwesomeIcons.repeat,
                value: _selectedMode!.totalRounds.toString(),
                label: 'Rounds',
                color: AppTheme.accentPink,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.lightbulb,
              color: Color(0xFFFEE440),
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              'Mindfulness Tips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildTipCard(
          icon: FontAwesomeIcons.leaf,
          color: Color(0xFF4FC1B9),
          title: 'Be Present',
          content:
              'During practice, try to focus all your attention on your breathing, ignoring distracting thoughts.',
        ),
        SizedBox(height: 12),
        _buildTipCard(
          icon: FontAwesomeIcons.couch,
          color: Color(0xFF9B5DE5),
          title: 'Comfortable Position',
          content:
              'Find a comfortable position to sit or lie down, allowing your body to fully relax for better practice.',
        ),
      ],
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2238), Color(0xFF12192D)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE0E0E0).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
