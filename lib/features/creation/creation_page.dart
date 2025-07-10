import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/dynamic_island.dart';
import '../../core/services/ai_service.dart';
import '../../data/models/comic_model.dart';
import 'dart:math';

/// 漫画创作页面
class CreationPage extends StatefulWidget {
  const CreationPage({Key? key}) : super(key: key);

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  final TextEditingController _plotController = TextEditingController();
  final FocusNode _plotFocusNode = FocusNode();
  ComicStyle _selectedStyle = ComicStyle.cyberpunk;
  int _panelCount = 4;
  String _qualityLevel = 'HD';
  bool _isGenerating = false;
  DynamicIslandController? _dynamicIslandController;
  List<String> _generatedImages = [];
  String? _errorMessage;
  bool _isDisposed = false;

  // 输入限制
  static const int maxPlotLength = 500; // 最大剧情描述长度
  static const int minPlotLength = 20; // 最小剧情描述长度

  final Map<ComicStyle, IconData> _styleIcons = {
    ComicStyle.cyberpunk: Icons.memory,
    ComicStyle.fantasy: Icons.auto_awesome,
    ComicStyle.sciFi: Icons.rocket_launch,
    ComicStyle.modern: Icons.apartment,
    ComicStyle.other: Icons.palette,
  };

  final Map<ComicStyle, String> _styleNames = {
    ComicStyle.cyberpunk: 'Cyberpunk',
    ComicStyle.fantasy: 'Fantasy',
    ComicStyle.sciFi: 'Sci-Fi',
    ComicStyle.modern: 'Modern',
    ComicStyle.other: 'Other',
  };

  final Map<ComicStyle, String> _styleDescriptions = {
    ComicStyle.cyberpunk: 'Neon lights and futuristic tech',
    ComicStyle.fantasy: 'Magic and mystical creatures',
    ComicStyle.sciFi: 'Space and advanced technology',
    ComicStyle.modern: 'Contemporary urban life',
    ComicStyle.other: 'Custom style',
  };

  @override
  void initState() {
    super.initState();
    _plotController.text =
        'In a futuristic cyberpunk city, a young hacker discovers a mysterious device that can control the city\'s AI system...';

    // 添加文本变化监听
    _plotController.addListener(_onPlotTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dynamicIslandController = DynamicIslandController(context);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _plotController.removeListener(_onPlotTextChanged);
    _plotController.dispose();
    _plotFocusNode.dispose();
    _dynamicIslandController?.dispose();
    super.dispose();
  }

  // 监听文本变化
  void _onPlotTextChanged() {
    if (_plotController.text.length > maxPlotLength) {
      _plotController.text = _plotController.text.substring(0, maxPlotLength);
      _plotController.selection = TextSelection.fromPosition(
        TextPosition(offset: _plotController.text.length),
      );
    }
  }

  // 验证输入
  bool _validateInput() {
    if (_plotController.text.length < minPlotLength) {
      _dynamicIslandController?.show(
        message: 'Plot must be at least $minPlotLength characters',
        icon: Icons.error_outline,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
    return true;
  }

  Future<void> _generateComic() async {
    // 验证输入
    if (!_validateInput()) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    developer.log('Starting comic generation process', name: 'CreationPage');

    if (_plotController.text.isEmpty) {
      const message = 'Plot description is empty';
      developer.log(message, name: 'CreationPage');
      if (!_isDisposed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(message)),
        );
      }
      return;
    }

    if (!mounted) return;

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _generatedImages = [];
    });

    try {
      developer.log('Initializing generation with parameters:',
          name: 'CreationPage');
      developer.log('Style: ${_selectedStyle.toString()}',
          name: 'CreationPage');
      developer.log('Panel Count: $_panelCount', name: 'CreationPage');
      developer.log('Quality Level: $_qualityLevel', name: 'CreationPage');
      developer.log('Image Size: ${_getImageSize()}', name: 'CreationPage');
      developer.log('Inference Steps: ${_getInferenceSteps()}',
          name: 'CreationPage');

      if (!mounted) return;
      _dynamicIslandController?.show(
        message: 'Generating comic...',
        icon: Icons.auto_awesome,
        duration: const Duration(seconds: 10),
      );

      final List<String> allImages = [];
      for (int i = 0; i < _panelCount; i++) {
        if (!mounted) return;

        developer.log('Generating panel ${i + 1} of $_panelCount',
            name: 'CreationPage');

        final prompt = AIService.generatePromptForStyle(
          _plotController.text,
          _selectedStyle.toString().split('.').last,
        );
        developer.log('Generated prompt: $prompt', name: 'CreationPage');

        try {
          final images = await AIService.generateImages(
            prompt: prompt,
            imageSize: _getImageSize(),
            numInferenceSteps: _getInferenceSteps(),
          );

          if (!mounted) return;

          developer.log('API response received for panel ${i + 1}',
              name: 'CreationPage');
          developer.log('Number of images received: ${images.length}',
              name: 'CreationPage');

          if (images.isNotEmpty) {
            allImages.addAll(images);
            developer.log('Added ${images.length} images to result list',
                name: 'CreationPage');
          } else {
            developer.log(
                'Warning: No images received from API for panel ${i + 1}',
                name: 'CreationPage');
          }
        } catch (panelError) {
          developer.log('Error generating panel ${i + 1}: $panelError',
              name: 'CreationPage', error: panelError);
          throw Exception('Failed to generate panel ${i + 1}: $panelError');
        }

        if (!mounted) return;
        _dynamicIslandController?.show(
          message: 'Generated ${i + 1} of $_panelCount panels',
          icon: Icons.auto_awesome,
          duration: const Duration(seconds: 2),
        );
      }

      if (allImages.isEmpty) {
        const errorMsg = 'No images were generated successfully';
        developer.log(errorMsg,
            name: 'CreationPage', error: Exception(errorMsg));
        throw Exception(errorMsg);
      }

      if (!mounted) return;

      setState(() {
        _generatedImages = allImages;
        _isGenerating = false;
      });

      if (!mounted) return;
      _dynamicIslandController?.show(
        message: 'Comic generated successfully!',
        icon: Icons.check_circle,
        duration: const Duration(seconds: 2),
      );

      if (!mounted) return;
      _showResultDialog();
    } catch (e, stackTrace) {
      developer.log('Error during comic generation',
          name: 'CreationPage', error: e, stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isGenerating = false;
        _errorMessage = e.toString();
      });

      if (!mounted) return;
      _dynamicIslandController?.show(
        message: 'Generation failed',
        icon: Icons.error,
        duration: const Duration(seconds: 2),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _saveImagesToGallery(List<String> imageUrls) async {
    if (!mounted) return;

    try {
      // Request permission first
      final status = await Permission.photos.request();
      if (!mounted) return;

      if (!status.isGranted) {
        _dynamicIslandController?.show(
          message: 'Please allow access to save photos',
          icon: Icons.error,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      if (!mounted) return;
      _dynamicIslandController?.show(
        message: 'Preparing to save images...',
        icon: Icons.save,
        duration: const Duration(seconds: 2),
      );

      int savedCount = 0;
      for (int i = 0; i < imageUrls.length; i++) {
        if (!mounted) return;

        try {
          // Download image
          final response = await http.get(Uri.parse(imageUrls[i]));
          if (!mounted) return;

          if (response.statusCode == 200) {
            // Save to gallery
            final result = await ImageGallerySaver.saveImage(
              Uint8List.fromList(response.bodyBytes),
              quality: 100,
              name: 'comic_${DateTime.now().millisecondsSinceEpoch}_$i',
            );

            if (!mounted) return;

            if (result['isSuccess']) {
              savedCount++;
              // Show progress
              _dynamicIslandController?.show(
                message: 'Saving image ${i + 1} of ${imageUrls.length}',
                icon: Icons.save,
                duration: const Duration(milliseconds: 500),
              );
            }
          }
        } catch (e) {
          developer.log('Error saving image $i: $e', name: 'CreationPage');
        }
      }

      if (!mounted) return;

      if (savedCount > 0) {
        _dynamicIslandController?.show(
          message: 'Saved $savedCount images to Photos',
          icon: Icons.check_circle,
          duration: const Duration(seconds: 2),
        );
      } else {
        _dynamicIslandController?.show(
          message: 'Failed to save images',
          icon: Icons.error,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      developer.log('Error in _saveImagesToGallery: $e', name: 'CreationPage');
      if (!mounted) return;

      _dynamicIslandController?.show(
        message: 'Error saving images',
        icon: Icons.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  String _getImageSize() {
    final size = switch (_qualityLevel) {
      'Standard' => '512x512',
      'HD' => '768x768',
      'UHD' => '1024x1024',
      _ => '768x768',
    };
    developer.log('Selected image size: $size for quality: $_qualityLevel',
        name: 'CreationPage');
    return size;
  }

  int _getInferenceSteps() {
    final steps = switch (_qualityLevel) {
      'Standard' => 20,
      'HD' => 30,
      'UHD' => 40,
      _ => 30,
    };
    developer.log(
        'Selected inference steps: $steps for quality: $_qualityLevel',
        name: 'CreationPage');
    return steps;
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusLarge),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: AppColors.accentPurple),
                    ),
                    const SizedBox(width: 12),
                    const Text('Comic Generated', style: AppStyles.heading3),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              if (_generatedImages.isNotEmpty)
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusMedium),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusMedium),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemCount: _generatedImages.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                _generatedImages[index],
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      color: AppColors.accentPurple,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: Colors.black45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _generatedImages.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AppColors.accentPurple.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.white30,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _generatedImages.isEmpty
                          ? 'Failed to generate images'
                          : 'Comic generated successfully.',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyText.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: AppStyles.secondaryButtonStyle,
                          child: const Text('Close'),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360 || screenSize.height < 600;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backgroundGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const CustomAppBar(title: 'Create Comic'),
                if (_errorMessage != null)
                  Container(
                    margin: EdgeInsets.all(
                        isSmallScreen ? 8.0 : AppStyles.paddingMedium),
                    padding: EdgeInsets.all(
                        isSmallScreen ? 8.0 : AppStyles.paddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusSmall),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: isSmallScreen ? 16 : 24,
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: (isSmallScreen
                                    ? AppStyles.bodyTextSmall
                                    : AppStyles.bodyText)
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: isSmallScreen ? 16 : 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: isSmallScreen ? 32 : 48,
                            minHeight: isSmallScreen ? 32 : 48,
                          ),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                        isSmallScreen ? 8.0 : AppStyles.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlotSection(isSmallScreen),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildStyleSection(isSmallScreen),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildAdvancedSettings(isSmallScreen),
                        SizedBox(height: isSmallScreen ? 16 : 24),
                        _buildGenerateButton(),
                      ],
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

  Widget _buildPlotSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.text_fields,
                color: AppColors.accentPurple,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Plot Description',
                style: isSmallScreen
                    ? AppStyles.heading3.copyWith(fontSize: 16)
                    : AppStyles.heading3,
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          TextField(
            controller: _plotController,
            focusNode: _plotFocusNode,
            maxLines: isSmallScreen ? 3 : 4,
            maxLength: maxPlotLength,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            style: isSmallScreen
                ? AppStyles.bodyText.copyWith(fontSize: 14)
                : AppStyles.bodyText,
            decoration:
                AppStyles.inputDecoration('Describe your comic story...')
                    .copyWith(
              counterText: '${_plotController.text.length}/$maxPlotLength',
              counterStyle: (isSmallScreen
                      ? AppStyles.caption.copyWith(fontSize: 10)
                      : AppStyles.caption)
                  .copyWith(
                color: _plotController.text.length >= maxPlotLength
                    ? Colors.red
                    : Colors.white54,
              ),
              helperText: 'Minimum $minPlotLength characters required',
              helperStyle: (isSmallScreen
                      ? AppStyles.caption.copyWith(fontSize: 10)
                      : AppStyles.caption)
                  .copyWith(
                color: _plotController.text.length < minPlotLength
                    ? Colors.red
                    : Colors.white54,
              ),
              contentPadding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            ),
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: AppColors.accentPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
              border: const Border(
                left: BorderSide(color: AppColors.accentPurple, width: 3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb,
                    color: AppColors.accentPurple,
                    size: isSmallScreen ? 14 : 18),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Expanded(
                  child: Text(
                    'Tip: Add details like "A tense scene where the hacker is being chased"',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette,
                color: AppColors.accentPurple,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Comic Style',
                style: isSmallScreen
                    ? AppStyles.heading3.copyWith(fontSize: 16)
                    : AppStyles.heading3,
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: isSmallScreen ? 8 : 12,
              mainAxisSpacing: isSmallScreen ? 8 : 12,
              childAspectRatio: 1,
            ),
            itemCount: ComicStyle.values.length,
            itemBuilder: (context, index) {
              final style = ComicStyle.values[index];
              final isSelected = style == _selectedStyle;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStyle = style;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withOpacity(0.4),
                    borderRadius:
                        BorderRadius.circular(AppStyles.borderRadiusSmall),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentPurple
                          : Colors.white.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accentPurple.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Icon(
                      _styleIcons[style] ?? Icons.palette,
                      color: isSelected ? AppColors.accentPurple : Colors.white,
                      size: isSmallScreen ? 24 : 32,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _styleNames[_selectedStyle] ?? 'Unknown Style',
                    style: (isSmallScreen
                            ? AppStyles.heading3.copyWith(fontSize: 16)
                            : AppStyles.heading3)
                        .copyWith(color: AppColors.accentPurple),
                  ),
                  Text(
                    _styleDescriptions[_selectedStyle] ?? '',
                    style: isSmallScreen
                        ? AppStyles.caption.copyWith(fontSize: 11)
                        : AppStyles.caption,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: AppColors.accentPurple,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Advanced Settings',
                style: isSmallScreen
                    ? AppStyles.heading3.copyWith(fontSize: 16)
                    : AppStyles.heading3,
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Column(
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
                          'Panel Count',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Generate $_panelCount panels',
                          style: isSmallScreen
                              ? AppStyles.caption.copyWith(fontSize: 11)
                              : AppStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPanelCountButton(4, isSmallScreen),
                        _buildPanelCountButton(3, isSmallScreen),
                        _buildPanelCountButton(2, isSmallScreen),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quality Level',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$_qualityLevel',
                          style: isSmallScreen
                              ? AppStyles.caption.copyWith(fontSize: 11)
                              : AppStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildQualityButton('Standard', isSmallScreen),
                        _buildQualityButton('HD', isSmallScreen),
                        _buildQualityButton('UHD', isSmallScreen),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPanelCountButton(int count, bool isSmallScreen) {
    final isSelected = count == _panelCount;

    return GestureDetector(
      onTap: () {
        setState(() {
          _panelCount = count;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentPurple : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(count == 4 ? AppStyles.borderRadiusSmall : 0),
            right:
                Radius.circular(count == 2 ? AppStyles.borderRadiusSmall : 0),
          ),
        ),
        child: Text(
          '$count',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: isSmallScreen ? 12 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildQualityButton(String quality, bool isSmallScreen) {
    final isSelected = quality == _qualityLevel;

    return GestureDetector(
      onTap: () {
        setState(() {
          _qualityLevel = quality;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentPurple : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(
                quality == 'Standard' ? AppStyles.borderRadiusSmall : 0),
            right: Radius.circular(
                quality == 'UHD' ? AppStyles.borderRadiusSmall : 0),
          ),
        ),
        child: Text(
          quality,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: isSmallScreen ? 12 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : _generateComic,
        icon: _isGenerating
            ? SizedBox(
                width: isSmallScreen ? 16 : 20,
                height: isSmallScreen ? 16 : 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: isSmallScreen ? 1.5 : 2,
                ),
              )
            : Icon(Icons.auto_awesome, size: isSmallScreen ? 20 : 24),
        label: Text(
          _isGenerating ? 'Generating...' : 'Generate Comic',
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
        style: AppStyles.primaryButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return AppColors.buttonDisabled;
              }
              return AppColors.buttonPrimary;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return AppColors.buttonTextDisabled;
              }
              return AppColors.buttonText;
            },
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              vertical: isSmallScreen ? 12 : 16,
              horizontal: isSmallScreen ? 16 : 24,
            ),
          ),
        ),
      ),
    );
  }
}
