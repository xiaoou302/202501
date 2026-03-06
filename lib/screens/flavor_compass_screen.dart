import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/ai_service.dart';
import '../widgets/radar_chart.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import '../baristalAP/InitializePublicFrameObserver.dart'; // Import for coin balance

class FlavorCompassScreen extends StatefulWidget {
  const FlavorCompassScreen({super.key});

  @override
  State<FlavorCompassScreen> createState() => _FlavorCompassScreenState();
}

class _FlavorCompassScreenState extends State<FlavorCompassScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _isAnalyzing = false;

  // Default / Initial Data
  Map<String, double> _flavorData = {
    'Acidity': 5.0,
    'Sweet': 5.0,
    'Body': 5.0,
    'Bitter': 5.0,
    'Finish': 5.0,
    'Aroma': 5.0,
  };

  double? _scaScore;
  String? _recommendation;
  List<String> _tags = [];
  bool _hasResult = false;

  final List<String> _quickTags = [
    "Bright Acidity",
    "Dark Chocolate",
    "Jasmine",
    "Caramel",
    "Full Body",
    "Nutty",
    "Berry",
    "Spicy",
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addTagToInput(String tag) {
    final currentText = _notesController.text;
    if (currentText.isNotEmpty && !currentText.endsWith(', ')) {
      _notesController.text = "$currentText, $tag";
    } else {
      _notesController.text = "$currentText$tag";
    }
    // Move cursor to end
    _notesController.selection = TextSelection.fromPosition(
      TextPosition(offset: _notesController.text.length),
    );
  }

  Future<void> _analyzeSensoryNotes() async {
    if (_notesController.text.trim().isEmpty) return;

    // Check coin balance
    final currentBalance =
        await PausePermanentFlagsPool.WriteDisplayableVideoCollection();
    if (currentBalance < 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Insufficient diamonds. Please recharge in Settings -> Store.",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });
    FocusScope.of(context).unfocus();

    try {
      final result = await AiService.analyzeTastingNotes(_notesController.text);

      if (mounted) {
        if (result != null) {
          // Deduct coin only on successful analysis
          await PausePermanentFlagsPool.SpinSortedOperationProtocol(1);

          setState(() {
            _hasResult = true;
            if (result['radar_data'] != null) {
              final Map<String, dynamic> rawData = result['radar_data'];
              _flavorData = rawData.map(
                (key, value) => MapEntry(key, (value as num).toDouble()),
              );
            }
            if (result['sca_score'] != null) {
              _scaScore = (result['sca_score'] as num).toDouble();
            }
            if (result['recommendation'] != null) {
              _recommendation = result['recommendation'];
            }
            if (result['tags'] != null) {
              _tags = List<String>.from(result['tags']);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not analyze notes. Please try again."),
              backgroundColor: ColorPalette.rustedCopper,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "SENSORY COMPASS",
          style: AppTheme.monoStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorPalette.obsidian,
            letterSpacing: 1.5,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Decode your palate with professional sensory analysis.",
                style: const TextStyle(
                  color: ColorPalette.matteSteel,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "FEATURES",
                style: AppTheme.monoStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: ColorPalette.obsidian,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "• Enter tasting notes to generate a flavor radar chart\n• Get estimated SCA scores\n• Receive personalized bean recommendations",
                style: TextStyle(color: ColorPalette.matteSteel, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "AI & PRIVACY",
                style: AppTheme.monoStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: ColorPalette.obsidian,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: ColorPalette.matteSteel,
                    height: 1.5,
                    fontSize: 14,
                  ),
                  children: [
                    const TextSpan(
                      text: "AI Provider: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: "DeepSeek\n"),
                    const TextSpan(
                      text: "Data Sharing: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text:
                          "No. Your data is processed solely for analysis and is not shared with third parties.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "GOT IT",
              style: AppTheme.monoStyle.copyWith(
                color: ColorPalette.obsidian,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorPalette.concrete,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                // Editorial Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SENSORY\nCOMPASS",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: ColorPalette.obsidian,
                            fontWeight: FontWeight.w900,
                            height: 0.9,
                            letterSpacing: -2.0,
                            fontSize: 42,
                          ),
                    ),
                    GestureDetector(
                      onTap: _showHelpDialog,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.circleQuestion,
                          size: 18,
                          color: ColorPalette.matteSteel,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "DECODE YOUR PALATE",
                  style: AppTheme.monoStyle.copyWith(
                    color: ColorPalette.rustedCopper,
                    letterSpacing: 3.0,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Input Section (Always Visible)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TASTING NOTES",
                        style: AppTheme.monoStyle.copyWith(
                          fontSize: 10,
                          color: ColorPalette.matteSteel,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _notesController,
                        maxLines: 4,
                        maxLength: 140, // Tweet-length limit for concise notes
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText:
                              "What are you tasting? \ne.g., Silky body with notes of jasmine and peach...",
                          hintStyle: TextStyle(
                            color: ColorPalette.matteSteel.withOpacity(0.4),
                            fontSize: 16,
                            height: 1.5,
                          ),
                          border: InputBorder.none,
                          counterText:
                              "", // Hide default counter to keep it clean, or we can style it
                          contentPadding: EdgeInsets.zero,
                        ),
                        buildCounter:
                            (
                              context, {
                              required currentLength,
                              required isFocused,
                              required maxLength,
                            }) {
                              return isFocused
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "$currentLength/$maxLength",
                                        style: AppTheme.monoStyle.copyWith(
                                          fontSize: 10,
                                          color: currentLength > maxLength!
                                              ? Colors.red
                                              : ColorPalette.matteSteel
                                                    .withOpacity(0.5),
                                        ),
                                      ),
                                    )
                                  : null;
                            },
                        style: const TextStyle(
                          color: ColorPalette.obsidian,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Quick Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _quickTags.map((tag) {
                          return GestureDetector(
                            onTap: () => _addTagToInput(tag),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorPalette.concrete,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ColorPalette.concreteDark,
                                ),
                              ),
                              child: Text(
                                "+ $tag",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ColorPalette.matteSteel,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isAnalyzing ? null : _analyzeSensoryNotes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.obsidian,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isAnalyzing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.wandMagicSparkles,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "ANALYZE FLAVOR",
                                      style: AppTheme.monoStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Rich Empty State or Results
                if (!_hasResult && !_isAnalyzing)
                  _buildRichEmptyState()
                else if (_hasResult)
                  _buildResultsSection(),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRichEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GUIDE",
          style: AppTheme.monoStyle.copyWith(
            color: ColorPalette.matteSteel,
            letterSpacing: 2.0,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ColorPalette.charcoal,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.mugHot,
                      color: ColorPalette.cremaGold,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "HOW TO TASTE",
                    style: AppTheme.monoStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGuideStep("1. SMELL", "Inhale deeply before sipping."),
              const SizedBox(height: 12),
              _buildGuideStep("2. SLURP", "Spray coffee across your palate."),
              const SizedBox(height: 12),
              _buildGuideStep("3. LOCATE", "Where do you feel it? Tongue?"),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Placeholder Artistic Radar
        Opacity(
          opacity: 0.5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: ColorPalette.concreteDark, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  "SAMPLE PROFILE",
                  style: AppTheme.monoStyle.copyWith(
                    fontSize: 10,
                    color: ColorPalette.matteSteel,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SimpleRadarChart(
                  data: {
                    'Acidity': 8.0,
                    'Sweet': 6.0,
                    'Body': 4.0,
                    'Bitter': 2.0,
                    'Finish': 7.0,
                    'Aroma': 9.0,
                  },
                  size: 200,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideStep(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: ColorPalette.cremaGold,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            desc,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      children: [
        // Radar Chart Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "FLAVOR PROFILE",
                        style: AppTheme.monoStyle.copyWith(
                          fontSize: 10,
                          color: ColorPalette.matteSteel,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ANALYSIS COMPLETE",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.obsidian,
                        ),
                      ),
                    ],
                  ),
                  if (_scaScore != null)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColorPalette.obsidian,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SCA",
                              style: AppTheme.monoStyle.copyWith(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 8,
                              ),
                            ),
                            Text(
                              _scaScore!.toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              Center(child: SimpleRadarChart(data: _flavorData, size: 280)),
              const SizedBox(height: 40),
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: _tags.map((tag) => _buildTag(tag)).toList(),
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // AI Recommendation
        if (_recommendation != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorPalette.charcoal, Color(0xFF2C3035)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ColorPalette.charcoal.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: ColorPalette.rustedCopper.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.quoteLeft,
                          size: 16,
                          color: ColorPalette.cremaGold,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "SOMMELIER'S NOTE",
                          style: AppTheme.monoStyle.copyWith(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _recommendation!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorPalette.concrete,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.monoStyle.copyWith(
          fontSize: 10,
          color: ColorPalette.obsidian,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
