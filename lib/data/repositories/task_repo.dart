import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../datasources/local_db.dart';

/// 任务数据仓库
class TaskRepository {
  final _uuid = const Uuid();
  List<TaskModel> _tasks = [];
  bool _isLoaded = false;

  /// 加载所有任务
  Future<List<TaskModel>> loadTasks() async {
    if (_isLoaded) {
      return _tasks;
    }

    final tasksJson = await LocalDatabase.getTasks();
    _tasks = tasksJson.map((json) => TaskModel.fromJson(json)).toList();
    _isLoaded = true;
    return _tasks;
  }

  /// 获取所有任务
  Future<List<TaskModel>> getAllTasks() async {
    return await loadTasks();
  }

  /// 根据优先级获取任务
  Future<List<TaskModel>> getTasksByPriority(TaskPriority priority) async {
    final tasks = await loadTasks();
    return tasks.where((task) => task.priority == priority).toList();
  }

  /// 获取未完成任务
  Future<List<TaskModel>> getIncompleteTasks() async {
    final tasks = await loadTasks();
    return tasks.where((task) => !task.isCompleted).toList();
  }

  /// 添加任务
  Future<TaskModel> addTask(
    String title,
    String? description,
    DateTime dueDate,
    TaskPriority priority,
  ) async {
    final tasks = await loadTasks();

    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
    );

    _tasks = [...tasks, newTask];
    await _saveTasks();

    return newTask;
  }

  /// 更新任务
  Future<TaskModel> updateTask(TaskModel task) async {
    final tasks = await loadTasks();

    _tasks = tasks.map((t) => t.id == task.id ? task : t).toList();
    await _saveTasks();

    return task;
  }

  /// 删除任务
  Future<void> deleteTask(String id) async {
    final tasks = await loadTasks();

    _tasks = tasks.where((task) => task.id != id).toList();
    await _saveTasks();
  }

  /// 标记任务为完成/未完成
  Future<TaskModel> toggleTaskCompletion(String id) async {
    final tasks = await loadTasks();

    final taskIndex = tasks.indexWhere((task) => task.id == id);
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }

    final task = tasks[taskIndex];
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    _tasks[taskIndex] = updatedTask;
    await _saveTasks();

    return updatedTask;
  }

  /// 保存任务到本地存储
  Future<void> _saveTasks() async {
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await LocalDatabase.saveTasks(tasksJson);
  }

  /// 清除所有任务
  Future<void> clearAllTasks() async {
    _tasks = [];
    _isLoaded = false;
    await _saveTasks();
  }
}
