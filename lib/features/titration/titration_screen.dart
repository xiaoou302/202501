import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import 'widgets/tank_wireframe.dart';

class TitrationScreen extends StatefulWidget {
  const TitrationScreen({super.key});

  @override
  State<TitrationScreen> createState() => _TitrationScreenState();
}

class _TitrationScreenState extends State<TitrationScreen> {
  double _hardscapeVolume = 15;
  double _density = 50;

  // Tank Dimensions (cm)
  double _length = 90;
  double _width = 45;
  double _height = 45;
  double _substrateHeight = 5;

  String _selectedBrand = 'ADA';
  final List<String> _brands = ['ADA', 'Seachem', 'Tropica'];
  final List<Map<String, String>> _scheduledDoses = [];

  double get _grossVolume => (_length * _width * _height) / 1000;
  double get _substrateVolume => (_length * _width * _substrateHeight) / 1000;
  double get _hardscapeLiters => _grossVolume * (_hardscapeVolume / 100);
  double get _netVolume => _grossVolume - _substrateVolume - _hardscapeLiters;

  Map<String, String> get _dosingPrescription {
    double densityMultiplier = 1.0;
    if (_density < 33)
      densityMultiplier = 0.5;
    else if (_density > 66)
      densityMultiplier = 1.5;

    // Base Dosing logic (Simplified heuristics)
    // ADA: 1ml per 20L (approx)
    // Seachem: 5ml per 250L (approx)
    double macroDose = 0;
    double microDose = 0;
    String macroName = 'Macros';
    String microName = 'Micros';
    String macroUnit = 'ml';
    String microUnit = 'ml';

    if (_selectedBrand == 'ADA') {
      // Green Brighty Neutral K + Mineral
      macroName = 'Green Brighty K';
      microName = 'Mineral';
      macroDose = (_netVolume / 20) * densityMultiplier;
      microDose = (_netVolume / 20) * densityMultiplier;
    } else if (_selectedBrand == 'Seachem') {
      // NPK + Iron/Trace
      macroName = 'Flourish NPK';
      microName = 'Iron/Trace';
      macroDose = (_netVolume / 40) * densityMultiplier; // Approx
      microDose = (_netVolume / 80) * densityMultiplier; // Approx
    } else if (_selectedBrand == 'Tropica') {
      // Specialised vs Premium
      macroName = 'Specialised'; // Green (Macros+Micros)
      microName = 'Premium'; // Orange (Micros only)
      macroDose = (_netVolume / 100 * 2) * densityMultiplier; // 2ml per 100L
      microDose = (_netVolume / 100 * 2) * densityMultiplier;
    }

    return {
      'macroName': macroName,
      'microName': microName,
      'macroVal': '+${macroDose.toStringAsFixed(1)}',
      'microVal': '+${microDose.toStringAsFixed(1)}',
      'macroUnit': macroUnit,
      'microUnit': microUnit,
    };
  }

  void _showScheduleDialog() {
    final dose = _dosingPrescription;
    String selectedFreq = 'Daily';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.deepTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.aquaCyan.withValues(alpha: 0.3),
              ),
            ),
            title: const Text(
              'Set Dosing Schedule',
              style: TextStyle(color: AppColors.starlightWhite),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Frequency:',
                  style: TextStyle(
                    color: AppColors.mossMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFreqOption(
                  'Daily',
                  selectedFreq,
                  (v) => setDialogState(() => selectedFreq = v),
                ),
                _buildFreqOption(
                  'Every other day',
                  selectedFreq,
                  (v) => setDialogState(() => selectedFreq = v),
                ),
                _buildFreqOption(
                  'Weekly',
                  selectedFreq,
                  (v) => setDialogState(() => selectedFreq = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.mossMuted),
                ),
              ),
              TextButton(
                onPressed: () {
                  _addSchedule(dose, selectedFreq);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: AppColors.aquaCyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addSchedule(Map<String, String> dose, String frequency) {
    setState(() {
      _scheduledDoses.add({
        'brand': _selectedBrand,
        'macro': '${dose['macroName']} ${dose['macroVal']}${dose['macroUnit']}',
        'micro': '${dose['microName']} ${dose['microVal']}${dose['microUnit']}',
        'freq': frequency,
        'time': DateTime.now().toString(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scheduled: $frequency dosing added!'),
        backgroundColor: AppColors.aquaCyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.voidBlack,
          onPressed: () {
            setState(() {
              _scheduledDoses.removeLast();
            });
          },
        ),
      ),
    );
  }

  Widget _buildFreqOption(
    String label,
    String selected,
    Function(String) onTap,
  ) {
    final isSelected = label == selected;
    return InkWell(
      onTap: () => onTap(label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.aquaCyan.withValues(alpha: 0.2)
              : AppColors.voidBlack.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.aquaCyan
                : AppColors.starlightWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? FontAwesomeIcons.circleCheck
                  : FontAwesomeIcons.circle,
              color: isSelected ? AppColors.aquaCyan : AppColors.mossMuted,
              size: 16,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.starlightWhite
                    : AppColors.mossMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dose = _dosingPrescription;

    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.flask,
                        color: AppColors.aquaCyan,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Titration Engine',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Precision Nutrient Calculator',
                    style: TextStyle(color: AppColors.mossMuted, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dimensions Input Grid
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.trenchBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.starlightWhite.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TANK DIMENSIONS (cm)',
                      style: TextStyle(
                        color: AppColors.mossMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDimensionInput(
                          'Length',
                          _length,
                          (v) => setState(() => _length = v),
                        ),
                        const SizedBox(width: 12),
                        _buildDimensionInput(
                          'Width',
                          _width,
                          (v) => setState(() => _width = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDimensionInput(
                          'Height',
                          _height,
                          (v) => setState(() => _height = v),
                        ),
                        const SizedBox(width: 12),
                        _buildDimensionInput(
                          'Substrate',
                          _substrateHeight,
                          (v) => setState(() => _substrateHeight = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tank Wireframe
              TankWireframe(
                fillPercentage: (100 - _hardscapeVolume) / 100,
                netVolume: _netVolume,
                grossVolume: _grossVolume,
              ),

              const SizedBox(height: 24),

              // Controls
              Column(
                children: [
                  // Hardscape Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hardscape Displacement',
                        style: TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${_hardscapeVolume.toInt()}%',
                        style: const TextStyle(
                          color: AppColors.starlightWhite,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _hardscapeVolume,
                    min: 0,
                    max: 50,
                    activeColor: AppColors.mossMuted,
                    inactiveColor: AppColors.trenchBlue,
                    onChanged: (v) => setState(() => _hardscapeVolume = v),
                  ),

                  const SizedBox(height: 16),

                  // Density Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Flora Density Demand',
                        style: TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _density > 66
                            ? 'High'
                            : (_density > 33 ? 'Moderate' : 'Low'),
                        style: TextStyle(
                          color: _density > 66
                              ? AppColors.toxicityAlert
                              : (_density > 33
                                    ? AppColors.algaeWarning
                                    : AppColors.floraNeon),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 24,
                      ),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.floraNeon,
                                AppColors.algaeWarning,
                                AppColors.toxicityAlert,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Slider(
                          value: _density,
                          min: 0,
                          max: 100,
                          thumbColor: AppColors.starlightWhite,
                          onChanged: (v) => setState(() => _density = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sparse',
                        style: TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Moderate',
                        style: TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Dense',
                        style: TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Brand Selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.trenchBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.starlightWhite.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.tag,
                      size: 14,
                      color: AppColors.mossMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBrand,
                          dropdownColor: AppColors.deepTeal,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.aquaCyan,
                          ),
                          style: const TextStyle(
                            color: AppColors.starlightWhite,
                            fontSize: 14,
                          ),
                          items: _brands.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedBrand = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Prescription
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.aquaCyan.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.aquaCyan.withValues(alpha: 0.4),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.filePrescription,
                          color: AppColors.aquaCyan,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'DOSING PRESCRIPTION',
                          style: TextStyle(
                            color: AppColors.aquaCyan,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildDoseItem(
                      _selectedBrand == 'ADA'
                          ? 'K'
                          : (_selectedBrand == 'Seachem' ? 'N' : 'G'),
                      dose['macroName']!,
                      dose['macroVal']!,
                      dose['macroUnit']!,
                      AppColors.floraNeon,
                      AppColors.trenchBlue,
                    ),
                    const SizedBox(height: 12),
                    _buildDoseItem(
                      _selectedBrand == 'ADA'
                          ? 'M'
                          : (_selectedBrand == 'Seachem' ? 'Fe' : 'P'),
                      dose['microName']!,
                      dose['microVal']!,
                      dose['microUnit']!,
                      AppColors.alienPurple,
                      AppColors.alienPurple.withValues(alpha: 0.2),
                    ),

                    const SizedBox(height: 24),

                    InkWell(
                      onTap: _showScheduleDialog,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.aquaCyan,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.aquaCyan.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.clock,
                              color: AppColors.voidBlack,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Dispense & Schedule',
                              style: TextStyle(
                                color: AppColors.voidBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Scheduled Regimens List
              if (_scheduledDoses.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.calendarCheck,
                      color: AppColors.floraNeon,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ACTIVE SCHEDULES',
                      style: TextStyle(
                        color: AppColors.floraNeon,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._scheduledDoses.map((schedule) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.deepTeal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.floraNeon.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule['brand']!,
                              style: const TextStyle(
                                color: AppColors.mossMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              schedule['freq']!,
                              style: const TextStyle(
                                color: AppColors.starlightWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.droplet,
                                  size: 10,
                                  color: AppColors.aquaCyan.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  schedule['macro']!,
                                  style: TextStyle(
                                    color: AppColors.aquaCyan.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  FontAwesomeIcons.leaf,
                                  size: 10,
                                  color: AppColors.alienPurple.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  schedule['micro']!,
                                  style: TextStyle(
                                    color: AppColors.alienPurple.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.trash,
                            size: 14,
                            color: AppColors.toxicityAlert,
                          ),
                          onPressed: () {
                            setState(() {
                              _scheduledDoses.remove(schedule);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionInput(
    String label,
    double value,
    Function(double) onChanged,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.mossMuted, fontSize: 10),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.voidBlack,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.starlightWhite.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    size: 14,
                    color: AppColors.mossMuted,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32),
                  onPressed: () {
                    if (value > 0) onChanged(value - 1);
                  },
                ),
                Expanded(
                  child: Text(
                    value.toInt().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.starlightWhite,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 14,
                    color: AppColors.mossMuted,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32),
                  onPressed: () => onChanged(value + 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseItem(
    String symbol,
    String name,
    String value,
    String unit,
    Color color,
    Color bgSymbol,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.voidBlack.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgSymbol,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    symbol,
                    style: TextStyle(
                      color: bgSymbol == AppColors.trenchBlue
                          ? AppColors.starlightWhite
                          : color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.starlightWhite,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    color: AppColors.mossMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
