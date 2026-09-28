import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

/// Displays statistical overview of tasks (Total, Completed, Pending).
///
/// Demonstrates the usage of [Consumer] to reactively listen to
/// changes in [TaskProvider] and automatically rebuild the statistics.
class TaskStatistics extends StatelessWidget {
  const TaskStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer listens to TaskProvider and rebuilds only this subtree
    // when notifyListeners() is called in TaskProvider.
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total',
                  count: taskProvider.totalTasks,
                  icon: Icons.list_alt_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _StatCard(
                  title: 'Completed',
                  count: taskProvider.completedTasks,
                  icon: Icons.check_circle_rounded,
                  color: Colors.green.shade700,
                  backgroundColor: Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _StatCard(
                  title: 'Pending',
                  count: taskProvider.pendingTasks,
                  icon: Icons.pending_actions_rounded,
                  color: Colors.orange.shade800,
                  backgroundColor: Colors.orange.shade50,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26.0),
          const SizedBox(height: 6.0),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
