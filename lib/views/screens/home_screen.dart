import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../view_models/task_bloc/task_bloc.dart';
import '../../view_models/task_bloc/task_event.dart';
import '../../view_models/task_bloc/task_state.dart';
import '../../views/widgets/task_caard.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load tasks when screen initializes
    context.read<TaskBloc>().add(LoadTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Tasks',
          style: AppTypography.heading1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.text,
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: AppColors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppTypography.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTasksEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoadedState) {
            final tasks = state.filteredTasks;
            return Column(
              children: [
                // Search/Add Task Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search tasks...',
                            hintStyle: AppTypography.hint,
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<TaskBloc>().add(
                                        const SearchTasksEvent(''),
                                      );
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            context.read<TaskBloc>().add(
                              SearchTasksEvent(value),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Tasks Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Tasks',
                        style: AppTypography.heading2,
                      ),
                      Row(
                        children: [
                          Text(
                            '${tasks.length} tasks',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(width: 12),
                          // Filter toggle
                          Row(
                            children: [
                              const Text('Show All', style: TextStyle(fontSize: 12)),
                              Switch(
                                value: state.showCompleted,
                                onChanged: (value) {
                                  context.read<TaskBloc>().add(
                                    FilterTasksEvent(value),
                                  );
                                },
                                activeThumbColor: AppColors.primary,
                              ),
                              const Text('Done', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Task List
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 80,
                                color: AppColors.secondaryText,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.showCompleted
                                    ? 'No completed tasks'
                                    : 'No tasks found',
                                style: AppTypography.heading2.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.showCompleted
                                    ? 'Complete some tasks to see them here'
                                    : 'Add your first task now!',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskCard(
                              task: task,
                              onToggle: () {
                                context.read<TaskBloc>().add(
                                  ToggleTaskEvent(task.id),
                                );
                              },
                              onDelete: () {
                                context.read<TaskBloc>().add(
                                  DeleteTaskEvent(task.id),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/add_task');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}