import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_icons.dart';
import '../../app_typography.dart';
import '../../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 0,
      color: task.isDone ? AppColors.background : AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => onToggle(),
          activeColor: AppColors.primary,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: AppTypography.todo.copyWith(
                color: task.isDone ? AppColors.secondaryText : AppColors.text,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            if (task.description != null) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: AppTypography.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (task.category != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.category!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (task.priority != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.priority!,
                        style: AppTypography.caption.copyWith(
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(AppIcons.delete),
          color: AppColors.delete,
          onPressed: onDelete,
        ),
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    if (priority == null) return AppColors.secondaryText;
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return AppColors.secondaryText;
    }
  }
}