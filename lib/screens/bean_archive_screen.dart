import 'dart:ui'; // For BackdropFilter
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/bean.dart';
import '../services/bean_service.dart';
import '../services/ai_service.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import '../baristalAP/InitializePublicFrameObserver.dart'; // Import for coin balance

class BeanArchiveScreen extends StatefulWidget {
  const BeanArchiveScreen({super.key});

  @override
  State<BeanArchiveScreen> createState() => _BeanArchiveScreenState();
}

class _BeanArchiveScreenState extends State<BeanArchiveScreen> {
  List<Bean> _beans = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadBeans();
  }

  Future<void> _loadBeans() async {
    await BeanService.loadBeans();
    if (mounted) {
      setState(() {
        _beans = BeanService.getBeans();
      });
    }
  }

  Future<void> _handleScan(ImageSource source) async {
    // Check coin balance before starting scan/analysis
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

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 80,
      );

      if (image == null) return;

      // Save image to permanent storage
      final directory = await getApplicationDocumentsDirectory();
      final String fileName =
          '${const Uuid().v4()}${path.extension(image.path)}';
      final String localPath = path.join(directory.path, 'beans', fileName);

      // Ensure directory exists
      final File localFile = File(localPath);
      await localFile.parent.create(recursive: true);

      // Copy the file
      await File(image.path).copy(localPath);

      // Show editor immediately with empty bean but image set
      final newBean = Bean(
        id: const Uuid().v4(),
        name: "",
        origin: "",
        process: "",
        roastLevel: "",
        roastDate: DateTime.now(),
        initialWeight: 250,
        remainingWeight: 250,
        flavorNotes: [],
        imagePath: localPath,
      );

      // Deduct coin after successful image pick/setup, assuming analysis will happen or is part of the "Scan" value
      await PausePermanentFlagsPool.SpinSortedOperationProtocol(1);

      _showBeanEditor(newBean, isNew: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error picking image: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showBeanEditor(Bean bean, {bool isNew = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BeanEditorModal(
        bean: bean,
        isNew: isNew,
        onSave: (updatedBean) async {
          await BeanService.saveBean(updatedBean);
          _loadBeans();
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isNew ? "Bean added to pantry!" : "Bean updated!",
                ),
                backgroundColor: ColorPalette.extractionGreen,
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(Bean bean) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Bean"),
        content: Text(
          "Are you sure you want to delete '${bean.name}'? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: ColorPalette.matteSteel),
            ),
          ),
          TextButton(
            onPressed: () async {
              await BeanService.deleteBean(bean.id);
              _loadBeans();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bean deleted"),
                    backgroundColor: ColorPalette.obsidian,
                  ),
                );
              }
            },
            child: const Text(
              "DELETE",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "BEAN ARCHIVE",
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
                "This is your digital coffee bean pantry. Keep track of your collection and brewing history.",
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
                "• Scan bags to auto-extract details\n• Track roast dates & aging\n• Manage inventory levels",
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
                    const TextSpan(text: "Doubao (by ByteDance)\n"),
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

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ADD NEW BEAN",
              style: AppTheme.monoStyle.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: ColorPalette.matteSteel,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionBtn(
                  icon: FontAwesomeIcons.camera,
                  label: "SCAN BAG",
                  onTap: () {
                    Navigator.pop(context);
                    _handleScan(ImageSource.camera);
                  },
                ),
                _buildOptionBtn(
                  icon: FontAwesomeIcons.image,
                  label: "GALLERY",
                  onTap: () {
                    Navigator.pop(context);
                    _handleScan(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ColorPalette.concrete,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: ColorPalette.obsidian),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTheme.monoStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ColorPalette.obsidian,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero Icon with Glow
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.rustedCopper.withOpacity(0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.mugHot,
                    size: 48,
                    color: ColorPalette.rustedCopper,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                "Start Your Coffee Journey",
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.obsidian,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Archive your favorite beans, track roast dates, and discover new flavors with AI-powered insights.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPalette.matteSteel,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),

              // Feature Steps
              _buildFeatureStep(
                FontAwesomeIcons.camera,
                "Snap a Photo",
                "Capture the bag details instantly",
              ),
              const SizedBox(height: 24),
              _buildFeatureStep(
                FontAwesomeIcons.wandMagicSparkles,
                "AI Analysis",
                "Auto-extract origin & flavors",
              ),
              const SizedBox(height: 24),
              _buildFeatureStep(
                FontAwesomeIcons.boxArchive,
                "Digital Pantry",
                "Track aging & inventory levels",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureStep(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: ColorPalette.concreteDark.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: ColorPalette.obsidian),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ColorPalette.obsidian,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: ColorPalette.matteSteel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.concrete,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Pantry",
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: ColorPalette.obsidian,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                  fontSize: 32,
                                ),
                          ),
                          if (_beans.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorPalette.obsidian,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.wandMagicSparkles,
                                    size: 10,
                                    color: ColorPalette.rustedCopper,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "AI VISION",
                                    style: AppTheme.monoStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _beans.isEmpty
                            ? "Welcome Back"
                            : "Inventory: ${_beans.length} ${_beans.length == 1 ? 'Bag' : 'Bags'}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorPalette.matteSteel,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showAddOptions,
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
                            FontAwesomeIcons.plus,
                            size: 18,
                            color: ColorPalette.obsidian,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                ],
              ),
              const SizedBox(height: 32),

              // Content
              Expanded(
                child: _beans.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          0,
                          0,
                          0,
                          120,
                        ), // Bottom padding for FAB/Navigation
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio:
                                  0.65, // Taller cards for elegant portrait display
                            ),
                        itemCount: _beans.length,
                        itemBuilder: (context, index) {
                          return _buildBeanCard(_beans[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeanCard(Bean bean) {
    final bool isOld = bean.agingDays > 20;

    return GestureDetector(
      onTap: () => _showBeanEditor(bean, isNew: false),
      onLongPress: () => _showDeleteConfirmation(bean),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Full Bleed Image with Blur + Contain effect for completeness
              if (bean.imagePath != null) ...[
                // Background: Blurred version of the image
                Image.file(
                  File(bean.imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: ColorPalette.concreteDark);
                  },
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                // Foreground: Full image contained
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Breathing room
                    child: Image.file(
                      File(bean.imagePath!),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          FontAwesomeIcons.image,
                          size: 48,
                          color: ColorPalette.matteSteel,
                        );
                      },
                    ),
                  ),
                ),
              ] else ...[
                Container(color: ColorPalette.concreteDark),
              ],

              // 2. Gradient Overlay (Bottom) for text legibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 0.7, 1.0],
                  ),
                ),
              ),

              // 3. Top Info (Tags)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isOld)
                      _buildGlassTag(
                        "AGED",
                        ColorPalette.cremaGold,
                        textColor: Colors.black,
                      )
                    else
                      _buildGlassTag("FRESH", ColorPalette.extractionGreen),

                    if (bean.roastLevel.isNotEmpty)
                      _buildGlassTag(
                        bean.roastLevel,
                        Colors.black.withOpacity(0.6),
                        textColor: Colors.white,
                      ),
                  ],
                ),
              ),

              // 4. Bottom Info (Name & Origin)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bean.origin.toUpperCase(),
                      style: AppTheme.monoStyle.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bean.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (bean.flavorNotes.isNotEmpty)
                      Text(
                        bean.flavorNotes.take(2).join(" • "),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTag(
    String text,
    Color color, {
    Color textColor = Colors.white,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text.toUpperCase(),
            style: AppTheme.monoStyle.copyWith(
              color: textColor,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BeanEditorModal extends StatefulWidget {
  final Bean bean;
  final bool isNew;
  final Function(Bean) onSave;

  const BeanEditorModal({
    super.key,
    required this.bean,
    required this.isNew,
    required this.onSave,
  });

  @override
  State<BeanEditorModal> createState() => _BeanEditorModalState();
}

class _BeanEditorModalState extends State<BeanEditorModal> {
  late TextEditingController _nameController;
  late TextEditingController _originController;
  late TextEditingController _processController;
  late TextEditingController _roastController;
  late TextEditingController _flavorController;

  bool _isAnalyzing = false;
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bean.name);
    _originController = TextEditingController(text: widget.bean.origin);
    _processController = TextEditingController(text: widget.bean.process);
    _roastController = TextEditingController(text: widget.bean.roastLevel);
    _flavorController = TextEditingController(
      text: widget.bean.flavorNotes.join(", "),
    );

    // If it's not new, or if there is no image, show save button immediately
    if (!widget.isNew || widget.bean.imagePath == null) {
      _showSaveButton = true;
    }

    // Listen to changes to switch to Save button if user types manually
    void onTextChanged() {
      if (_isAnalyzing) return; // Prevent switching while AI is running
      if (!_showSaveButton && widget.isNew) {
        setState(() {
          _showSaveButton = true;
        });
      }
    }

    _nameController.addListener(onTextChanged);
    _originController.addListener(onTextChanged);
    _processController.addListener(onTextChanged);
    _roastController.addListener(onTextChanged);
    _flavorController.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _originController.dispose();
    _processController.dispose();
    _roastController.dispose();
    _flavorController.dispose();
    super.dispose();
  }

  Future<void> _runAiAnalysis() async {
    if (widget.bean.imagePath == null) return;

    setState(() {
      _isAnalyzing = true;
    });
    FocusScope.of(context).unfocus();

    try {
      final XFile imageFile = XFile(widget.bean.imagePath!);
      final Bean? analyzedBean = await AiService.analyzeBeanImage(imageFile);

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        if (analyzedBean != null) {
          _nameController.text = analyzedBean.name;
          _originController.text = analyzedBean.origin;
          _processController.text = analyzedBean.process;
          _roastController.text = analyzedBean.roastLevel;
          _flavorController.text = analyzedBean.flavorNotes.join(", ");

          setState(() {
            _showSaveButton = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("AI Analysis Complete!"),
              backgroundColor: ColorPalette.extractionGreen,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "AI could not identify details. Please enter manually.",
              ),
              backgroundColor: ColorPalette.rustedCopper,
            ),
          );
          // Switch to save button anyway to allow manual entry
          setState(() {
            _showSaveButton = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error during analysis: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _handleSave() {
    final updatedBean = Bean(
      id: widget.bean.id,
      name: _nameController.text.isEmpty
          ? "Unnamed Bean"
          : _nameController.text,
      origin: _originController.text,
      process: _processController.text,
      roastLevel: _roastController.text,
      roastDate: widget.bean.roastDate,
      initialWeight: widget.bean.initialWeight,
      remainingWeight: widget.bean.remainingWeight,
      flavorNotes: _flavorController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      imagePath: widget.bean.imagePath,
    );

    widget.onSave(updatedBean);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isNew ? "NEW BEAN" : "EDIT BEAN",
                    style: AppTheme.monoStyle.copyWith(
                      color: ColorPalette.rustedCopper,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Image Preview
              if (widget.bean.imagePath != null)
                Container(
                  height: 400, // Taller for better visibility
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.black, // Background for the image
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Blur
                        Image.file(
                          File(widget.bean.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: ColorPalette.concreteDark);
                          },
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        // Foreground Image
                        Center(
                          child: Image.file(
                            File(widget.bean.imagePath!),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.image,
                                    size: 48,
                                    color: ColorPalette.matteSteel,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Image not found",
                                    style: AppTheme.monoStyle.copyWith(
                                      color: ColorPalette.matteSteel,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              TextField(
                controller: _nameController,
                enabled: !_isAnalyzing,
                decoration: const InputDecoration(
                  labelText: "Bean Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _originController,
                      enabled: !_isAnalyzing,
                      decoration: const InputDecoration(
                        labelText: "Origin",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _processController,
                      enabled: !_isAnalyzing,
                      decoration: const InputDecoration(
                        labelText: "Process",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _roastController,
                enabled: !_isAnalyzing,
                decoration: const InputDecoration(
                  labelText: "Roast Level",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _flavorController,
                enabled: !_isAnalyzing,
                decoration: const InputDecoration(
                  labelText: "Flavor Notes (comma separated)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Animated Button
              SizedBox(
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                  child: _showSaveButton
                      ? ElevatedButton(
                          key: const ValueKey("saveBtn"),
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.obsidian,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text("SAVE TO PANTRY"),
                        )
                      : ElevatedButton.icon(
                          key: const ValueKey("aiBtn"),
                          onPressed: _isAnalyzing ? null : _runAiAnalysis,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.obsidian,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          icon: _isAnalyzing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  FontAwesomeIcons.wandMagicSparkles,
                                  size: 16,
                                ),
                          label: Text(
                            _isAnalyzing ? "ANALYZING..." : "AI IDENTIFY",
                            style: AppTheme.monoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
