import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../view_models/task_bloc/task_bloc.dart';
import '../../view_models/task_bloc/task_event.dart';
import '../../view_models/task_bloc/task_state.dart';
import '../views/widgets/task_caard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Tasks', style: AppTypography.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for tasks...',
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (value) {
                context.read<TaskBloc>().add(
                  SearchTasksEvent(value),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoadedState) {
                    final results = state.filteredTasks;
                    
                    if (results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 80,
                              color: AppColors.secondaryText,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Search for your tasks'
                                  : 'No results found',
                              style: AppTypography.heading2.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Type something to start searching'
                                  : 'Try searching for something else',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final task = results[index];
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
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}