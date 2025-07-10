import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/task_model.dart';

/// 四象限任务视图组件
class QuadrantView extends StatefulWidget {
  /// 按优先级分组的任务
  final Map<TaskPriority, List<TaskModel>> tasksByPriority;

  /// 切换任务完成状态的回调
  final Function(TaskModel) onToggleCompletion;

  /// 删除任务的回调
  final Function(TaskModel) onDeleteTask;

  /// 编辑任务的回调
  final Function(TaskModel) onEditTask;

  const QuadrantView({
    Key? key,
    required this.tasksByPriority,
    required this.onToggleCompletion,
    required this.onDeleteTask,
    required this.onEditTask,
  }) : super(key: key);

  @override
  State<QuadrantView> createState() => _QuadrantViewState();
}

class _QuadrantViewState extends State<QuadrantView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _quadrantAnimations;

  // 定义每个象限的标题和图标
  final Map<TaskPriority, Map<String, dynamic>> _quadrantInfo = {
    TaskPriority.urgentImportant: {
      'title': 'Critical Tasks',
      'icon': Icons.priority_high,
      'color': AppColors.urgentImportant,
      'description': 'Do it now',
    },
    TaskPriority.importantNotUrgent: {
      'title': 'Important Tasks',
      'icon': Icons.star_outline,
      'color': AppColors.importantNotUrgent,
      'description': 'Schedule it',
    },
    TaskPriority.urgentNotImportant: {
      'title': 'Urgent Tasks',
      'icon': Icons.timer_outlined,
      'color': AppColors.urgentNotImportant,
      'description': 'Delegate it',
    },
    TaskPriority.notUrgentNotImportant: {
      'title': 'Optional Tasks',
      'icon': Icons.more_horiz,
      'color': AppColors.notUrgentNotImportant,
      'description': 'Eliminate it',
    },
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // 创建各个象限的动画，错开时间
    _quadrantAnimations = [
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
      ),
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    ];

    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isSmallScreen ? 4 : AppStyles.paddingSmall,
            bottom: isSmallScreen ? 4 : AppStyles.paddingMedium,
          ),
          child: Text(
            'Priority Matrix',
            style: (isSmallScreen
                    ? AppStyles.heading3.copyWith(fontSize: 15)
                    : AppStyles.heading3)
                .copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: isSmallScreen ? 4 : AppStyles.paddingMedium,
            mainAxisSpacing: isSmallScreen ? 4 : AppStyles.paddingMedium,
            childAspectRatio: isSmallScreen ? 0.85 : 0.95, // 调整宽高比
            children: [
              _buildQuadrant(
                context,
                TaskPriority.urgentImportant,
                _quadrantAnimations[0],
              ),
              _buildQuadrant(
                context,
                TaskPriority.importantNotUrgent,
                _quadrantAnimations[1],
              ),
              _buildQuadrant(
                context,
                TaskPriority.urgentNotImportant,
                _quadrantAnimations[2],
              ),
              _buildQuadrant(
                context,
                TaskPriority.notUrgentNotImportant,
                _quadrantAnimations[3],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuadrant(
    BuildContext context,
    TaskPriority priority,
    Animation<double> animation,
  ) {
    final tasks = widget.tasksByPriority[priority] ?? [];
    final info = _quadrantInfo[priority]!;
    final String title = info['title'];
    final IconData icon = info['icon'];
    final Color color = info['color'];
    final String description = info['description'];
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return ScaleTransition(
      scale: animation,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 4 : AppStyles.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusLarge),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: AppStyles.elevationMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with title and count
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                      isSmallScreen ? 2 : AppStyles.paddingSmall),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: isSmallScreen ? 10 : AppStyles.iconSizeSmall,
                    color: color,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 2 : AppStyles.paddingSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: (isSmallScreen
                                ? AppStyles.bodyText.copyWith(fontSize: 10)
                                : AppStyles.bodyText)
                            .copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isSmallScreen)
                        Text(
                          description,
                          style: (isSmallScreen
                                  ? AppStyles.caption.copyWith(fontSize: 8)
                                  : AppStyles.caption)
                              .copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 2 : AppStyles.paddingSmall,
                    vertical: isSmallScreen ? 1 : AppStyles.paddingTiny,
                  ),
                  decoration: AppStyles.tagDecoration(color),
                  child: Text(
                    '${tasks.length}',
                    style: (isSmallScreen
                            ? AppStyles.caption.copyWith(fontSize: 7)
                            : AppStyles.caption)
                        .copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 2 : AppStyles.paddingSmall),
            Divider(color: color.withOpacity(0.2), height: 1),
            SizedBox(height: isSmallScreen ? 1 : AppStyles.paddingSmall),
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState(context, icon, color, isSmallScreen)
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskItem(context, tasks[index], color);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, IconData icon, Color color, bool isSmallScreen) {
    // 更简洁的空状态显示
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 14 : 20,
            color: color.withOpacity(0.5),
          ),
          if (!isSmallScreen)
            SizedBox(height: isSmallScreen ? 2 : AppStyles.paddingSmall),
          if (!isSmallScreen)
            Text(
              'No tasks yet',
              style: AppStyles.caption.copyWith(
                color: Colors.white38,
                fontSize: isSmallScreen ? 8 : 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task, Color color) {
    final bool isOverdue =
        task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Padding(
      padding:
          EdgeInsets.only(bottom: isSmallScreen ? 3 : AppStyles.paddingSmall),
      child: Hero(
        tag: 'task_${task.id}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onEditTask(task),
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
            splashColor: color.withOpacity(0.1),
            highlightColor: color.withOpacity(0.05),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 5 : AppStyles.paddingMedium,
                vertical: isSmallScreen ? 3 : AppStyles.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundAlt,
                borderRadius:
                    BorderRadius.circular(AppStyles.borderRadiusMedium),
                border: Border.all(
                  color: task.isCompleted
                      ? Colors.white.withOpacity(0.1)
                      : isOverdue
                          ? AppColors.error.withOpacity(0.3)
                          : Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: AppStyles.elevationSmall,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => widget.onToggleCompletion(task),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: isSmallScreen ? 12 : 20,
                      height: isSmallScreen ? 12 : 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? color.withOpacity(0.8)
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted ? color : Colors.white38,
                          width: isSmallScreen ? 1 : 2,
                        ),
                      ),
                      child: task.isCompleted
                          ? Icon(
                              Icons.check,
                              size: isSmallScreen ? 8 : 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 3 : AppStyles.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          task.title,
                          style: (isSmallScreen
                                  ? AppStyles.bodyTextSmall
                                      .copyWith(fontSize: 10)
                                  : AppStyles.bodyTextSmall)
                              .copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task.isCompleted
                                ? Colors.white38
                                : isOverdue
                                    ? AppColors.error
                                    : Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.description != null && !isSmallScreen) ...[
                          SizedBox(
                              height:
                                  isSmallScreen ? 1 : AppStyles.paddingTiny),
                          Text(
                            task.description!,
                            style: (isSmallScreen
                                    ? AppStyles.caption.copyWith(fontSize: 8)
                                    : AppStyles.caption)
                                .copyWith(
                              color: Colors.white38,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(
                            height: isSmallScreen ? 0 : AppStyles.paddingTiny),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: isSmallScreen ? 8 : AppStyles.iconSizeSmall,
                              color:
                                  isOverdue ? AppColors.error : Colors.white38,
                            ),
                            SizedBox(
                                width:
                                    isSmallScreen ? 1 : AppStyles.paddingTiny),
                            Flexible(
                              child: Text(
                                DateTimeUtils.formatRelativeDateWithTime(
                                    task.dueDate),
                                style: (isSmallScreen
                                        ? AppStyles.caption
                                            .copyWith(fontSize: 8)
                                        : AppStyles.caption)
                                    .copyWith(
                                  color: isOverdue
                                      ? AppColors.error
                                      : Colors.white38,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppStyles.borderRadiusSmall),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => widget.onDeleteTask(task),
                      child: Padding(
                        padding: EdgeInsets.all(
                            isSmallScreen ? 2 : AppStyles.paddingTiny),
                        child: Icon(
                          Icons.close,
                          size: isSmallScreen ? 10 : AppStyles.iconSizeSmall,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
