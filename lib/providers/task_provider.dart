import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

/// State management provider for tasks using ChangeNotifier.
///
/// Manages the task list and notifies listeners whenever tasks
/// are added, deleted, or their completion status is toggled.
class TaskProvider extends ChangeNotifier {
  /// Internal list of tasks.
  final List<Task> _tasks = [];

  /// An unmodifiable view of the tasks to prevent direct mutation.
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  /// Total number of tasks currently managed.
  int get totalTasks => _tasks.length;

  /// Total number of completed tasks.
  int get completedTasks =>
      _tasks.where((task) => task.isCompleted).length;

  /// Total number of pending (incomplete) tasks.
  int get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).length;

  /// Adds a new task with the specified [title] and [description].
  ///
  /// Automatically generates a unique ID, inserts the task,
  /// and calls [notifyListeners] to trigger UI updates.
  void addTask(String title, String description) {
    final trimmedTitle = title.trim();
    final trimmedDescription = description.trim();

    if (trimmedTitle.isEmpty) {
      return;
    }

    final newTask = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
      description: trimmedDescription,
      isCompleted: false,
    );

    _tasks.add(newTask);
    notifyListeners();
  }

  /// Toggles the completion status of the task identified by [id].
  ///
  /// Calls [notifyListeners] to update reactive widgets.
  void toggleTaskCompletion(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final currentTask = _tasks[taskIndex];
      _tasks[taskIndex] = currentTask.copyWith(
        isCompleted: !currentTask.isCompleted,
      );
      notifyListeners();
    }
  }

  /// Deletes the task identified by [id] from the list.
  ///
  /// Calls [notifyListeners] to update reactive widgets and statistics.
  void deleteTask(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks.removeAt(taskIndex);
      notifyListeners();
    }
  }
}
