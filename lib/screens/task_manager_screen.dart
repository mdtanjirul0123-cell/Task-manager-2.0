import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_card.dart';
import '../widgets/task_statistics.dart';

/// The main screen of the Task Manager app.
///
/// Demonstrates the usage of `context.watch<TaskProvider>()` to reactively
/// observe changes in the task list and switch between the empty state
/// and the ListView without any `setState()` calls.
class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

  /// Opens the dialog to add a new task.
  void _openAddTaskDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => const AddTaskDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<TaskProvider>() subscribes this widget to changes in TaskProvider.
    // Whenever notifyListeners() is called in TaskProvider, build() will re-run.
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 26.0),
            SizedBox(width: 10.0),
            Text(
              'Task Manager',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Statistics overview section using Consumer<TaskProvider>
            const TaskStatistics(),

            const SizedBox(height: 8.0),

            // Task list section or empty state
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        bottom: 80.0, // Space for FloatingActionButton
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          key: ValueKey(task.id),
                          task: task,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
        elevation: 3.0,
      ),
    );
  }

  /// Empty state UI shown when there are no tasks in the list.
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  size: 52.0,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'No tasks yet',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Add your first task using the + button below.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24.0),
              FilledButton.tonalIcon(
                onPressed: () => _openAddTaskDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create a Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
