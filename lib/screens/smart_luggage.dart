import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/pack_item.dart';
import '../models/mission.dart';
import '../services/deepseek_ai_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 智能行囊屏幕，用于管理旅行物品清单
class SmartLuggageScreen extends StatefulWidget {
  const SmartLuggageScreen({Key? key}) : super(key: key);

  @override
  State<SmartLuggageScreen> createState() => _SmartLuggageScreenState();
}

class _SmartLuggageScreenState extends State<SmartLuggageScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _destinationFocusNode = FocusNode();
  final FocusNode _durationFocusNode = FocusNode();
  final FocusNode _peopleFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();

  final StorageService _storageService = StorageService();
  final DeepseekAIService _deepseekAIService = DeepseekAIService();

  List<Mission> _missions = [];
  Mission? _currentMission;
  bool _isLoading = true;
  bool _isGenerating = false;
  String? _generationError;
  bool _mounted = true;
  String _searchQuery = '';
  PackCategory? _selectedCategory;
  bool _showOnlyUnpacked = false;
  late AnimationController _animationController;

  // 输入验证错误信息
  String? _destinationError;
  String? _durationError;
  String? _peopleError;

  // 按类别分组的物品
  Map<PackCategory, List<PackItem>> _categorizedItems = {};
  Map<PackCategory, List<PackItem>> _filteredItems = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchController.addListener(_onSearchChanged);
    _initializeData();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _durationController.dispose();
    _peopleController.dispose();
    _searchController.dispose();
    _destinationFocusNode.dispose();
    _durationFocusNode.dispose();
    _peopleFocusNode.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _mounted = false;
    super.dispose();
  }

  /// 搜索内容变更时触发
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterItems();
    });
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    // 迁移旧数据（如果有的话）
    await _storageService.migrateOldData();
    // 加载任务
    await _loadMissions();
  }

  /// 加载已保存的任务
  Future<void> _loadMissions() async {
    if (!_mounted) return;

    setState(() {
      _isLoading = true;
    });

    final missions = await _storageService.getMissions(MissionType.luggage);

    if (!_mounted) return;

    setState(() {
      _missions = missions;

      // 如果有任务，选择第一个作为当前任务
      if (_missions.isNotEmpty) {
        _currentMission = _missions.firstWhere(
          (mission) => mission.packItems.isNotEmpty,
          orElse: () => _missions[0],
        );
        if (_currentMission != null) {
          _categorizePacks(_currentMission!);
        }
      }

      _isLoading = false;
    });
  }

  /// 按类别对物品进行分组
  void _categorizePacks(Mission mission) {
    final categorized = <PackCategory, List<PackItem>>{};

    for (final item in mission.packItems) {
      if (!categorized.containsKey(item.category)) {
        categorized[item.category] = [];
      }
      categorized[item.category]!.add(item);
    }

    if (!_mounted) return;

    setState(() {
      _categorizedItems = categorized;
      _filterItems();
    });
  }

  /// 根据搜索条件过滤物品
  void _filterItems() {
    if (_currentMission == null) {
      _filteredItems = {};
      return;
    }

    final filtered = <PackCategory, List<PackItem>>{};

    _categorizedItems.forEach((category, items) {
      // 如果选择了特定类别且不匹配，则跳过
      if (_selectedCategory != null && category != _selectedCategory) {
        return;
      }

      // 过滤物品
      final filteredItems = items.where((item) {
        // 搜索过滤
        final matchesSearch =
            _searchQuery.isEmpty ||
            item.name.toLowerCase().contains(_searchQuery);

        // 状态过滤（只显示未打包的物品）
        final matchesStatus = !_showOnlyUnpacked || !item.isPacked;

        return matchesSearch && matchesStatus;
      }).toList();

      if (filteredItems.isNotEmpty) {
        filtered[category] = filteredItems;
      }
    });

    _filteredItems = filtered;
  }

  /// 生成打包清单
  Future<void> _generatePackingList() async {
    final destination = _destinationController.text.trim();
    final duration = _durationController.text.trim();
    final people = _peopleController.text.trim();

    // 验证所有输入
    bool hasError = false;

    setState(() {
      // 检查是否为空
      if (destination.isEmpty) {
        _destinationError = 'Destination is required';
        hasError = true;
      } else if (!_isValidDestination(destination)) {
        _destinationError = 'Please enter a valid destination';
        hasError = true;
      } else {
        _destinationError = null;
      }

      if (duration.isEmpty) {
        _durationError = 'Duration is required';
        hasError = true;
      } else if (!_isValidDuration(duration)) {
        _durationError = 'Please enter a valid duration';
        hasError = true;
      } else {
        _durationError = null;
      }

      if (people.isEmpty) {
        _peopleError = 'Number of people is required';
        hasError = true;
      } else if (!_isValidPeople(people)) {
        _peopleError = 'Please enter a valid number';
        hasError = true;
      } else {
        _peopleError = null;
      }
    });

    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    // 收起键盘
    FocusScope.of(context).unfocus();

    if (!_mounted) return;

    setState(() {
      _isGenerating = true;
      _generationError = null;
    });

    try {
      // 构建输入文本
      final input = 'Trip to $destination for $duration with $people';

      // 使用DeepSeek AI服务生成任务
      final mission = await _deepseekAIService.generateMission(input);

      // 保存任务
      await _storageService.saveMission(mission, MissionType.luggage);

      // 重新加载任务
      await _loadMissions();

      // 清空输入框
      _destinationController.clear();
      _durationController.clear();
      _peopleController.clear();

      if (!_mounted) return;

      // 显示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trip created successfully: ${mission.title}'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // 提供触觉反馈
      HapticFeedback.mediumImpact();
    } catch (e) {
      if (!_mounted) return;

      setState(() {
        _generationError = 'Failed to generate packing list: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate packing list: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    } finally {
      if (!_mounted) return;

      setState(() {
        _isGenerating = false;
      });
    }
  }

  /// 更新打包物品状态
  Future<void> _updatePackItemStatus(PackItem item) async {
    if (_currentMission == null) return;

    // 找到任务中的物品
    final updatedItems = List<PackItem>.from(_currentMission!.packItems);
    final itemIndex = updatedItems.indexWhere((i) => i.id == item.id);
    if (itemIndex < 0) return;

    // 更新物品状态
    final updatedItem = updatedItems[itemIndex].copyWith(
      isPacked: !item.isPacked,
    );
    updatedItems[itemIndex] = updatedItem;

    // 更新任务
    final updatedMission = _currentMission!.copyWith(packItems: updatedItems);

    // 保存更新后的任务
    await _storageService.saveMission(updatedMission, MissionType.luggage);

    // 更新状态
    if (!_mounted) return;

    setState(() {
      _currentMission = updatedMission;
      _categorizePacks(updatedMission);

      // 更新missions列表中的任务
      final index = _missions.indexWhere((m) => m.id == updatedMission.id);
      if (index >= 0) {
        _missions[index] = updatedMission;
      }
    });

    // 提供触觉反馈
    HapticFeedback.mediumImpact();

    // 播放动画效果
    if (updatedItem.isPacked) {
      _animationController.forward(from: 0.0);
    }

    // 如果所有物品都已打包，显示祝贺消息
    if (updatedMission.packItems.every((item) => item.isPacked)) {
      _showAllPackedDialog();
    } else {
      // 计算完成百分比
      final progress = _getPackingProgress();

      // 在完成25%、50%、75%时显示鼓励消息
      if (progress == 0.25 || progress == 0.5 || progress == 0.75) {
        _showProgressMessage(progress);
      }
    }
  }

  /// 显示进度鼓励消息
  void _showProgressMessage(double progress) {
    String message;
    if (progress == 0.25) {
      message = '🚀 25% Complete! Keep going!';
    } else if (progress == 0.5) {
      message = '🎯 Halfway there! Well done!';
    } else {
      message = '🏆 Almost done! Just a little more!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.brandBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        action: SnackBarAction(
          label: 'Continue',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  /// 显示所有物品已打包对话框
  void _showAllPackedDialog() {
    // 播放动画
    _animationController.forward(from: 0.0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppTheme.accentOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.all(24),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🎉 Ready to Go!',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 行李图标和动画
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentOrange.withOpacity(0.2),
                          blurRadius: 20 * value,
                          spreadRadius: 5 * value,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.luggage,
                        color: AppTheme.accentOrange,
                        size: 64,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 祝贺文本
            const Text(
              'Congratulations! All items are packed!',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your luggage is ready. Have a great trip!',
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 旅行小贴士
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.brandBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.brandBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppTheme.brandBlue,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Travel Tips',
                        style: TextStyle(
                          color: AppTheme.brandBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Double-check your important documents before departure\n• Prepare some common medications\n• Remember to bring chargers and power adapters',
                    style: TextStyle(color: AppTheme.primaryText, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.secondaryText,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Start Journey'),
          ),
        ],
      ),
    );
  }

  /// 计算已打包物品数量
  int _getPackedItemsCount() {
    if (_currentMission == null) return 0;
    return _currentMission!.packItems.where((item) => item.isPacked).length;
  }

  /// 计算打包进度百分比
  double _getPackingProgress() {
    if (_currentMission == null || _currentMission!.packItems.isEmpty) return 0;
    return _getPackedItemsCount() / _currentMission!.packItems.length;
  }

  /// 切换任务
  void _switchMission(Mission mission) {
    if (!_mounted) return;

    setState(() {
      _currentMission = mission;
      _categorizePacks(mission);
    });
  }

  /// 删除任务
  Future<void> _deleteMission(Mission mission) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Trip',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${mission.title}"? This action cannot be undone.',
          style: const TextStyle(color: AppTheme.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.deleteMission(mission.id, MissionType.luggage);
      await _loadMissions();

      if (!_mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Trip deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildTripForm(),
                        const SizedBox(height: 24),
                        if (_currentMission != null) _buildPackingList(),
                        if (_currentMission == null && !_isGenerating)
                          _buildEmptyState(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Smart Luggage',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_missions.isNotEmpty)
          PopupMenuButton<Mission>(
            icon: const Icon(Icons.more_vert, color: AppTheme.secondaryText),
            onSelected: _switchMission,
            itemBuilder: (context) => _missions
                .map(
                  (mission) => PopupMenuItem<Mission>(
                    value: mission,
                    child: Text(
                      mission.title,
                      style: TextStyle(
                        color: mission.id == _currentMission?.id
                            ? AppTheme.brandBlue
                            : AppTheme.primaryText,
                        fontWeight: mission.id == _currentMission?.id
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  /// 构建旅行表单
  Widget _buildTripForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 目的地输入
          const Text(
            'Destination',
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _destinationController,
            focusNode: _destinationFocusNode,
            decoration: InputDecoration(
              hintText: 'e.g., Tokyo, Japan',
              hintStyle: const TextStyle(color: AppTheme.secondaryText),
              filled: true,
              fillColor: AppTheme.primaryBackground.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
              enabled: !_isGenerating,
              // Add error text when invalid
              errorText: _destinationError,
            ),
            style: const TextStyle(color: AppTheme.primaryText),
            // 限制输入长度
            maxLength: 30, // Increased to allow for longer destination names
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            // 隐藏计数器
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => null,
            // 输入验证
            onChanged: (value) {
              setState(() {
                // Clear error when typing
                _destinationError = null;

                // Validate on change (optional)
                if (value.length > 2 && !_isValidDestination(value)) {
                  _destinationError = 'Please enter a valid destination';
                }
              });
            },
            // 下一个输入框
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _durationFocusNode.requestFocus(),
            // 输入过滤器 - 只允许字母、数字、空格和常用标点
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.\-]')),
            ],
          ),
          const SizedBox(height: 16),

          // 时间和人数输入
          Row(
            children: [
              // 时间输入
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Duration',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _durationController,
                      focusNode: _durationFocusNode,
                      decoration: InputDecoration(
                        hintText: '7 days',
                        hintStyle: const TextStyle(
                          color: AppTheme.secondaryText,
                        ),
                        filled: true,
                        fillColor: AppTheme.primaryBackground.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabled: !_isGenerating,
                        errorText: _durationError,
                      ),
                      style: const TextStyle(color: AppTheme.primaryText),
                      // 限制输入长度
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      // 隐藏计数器
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            maxLength,
                          }) => null,
                      // 输入验证
                      onChanged: (value) {
                        setState(() {
                          _durationError = null;

                          // Validate on change
                          if (value.isNotEmpty && !_isValidDuration(value)) {
                            _durationError = 'Invalid format';
                          }
                        });
                      },
                      // 下一个输入框
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _peopleFocusNode.requestFocus(),
                      // 输入过滤器 - 允许数字、空格和一些关键词（days, weeks, months）
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9\s]|days?|weeks?|months?'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 人数输入
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'People',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _peopleController,
                      focusNode: _peopleFocusNode,
                      decoration: InputDecoration(
                        hintText: '2 people',
                        hintStyle: const TextStyle(
                          color: AppTheme.secondaryText,
                        ),
                        filled: true,
                        fillColor: AppTheme.primaryBackground.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabled: !_isGenerating,
                        errorText: _peopleError,
                      ),
                      style: const TextStyle(color: AppTheme.primaryText),
                      // 限制输入长度
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      // 隐藏计数器
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            maxLength,
                          }) => null,
                      // 输入验证
                      onChanged: (value) {
                        setState(() {
                          _peopleError = null;

                          // Validate number of people (1-99)
                          if (value.isNotEmpty && !_isValidPeople(value)) {
                            _peopleError = 'Invalid number';
                          }
                        });
                      },
                      // 完成输入
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _generatePackingList(),
                      // 输入过滤器 - 只允许数字、空格和"people"或"person"
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9\s]|people|person'),
                        ),
                      ],
                      // 数字键盘
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 生成按钮
          SizedBox(
            width: double.infinity,
            child: _buildPulseAnimatedButton(
              onPressed: _isGenerating ? null : _generatePackingList,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generatePackingList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentOrange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: _isGenerating
                    ? const SpinKitThreeBounce(color: Colors.white, size: 24)
                    : const Text(
                        'Generate Packing List',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
          if (_generationError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _generationError!,
                style: const TextStyle(color: AppTheme.errorRed, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.luggage, color: AppTheme.brandBlue, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Start Your First Trip',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fill in the form above, and AI will generate a personalized packing list for you',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _destinationController.text = 'Tokyo, Japan';
              _durationController.text = '7 days';
              _peopleController.text = '2 people';
              _generatePackingList();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Try Example: 7-day Trip to Tokyo, Japan'),
          ),
        ],
      ),
    );
  }

  /// 构建打包清单
  Widget _buildPackingList() {
    if (_currentMission == null) return const SizedBox.shrink();

    final packedCount = _getPackedItemsCount();
    final totalCount = _currentMission!.packItems.length;
    final progress = _getPackingProgress();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和进度
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentMission!.title,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_currentMission!.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _currentMission!.description,
                          style: const TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppTheme.secondaryText,
                ),
                onPressed: () => _deleteMission(_currentMission!),
                tooltip: '删除行程',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 进度信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '已打包: $packedCount / $totalCount',
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: progress == 1.0
                      ? AppTheme.successGreen
                      : AppTheme.secondaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.primaryBackground.withOpacity(0.5),
              color: AppTheme.successGreen,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),

          // 搜索和筛选
          _buildSearchAndFilter(),
          const SizedBox(height: 16),

          // 分类物品列表
          ..._filteredItems.entries.map(
            (entry) => _buildCategorySection(entry.key, entry.value),
          ),

          // 如果过滤后没有物品，显示空状态
          if (_filteredItems.isEmpty && _categorizedItems.isNotEmpty)
            _buildNoItemsFound(),
        ],
      ),
    );
  }

  /// 构建搜索和筛选部分
  Widget _buildSearchAndFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 搜索框
        TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search items...',
            hintStyle: const TextStyle(color: AppTheme.secondaryText),
            filled: true,
            fillColor: AppTheme.primaryBackground.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(12),
            prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryText),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppTheme.secondaryText,
                    ),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
          ),
          style: const TextStyle(color: AppTheme.primaryText),
          // 限制搜索长度
          maxLength: 50,
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
                  null,
          // 输入过滤器 - 允许字母、数字、空格和常用标点
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.\-_]')),
          ],
        ),
        const SizedBox(height: 12),

        // 筛选选项
        Row(
          children: [
            // 类别筛选
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<PackCategory?>(
                  value: _selectedCategory,
                  hint: const Text(
                    'All Categories',
                    style: TextStyle(color: AppTheme.secondaryText),
                  ),
                  style: const TextStyle(color: AppTheme.primaryText),
                  dropdownColor: AppTheme.surfaceBackground,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.secondaryText,
                  ),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _filterItems();
                    });
                  },
                  items: [
                    const DropdownMenuItem<PackCategory?>(
                      value: null,
                      child: Text(
                        'All Categories',
                        style: TextStyle(color: AppTheme.primaryText),
                      ),
                    ),
                    ...PackCategory.values.map((category) {
                      // 只显示有物品的类别
                      if (_categorizedItems.containsKey(category)) {
                        final item = _categorizedItems[category]!.first;
                        return DropdownMenuItem<PackCategory>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category),
                                size: 16,
                                color: AppTheme.brandBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.categoryName,
                                style: const TextStyle(
                                  color: AppTheme.primaryText,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return null;
                    }).whereType<DropdownMenuItem<PackCategory?>>(),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 显示未打包物品的开关
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOnlyUnpacked = !_showOnlyUnpacked;
                  _filterItems();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _showOnlyUnpacked
                      ? AppTheme.brandBlue.withOpacity(0.2)
                      : AppTheme.primaryBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: _showOnlyUnpacked
                      ? Border.all(color: AppTheme.brandBlue, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _showOnlyUnpacked
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 18,
                      color: _showOnlyUnpacked
                          ? AppTheme.brandBlue
                          : AppTheme.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Show only unpacked',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建没有找到物品的提示
  Widget _buildNoItemsFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppTheme.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No items found containing "$_searchQuery"'
                  : 'No items match your filters',
              style: TextStyle(
                color: AppTheme.secondaryText.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = null;
                  _showOnlyUnpacked = false;
                  _filterItems();
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建分类部分
  Widget _buildCategorySection(PackCategory category, List<PackItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    final packedCount = items.where((item) => item.isPacked).length;
    final progress = packedCount / items.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: progress == 1.0
              ? AppTheme.successGreen.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类标题
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.brandBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: AppTheme.brandBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items.first.categoryName,
                            style: const TextStyle(
                              color: AppTheme.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Packed: $packedCount / ${items.length} items',
                            style: const TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: progress == 1.0
                            ? AppTheme.successGreen.withOpacity(0.1)
                            : AppTheme.primaryBackground.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: progress == 1.0
                              ? AppTheme.successGreen
                              : AppTheme.secondaryText.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            color: progress == 1.0
                                ? AppTheme.successGreen
                                : AppTheme.secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 进度条
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.primaryBackground.withOpacity(
                      0.5,
                    ),
                    color: progress == 1.0
                        ? AppTheme.successGreen
                        : AppTheme.brandBlue,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          // 物品列表
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items.map((item) => _buildPackItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建打包物品
  Widget _buildPackItem(PackItem item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: item.isPacked
            ? AppTheme.primaryBackground.withOpacity(0.3)
            : AppTheme.primaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: item.isPacked
            ? Border.all(
                color: AppTheme.successGreen.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _updatePackItemStatus(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // 完成状态图标
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isPacked
                        ? AppTheme.successGreen
                        : Colors.transparent,
                    border: Border.all(
                      color: item.isPacked
                          ? AppTheme.successGreen
                          : AppTheme.secondaryText,
                      width: 2,
                    ),
                    boxShadow: item.isPacked
                        ? [
                            BoxShadow(
                              color: AppTheme.successGreen.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: item.isPacked
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 物品图标和名称
                Expanded(
                  child: Row(
                    children: [
                      // 物品图标
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.brandBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(item.category),
                            size: 16,
                            color: AppTheme.brandBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 物品名称和描述
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.quantity > 1
                                  ? '${item.name} x${item.quantity}'
                                  : item.name,
                              style: TextStyle(
                                color: item.isPacked
                                    ? AppTheme.secondaryText
                                    : AppTheme.primaryText,
                                decoration: item.isPacked
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: item.isPacked
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            if (item.description != null &&
                                item.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item.description!,
                                  style: TextStyle(
                                    color: AppTheme.secondaryText.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 12,
                                    decoration: item.isPacked
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 打包状态文本
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.isPacked
                        ? AppTheme.successGreen.withOpacity(0.1)
                        : AppTheme.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.isPacked ? 'Packed' : 'To Pack',
                    style: TextStyle(
                      color: item.isPacked
                          ? AppTheme.successGreen
                          : AppTheme.accentOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  /// 构建脉冲动画按钮
  Widget _buildPulseAnimatedButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    if (onPressed == null) {
      return child; // 如果按钮禁用，不显示动画
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        _animationController.repeat(reverse: true);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentOrange.withOpacity(
                  0.3 * _animationController.value,
                ),
                blurRadius: 12 * _animationController.value,
                spreadRadius: 2 * _animationController.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  /// 验证目的地输入
  bool _isValidDestination(String value) {
    // 目的地至少需要2个字符，且不能只包含空格或标点
    if (value.trim().length < 2) return false;

    // 确保至少包含一个字母（排除纯数字或符号）
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) return false;

    return true;
  }

  /// 验证时间输入
  bool _isValidDuration(String value) {
    // 基本格式验证：必须包含数字
    if (!RegExp(r'\d+').hasMatch(value)) return false;

    // 提取数字部分
    final numMatch = RegExp(r'\d+').firstMatch(value);
    if (numMatch == null) return false;

    final number = int.tryParse(numMatch.group(0) ?? '');
    if (number == null || number < 1 || number > 365) return false;

    // 检查是否包含有效的时间单位（可选，但不强制要求）
    // 如果只有数字，也是有效的
    return true;
  }

  /// 验证人数输入
  bool _isValidPeople(String value) {
    // 提取数字部分
    final numMatch = RegExp(r'\d+').firstMatch(value);
    if (numMatch == null) return false;

    final number = int.tryParse(numMatch.group(0) ?? '');
    if (number == null || number < 1 || number > 99) return false;

    return true;
  }

  /// 获取类别图标
  IconData _getCategoryIcon(PackCategory category) {
    switch (category) {
      case PackCategory.documents:
        return Icons.description;
      case PackCategory.clothing:
        return Icons.checkroom;
      case PackCategory.electronics:
        return Icons.devices;
      case PackCategory.toiletries:
        return Icons.bathroom;
      case PackCategory.accessories:
        return Icons.watch;
      case PackCategory.equipment:
        return Icons.sports;
      case PackCategory.medications:
        return Icons.medication;
      case PackCategory.footwear:
        return Icons.hiking;
      case PackCategory.seasonal:
        return Icons.wb_sunny;
      case PackCategory.food:
        return Icons.fastfood;
      case PackCategory.childcare:
        return Icons.child_care;
      case PackCategory.other:
        return Icons.category;
    }
  }
}
