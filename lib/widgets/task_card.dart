import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

/// Reusable card widget for displaying a single [Task].
///
/// Demonstrates the usage of `context.read<TaskProvider>()` to invoke
/// actions without causing unnecessary rebuilds of the entire widget tree.
/// NO `setState()` is used in this widget.
class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  /// Displays a confirmation dialog before deleting the task.
  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Delete Task'),
          content: Text(
            'Are you sure you want to delete "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Action triggered using context.read<TaskProvider>()
                // without setState().
                context.read<TaskProvider>().deleteTask(task.id);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task "${task.title}" deleted'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = task.isCompleted;

    return Card(
      elevation: isDone ? 0.5 : 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: isDone
              ? Colors.green.shade200
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      color: isDone
          ? Colors.green.shade50.withValues(alpha: 0.4)
          : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox for toggling task completion state
            Transform.scale(
              scale: 1.15,
              child: Checkbox(
                value: isDone,
                activeColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onChanged: (_) {
                  // Toggle state through context.read<TaskProvider>()
                  // Provider updates state and calls notifyListeners()
                  context.read<TaskProvider>().toggleTaskCompletion(task.id);
                },
              ),
            ),
            const SizedBox(width: 8.0),
            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone
                                ? theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.55)
                                : theme.textTheme.titleMedium?.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: isDone
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          isDone ? 'Completed' : 'Pending',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: isDone
                                ? Colors.green.shade800
                                : Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDone
                            ? theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.45)
                            : theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.75),
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 4.0),
            // Delete Action Button
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade400,
              ),
              tooltip: 'Delete Task',
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }
}
