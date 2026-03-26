import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../data/models/tank_config.dart';
import '../../data/providers/tank_provider.dart';
import 'widgets/add_log_dialog.dart';
import 'widgets/living_water_graph.dart';
import 'widgets/parameter_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTank = ref.watch(currentTankProvider);
    final waterLogsAsync = ref.watch(waterLogsProvider);

    // If no tank is selected, show Create Tank view
    if (currentTank == null) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.voidBlack,
          body: Stack(
            children: [
              // Subtle background element
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.floraNeon.withOpacity(0.05),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.floraNeon.withOpacity(0.2),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.deepTeal.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.floraNeon.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.floraNeon.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.water,
                          size: 64,
                          color: AppColors.floraNeon,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'No Active Ecosystem',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Start your journey by creating a new tank\nor cloning one from the Gallery.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _buildCreateButton(context, ref),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final tankName = currentTank.name;

    // Process Logs
    return waterLogsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.voidBlack,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: AppColors.voidBlack,
        body: Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.toxicityAlert),
          ),
        ),
      ),
      data: (logs) {
        // Sort logs by timestamp just in case
        logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        final latestLog = logs.isNotEmpty ? logs.last : null;

        // Prepare Chart Data (e.g., pH over time)
        // We take last 10 logs
        final recentLogs = logs.length > 10
            ? logs.sublist(logs.length - 10)
            : logs;
        final spots = recentLogs.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.pH);
        }).toList();

        // Calculate Stability (Mock logic: based on pH variance)
        double stability = 98.4;
        if (logs.length >= 2) {
          final phVariance = (logs.last.pH - logs[logs.length - 2].pH).abs();
          stability = (1.0 - (phVariance / 2.0)).clamp(0.0, 1.0) * 100;
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.voidBlack,
            // FAB removed as requested
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(currentTank, context, ref),
                    const SizedBox(height: 32),

                    // Living Water Graph
                    LivingWaterGraph(spots: spots, stabilityIndex: stability),
                    const SizedBox(height: 32),

                    // Parameters Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate width for 2 columns with spacing
                        final itemWidth = (constraints.maxWidth - 16) / 2;
                        // Force a fixed height or aspect ratio that fits content
                        // Aspect ratio 1.4 might be too wide/short on small screens
                        // Let's use a lower aspect ratio or fixed height approach
                        // Or just Wrap instead of GridView to avoid overflow

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          // Increase childAspectRatio to make cards taller if needed
                          // OR use a calculation based on screen width
                          childAspectRatio: constraints.maxWidth < 360
                              ? 1.2
                              : 1.4,
                          children: [
                            ParameterCard(
                              title: 'pH Level',
                              value: latestLog?.pH.toStringAsFixed(1) ?? '--',
                              unit: '',
                              icon: FontAwesomeIcons.vial,
                              statusText: _getPhStatus(latestLog?.pH),
                              statusColor: _getPhColor(latestLog?.pH),
                              valueColor: _getPhColor(latestLog?.pH),
                            ),
                            ParameterCard(
                              title: 'Temperature',
                              value:
                                  latestLog?.temperature.toStringAsFixed(1) ??
                                  '--',
                              unit: '°C',
                              icon: FontAwesomeIcons.temperatureHalf,
                              valueColor: AppColors.starlightWhite,
                              statusText: 'Optimal', // Logic could be added
                              statusColor: AppColors.floraNeon,
                            ),
                            ParameterCard(
                              title: 'CO₂ Injection',
                              value:
                                  latestLog?.co2Bps.toStringAsFixed(1) ?? '--',
                              unit: 'bps',
                              icon: FontAwesomeIcons.wind,
                              statusText: 'Target: 2-3',
                              statusColor: AppColors.alienPurple,
                              valueColor: AppColors.alienPurple,
                            ),
                            ParameterCard(
                              title: 'TDS Level',
                              value: latestLog?.tds.toStringAsFixed(0) ?? '--',
                              unit: 'ppm',
                              icon: FontAwesomeIcons.cubesStacked,
                              statusText: 'Rising',
                              statusColor: AppColors.algaeWarning,
                              valueColor: AppColors.algaeWarning,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Action Button
                    _buildActionButton(context, ref, currentTank),

                    const SizedBox(height: 100), // Bottom padding for nav bar
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.floraNeon.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showCreateTankDialog(context, ref),
        icon: const Icon(FontAwesomeIcons.plus),
        label: const Text(
          'Create New Tank',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.floraNeon,
          foregroundColor: AppColors.voidBlack,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _showCreateTankDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final lengthController = TextEditingController(text: '60');
    final widthController = TextEditingController(text: '30');
    final heightController = TextEditingController(text: '36');

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          backgroundColor: AppColors.deepTeal,
          title: const Text(
            'Create New Tank',
            style: TextStyle(color: AppColors.starlightWhite),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: AppColors.starlightWhite),
                    decoration: const InputDecoration(
                      labelText: 'Tank Name',
                      hintText: 'e.g. Iwagumi 60P',
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimInput(lengthController, 'L (cm)'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDimInput(widthController, 'W (cm)'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDimInput(heightController, 'H (cm)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.mossMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newTank = TankConfig.create(
                    name: nameController.text.trim(),
                    length: double.tryParse(lengthController.text) ?? 60,
                    width: double.tryParse(widthController.text) ?? 30,
                    height: double.tryParse(heightController.text) ?? 36,
                  );
                  await ref.read(tankActionsProvider.notifier).addTank(newTank);
                  ref.read(selectedTankIdProvider.notifier).state = newTank.id;
                  if (context.mounted) Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.floraNeon,
              ),
              child: const Text(
                'Create',
                style: TextStyle(color: AppColors.voidBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDimInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: AppColors.starlightWhite),
      decoration: InputDecoration(labelText: label, counterText: ""),
      maxLength: 5,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Req';
        final val = double.tryParse(value);
        if (val == null || val <= 0) return 'Invalid';
        return null;
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Dialog(
          backgroundColor: AppColors.deepTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppColors.aquaCyan.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.circleInfo,
                      color: AppColors.aquaCyan,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Glim Guide',
                      style: TextStyle(
                        color: AppColors.starlightWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildHelpItem(
                  FontAwesomeIcons.circlePlus,
                  'Add Log',
                  'Record water parameters (pH, Temp, etc.) to track ecosystem health.',
                  AppColors.floraNeon,
                ),
                _buildHelpItem(
                  FontAwesomeIcons.checkDouble,
                  'Maintenance',
                  'Mark weekly water changes and cleaning tasks as complete.',
                  AppColors.floraNeon,
                ),
                _buildHelpItem(
                  FontAwesomeIcons.trash,
                  'Delete Tank',
                  'Permanently remove this ecosystem and all its data.',
                  AppColors.toxicityAlert,
                ),
                _buildHelpItem(
                  FontAwesomeIcons.chartLine,
                  'Stability',
                  'Visualizes pH fluctuations. Keep the curve flat for optimal health.',
                  AppColors.aquaCyan,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Tap anywhere to close',
                    style: TextStyle(
                      color: AppColors.mossMuted.withOpacity(0.5),
                      fontSize: 12,
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

  Widget _buildHelpItem(IconData icon, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.starlightWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.mossMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPhStatus(double? ph) {
    if (ph == null) return 'No Data';
    if (ph >= 6.5 && ph <= 7.5) return 'Stable';
    if (ph < 6.0) return 'Acidic';
    if (ph > 8.0) return 'Alkaline';
    return 'Warning';
  }

  Color _getPhColor(double? ph) {
    if (ph == null) return AppColors.mossMuted;
    if (ph >= 6.5 && ph <= 7.5) return AppColors.floraNeon;
    return AppColors.algaeWarning;
  }

  Widget _buildHeader(TankConfig tank, BuildContext context, WidgetRef ref) {
    final lastMaintenance = tank.lastMaintenanceDate != null
        ? DateFormat('MMM d').format(tank.lastMaintenanceDate!)
        : 'Never';

    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) greeting = 'Good Afternoon';
    if (hour >= 17) greeting = 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.mossMuted.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tank.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.starlightWhite,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                // Add Log Button (Moved from FAB)
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.circlePlus,
                    size: 18,
                    color: AppColors.floraNeon,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddLogDialog(),
                    );
                  },
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.trash,
                    size: 18,
                    color: AppColors.toxicityAlert,
                  ),
                  onPressed: () {
                    ref.read(tankActionsProvider.notifier).deleteTank(tank.id);
                    ref.read(selectedTankIdProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 8),
                // Help/Info Button
                GestureDetector(
                  onTap: () {
                    _showHelpDialog(context);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.trenchBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.aquaCyan.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.aquaCyan.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.question,
                        color: AppColors.aquaCyan,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.floraNeon.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.floraNeon.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.checkDouble,
                size: 12,
                color: AppColors.floraNeon.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Text(
                'Last Maintenance: $lastMaintenance',
                style: TextStyle(
                  color: AppColors.floraNeon.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    TankConfig tank,
  ) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.trenchBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.floraNeon.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.floraNeon.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Update tank maintenance date
            final updatedTank = tank.copyWith(
              lastMaintenanceDate: DateTime.now(),
            );
            await ref.read(tankActionsProvider.notifier).addTank(updatedTank);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maintenance logged! Next reminder in 7 days.'),
                  backgroundColor: AppColors.floraNeon,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ping animation placeholder
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.floraNeon,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.floraNeon.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Run Weekly Maintenance',
                style: TextStyle(
                  color: AppColors.floraNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
