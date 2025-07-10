import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/dynamic_island.dart';
import '../../data/models/task_model.dart';
import 'quadrant_view.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

/// 任务管理页面
class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  List<TaskModel> _tasks = [];
  List<TaskModel> _filteredTasks = [];
  DynamicIslandController? _dynamicIslandController;
  final _uuid = const Uuid();
  bool _isLoading = false;
  String _currentFilter = "all"; // all, pending, completed, overdue
  String _currentSort = "dueDate"; // dueDate, priority, completion
  late AnimationController _addTaskAnimationController;
  late Animation<double> _addTaskAnimation;

  // 输入限制
  static const int maxTitleLength = 50;
  static const int maxDescriptionLength = 200;

  @override
  void initState() {
    super.initState();
    _addTaskAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _addTaskAnimation = CurvedAnimation(
      parent: _addTaskAnimationController,
      curve: Curves.easeInOut,
    );
    _loadTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dynamicIslandController = DynamicIslandController(context);
  }

  @override
  void dispose() {
    _dynamicIslandController?.dispose();
    _addTaskAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList('tasks') ?? [];

      final loadedTasks = tasksJson
          .map((taskJson) => TaskModel.fromJson(json.decode(taskJson)))
          .toList();

      setState(() {
        _tasks = loadedTasks;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _tasks = [];
        _filteredTasks = [];
        _isLoading = false;
      });
      _dynamicIslandController?.show(
        message: '加载任务失败',
        icon: Icons.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson =
          _tasks.map((task) => json.encode(task.toJson())).toList();
      await prefs.setStringList('tasks', tasksJson);
    } catch (e) {
      _dynamicIslandController?.show(
        message: '保存任务失败',
        icon: Icons.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _applyFiltersAndSort() {
    List<TaskModel> filtered = List.from(_tasks);

    // 应用筛选
    switch (_currentFilter) {
      case "pending":
        filtered = filtered.where((task) => !task.isCompleted).toList();
        break;
      case "completed":
        filtered = filtered.where((task) => task.isCompleted).toList();
        break;
      case "overdue":
        final now = DateTime.now();
        filtered = filtered
            .where(
              (task) => !task.isCompleted && task.dueDate.isBefore(now),
            )
            .toList();
        break;
      case "all":
      default:
        // 不需要额外筛选
        break;
    }

    // 应用排序
    switch (_currentSort) {
      case "priority":
        filtered.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case "completion":
        filtered.sort((a, b) {
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          return a.dueDate.compareTo(b.dueDate);
        });
        break;
      case "dueDate":
      default:
        filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
    }

    setState(() {
      _filteredTasks = filtered;
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();
    TaskPriority selectedPriority = TaskPriority.importantNotUrgent;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Task',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 点击空白处收起键盘
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
            child: FadeTransition(
              opacity: animation,
              child: StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  backgroundColor: AppColors.deepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppStyles.borderRadiusMedium),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_task,
                            color: AppColors.accentPurple),
                      ),
                      const SizedBox(width: 12),
                      const Text('Add New Task'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration:
                              AppStyles.inputDecoration('Task Title').copyWith(
                            prefixIcon:
                                const Icon(Icons.title, color: Colors.white54),
                            counterText:
                                '${titleController.text.length}/$maxTitleLength',
                            counterStyle: AppStyles.caption.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          style: AppStyles.bodyText,
                          autofocus: true,
                          maxLength: maxTitleLength,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descriptionController,
                          decoration: AppStyles.inputDecoration(
                                  'Task Description (Optional)')
                              .copyWith(
                            prefixIcon: const Icon(Icons.description,
                                color: Colors.white54),
                            counterText:
                                '${descriptionController.text.length}/$maxDescriptionLength',
                            counterStyle: AppStyles.caption.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          style: AppStyles.bodyText,
                          maxLines: 3,
                          maxLength: maxDescriptionLength,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                        ),
                        const SizedBox(height: 16),
                        const Text('Due Date', style: AppStyles.bodyText),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            DateTimeUtils.formatDate(selectedDate),
                            style: AppStyles.bodyText,
                          ),
                          trailing: const Icon(Icons.calendar_today,
                              color: AppColors.accentPurple),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: AppColors.accentPurple,
                                      onPrimary: Colors.white,
                                      surface: AppColors.deepBlue,
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text('Due Time', style: AppStyles.bodyText),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                            style: AppStyles.bodyText,
                          ),
                          trailing: const Icon(Icons.access_time,
                              color: AppColors.accentPurple),
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: AppColors.accentPurple,
                                      onPrimary: Colors.white,
                                      surface: AppColors.deepBlue,
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Priority', style: AppStyles.bodyText),
                        const SizedBox(height: 8),
                        _buildPrioritySelector(selectedPriority, (priority) {
                          setState(() {
                            selectedPriority = priority;
                          });
                        }),
                      ],
                    ),
                  ),
                  actions: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadiusSmall),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: AppStyles.buttonText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.buttonGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.buttonShadowColor,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter task title')),
                            );
                            return;
                          }

                          final DateTime dueDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          final newTask = TaskModel(
                            id: _uuid.v4(),
                            title: titleController.text,
                            description: descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text,
                            dueDate: dueDateTime,
                            priority: selectedPriority,
                          );

                          setState(() {
                            _tasks.add(newTask);
                            _applyFiltersAndSort();
                          });

                          _saveTasks();

                          _dynamicIslandController?.show(
                            message: 'Task added',
                            icon: Icons.check_circle,
                            duration: const Duration(seconds: 2),
                          );

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppStyles.paddingMedium,
                            vertical: AppStyles.paddingSmall,
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: AppStyles.buttonText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrioritySelector(
    TaskPriority currentPriority,
    Function(TaskPriority) onSelect,
  ) {
    return Column(
      children: [
        _buildPriorityOption(
          TaskPriority.urgentImportant,
          'Urgent & Important',
          AppColors.urgentImportant,
          currentPriority,
          onSelect,
        ),
        _buildPriorityOption(
          TaskPriority.importantNotUrgent,
          'Important, Not Urgent',
          AppColors.importantNotUrgent,
          currentPriority,
          onSelect,
        ),
        _buildPriorityOption(
          TaskPriority.urgentNotImportant,
          'Urgent, Not Important',
          AppColors.urgentNotImportant,
          currentPriority,
          onSelect,
        ),
        _buildPriorityOption(
          TaskPriority.notUrgentNotImportant,
          'Not Urgent & Important',
          AppColors.notUrgentNotImportant,
          currentPriority,
          onSelect,
        ),
      ],
    );
  }

  Widget _buildPriorityOption(
    TaskPriority priority,
    String label,
    Color color,
    TaskPriority currentPriority,
    Function(TaskPriority) onSelect,
  ) {
    final isSelected = priority == currentPriority;

    return InkWell(
      onTap: () => onSelect(priority),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppStyles.bodyText.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _deleteTask(TaskModel task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final deletedTask = _tasks[index];
      final deletedIndex = index;

      setState(() {
        _tasks.removeAt(index);
        _applyFiltersAndSort();
      });

      _saveTasks();

      _dynamicIslandController?.show(
        message: 'Task deleted',
        icon: Icons.delete,
        duration: const Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _tasks.insert(deletedIndex, deletedTask);
                _applyFiltersAndSort();
                _saveTasks();
              });
            },
          ),
        ),
      );
    }
  }

  void _toggleTaskCompletion(TaskModel task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      setState(() {
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        _tasks[index] = updatedTask;
        _applyFiltersAndSort();
        _saveTasks();

        if (updatedTask.isCompleted) {
          _dynamicIslandController?.show(
            message: 'Task completed',
            icon: Icons.task_alt,
            duration: const Duration(seconds: 2),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 按优先级分组任务
    final Map<TaskPriority, List<TaskModel>> tasksByPriority = {
      TaskPriority.urgentImportant: [],
      TaskPriority.importantNotUrgent: [],
      TaskPriority.urgentNotImportant: [],
      TaskPriority.notUrgentNotImportant: [],
    };

    // 分组任务
    for (final task in _filteredTasks) {
      tasksByPriority[task.priority]!.add(task);
    }

    // 计算任务统计数据
    final int totalTasks = _tasks.length;
    final int completedTasks = _tasks.where((t) => t.isCompleted).length;
    final int pendingTasks = totalTasks - completedTasks;
    final int overdueTasks = _tasks
        .where((t) => !t.isCompleted && t.dueDate.isBefore(DateTime.now()))
        .length;

    // 计算任务完成率
    final double completionRate =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.backgroundGradient,
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                bottom: false, // 不使用底部安全区域，我们会手动处理
                child: Column(
                  children: [
                    // 顶部状态栏额外边距，适配刘海屏和灵动岛
                    SizedBox(
                        height: MediaQuery.of(context).padding.top > 20
                            ? AppStyles.safeAreaTop - 20
                            : 0),
                    Padding(
                      padding: const EdgeInsets.all(AppStyles.paddingMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width < 360
                                            ? 6
                                            : 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentPurple
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.grid_view_rounded,
                                      color: AppColors.accentPurple,
                                      size: MediaQuery.of(context).size.width <
                                              360
                                          ? 16
                                          : 20,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width <
                                              360
                                          ? 8
                                          : 12),
                                  Text(
                                    'Task Management',
                                    style:
                                        MediaQuery.of(context).size.width < 360
                                            ? AppStyles.heading3
                                                .copyWith(fontSize: 18)
                                            : AppStyles.heading3,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width < 360
                                            ? 30.0
                                            : 40.0),
                                child: Text(
                                  '$totalTasks tasks total, $completedTasks completed',
                                  style: AppStyles.bodyTextSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize:
                                        MediaQuery.of(context).size.width < 360
                                            ? 12
                                            : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.buttonSecondary
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: _showAddTaskDialog,
                                  icon: const Icon(Icons.add,
                                      color: AppColors.textPrimary),
                                  tooltip: 'Add Task',
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width < 360
                                            ? 8
                                            : 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width < 360
                                      ? 6
                                      : 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.buttonSecondary
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: _showHelpDialog,
                                  icon: const Icon(Icons.help_outline,
                                      color: AppColors.textPrimary),
                                  tooltip: 'Help Guide',
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width < 360
                                            ? 8
                                            : 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_tasks.isNotEmpty && !_isLoading)
                      _buildTaskSummary(completedTasks, pendingTasks,
                          overdueTasks, completionRate),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accentPurple,
                              ),
                            )
                          : _tasks.isEmpty
                              ? _buildEmptyTasksView()
                              : _filteredTasks.isEmpty
                                  ? _buildNoFilterResultsView()
                                  : SingleChildScrollView(
                                      padding: EdgeInsets.only(
                                        left: AppStyles.paddingMedium,
                                        right: AppStyles.paddingMedium,
                                        bottom: AppStyles.paddingLarge,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 使用 LayoutBuilder 来确保 QuadrantView 有足够的空间
                                          LayoutBuilder(
                                              builder: (context, constraints) {
                                            // 计算可用高度
                                            final availableHeight =
                                                MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    (MediaQuery.of(context)
                                                            .padding
                                                            .top +
                                                        MediaQuery.of(context)
                                                            .padding
                                                            .bottom) -
                                                    200; // 预留顶部和底部空间

                                            return SizedBox(
                                              height: availableHeight,
                                              child: QuadrantView(
                                                tasksByPriority:
                                                    tasksByPriority,
                                                onToggleCompletion:
                                                    _toggleTaskCompletion,
                                                onDeleteTask: _deleteTask,
                                                onEditTask:
                                                    _showTaskDetailsDialog,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
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

  Widget _buildTaskSummary(
      int completed, int pending, int overdue, double completionRate) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 8 : AppStyles.paddingMedium),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : AppStyles.paddingMedium,
        vertical: isSmallScreen ? 8 : AppStyles.paddingMedium,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purpleAccent.withOpacity(0.2),
            AppColors.accentPurple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.accentPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  completed.toString(),
                  'Completed',
                  Icons.check_circle_outline,
                  AppColors.notUrgentNotImportant,
                  isSmallScreen,
                ),
                SizedBox(width: isSmallScreen ? 6 : 12),
                _buildStatCard(
                  pending.toString(),
                  'Pending',
                  Icons.pending_actions,
                  AppColors.importantNotUrgent,
                  isSmallScreen,
                ),
                SizedBox(width: isSmallScreen ? 6 : 12),
                _buildStatCard(
                  overdue.toString(),
                  'Overdue',
                  Icons.warning_amber,
                  AppColors.urgentImportant,
                  isSmallScreen,
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completion Rate',
                    style: (isSmallScreen
                            ? AppStyles.bodyTextSmall.copyWith(fontSize: 11)
                            : AppStyles.bodyTextSmall)
                        .copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${completionRate.toStringAsFixed(1)}%',
                    style: (isSmallScreen
                            ? AppStyles.bodyText.copyWith(fontSize: 13)
                            : AppStyles.bodyText)
                        .copyWith(
                      color: AppColors.accentPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 5 : 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completionRate / 100,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.accentPurple),
                  minHeight: isSmallScreen ? 5 : 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color,
      bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 65 : 80,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 5 : AppStyles.paddingSmall,
        horizontal: isSmallScreen ? 5 : AppStyles.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: isSmallScreen ? 18 : 24),
          SizedBox(height: isSmallScreen ? 2 : 4),
          Text(
            value,
            style: (isSmallScreen
                    ? AppStyles.heading3.copyWith(fontSize: 13)
                    : AppStyles.heading3)
                .copyWith(
              color: color,
            ),
          ),
          SizedBox(height: isSmallScreen ? 1 : 2),
          Text(
            label,
            style: (isSmallScreen
                    ? AppStyles.caption.copyWith(fontSize: 9)
                    : AppStyles.caption)
                .copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasksView() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isSmallScreen ? 100 : 120,
            height: isSmallScreen ? 100 : 120,
            decoration: BoxDecoration(
              color: AppColors.accentPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: isSmallScreen ? 52 : 64,
              color: AppColors.accentPurple.withOpacity(0.7),
            ),
          ),
          SizedBox(height: isSmallScreen ? 18 : 24),
          Text(
            'Start Planning Your Tasks!',
            style: AppStyles.heading3.copyWith(
              color: Colors.white,
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
            child: Text(
              'Use the Four Quadrants method to manage your task priorities',
              textAlign: TextAlign.center,
              style: AppStyles.bodyText.copyWith(
                color: Colors.white70,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 18 : 24),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.buttonGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.buttonShadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _showAddTaskDialog,
              icon: Icon(Icons.add,
                  color: Colors.white, size: isSmallScreen ? 20 : 24),
              label: Text(
                'Create First Task',
                style: AppStyles.buttonText.copyWith(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen
                      ? AppStyles.paddingMedium
                      : AppStyles.paddingLarge,
                  vertical: isSmallScreen
                      ? AppStyles.paddingSmall
                      : AppStyles.paddingMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFilterResultsView() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list,
            size: isSmallScreen ? 52 : 64,
            color: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'No tasks match the filter criteria',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentFilter = "all";
                _applyFiltersAndSort();
              });
            },
            icon: Icon(Icons.refresh, size: isSmallScreen ? 16 : 20),
            label: Text(
              'Show All Tasks',
              style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPurple,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 8 : 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 用于编辑任务页面的Hero动画
  Widget _buildHeroTask(BuildContext context, TaskModel task) {
    final bool isOverdue =
        task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
    final Color priorityColor = _getPriorityColor(task.priority);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppStyles.paddingMedium),
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            priorityColor.withOpacity(0.15),
            AppColors.deepBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        border: Border.all(color: priorityColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(_getPriorityIcon(task.priority), color: priorityColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppStyles.heading3.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.white60 : Colors.white,
                      ),
                    ),
                    Text(
                      _getPriorityName(task.priority),
                      style: TextStyle(
                        color: priorityColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              task.description!,
              style: AppStyles.bodyText.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? Colors.red.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOverdue
                        ? Colors.red.withOpacity(0.5)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: isOverdue ? Colors.red : Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateTimeUtils.formatRelativeDateWithTime(task.dueDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? Colors.red : Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? AppColors.notUrgentNotImportant.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 16,
                      color: task.isCompleted
                          ? AppColors.notUrgentNotImportant
                          : Colors.white54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.isCompleted ? 'Completed' : 'Incomplete',
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isCompleted
                          ? AppColors.notUrgentNotImportant
                          : Colors.white54,
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

  // 获取优先级对应的颜色
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgentImportant:
        return AppColors.urgentImportant;
      case TaskPriority.importantNotUrgent:
        return AppColors.importantNotUrgent;
      case TaskPriority.urgentNotImportant:
        return AppColors.urgentNotImportant;
      case TaskPriority.notUrgentNotImportant:
        return AppColors.notUrgentNotImportant;
    }
  }

  // 获取优先级对应的图标
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgentImportant:
        return Icons.priority_high;
      case TaskPriority.importantNotUrgent:
        return Icons.star;
      case TaskPriority.urgentNotImportant:
        return Icons.access_time;
      case TaskPriority.notUrgentNotImportant:
        return Icons.low_priority;
    }
  }

  // 获取优先级名称
  String _getPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgentImportant:
        return 'Urgent & Important';
      case TaskPriority.importantNotUrgent:
        return 'Important, Not Urgent';
      case TaskPriority.urgentNotImportant:
        return 'Urgent, Not Important';
      case TaskPriority.notUrgentNotImportant:
        return 'Not Urgent & Important';
    }
  }

  Widget _buildFilterBadge() {
    if (_currentFilter == "all") {
      return const SizedBox.shrink();
    }

    String label;
    Color color;

    switch (_currentFilter) {
      case "pending":
        label = "Pending";
        color = AppColors.importantNotUrgent;
        break;
      case "completed":
        label = "Completed";
        color = AppColors.notUrgentNotImportant;
        break;
      case "overdue":
        label = "Overdue";
        color = AppColors.urgentImportant;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentFilter = "all";
                _applyFiltersAndSort();
              });
            },
            child: Icon(
              Icons.close,
              size: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sort By',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: AppColors.deepBlue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppStyles.borderRadiusMedium),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.sort, color: AppColors.accentPurple),
                  ),
                  const SizedBox(width: 12),
                  const Text('Sort By'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSortOption(
                    'By Due Date',
                    Icons.access_time,
                    'dueDate',
                  ),
                  _buildSortOption(
                    'By Priority',
                    Icons.priority_high,
                    'priority',
                  ),
                  _buildSortOption(
                    'By Completion',
                    Icons.check_circle,
                    'completion',
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, IconData icon, String sortKey) {
    final isSelected = _currentSort == sortKey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentSort = sortKey;
              _applyFiltersAndSort();
            });
            Navigator.of(context).pop();
          },
          splashColor: AppColors.accentPurple.withOpacity(0.1),
          highlightColor: AppColors.accentPurple.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accentPurple.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
              border: Border.all(
                color: isSelected ? AppColors.accentPurple : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon,
                    color: isSelected ? AppColors.accentPurple : Colors.white70,
                    size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? AppColors.accentPurple : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check,
                      color: AppColors.accentPurple, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter Tasks',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: AppColors.deepBlue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppStyles.borderRadiusMedium),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.filter_list,
                        color: AppColors.accentPurple),
                  ),
                  const SizedBox(width: 12),
                  const Text('Filter Tasks'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterOption(
                    'Show All',
                    Icons.all_inclusive,
                    'all',
                  ),
                  _buildFilterOption(
                    'Pending',
                    Icons.pending,
                    'pending',
                  ),
                  _buildFilterOption(
                    'Completed',
                    Icons.check_circle,
                    'completed',
                  ),
                  _buildFilterOption(
                    'Overdue',
                    Icons.warning,
                    'overdue',
                    color: Colors.red,
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon, String filterKey,
      {Color? color}) {
    final isSelected = _currentFilter == filterKey;
    final iconColor =
        color ?? (isSelected ? AppColors.accentPurple : Colors.white70);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentFilter = filterKey;
              _applyFiltersAndSort();
            });
            Navigator.of(context).pop();
          },
          splashColor: AppColors.accentPurple.withOpacity(0.1),
          highlightColor: AppColors.accentPurple.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? (color?.withOpacity(0.15) ??
                      AppColors.accentPurple.withOpacity(0.15))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
              border: Border.all(
                color: isSelected ? iconColor : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? iconColor : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected) Icon(Icons.check, color: iconColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateTask(TaskModel oldTask, TaskModel updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == oldTask.id);
    if (index != -1) {
      setState(() {
        _tasks[index] = updatedTask;
        _applyFiltersAndSort();
      });
      _saveTasks();

      _dynamicIslandController?.show(
        message: 'Task updated',
        icon: Icons.check_circle,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showTaskDetailsDialog(TaskModel task) {
    final Color priorityColor = _getPriorityColor(task.priority);
    final bool isOverdue =
        task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Task Details',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: animation,
          child: Hero(
            tag: 'task_${task.id}',
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    insetPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 18 : 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -0.1),
                            end: Offset.zero,
                          ).animate(curvedAnimation),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 2 : 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  priorityColor.withOpacity(0.15),
                                  AppColors.deepBlue,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppStyles.borderRadiusMedium),
                              border: Border.all(
                                  color: priorityColor.withOpacity(0.3),
                                  width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 任务标题栏
                                Container(
                                  padding: EdgeInsets.all(isSmallScreen
                                      ? 12
                                      : AppStyles.paddingMedium),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: priorityColor.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            isSmallScreen ? 6 : 8),
                                        decoration: BoxDecoration(
                                          color: priorityColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getPriorityIcon(task.priority),
                                          color: priorityColor,
                                          size: isSmallScreen ? 18 : 24,
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 8 : 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              task.title,
                                              style: (isSmallScreen
                                                      ? AppStyles.heading3
                                                          .copyWith(
                                                              fontSize: 16)
                                                      : AppStyles.heading3)
                                                  .copyWith(
                                                decoration: task.isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                color: task.isCompleted
                                                    ? Colors.white60
                                                    : Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                                height: isSmallScreen ? 2 : 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isSmallScreen ? 6 : 8,
                                                    vertical:
                                                        isSmallScreen ? 1 : 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: priorityColor
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    _getPriorityName(
                                                        task.priority),
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen
                                                          ? 10
                                                          : 12,
                                                      color: priorityColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        isSmallScreen ? 6 : 8),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isSmallScreen ? 6 : 8,
                                                    vertical:
                                                        isSmallScreen ? 1 : 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: task.isCompleted
                                                        ? AppColors
                                                            .notUrgentNotImportant
                                                            .withOpacity(0.2)
                                                        : isOverdue
                                                            ? Colors.red
                                                                .withOpacity(
                                                                    0.2)
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    task.isCompleted
                                                        ? 'Completed'
                                                        : isOverdue
                                                            ? 'Overdue'
                                                            : 'In Progress',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen
                                                          ? 10
                                                          : 12,
                                                      color: task.isCompleted
                                                          ? AppColors
                                                              .notUrgentNotImportant
                                                          : isOverdue
                                                              ? Colors.red
                                                              : Colors.white70,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 任务详情内容
                                Padding(
                                  padding: EdgeInsets.all(isSmallScreen
                                      ? 12
                                      : AppStyles.paddingMedium),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (task.description != null &&
                                          task.description!.isNotEmpty) ...[
                                        Text(
                                          'Task Description',
                                          style: (isSmallScreen
                                                  ? AppStyles.bodyTextSmall
                                                      .copyWith(fontSize: 12)
                                                  : AppStyles.bodyTextSmall)
                                              .copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: isSmallScreen ? 6 : 8),
                                        Container(
                                          padding: EdgeInsets.all(
                                              isSmallScreen ? 10 : 12),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(
                                                AppStyles.borderRadiusSmall),
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                            ),
                                          ),
                                          child: Text(
                                            task.description!,
                                            style: (isSmallScreen
                                                    ? AppStyles.bodyText
                                                        .copyWith(fontSize: 13)
                                                    : AppStyles.bodyText)
                                                .copyWith(
                                              color: Colors.white70,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: isSmallScreen ? 12 : 16),
                                      ],
                                      Text(
                                        'Due Date',
                                        style: (isSmallScreen
                                                ? AppStyles.bodyTextSmall
                                                    .copyWith(fontSize: 12)
                                                : AppStyles.bodyTextSmall)
                                            .copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 6 : 8),
                                      Container(
                                        padding: EdgeInsets.all(
                                            isSmallScreen ? 10 : 12),
                                        decoration: BoxDecoration(
                                          color: isOverdue
                                              ? Colors.red.withOpacity(0.1)
                                              : Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(
                                              AppStyles.borderRadiusSmall),
                                          border: Border.all(
                                            color: isOverdue
                                                ? Colors.red.withOpacity(0.3)
                                                : Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: isSmallScreen ? 14 : 16,
                                              color: isOverdue
                                                  ? Colors.red
                                                  : Colors.white70,
                                            ),
                                            SizedBox(
                                                width: isSmallScreen ? 6 : 8),
                                            Text(
                                              DateTimeUtils.formatDateTime(
                                                  task.dueDate),
                                              style: (isSmallScreen
                                                      ? AppStyles.bodyText
                                                          .copyWith(
                                                              fontSize: 13)
                                                      : AppStyles.bodyText)
                                                  .copyWith(
                                                color: isOverdue
                                                    ? Colors.red
                                                    : Colors.white70,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              DateTimeUtils
                                                  .formatRelativeDateWithTime(
                                                      task.dueDate),
                                              style: (isSmallScreen
                                                      ? AppStyles.bodyTextSmall
                                                          .copyWith(
                                                              fontSize: 11)
                                                      : AppStyles.bodyTextSmall)
                                                  .copyWith(
                                                color: isOverdue
                                                    ? Colors.red
                                                        .withOpacity(0.7)
                                                    : Colors.white54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 底部操作栏
                                Container(
                                  padding: const EdgeInsets.all(
                                      AppStyles.paddingMedium),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _toggleTaskCompletion(task);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: task.isCompleted
                                              ? Colors.white70
                                              : AppColors.notUrgentNotImportant,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              task.isCompleted
                                                  ? Icons.refresh
                                                  : Icons.check_circle_outline,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              task.isCompleted
                                                  ? 'Restart'
                                                  : 'Mark Complete',
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _deleteTask(task);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Delete Task'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppStyles.borderRadiusLarge),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.more_horiz,
                          color: AppColors.accentPurple),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'More Options',
                      style: AppStyles.heading3,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white12),
              _buildOptionTile(
                icon: Icons.file_download,
                title: 'Export Task Data',
                subtitle: 'Copy current task data to clipboard',
                color: AppColors.accentPurple,
                onTap: () {
                  Navigator.pop(context);
                  _exportTasks();
                },
              ),
              _buildOptionTile(
                icon: Icons.file_upload,
                title: 'Import Task Data',
                subtitle: 'Import task data from clipboard',
                color: AppColors.accentPurple,
                onTap: () {
                  Navigator.pop(context);
                  _importTasks();
                },
              ),
              _buildOptionTile(
                icon: Icons.delete_sweep,
                title: 'Clear All Tasks',
                subtitle: 'Delete all task data (This action cannot be undone)',
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                  _showClearConfirmationDialog();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.paddingMedium,
            vertical: AppStyles.paddingMedium,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
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
                      style: AppStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppStyles.caption.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportTasks() async {
    if (_tasks.isEmpty) {
      _dynamicIslandController?.show(
        message: 'No tasks to export',
        icon: Icons.info,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      final tasksJson =
          _tasks.map((task) => json.encode(task.toJson())).toList();
      final exportData = json.encode(tasksJson);

      await Clipboard.setData(ClipboardData(text: exportData));

      _dynamicIslandController?.show(
        message: 'Task data copied to clipboard',
        icon: Icons.check_circle,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _dynamicIslandController?.show(
        message: 'Export failed',
        icon: Icons.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _importTasks() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData == null ||
          clipboardData.text == null ||
          clipboardData.text!.isEmpty) {
        _dynamicIslandController?.show(
          message: 'Clipboard is empty',
          icon: Icons.info,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      final importData = clipboardData.text!;
      final List<dynamic> tasksJsonList = json.decode(importData);
      final List<TaskModel> importedTasks = tasksJsonList
          .map((taskJson) => TaskModel.fromJson(json.decode(taskJson)))
          .toList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.deepBlue,
          title: Row(
            children: [
              const Icon(Icons.file_upload, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              const Text('Import Task Data'),
            ],
          ),
          content: Text(
            'Are you sure you want to import ${importedTasks.length} tasks? This will overwrite your current task data.',
            style: AppStyles.bodyText,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks = importedTasks;
                  _applyFiltersAndSort();
                });
                _saveTasks();
                Navigator.pop(context);
                _dynamicIslandController?.show(
                  message:
                      'Successfully imported ${importedTasks.length} tasks',
                  icon: Icons.check_circle,
                  duration: const Duration(seconds: 2),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPurple,
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    } catch (e) {
      _dynamicIslandController?.show(
        message: 'Import failed, incorrect data format',
        icon: Icons.error,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showClearConfirmationDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Clear',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: AppColors.deepBlue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppStyles.borderRadiusMedium),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning, color: Colors.redAccent),
                  ),
                  const SizedBox(width: 12),
                  const Text('Clear All Tasks'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure you want to delete all tasks?',
                    style: AppStyles.bodyText,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(AppStyles.paddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusSmall),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This action cannot be undone. All task data will be permanently deleted.',
                            style: AppStyles.caption.copyWith(
                              color: Colors.redAccent.shade100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tasks = [];
                      _filteredTasks = [];
                    });
                    _saveTasks();
                    Navigator.pop(context);
                    _dynamicIslandController?.show(
                      message: 'All tasks cleared',
                      icon: Icons.delete_forever,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusSmall),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Confirm Clear'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.help_outline, color: AppColors.accentPurple),
            ),
            const SizedBox(width: 12),
            const Text('Help Guide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Four Quadrants Task Management',
                'Tasks are divided into four quadrants based on "Importance" and "Urgency":\n'
                    '• Urgent & Important: Require immediate attention\n'
                    '• Important, Not Urgent: Need planning\n'
                    '• Urgent, Not Important: Can be delegated\n'
                    '• Not Urgent & Important: Can be reconsidered',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Basic Operations',
                '• Click the "+" button to add a new task\n'
                    '• Click a task to view details\n'
                    '• Click the circle to mark completion status\n'
                    '• Click "×" to delete a task',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Task Filtering',
                'Click status labels to filter:\n'
                    '• All Tasks\n'
                    '• Pending Tasks\n'
                    '• Completed Tasks\n'
                    '• Overdue Tasks',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.bodyText.copyWith(
            color: AppColors.accentPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppStyles.bodyTextSmall.copyWith(
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
