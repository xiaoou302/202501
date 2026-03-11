import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/astro_image.dart';
import '../widgets/glass_panel.dart';
import '../utils/app_colors.dart';
import '../models/astro_target.dart';
import 'target_detail_screen.dart';

class AtlasScreen extends StatefulWidget {
  const AtlasScreen({super.key});

  @override
  State<AtlasScreen> createState() => _AtlasScreenState();
}

class _AtlasScreenState extends State<AtlasScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showReportDialog(BuildContext context) {
    String reportType = 'Spam';
    final TextEditingController reportContentController =
        TextEditingController();
    final List<String> reportTypes = [
      'Spam',
      'Inappropriate Content',
      'Incorrect Data',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.translucent,
                child: GlassPanel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Target',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.starlightWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: reportType,
                        dropdownColor: AppColors.cosmicBlack,
                        style: const TextStyle(color: AppColors.starlightWhite),
                        items: reportTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            reportType = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Report Type',
                          labelStyle: const TextStyle(
                            color: AppColors.meteoriteGrey,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.meteoriteGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: reportContentController,
                        style: const TextStyle(color: AppColors.starlightWhite),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: AppColors.meteoriteGrey),
                          helperText: 'Max 200 characters',
                          helperStyle: TextStyle(
                            color: AppColors.meteoriteGrey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.meteoriteGrey,
                            ),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.meteoriteGrey),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orionPurple,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('我们会在24小时内核实举报内容并出现相应处理'),
                                  backgroundColor: AppColors.orionPurple,
                                ),
                              );
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOptions(BuildContext context, AstroTarget target) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassPanel(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.flag,
                  color: AppColors.starlightWhite,
                ),
                title: const Text(
                  'Report',
                  style: TextStyle(color: AppColors.starlightWhite),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),
              Divider(color: AppColors.meteoriteGrey.withOpacity(0.5)),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Confirm delete? Or just delete. User said "Select delete to permanently delete".
                  // I'll add a quick confirm dialog for safety, or just do it.
                  // Let's do it directly to be fast as per user instruction "Select delete can permanently delete".
                  context.read<DataService>().removeTarget(target.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${target.name} deleted'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTargets = context.watch<DataService>().targets;

    // Filter logic: match name or constellation
    final filteredTargets = allTargets.where((target) {
      final query = _searchQuery.toLowerCase();
      return target.name.toLowerCase().contains(query) ||
          target.constellation.toLowerCase().contains(query) ||
          target.id.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Dismiss keyboard when tapping outside of the TextField
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASTRO-ATLAS',
                      style: TextStyle(
                        color: AppColors.orionPurple,
                        fontSize: 12,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Deep Sky Database',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.starlightWhite,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: GlassPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.meteoriteGrey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          // Input restriction: limit length to avoid unreasonable input
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          style: const TextStyle(
                            color: AppColors.starlightWhite,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search targets, constellations...',
                            hintStyle: const TextStyle(
                              color: AppColors.meteoriteGrey,
                            ),
                            border: InputBorder.none,
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.meteoriteGrey,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: filteredTargets.isEmpty
                    ? Center(
                        child: Text(
                          'No targets found for "$_searchQuery"',
                          style: const TextStyle(
                            color: AppColors.meteoriteGrey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredTargets.length,
                        itemBuilder: (context, index) {
                          final target = filteredTargets[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                _searchFocusNode.unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TargetDetailScreen(target: target),
                                  ),
                                );
                              },
                              onLongPress: () {
                                _searchFocusNode.unfocus();
                                _showOptions(context, target);
                              },
                              child: GlassPanel(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section with Tag Overlay
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                          child: AstroImage(
                                            imageUrl: target.imageUrl,
                                            height: 220,
                                            width: double.infinity,
                                            heroTag: target.id,
                                          ),
                                        ),
                                        // Palette Badge Overlay
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.7,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: AppColors.orionPurple,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              target.palette,
                                              style: const TextStyle(
                                                color: AppColors.orionPurple,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Gradient for Text Readability (if we overlay text)
                                        // But here we keep text below for cleaner look
                                      ],
                                    ),

                                    // Content Section
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Header Row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      target.name.toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0,
                                                            color: AppColors
                                                                .starlightWhite,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      target.constellation
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .andromedaCyan,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 16),

                                          // Tech Specs Row with Icons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildInfoItem(
                                                context,
                                                FontAwesomeIcons.clock,
                                                '${target.integrationHours}h',
                                              ),
                                              _buildInfoItem(
                                                context,
                                                FontAwesomeIcons.ruler,
                                                '${target.focalLength}mm',
                                              ),
                                              _buildInfoItem(
                                                context,
                                                FontAwesomeIcons.camera,
                                                target.cameraModel,
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
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: AppColors.meteoriteGrey),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
