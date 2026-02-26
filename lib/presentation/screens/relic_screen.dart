import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:orivet/core/constants/strings.dart';
import 'package:orivet/data/services/ai_restoration_service.dart';
import 'package:orivet/presentation/widgets/restoration/before_after_slider.dart';
import 'package:orivet/data/models/restoration_record.dart';
import 'package:orivet/data/repositories/history_repository.dart';

class RelicScreen extends StatefulWidget {
  const RelicScreen({super.key});

  @override
  State<RelicScreen> createState() => _RelicScreenState();
}

class _RelicScreenState extends State<RelicScreen> {
  bool _isRestoring = false;
  File? _selectedImage;
  String? _restoredImageUrl;
  final AiRestorationService _aiService = AiRestorationService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _restoredImageUrl = null; // Reset previous restoration
      });
    }
  }

  Future<void> _handleRestoration() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image first."),
          backgroundColor: AppColors.wax,
        ),
      );
      return;
    }

    setState(() => _isRestoring = true);

    try {
      final url = await _aiService.generateRestoration(_selectedImage!);

      if (mounted) {
        setState(() {
          _restoredImageUrl = url;
          _isRestoring = false;
        });

        // Save to history
        final record = RestorationRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          itemName: "Restoration ${DateTime.now().toString().split('.')[0]}",
          date: DateTime.now(),
          originalImagePath: _selectedImage!.path,
          restoredImageUrl: url,
        );
        await HistoryRepository().saveRecord(record);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("RESTORATION COMPLETE"),
              backgroundColor: AppColors.teal,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Restoration Error: $e");
      if (mounted) {
        setState(() => _isRestoring = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Error: ${e.toString().replaceAll('Exception: ', '')}"),
            backgroundColor: AppColors.wax,
          ),
        );
      }
    }
  }

  Future<void> _resetRestoration() async {
    setState(() {
      _selectedImage = null;
      _restoredImageUrl = null;
    });
  }

  Future<void> _showHistory() async {
    final records = await HistoryRepository().getRecords();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text("Restoration History",
                style: TextStyle(color: AppColors.vellum)),
            content: SizedBox(
              width: double.maxFinite,
              child: records.isEmpty
                  ? const Text("No history records found.",
                      style: TextStyle(color: AppColors.shale))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return ListTile(
                          leading: Image.file(
                              File(record.originalImagePath ?? ''),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover),
                          title: Text(record.itemName,
                              style: const TextStyle(color: AppColors.vellum)),
                          subtitle: Text(record.date.toString().split(' ')[0],
                              style: const TextStyle(color: AppColors.shale)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: AppColors.wax, size: 20),
                            onPressed: () async {
                              await HistoryRepository().deleteRecord(record.id);
                              setStateDialog(() {
                                records.removeAt(index);
                              });
                            },
                          ),
                          onTap: () {
                            if (record.originalImagePath != null) {
                              setState(() {
                                _selectedImage =
                                    File(record.originalImagePath!);
                                _restoredImageUrl = record.restoredImageUrl;
                              });
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("CLOSE",
                    style: TextStyle(color: AppColors.brass)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Header with Divider
          Column(
            children: [
              Text(
                AppStrings.relicTitle.toUpperCase(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.leather,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 1, color: AppColors.brass),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.brass,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 40, height: 1, color: AppColors.brass),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.relicSubtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.soot,
                      letterSpacing: 3.0,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Main Image Container (Steampunk Frame)
          Container(
            height: 420,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: AppColors.leather, width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brass, width: 2),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Content
                  _buildImageContent(),

                  // Corner Ornaments
                  _buildCorner(Alignment.topLeft),
                  _buildCorner(Alignment.topRight),
                  _buildCorner(Alignment.bottomLeft),
                  _buildCorner(Alignment.bottomRight),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action Button
          GestureDetector(
            onTap: _isRestoring ? null : _handleRestoration,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.metalGradient,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.vellum.withValues(alpha: 0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: _isRestoring
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: AppColors.leather, strokeWidth: 3),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(FontAwesomeIcons.wandMagicSparkles,
                              color: AppColors.leather, size: 20),
                          const SizedBox(width: 16),
                          Text(
                            AppStrings.generateRestoration.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontSize: 16,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.leather,
                                ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Secondary Buttons
          Row(
            children: [
              Expanded(
                  child: _buildSecondaryButton(
                      FontAwesomeIcons.arrowsRotate, AppStrings.reset)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildSecondaryButton(
                      FontAwesomeIcons.clockRotateLeft, AppStrings.history)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    if (_selectedImage == null) {
      return Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.brass.withValues(alpha: 0.3),
              width: 2,
              style: BorderStyle
                  .none, // Dashed simulation usually needs custom painter, simple border for now
            ),
            color: Colors.black12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.image,
                  size: 64, color: AppColors.brass.withValues(alpha: 0.3)),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: _pickImage,
                icon:
                    const Icon(FontAwesomeIcons.upload, color: AppColors.brass),
                label: Text(
                  "UPLOAD ARTIFACT",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.brass,
                        fontSize: 14,
                        letterSpacing: 2.0,
                      ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_restoredImageUrl == null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.vellum),
                ),
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(FontAwesomeIcons.arrowsRotate,
                      color: AppColors.vellum, size: 20),
                  label: Text(
                    "CHANGE IMAGE",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.vellum,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return BeforeAfterSlider(
        beforeImage: _selectedImage!.path,
        afterImage: _restoredImageUrl!,
        isLocalBefore: true,
      );
    }
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.brass,
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black45, width: 1),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.vellum.withValues(alpha: 0.5),
        border: Border.all(color: AppColors.leather, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (label == AppStrings.reset) {
              _resetRestoration();
            } else if (label == AppStrings.history) {
              _showHistory();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.leather),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.leather,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
