import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_typography.dart';

class TodoTile extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.title,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 0,
      color: isDone ? AppColors.background : AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (_) => onToggle(),
          activeColor: AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTypography.todo.copyWith(
            color: isDone ? AppColors.secondaryText : AppColors.text,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(AppIcons.delete),
          color: AppColors.delete,
          onPressed: onDelete,
        ),
      ),
    );
  }
}