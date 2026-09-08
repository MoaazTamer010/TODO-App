import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../view_models/task_bloc/task_bloc.dart';
import '../../view_models/task_bloc/task_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final totalTasks = state is TaskLoadedState ? state.tasks.length : 0;
          final completedTasks = state is TaskLoadedState 
              ? state.completedTasks.length 
              : 0;
          final pendingTasks = state is TaskLoadedState 
              ? state.pendingTasks.length 
              : 0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'User Name',
                  style: AppTypography.heading1,
                ),
                const SizedBox(height: 8),
                Text(
                  'user@email.com',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProfileItem(
                        Icons.task,
                        'Total Tasks',
                        '$totalTasks',
                      ),
                      const Divider(),
                      _buildProfileItem(
                        Icons.check_circle,
                        'Completed',
                        '$completedTasks',
                        color: AppColors.green,
                      ),
                      const Divider(),
                      _buildProfileItem(
                        Icons.pending,
                        'Pending',
                        '$pendingTasks',
                        color: AppColors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String label,
    String value, {
    Color color = AppColors.primary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(label, style: AppTypography.body),
            ],
          ),
          Text(
            value,
            style: AppTypography.heading2.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}