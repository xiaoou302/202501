import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/models/water_parameter.dart';
import '../../../../data/providers/tank_provider.dart';

class AddLogDialog extends ConsumerStatefulWidget {
  const AddLogDialog({super.key});

  @override
  ConsumerState<AddLogDialog> createState() => _AddLogDialogState();
}

class _AddLogDialogState extends ConsumerState<AddLogDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _phController = TextEditingController(text: '7.0');
  final _tempController = TextEditingController(text: '24.0');
  final _tdsController = TextEditingController(text: '150');
  final _co2Controller = TextEditingController(text: '2.0');
  final _khController = TextEditingController(text: '4.0');
  final _ghController = TextEditingController(text: '6.0');
  final _ammoniaController = TextEditingController(text: '0.0');
  final _nitriteController = TextEditingController(text: '0.0');
  final _nitrateController = TextEditingController(text: '10.0');

  @override
  void dispose() {
    _phController.dispose();
    _tempController.dispose();
    _tdsController.dispose();
    _co2Controller.dispose();
    _khController.dispose();
    _ghController.dispose();
    _ammoniaController.dispose();
    _nitriteController.dispose();
    _nitrateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final tank = ref.read(currentTankProvider);
      if (tank == null) return;

      final log = WaterParameter(
        timestamp: DateTime.now(),
        pH: double.parse(_phController.text),
        temperature: double.parse(_tempController.text),
        tds: double.parse(_tdsController.text),
        co2Bps: double.parse(_co2Controller.text),
        kh: double.tryParse(_khController.text),
        gh: double.tryParse(_ghController.text),
        ammonia: double.tryParse(_ammoniaController.text),
        nitrite: double.tryParse(_nitriteController.text),
        nitrate: double.tryParse(_nitrateController.text),
      );

      ref.read(tankActionsProvider.notifier).addWaterLog(tank.id, log);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Water log added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        backgroundColor: AppColors.deepTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.floraNeon.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Log Parameters',
                      style: TextStyle(
                        color: AppColors.starlightWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.floraNeon.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.penToSquare,
                        size: 16,
                        color: AppColors.floraNeon,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                _buildSection('Core Metrics', [
                  _buildInput('pH', _phController, icon: FontAwesomeIcons.vial, max: 14),
                  _buildInput('Temp', _tempController, icon: FontAwesomeIcons.temperatureHalf, max: 40, suffix: '°C'),
                  _buildInput('TDS', _tdsController, icon: FontAwesomeIcons.cubesStacked, max: 5000, suffix: 'ppm'),
                  _buildInput('CO₂', _co2Controller, icon: FontAwesomeIcons.wind, max: 20, suffix: 'bps'),
                ]),
                
                _buildSection('Hardness', [
                  _buildInput('kH', _khController, max: 30, suffix: 'dKH'),
                  _buildInput('gH', _ghController, max: 30, suffix: 'dGH'),
                ]),

                _buildSection('Nutrients & Toxins', [
                  _buildInput('NH3', _ammoniaController, color: AppColors.toxicityAlert, max: 10, suffix: 'ppm'),
                  _buildInput('NO2', _nitriteController, color: AppColors.toxicityAlert, max: 10, suffix: 'ppm'),
                  _buildInput('NO3', _nitrateController, max: 100, suffix: 'ppm'),
                ]),

                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.floraNeon,
                      foregroundColor: AppColors.voidBlack,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Save Record',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.mossMuted.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.mossMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2, // Slightly taller for labels
          children: children,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    IconData? icon,
    Color? color,
    double max = 9999,
    String? suffix,
  }) {
    final effectiveColor = color ?? AppColors.starlightWhite;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.trenchBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                icon,
                size: 14,
                color: AppColors.mossMuted,
              ),
            ),
            const SizedBox(width: 8),
          ] else 
            const SizedBox(width: 12),
            
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.mossMuted.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
                TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    color: effectiveColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    filled: false,
                    counterText: "",
                  ),
                  maxLength: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) return '!';
                    final numVal = double.tryParse(value);
                    if (numVal == null) return '!';
                    if (numVal < 0 || numVal > max) return 'Max $max';
                    return null;
                  },
                ),
              ],
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                suffix,
                style: TextStyle(
                  color: AppColors.mossMuted.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
