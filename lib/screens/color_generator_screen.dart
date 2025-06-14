import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/color_scheme.dart';
import '../repositories/color_repository.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/color_sphere.dart';

// Custom painter for color box
class ColorBoxPainter extends CustomPainter {
  final Color color;

  ColorBoxPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill with solid color
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fillPaint,
    );

    // Add subtle gradient overlay
    final Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.transparent,
          Colors.black.withOpacity(0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );

    // Add shine effect in top left corner
    final Paint shinePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, -0.8),
        radius: 0.5,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! ColorBoxPainter ||
        (oldDelegate as ColorBoxPainter).color != color;
  }
}

class ColorGeneratorScreen extends StatefulWidget {
  const ColorGeneratorScreen({super.key});

  @override
  State<ColorGeneratorScreen> createState() => _ColorGeneratorScreenState();
}

class _ColorGeneratorScreenState extends State<ColorGeneratorScreen>
    with TickerProviderStateMixin {
  final ColorRepository _colorRepository = ColorRepository();
  CustomColorScheme _currentScheme = CustomColorScheme(
    hue: 285,
    saturation: 80,
    lightness: 50,
  );
  List<CustomColorScheme> _savedSchemes = [];
  List<CustomColorScheme> _favoriteSchemes = [];
  List<CustomColorScheme> _recentSchemes = [];
  bool _isLoading = true;
  bool _isCurrentFavorite = false;

  // Current palette type
  String _currentPaletteType = AppStrings.colorAnalogous;

  // Animation controller for color transitions
  late AnimationController _animationController;

  // Tab controller for palette types
  late TabController _tabController;

  // Available palette types
  final List<String> _paletteTypes = [
    AppStrings.colorAnalogous,
    AppStrings.colorMonochromatic,
    AppStrings.colorComplementary,
    AppStrings.colorTriadic,
    AppStrings.colorTetradic,
    AppStrings.colorSplitComplementary,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize tab controller
    _tabController = TabController(
      length: _paletteTypes.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentPaletteType = _paletteTypes[_tabController.index];
        });
      }
    });

    _loadColorSchemes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Load color schemes
  Future<void> _loadColorSchemes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final savedSchemes = await _colorRepository.getAllColorSchemes();
      final currentScheme = await _colorRepository.getCurrentScheme();
      final favoriteSchemes = await _colorRepository.getFavoriteSchemes();
      final recentSchemes = await _colorRepository.getRecentSchemes();

      setState(() {
        _savedSchemes = savedSchemes;
        _favoriteSchemes = favoriteSchemes;
        _recentSchemes = recentSchemes;

        if (currentScheme != null) {
          _currentScheme = currentScheme;
        }

        // Check if current scheme is a favorite
        _checkIfCurrentIsFavorite();
      });
    } catch (e) {
      debugPrint('Failed to load color schemes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Check if current scheme is a favorite
  Future<void> _checkIfCurrentIsFavorite() async {
    final isFavorite = await _colorRepository.isFavorite(_currentScheme);
    setState(() {
      _isCurrentFavorite = isFavorite;
    });
  }

  // Toggle favorite status of current scheme
  Future<void> _toggleFavorite() async {
    try {
      final result = await _colorRepository.toggleFavorite(_currentScheme);
      setState(() {
        _isCurrentFavorite = result;
      });

      await _loadColorSchemes();

      _showEnhancedSnackBar(
        message: result ? 'Added to favorites' : 'Removed from favorites',
        icon: result ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
        backgroundColor: result ? const Color(0xFFff4d94) : AppColors.deepSpace,
      );
    } catch (e) {
      debugPrint('Failed to toggle favorite: $e');
    }
  }

  // Copy color value to clipboard
  void _copyColorValue(String value) {
    Clipboard.setData(ClipboardData(text: value)).then((_) {
      _showEnhancedSnackBar(
        message: '${AppStrings.colorCopied} $value',
        icon: Icons.content_copy,
        backgroundColor: AppColors.electricBlue.withOpacity(0.8),
      );
    });
  }

  // Show enhanced snackbar with better visibility
  void _showEnhancedSnackBar({
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 8,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Save current color scheme
  Future<void> _saveCurrentScheme(String name) async {
    try {
      final schemeToSave = CustomColorScheme(
        hue: _currentScheme.hue,
        saturation: _currentScheme.saturation,
        lightness: _currentScheme.lightness,
        name: name,
      );

      await _colorRepository.addColorScheme(schemeToSave);
      await _colorRepository.saveCurrentScheme(schemeToSave);
      await _loadColorSchemes();

      _showEnhancedSnackBar(
        message: 'Color scheme "$name" saved',
        icon: FontAwesomeIcons.floppyDisk,
        backgroundColor: AppColors.hologramPurple.withOpacity(0.8),
      );
    } catch (e) {
      debugPrint('Failed to save color scheme: $e');
      _showEnhancedSnackBar(
        message: 'Failed to save color scheme',
        icon: FontAwesomeIcons.circleExclamation,
        backgroundColor: Colors.red.shade900,
      );
    }
  }

  // Generate random color scheme
  void _generateRandomScheme() {
    final random = Random();
    setState(() {
      _currentScheme = CustomColorScheme(
        hue: random.nextInt(360),
        saturation: 70.0 + random.nextInt(30).toDouble(),
        lightness: 40.0 + random.nextInt(20).toDouble(),
      );
    });

    _checkIfCurrentIsFavorite();
  }

  // Generate random pastel color scheme
  void _generateRandomPastelScheme() {
    setState(() {
      _currentScheme = CustomColorScheme.randomPastel();
    });

    _checkIfCurrentIsFavorite();
  }

  // Generate random vibrant color scheme
  void _generateRandomVibrantScheme() {
    setState(() {
      _currentScheme = CustomColorScheme.randomVibrant();
    });

    _checkIfCurrentIsFavorite();
  }

  // Generate random dark color scheme
  void _generateRandomDarkScheme() {
    setState(() {
      _currentScheme = CustomColorScheme.randomDark();
    });

    _checkIfCurrentIsFavorite();
  }

  // Show save scheme dialog
  void _showSaveSchemeDialog() {
    final nameController = TextEditingController();

    // Dismiss keyboard when tapping outside
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: AlertDialog(
            backgroundColor: AppColors.deepSpace,
            title: Text(AppStrings.colorSaveScheme),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppStrings.colorSchemeName,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.colorCancel),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    _saveCurrentScheme(nameController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text(AppStrings.colorSave),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show random generation menu
  void _showRandomGenerationMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.deepSpace,
      items: [
        _buildRandomMenuItem(
          AppStrings.colorRandomGenerate,
          FontAwesomeIcons.dice,
          AppColors.hologramPurple,
          _generateRandomScheme,
        ),
        _buildRandomMenuItem(
          AppStrings.colorRandomPastel,
          FontAwesomeIcons.palette,
          const Color(0xFF64B5F6),
          _generateRandomPastelScheme,
        ),
        _buildRandomMenuItem(
          AppStrings.colorRandomVibrant,
          FontAwesomeIcons.bolt,
          const Color(0xFFFF7043),
          _generateRandomVibrantScheme,
        ),
        _buildRandomMenuItem(
          AppStrings.colorRandomDark,
          FontAwesomeIcons.moon,
          const Color(0xFF455A64),
          _generateRandomDarkScheme,
        ),
      ],
    );
  }

  // Build random menu item
  PopupMenuItem<String> _buildRandomMenuItem(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return PopupMenuItem<String>(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppColors.hologramPurple,
                ))
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 20),

                    // Color sphere
                    _buildColorSphere(),
                    const SizedBox(height: 20),

                    // HSL controls
                    _buildHSLControls(),
                    const SizedBox(height: 20),

                    // Palette type tabs
                    _buildPaletteTypeTabs(),
                    const SizedBox(height: 16),

                    // Color palettes
                    _buildColorPaletteContainer(),
                    const SizedBox(
                        height: 100), // Extra space at bottom for scrolling
                  ],
                ),
        ),
      ),
    );
  }

  // Build header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          AppStrings.colorTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            // Random generation button
            _buildTooltipButton(
              icon: FontAwesomeIcons.dice,
              color: AppColors.electricBlue,
              onPressed: () {
                _showRandomGenerationMenu();
              },
              tooltip: AppStrings.colorRandomGenerate,
            ),

            // History button
            _buildTooltipButton(
              icon: FontAwesomeIcons.clock,
              color: AppColors.electricBlue,
              onPressed: () {
                // Show history
                _showSavedSchemes();
              },
              tooltip: AppStrings.colorHistory,
            ),

            // Save button
            _buildTooltipButton(
              icon: FontAwesomeIcons.floppyDisk,
              color: AppColors.hologramPurple,
              onPressed: _showSaveSchemeDialog,
              tooltip: AppStrings.colorSave,
            ),

            // Export button
            _buildTooltipButton(
              icon: FontAwesomeIcons.fileExport,
              color: AppColors.electricBlue,
              onPressed: () {
                // Export current color scheme
                _exportCurrentScheme();
              },
              tooltip: AppStrings.colorExport,
            ),
          ],
        ),
      ],
    );
  }

  // Build tooltip button with improved tooltip style
  Widget _buildTooltipButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.deepSpace.withOpacity(0.95),
            AppColors.nebulaPurple.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.hologramPurple.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      preferBelow: true,
      verticalOffset: 20,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.all(12),
      showDuration: const Duration(seconds: 2),
      waitDuration: const Duration(milliseconds: 500),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }

  // Build color sphere
  Widget _buildColorSphere() {
    return Center(
      child: ColorSphere(colorScheme: _currentScheme, size: 150),
    );
  }

  // Build HSL controls
  Widget _buildHSLControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.colorHSLValues,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildHSLBadge(
                    'H: ${_currentScheme.hue}°',
                    AppColors.electricBlue,
                  ),
                  const SizedBox(width: 8),
                  _buildHSLBadge(
                    'S: ${_currentScheme.saturation.toInt()}%',
                    AppColors.hologramPurple,
                  ),
                  const SizedBox(width: 8),
                  _buildHSLBadge(
                    'L: ${_currentScheme.lightness.toInt()}%',
                    const Color(0xFFff4d94),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hue slider
          _buildHSLSlider(
            label: AppStrings.colorHue,
            value: _currentScheme.hue.toDouble(),
            min: 0,
            max: 360,
            activeColor: AppColors.electricBlue,
            onChanged: (value) {
              setState(() {
                _currentScheme = _currentScheme.copyWith(hue: value.toInt());
                _checkIfCurrentIsFavorite();
              });
            },
          ),

          // Saturation slider
          _buildHSLSlider(
            label: AppStrings.colorSaturation,
            value: _currentScheme.saturation,
            min: 0,
            max: 100,
            activeColor: AppColors.hologramPurple,
            onChanged: (value) {
              setState(() {
                _currentScheme = _currentScheme.copyWith(saturation: value);
                _checkIfCurrentIsFavorite();
              });
            },
          ),

          // Lightness slider
          _buildHSLSlider(
            label: AppStrings.colorLightness,
            value: _currentScheme.lightness,
            min: 0,
            max: 100,
            activeColor: const Color(0xFFff4d94),
            onChanged: (value) {
              setState(() {
                _currentScheme = _currentScheme.copyWith(lightness: value);
                _checkIfCurrentIsFavorite();
              });
            },
          ),
        ],
      ),
    );
  }

  // Build HSL badge
  Widget _buildHSLBadge(String text, Color color) {
    return InkWell(
      onTap: () => _copyColorValue(text),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.content_copy,
              size: 10,
              color: color.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  // Build HSL slider
  Widget _buildHSLSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: activeColor, size: 12),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
            Text(
              label == AppStrings.colorHue
                  ? '${value.toInt()}°'
                  : '${value.toInt()}%',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: activeColor.withOpacity(0.2),
            thumbColor: activeColor,
            overlayColor: activeColor.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Build palette type tabs
  Widget _buildPaletteTypeTabs() {
    return Container(
      height: 50,
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColors.electricBlue.withOpacity(0.2),
              AppColors.hologramPurple.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.hologramPurple.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: AppColors.hologramPurple.withOpacity(0.5),
            width: 1,
          ),
        ),
        labelColor: AppColors.hologramPurple,
        unselectedLabelColor: AppColors.textColor.withOpacity(0.7),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        tabs: _paletteTypes.map((type) {
          IconData icon;
          switch (type) {
            case AppStrings.colorAnalogous:
              icon = Icons.panorama_fish_eye;
              break;
            case AppStrings.colorMonochromatic:
              icon = Icons.tonality;
              break;
            case AppStrings.colorComplementary:
              icon = Icons.change_history;
              break;
            case AppStrings.colorTriadic:
              icon = Icons.change_circle;
              break;
            case AppStrings.colorTetradic:
              icon = Icons.crop_square;
              break;
            case AppStrings.colorSplitComplementary:
              icon = Icons.auto_awesome;
              break;
            default:
              icon = Icons.palette;
          }

          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 8),
                Text(type),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Build color palettes container (not in a Column with Expanded)
  Widget _buildColorPaletteContainer() {
    List<Color> colors = [];

    // Get colors based on current palette type
    switch (_currentPaletteType) {
      case AppStrings.colorAnalogous:
        colors = _currentScheme.analogousColors;
        break;
      case AppStrings.colorMonochromatic:
        colors = _currentScheme.monochromaticColors;
        break;
      case AppStrings.colorComplementary:
        colors = [
          _currentScheme.primaryColor,
          _currentScheme.complementaryColor
        ];
        break;
      case AppStrings.colorTriadic:
        colors = _currentScheme.triadicColors;
        break;
      case AppStrings.colorTetradic:
        colors = _currentScheme.tetradicColors;
        break;
      case AppStrings.colorSplitComplementary:
        colors = _currentScheme.splitComplementaryColors;
        break;
      default:
        colors = _currentScheme.analogousColors;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.05,
        borderColor: AppColors.hologramPurple.withOpacity(0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Palette title
          Row(
            children: [
              Icon(
                _getPaletteIcon(_currentPaletteType),
                size: 16,
                color: AppColors.hologramPurple,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getPaletteDescription(_currentPaletteType),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.hologramPurple,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Color grid - no longer in an Expanded widget
          colors.length <= 2
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    colors.length,
                    (index) => Container(
                      height: 150, // Increased height for color boxes
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildColorBox(colors[index], index),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling for the grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio:
                        0.85, // Taller cards for better visibility
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return _buildColorBox(colors[index], index);
                  },
                ),
        ],
      ),
    );
  }

  // Get palette icon
  IconData _getPaletteIcon(String paletteType) {
    switch (paletteType) {
      case AppStrings.colorAnalogous:
        return Icons.panorama_fish_eye;
      case AppStrings.colorMonochromatic:
        return Icons.tonality;
      case AppStrings.colorComplementary:
        return Icons.change_history;
      case AppStrings.colorTriadic:
        return Icons.change_circle;
      case AppStrings.colorTetradic:
        return Icons.crop_square;
      case AppStrings.colorSplitComplementary:
        return Icons.auto_awesome;
      default:
        return Icons.palette;
    }
  }

  // Get palette description
  String _getPaletteDescription(String paletteType) {
    switch (paletteType) {
      case AppStrings.colorAnalogous:
        return 'Colors that are adjacent on the color wheel';
      case AppStrings.colorMonochromatic:
        return 'Different shades of the same hue';
      case AppStrings.colorComplementary:
        return 'Colors opposite each other on the color wheel';
      case AppStrings.colorTriadic:
        return 'Three colors equally spaced on the color wheel';
      case AppStrings.colorTetradic:
        return 'Four colors forming a rectangle on the color wheel';
      case AppStrings.colorSplitComplementary:
        return 'A base color and two adjacent to its complement';
      default:
        return paletteType;
    }
  }

  // Build color box
  Widget _buildColorBox(Color color, int index) {
    // Get color hex representation
    final hexColor =
        '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    final rgbValue = 'RGB(${color.red}, ${color.green}, ${color.blue})';

    return InkWell(
      onTap: () => _showColorDetails(color, hexColor, index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          fit: StackFit.expand, // Ensure stack takes full space of parent
          children: [
            // Color preview
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CustomPaint(
                painter: ColorBoxPainter(color),
              ),
            ),

            // Color info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hexColor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap for details',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Index badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show color details in a bottom sheet
  void _showColorDetails(Color color, String hexColor, int index) {
    final rgbValue = 'RGB(${color.red}, ${color.green}, ${color.blue})';
    final hslValue =
        'HSL(${HSLColor.fromColor(color).hue.round()}°, ${(HSLColor.fromColor(color).saturation * 100).round()}%, ${(HSLColor.fromColor(color).lightness * 100).round()}%)';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.9),
                AppColors.deepSpace.withOpacity(0.95),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color preview and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          color: ColorHelper.adjustLightness(
                            color,
                            color.computeLuminance() > 0.5 ? -0.6 : 0.6,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Action buttons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favorite button
                      InkWell(
                        onTap: _toggleFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isCurrentFavorite
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: _isCurrentFavorite
                                ? const Color(0xFFff4d94)
                                : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isCurrentFavorite ? 'Favorite' : 'Add to\nFavorites',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Color values
              const Text(
                'Color Values',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Color format options
              _buildColorDetailItem('HEX', hexColor),
              _buildColorDetailItem('RGB', rgbValue),
              _buildColorDetailItem('HSL', hslValue),

              const SizedBox(height: 24),

              // Color harmonies
              const Text(
                'Color Harmonies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Color harmony options
              Expanded(
                child: Row(
                  children: [
                    _buildHarmonyOption(
                      'Complementary',
                      ColorHelper.complementary(color),
                    ),
                    const SizedBox(width: 16),
                    _buildHarmonyOption(
                      'Lighter',
                      ColorHelper.adjustLightness(color, 0.2),
                    ),
                    const SizedBox(width: 16),
                    _buildHarmonyOption(
                      'Darker',
                      ColorHelper.adjustLightness(color, -0.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build color detail item
  Widget _buildColorDetailItem(String label, String value) {
    return InkWell(
      onTap: () => _copyColorValue(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.hologramPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.content_copy,
                  size: 16,
                  color: Colors.white70,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build harmony option
  Widget _buildHarmonyOption(String label, Color color) {
    final hexColor =
        '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    return Expanded(
      child: InkWell(
        onTap: () => _copyColorValue(hexColor),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              hexColor,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Show saved schemes
  void _showSavedSchemes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.deepSpace,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with tabs
                DefaultTabController(
                  length: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Saved'),
                          Tab(text: 'Favorites'),
                          Tab(text: 'Recent'),
                        ],
                        labelColor: AppColors.hologramPurple,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.hologramPurple,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6 - 100,
                        child: TabBarView(
                          children: [
                            // Saved schemes
                            _buildSchemeList(
                              _savedSchemes,
                              AppStrings.colorNoSavedSchemes,
                            ),

                            // Favorite schemes
                            _buildSchemeList(
                              _favoriteSchemes,
                              AppStrings.colorNoFavorites,
                            ),

                            // Recent schemes
                            _buildSchemeList(
                              _recentSchemes,
                              AppStrings.colorNoHistory,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build scheme list
  Widget _buildSchemeList(
      List<CustomColorScheme> schemes, String emptyMessage) {
    if (schemes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.palette,
              size: 48,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: schemes.length,
      itemBuilder: (context, index) {
        final scheme = schemes[index];
        return _buildSchemeListItem(scheme);
      },
    );
  }

  // Build scheme list item
  Widget _buildSchemeListItem(CustomColorScheme scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.deepSpace.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.hologramPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: scheme.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        title: Text(
          scheme.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          scheme.hslString,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.pen, size: 16),
              onPressed: () => _editScheme(scheme),
              tooltip: AppStrings.colorEdit,
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.trash, size: 16),
              onPressed: () => _deleteScheme(scheme),
              tooltip: AppStrings.colorDelete,
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _currentScheme = scheme;
          });
          _checkIfCurrentIsFavorite();
          Navigator.pop(context);
        },
      ),
    );
  }

  // Edit scheme
  void _editScheme(CustomColorScheme scheme) {
    final nameController = TextEditingController(text: scheme.name);

    // Dismiss keyboard when tapping outside
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: AlertDialog(
            backgroundColor: AppColors.deepSpace,
            title: Text(AppStrings.colorEdit),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppStrings.colorSchemeName,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.colorCancel),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final updatedScheme = scheme.copyWith(
                      name: nameController.text,
                    );
                    _colorRepository.updateColorScheme(scheme, updatedScheme);
                    _loadColorSchemes();
                    Navigator.pop(context);
                  }
                },
                child: Text(AppStrings.colorSave),
              ),
            ],
          ),
        );
      },
    );
  }

  // Delete scheme
  void _deleteScheme(CustomColorScheme scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepSpace,
        title: const Text('Delete Color Scheme'),
        content: Text('Are you sure you want to delete "${scheme.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.colorCancel),
          ),
          TextButton(
            onPressed: () {
              _colorRepository.removeColorScheme(scheme);
              _loadColorSchemes();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppStrings.colorDelete),
          ),
        ],
      ),
    );
  }

  // Export current scheme
  void _exportCurrentScheme() {
    // Get current color scheme values
    final primaryColor = _currentScheme.primaryColor;
    final hexColor = _currentScheme.hexString;
    final rgbColor = _currentScheme.rgbString;
    final hslColor = _currentScheme.hslString;

    // Show export dialog
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.deepSpace,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.colorExportTitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildExportItem('HEX', hexColor),
                _buildExportItem('RGB', rgbColor),
                _buildExportItem('HSL', hslColor),
                const SizedBox(height: 16),
                Text(
                  AppStrings.colorCopyToClipboard,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build export item
  Widget _buildExportItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nebulaPurple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              InkWell(
                onTap: () => _copyColorValue(value),
                child: Text(value,
                    style: const TextStyle(fontFamily: 'monospace')),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _copyColorValue(value),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.hologramPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.content_copy,
                      size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
