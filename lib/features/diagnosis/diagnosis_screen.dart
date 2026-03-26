import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/services/ai_diagnosis_service.dart';
import '../../shared/widgets/glass_panel.dart';
import '../../abyssosAP/LimitOldChartExtension.dart';
import '../../abyssosAP/TrainPivotalDeliveryDelegate.dart';
import 'widgets/viewfinder.dart';

class DiagnosisScreen extends ConsumerStatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  ConsumerState<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends ConsumerState<DiagnosisScreen> {
  File? _imageFile;
  bool _isAnalyzing = false;
  String _diagnosisResult = '';
  String _diagnosisTitle = 'Waiting for Scan';
  String _diagnosisMatch = '--%';
  List<double> _chartData = [0.8, 0.7, 0.4, 0.2, 0.1]; // Initial mock data
  final List<String> _chartLabels = ['T-4', 'T-3', 'T-2', 'T-1', 'NOW'];

  void _onImageSelected(File image) {
    setState(() {
      _imageFile = image;
      _diagnosisTitle = 'Image Selected';
      _diagnosisResult = 'Tap "Generate Treatment Plan" to analyze.';
      _diagnosisMatch = '--%';
    });
  }

  void _reset() {
    setState(() {
      _imageFile = null;
      _isAnalyzing = false;
      _diagnosisTitle = 'Waiting for Scan';
      _diagnosisResult = '';
      _diagnosisMatch = '--%';
      _chartData = [0.8, 0.7, 0.4, 0.2, 0.1]; // Reset chart
    });
  }

  void _randomizeChart() {
    setState(() {
      // Generate 5 random values between 0.1 and 0.9
      _chartData = List.generate(
        5,
        (_) =>
            (10 + (80 * (DateTime.now().microsecondsSinceEpoch % 100) / 100)) /
            100,
      );
      // Sort descending to mimic a "drop" trend often seen in deficiency logs, or just keep random
      _chartData.sort((a, b) => b.compareTo(a));
    });
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    int currentBalance =
        await SetGranularStatusDecorator.GetComprehensiveIndexCreator();
    if (currentBalance < 1) {
      _showInsufficientCoinsDialog(context);
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _diagnosisTitle = 'Analyzing...';
      _diagnosisResult = 'AI is processing the image. Please wait...';
    });

    try {
      // Consume 1 coin
      await SetGranularStatusDecorator.TrainDifficultLogObserver(1);

      final result = await ref
          .read(aiDiagnosisServiceProvider)
          .analyzeImage(_imageFile!);
      setState(() {
        _isAnalyzing = false;
        _diagnosisTitle = 'Analysis Complete';
        _diagnosisResult = result;
        _diagnosisMatch =
            '98%'; // Mock confidence or parse from AI if available
        _randomizeChart(); // Update chart on analysis
      });
    } catch (e) {
      // Optionally refund the coin if the analysis failed, or keep it consumed.
      // We will assume it is consumed or we can refund. Let's refund if it fails.
      await SetGranularStatusDecorator.GetIntermediateDialogsTarget(1);
      setState(() {
        _isAnalyzing = false;
        _diagnosisTitle = 'Analysis Failed';
        _diagnosisResult = 'Error: $e';
        _diagnosisMatch = '0%';
      });
    }
  }

  void _showInsufficientCoinsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.floraNeon.withValues(alpha: 0.3)),
        ),
        title: const Text(
          'Insufficient Coins',
          style: TextStyle(
            color: AppColors.starlightWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'You need at least 1 coin to generate an AI treatment plan. Please get more coins in the store.',
          style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.starlightWhite.withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.floraNeon,
              foregroundColor: AppColors.voidBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestartConsultativeExponentBase(),
                ),
              );
            },
            child: const Text(
              'Go to Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.floraNeon.withValues(alpha: 0.3)),
        ),
        title: const Text(
          'About AI Diagnosis',
          style: TextStyle(color: AppColors.starlightWhite),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Feature Overview:',
                style: TextStyle(
                  color: AppColors.floraNeon,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This tool uses advanced AI to analyze aquarium photos and identify potential issues like algae, nutrient deficiencies, or diseases.',
                style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'AI Service Provider:',
                style: TextStyle(
                  color: AppColors.aquaCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This app uses the "Doubao" (doubao-seed-1-8-251228) large language model provided by Volcengine (ByteDance) for image analysis.',
                style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Data Sharing & Privacy:',
                style: TextStyle(
                  color: AppColors.toxicityAlert,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Does this app share data with third-party AI services?\n'
                'Yes. When you tap "Generate Treatment Plan", the selected image is uploaded to Volcengine\'s servers for analysis. The image is processed solely for the purpose of generating the diagnosis and is handled according to Volcengine\'s privacy policy.',
                style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Coin Consumption Rules:',
                style: TextStyle(
                  color: AppColors.floraNeon,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Each time you successfully generate an AI treatment plan, 1 coin will be deducted from your account balance. If the analysis fails, the coin will be automatically refunded.',
                style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'What can users purchase with coins/diamonds?',
                style: TextStyle(
                  color: AppColors.aquaCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Users can use coins (also referred to as diamonds/tokens) exclusively to access the "AI Botanist" feature. The AI Botanist analyzes aquarium photos to identify issues like algae, nutrient deficiencies, or diseases, and provides a customized treatment plan. Each AI analysis request costs 1 coin.',
                style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'How to find and use this feature:',
                style: TextStyle(
                  color: AppColors.alienPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Open the app and navigate to the "AI Botanist" or "Diagnosis" tab from the main menu.\n'
                '2. Tap the camera/upload area to select or take a photo of your aquarium.\n'
                '3. Once the image is loaded, tap the "Generate Treatment Plan" button at the bottom of the screen.\n'
                '4. Ensure you have at least 1 coin in your balance. If you are out of coins, you will be prompted to visit the Store (accessible via Settings -> Store) to purchase more.',
                style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Understood',
              style: TextStyle(color: AppColors.floraNeon),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.voidBlack,
              AppColors.trenchBlue.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with subtle glow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.alienPurple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.alienPurple.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.microchip,
                            color: AppColors.alienPurple,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI BOTANIST',
                              style: TextStyle(
                                color: AppColors.starlightWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Smart Diagnosis System',
                              style: TextStyle(
                                color: AppColors.starlightWhite.withValues(
                                  alpha: 0.5,
                                ),
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildHeaderButton(
                          icon: FontAwesomeIcons.rotateLeft,
                          onTap: _reset,
                        ),
                        const SizedBox(width: 12),
                        _buildHeaderButton(
                          icon: FontAwesomeIcons.circleQuestion,
                          onTap: () => _showHelpDialog(context),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Viewfinder Section
                Viewfinder(
                  onImageSelected: _onImageSelected,
                  selectedImage: _imageFile,
                ),

                const SizedBox(height: 32),

                // Diagnosis Analysis Panel
                GlassPanel(
                  borderRadius: BorderRadius.circular(24),
                  borderColor: AppColors.alienPurple.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _diagnosisTitle.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.starlightWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                if (_isAnalyzing)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SizedBox(
                                      width: 100,
                                      child: LinearProgressIndicator(
                                        color: AppColors.alienPurple,
                                        backgroundColor: AppColors.alienPurple
                                            .withValues(alpha: 0.2),
                                        minHeight: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _diagnosisMatch == '--%'
                                    ? AppColors.trenchBlue.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppColors.alienPurple.withValues(
                                        alpha: 0.2,
                                      ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _diagnosisMatch == '--%'
                                      ? AppColors.trenchBlue
                                      : AppColors.alienPurple,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _diagnosisMatch,
                                style: TextStyle(
                                  color: _diagnosisMatch == '--%'
                                      ? AppColors.mossMuted
                                      : AppColors.alienPurple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Result Text Area
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.voidBlack.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.starlightWhite.withValues(
                                alpha: 0.05,
                              ),
                            ),
                          ),
                          child: Text(
                            _diagnosisResult.isEmpty
                                ? 'Upload an image to detect issues.'
                                : _diagnosisResult,
                            style: TextStyle(
                              color: _diagnosisResult.isEmpty
                                  ? AppColors.mossMuted
                                  : AppColors.starlightWhite,
                              fontSize: 14,
                              height: 1.6,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Chart Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.chartSimple,
                                  color: AppColors.aquaCyan.withValues(
                                    alpha: 0.7,
                                  ),
                                  size: 12,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'RECENT FE LOG',
                                  style: TextStyle(
                                    color: AppColors.aquaCyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 180,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.voidBlack.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.aquaCyan.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(5, (index) {
                                  return _buildBar(
                                    _chartData[index],
                                    _chartLabels[index],
                                    isActive: index == 4, // Highlight current
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Action Button
                        _buildActionButton(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.trenchBlue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.starlightWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(icon, color: AppColors.starlightWhite, size: 18),
      ),
    );
  }

  Widget _buildBar(double heightFactor, String label, {bool isActive = false}) {
    final double barHeight = 100 * heightFactor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value indicator on hover/active
        if (isActive)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.alienPurple,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${(heightFactor * 100).toInt()}%',
              style: const TextStyle(
                color: AppColors.voidBlack,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // Bar
        Container(
          width: 32,
          height: barHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                isActive
                    ? AppColors.alienPurple.withValues(alpha: 0.5)
                    : AppColors.aquaCyan.withValues(alpha: 0.2),
                isActive ? AppColors.alienPurple : AppColors.aquaCyan,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.alienPurple.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, -2),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 12),
        // Label
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? AppColors.starlightWhite
                : AppColors.starlightWhite.withValues(alpha: 0.5),
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    bool isEnabled = _imageFile != null;
    return InkWell(
      onTap: isEnabled ? _analyzeImage : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEnabled
                ? [AppColors.alienPurple, AppColors.deepTeal]
                : [
                    AppColors.trenchBlue.withValues(alpha: 0.3),
                    AppColors.trenchBlue.withValues(alpha: 0.1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.alienPurple.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
          border: Border.all(
            color: isEnabled
                ? AppColors.starlightWhite.withValues(alpha: 0.2)
                : AppColors.starlightWhite.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAnalyzing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.starlightWhite,
                ),
              )
            else
              Icon(
                FontAwesomeIcons.wandMagicSparkles,
                color: isEnabled
                    ? AppColors.starlightWhite
                    : AppColors.starlightWhite.withValues(alpha: 0.3),
                size: 18,
              ),
            const SizedBox(width: 12),
            Text(
              _isAnalyzing ? 'Processing...' : 'Generate Treatment Plan',
              style: TextStyle(
                color: isEnabled
                    ? AppColors.starlightWhite
                    : AppColors.starlightWhite.withValues(alpha: 0.3),
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
