import 'package:flutter/material.dart';
import '../../app_colors.dart';
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
    final isDone = task.isCompleted ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: isDone ? AppColors.background : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (value) {
            onToggle(); // <--- THIS IS THE CRITICAL LINE
          },
          activeColor: AppColors.primary,
        ),
        title: Text(
          task.title,
          style: AppTypography.todo.copyWith(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? AppColors.secondaryText : AppColors.text,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: AppColors.red,
          onPressed: onDelete,
        ),
      ),
    );
  }
}