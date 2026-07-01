import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';
import '../widgets/scan/visual_tags.dart';
import '../services/image_analysis_service.dart';
import '../services/database_service.dart';
import '../models/scan_record.dart';
import '../models/journal_entry.dart';
import 'journal_screen.dart';

class ScanScreen extends StatefulWidget {
  final void Function(JournalEntry)? onSaveComplete;

  const ScanScreen({super.key, this.onSaveComplete});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isAnalyzing = false;
  bool _hasResult = false;

  bool _isValidPet = false;
  String _breed = "";
  String _estimatedAge = "";
  String _condition = "";
  String _message = "";

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isAnalyzing = true;
          _hasResult = false;
        });

        final analysisResult = await ImageAnalysisService.analyzeImage(
          pickedFile.path,
        );

        if (mounted) {
          setState(() {
            _isValidPet = analysisResult['isValidPet'] ?? false;
            _breed = analysisResult['breed'] ?? "";
            _estimatedAge = analysisResult['estimatedAge'] ?? "";
            _condition = analysisResult['condition'] ?? "";
            _message = analysisResult['message'] ?? "";
            _isAnalyzing = false;
            _hasResult = true;
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Library'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.seafoam),
              SizedBox(width: 8),
              Text(
                'About Stray Rescue AI',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'This feature uses AI to analyze photos of stray cats and dogs to quickly estimate their breed, age, and physical condition, helping you provide better rescue assistance.',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '⚠️ Rescue Risks & Safety',
                  style: TextStyle(
                    color: AppColors.peachFuzz,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• AI analysis is for reference only and cannot replace professional veterinary diagnosis.\n'
                  '• Do not approach animals that show signs of aggression, rabies, or severe fear.\n'
                  '• Be aware of bites and scratches. Always prioritize your personal safety.\n'
                  '• If the animal is injured, please contact local animal shelters or professionals immediately.',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: AppColors.seafoam,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveScan() async {
    if (_imageFile == null || !_isValidPet) return;

    final record = ScanRecord(
      id: const Uuid().v4(),
      dateTime: DateTime.now(),
      photoPath: _imageFile!.path,
      isValidPet: _isValidPet,
      breed: _breed,
      estimatedAge: _estimatedAge,
      condition: _condition,
      message: _message,
      tags: [],
    );

    await DatabaseService().saveScanRecord(record);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rescue record saved successfully!')),
      );

      // Navigate to Journal Screen to complete the entry
      final prefilledEntry = JournalEntry(
        id: const Uuid().v4(),
        date: DateTime.now(),
        weight: 0.0,
        activityTags: [],
        notes: "",
        photoPath: _imageFile!.path,
        age: _estimatedAge,
        condition: _condition,
      );

      if (widget.onSaveComplete != null) {
        widget.onSaveComplete!(prefilledEntry);
      } else {
        // Fallback behavior if callback is not provided
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalScreen(initialEntry: prefilledEntry),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Stray Rescue AI',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          if (!_isAnalyzing && _hasResult && _isValidPet && _imageFile != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: _saveScan,
                icon: const Icon(
                  Icons.save_rounded,
                  color: AppColors.seafoam,
                  size: 20,
                ),
                label: const Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.seafoam,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.chestnutGray,
            ),
            onPressed: () => _showHelpDialog(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: _showImageSourceActionSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.creamWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.chestnutGray.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flip_camera_ios_rounded,
                          color: AppColors.seafoam,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Retake or Upload Another',
                          style: TextStyle(
                            color: AppColors.cocoaBrown,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_imageFile == null) _buildEmptyState() else _buildResultState(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceActionSheet,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.mistyFoam.withValues(alpha: 0.6),
                  AppColors.mistyFoam.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppColors.seafoam.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.seafoam.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.creamWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.seafoam.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 40,
                    color: AppColors.seafoam,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Upload a Photo',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Let AI analyze the condition of the stray\ndog or cat to help you rescue them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildRescueTips(),
        const SizedBox(height: 24),
        _buildDidYouKnowSection(),
        const SizedBox(height: 32),
        _buildFooterQuote(),
      ],
    );
  }

  Widget _buildDidYouKnowSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.morningPeach.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.peachFuzz.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.warmSun),
              SizedBox(width: 8),
              Text(
                'Why Your Help Matters',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• A stray animal\'s lifespan is significantly shorter than a housed pet due to starvation, disease, and traffic accidents.\n\n'
            '• By simply stopping to take a photo and assessing their condition, you are taking the first crucial step to saving a life.\n\n'
            '• Every local rescue organization relies on compassionate citizens like you to locate animals in need.',
            style: const TextStyle(
              color: AppColors.chestnutGray,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterQuote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            color: AppColors.chestnutGray.withValues(alpha: 0.3),
            size: 40,
          ),
          const SizedBox(height: 8),
          const Text(
            "Saving one animal won't change the world, but it will change the world for that one animal.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.chestnutGray,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRescueTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            'Safety & Protection',
            style: TextStyle(
              color: AppColors.cocoaBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _buildTipItem(
          Icons.back_hand_rounded,
          'Approach Slowly',
          'Avoid sudden movements. Let them come to you.',
          AppColors.peachFuzz,
        ),
        const SizedBox(height: 12),
        _buildTipItem(
          Icons.restaurant_rounded,
          'Provide Food & Water',
          'Place it near them and step back to give them space.',
          AppColors.seafoam,
        ),
        const SizedBox(height: 12),
        _buildTipItem(
          Icons.phone_in_talk_rounded,
          'Call Professionals',
          'If injured or aggressive, contact local shelters immediately.',
          AppColors.warmSun,
        ),
      ],
    );
  }

  Widget _buildTipItem(
    IconData icon,
    String title,
    String desc, [
    Color color = AppColors.seafoam,
  ]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.cocoaBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 13,
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

  Widget _buildResultState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: AppColors.warmGauze,
              boxShadow: [
                BoxShadow(
                  color: AppColors.chestnutGray.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(_imageFile!, fit: BoxFit.cover),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isAnalyzing)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.creamWhite,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (_isAnalyzing)
          _buildLoveAndCareMessages()
        else if (_hasResult)
          VisualTags(
            isValidPet: _isValidPet,
            breed: _breed,
            estimatedAge: _estimatedAge,
            condition: _condition,
            message: _message,
          ),
      ],
    );
  }

  Widget _buildLoveAndCareMessages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeartwarmingCard(
          icon: Icons.favorite,
          title: 'Every Life Matters',
          desc:
              'While AI is looking at the photo, remember that your attention today might change this little one\'s entire world.',
          iconColor: AppColors.peachFuzz,
        ),
        const SizedBox(height: 12),
        _buildHeartwarmingCard(
          icon: Icons.volunteer_activism,
          title: 'Thank You, Hero',
          desc:
              'Stray animals face countless hardships. Taking a moment to stop, observe, and help makes you their hero.',
          iconColor: AppColors.seafoam,
        ),
        const SizedBox(height: 12),
        _buildHeartwarmingCard(
          icon: Icons.pets,
          title: 'A Voice for the Voiceless',
          desc:
              'They cannot ask for help, but your actions speak volumes. Let\'s wait a moment for the analysis to complete...',
          iconColor: AppColors.warmSun,
        ),
      ],
    );
  }

  Widget _buildHeartwarmingCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmGauze),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 13,
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
}
