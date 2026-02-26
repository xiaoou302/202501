import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:orivet/core/constants/strings.dart';
import 'package:orivet/presentation/widgets/guide/guide_step_widget.dart';
import 'package:orivet/data/services/ai_guide_service.dart';
import 'package:orivet/data/models/guide_step.dart';
import 'package:orivet/data/models/restoration_record.dart';
import 'package:orivet/data/services/restoration_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen>
    with SingleTickerProviderStateMixin {
  bool _isCompleted = false;
  late AnimationController _stampController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  final AiGuideService _aiService = AiGuideService();
  final RestorationStorage _storage = RestorationStorage();
  File? _selectedImage;
  GuideResult? _guideResult;
  bool _isLoading = false;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _stampController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
      CurvedAnimation(parent: _stampController, curve: Curves.bounceOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _stampController, curve: Curves.easeIn),
    );

    _loadCompletedCount();
  }

  @override
  void dispose() {
    _stampController.dispose();
    super.dispose();
  }

  Future<void> _loadCompletedCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completedCount = prefs.getInt('completed_guides_count') ?? 0;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _guideResult = null;
        _isCompleted = false;
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _aiService.getAnalysisAndGuide(_selectedImage!);
      if (mounted) {
        setState(() {
          _guideResult = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error analyzing image: $e")),
        );
      }
    }
  }

  Future<void> _markAsComplete() async {
    setState(() => _isCompleted = true);
    _stampController.forward();

    final prefs = await SharedPreferences.getInstance();
    final newCount = _completedCount + 1;
    await prefs.setInt('completed_guides_count', newCount);

    // Save record
    if (_guideResult != null) {
      final record = RestorationRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        itemName: _guideResult!.description
            .split('.')
            .first, // Use first sentence as title
        material: _guideResult!.material,
        originalImagePath: _selectedImage?.path,
      );
      await _storage.addRecord(record);
    }

    setState(() {
      _completedCount = newCount;
    });
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.vellum,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "RESTORATION ARCHIVE",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: AppColors.leather,
                                fontSize: 20,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(FontAwesomeIcons.xmark,
                            color: AppColors.leather, size: 20),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.leather),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder<List<RestorationRecord>>(
                      future: _storage.getRecords(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.leather));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No records found in the archive.",
                              style: TextStyle(
                                  color: AppColors.soot,
                                  fontStyle: FontStyle.italic),
                            ),
                          );
                        }

                        final records = snapshot.data!;
                        return ListView.separated(
                          itemCount: records.length,
                          separatorBuilder: (context, index) => Divider(
                              color: AppColors.leather.withOpacity(0.1)),
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return Dismissible(
                              key: Key(record.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                color: AppColors.wax,
                                child: const Icon(FontAwesomeIcons.trash,
                                    color: Colors.white, size: 16),
                              ),
                              onDismissed: (direction) async {
                                await _storage.deleteRecord(record.id);
                                // No need to setState here as Dismissible removes the item visually
                                // But if we want to ensure consistency or if list becomes empty:
                                setState(() {});
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.leather.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Center(
                                    child: Icon(FontAwesomeIcons.scroll,
                                        color: AppColors.leather, size: 18),
                                  ),
                                ),
                                title: Text(
                                  record.itemName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.ink),
                                ),
                                subtitle: Text(
                                  "${record.material} • ${record.date.toString().split(' ')[0]}",
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.soot),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(FontAwesomeIcons.trashCan,
                                      size: 16, color: AppColors.soot),
                                  onPressed: () async {
                                    await _storage.deleteRecord(record.id);
                                    setState(() {});
                                  },
                                ),
                                onTap: () {
                                  // Optional: Show detail or reload
                                  // For now, just print or do nothing
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Achievement
          _buildHeader(context),
          const SizedBox(height: 32),

          // Image Upload Area
          _buildUploadArea(context),

          const SizedBox(height: 32),

          // Generate Button
          if (_selectedImage != null && _guideResult == null && !_isLoading)
            _buildGenerateButton(context),

          if (_selectedImage != null && _guideResult == null && !_isLoading)
            const SizedBox(height: 32),

          // Content Area (Empty State or Result)
          _buildContentArea(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.guideTitle,
                style: GoogleFonts.cinzel(
                  fontSize: 28,
                  color: AppColors.leather,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "AI RESTORATION ADVISOR",
                style: GoogleFonts.lato(
                  color: AppColors.brass,
                  letterSpacing: 3.0,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.leatherGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.leather.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.medal,
                      color: AppColors.brass, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    "$_completedCount PROJECTS",
                    style: GoogleFonts.lato(
                      color: AppColors.vellum,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.vellum,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.leather.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
              child: IconButton(
                onPressed: _showHistory,
                icon: const Icon(FontAwesomeIcons.clockRotateLeft,
                    size: 18, color: AppColors.leather),
                tooltip: "Restoration Archive",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadArea(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 260,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.vellum,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.leather.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.leather.withOpacity(0.08),
              offset: const Offset(0, 10),
              blurRadius: 20,
              spreadRadius: -5,
            )
          ],
        ),
        child: _selectedImage == null
            ? _buildUploadPlaceholder(context)
            : _buildImagePreview(context),
      ),
    );
  }

  Widget _buildUploadPlaceholder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.leather.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.leather.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(FontAwesomeIcons.cameraRetro,
              size: 48, color: AppColors.leather.withOpacity(0.7)),
        ),
        const SizedBox(height: 20),
        Text(
          "UPLOAD ARTIFACT PHOTO",
          style: GoogleFonts.cinzel(
            fontSize: 16,
            letterSpacing: 1.5,
            color: AppColors.leather,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Tap to select from gallery",
          style: GoogleFonts.lato(
            fontSize: 14,
            color: AppColors.soot.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_selectedImage!, fit: BoxFit.cover),
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: const Icon(FontAwesomeIcons.arrowsRotate,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.leather.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            )
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _analyzeImage,
          icon: const Icon(FontAwesomeIcons.wandMagicSparkles, size: 18),
          label: Text(
            "GENERATE RESTORATION PLAN",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.leather,
            foregroundColor: AppColors.vellum,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              const CircularProgressIndicator(color: AppColors.leather),
              const SizedBox(height: 16),
              Text(
                "Analyzing Artifact...",
                style: GoogleFonts.lato(
                  color: AppColors.leather,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_guideResult == null) {
      return _buildEmptyState(context);
    }

    return _buildResultCard(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "START YOUR JOURNEY",
          style: GoogleFonts.cinzel(
            fontSize: 20,
            color: AppColors.leather,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Follow these simple steps to breathe new life into your cherished items.",
          style: GoogleFonts.lato(
            color: AppColors.soot.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        _buildStepItem(
          context,
          FontAwesomeIcons.camera,
          "Upload Photo",
          "Select a clear, well-lit photo of your vintage item focusing on damages.",
        ),
        _buildStepItem(
          context,
          FontAwesomeIcons.wandMagicSparkles,
          "AI Analysis",
          "Our advanced AI identifies materials, era, and specific damage types.",
        ),
        _buildStepItem(
          context,
          FontAwesomeIcons.scroll,
          "Get Guide",
          "Receive a professional, step-by-step restoration plan tailored to your item.",
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.brass.withOpacity(0.1),
                AppColors.brass.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.brass.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.brass.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 12,
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.vellum,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brass.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(FontAwesomeIcons.lightbulb,
                    color: AppColors.brass, size: 20),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PRO TIP",
                      style: GoogleFonts.cinzel(
                        color: AppColors.brass,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ensure good lighting and focus on the damaged areas for the best results. Multiple angles help in better analysis.",
                      style: GoogleFonts.lato(
                        color: AppColors.leather,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(
      BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.vellum,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.leather.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.leather.withOpacity(0.05),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                )
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.leather,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    color: AppColors.soot,
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5EB), // Paper-like white
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Binding
          Positioned(
            left: -12,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: AppColors.leather.withOpacity(0.2),
                        width: 2,
                        style: BorderStyle.solid)),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "RESTORATION PLAN",
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    color: AppColors.leather,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 60,
                  height: 2,
                  color: AppColors.brass,
                ),
              ),
              const SizedBox(height: 32),

              // Analysis Section
              _buildSectionHeader(context, "ANALYSIS"),
              const SizedBox(height: 16),
              Text(
                _guideResult!.description,
                style: GoogleFonts.lato(
                  height: 1.6,
                  color: AppColors.ink,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.leather.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.leather.withOpacity(0.1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(FontAwesomeIcons.layerGroup,
                        size: 16, color: AppColors.leather),
                    const SizedBox(width: 12),
                    Text(
                      "MATERIAL:",
                      style: GoogleFonts.lato(
                        color: AppColors.leather,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _guideResult!.material,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Steps Section
              _buildSectionHeader(context, "PROCEDURE"),
              const SizedBox(height: 24),

              if (_guideResult!.steps.isEmpty)
                const Text("No steps available.")
              else
                ..._guideResult!.steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: GuideStepWidget(
                      stepNumber: index + 1,
                      title: step.title,
                      description: step.description,
                      warning: step.warning,
                    ),
                  );
                }).toList(),

              const SizedBox(height: 40),

              // Completion Area
              if (_guideResult!.steps.isNotEmpty) _buildCompletionArea(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        const Icon(FontAwesomeIcons.diamond, size: 12, color: AppColors.brass),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cinzel(
            color: AppColors.leather,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: AppColors.brass)),
      ],
    );
  }

  Widget _buildCompletionArea(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: AppColors.leather.withOpacity(0.1),
                width: 1,
                style: BorderStyle.solid)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_isCompleted)
            TextButton(
              onPressed: _markAsComplete,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.leather)),
              ),
              child: Text(
                AppStrings.markComplete,
                style: GoogleFonts.lato(
                  letterSpacing: 1.5,
                  color: AppColors.leather,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Stamp Animation
          AnimatedBuilder(
            animation: _stampController,
            builder: (context, child) {
              if (!_isCompleted) return const SizedBox.shrink();
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.rotate(
                    angle: -0.25,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.wax, width: 4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(FontAwesomeIcons.circleCheck,
                              color: AppColors.wax, size: 32),
                          Text(
                            "RESTORED",
                            style: GoogleFonts.cinzel(
                              color: AppColors.wax,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            DateTime.now().toString().split(' ')[0],
                            style: GoogleFonts.lato(
                              color: AppColors.wax,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
