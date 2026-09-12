import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

// ============ INITIAL ============
class TaskInitialState extends TaskState {}

// ============ LOADING ============
class TaskLoadingState extends TaskState {
  final String? message;
  
  const TaskLoadingState({this.message});

  @override
  List<Object?> get props => [message];
}

// ============ LOADED ============
class TaskLoadedState extends TaskState {
  final List<Task> tasks;           // All tasks from server
  final List<Task> filteredTasks;   // After search/filter
  final bool showCompleted;
  final String searchQuery;
  final bool isRefreshing;

  const TaskLoadedState({
    required this.tasks,
    required this.filteredTasks,
    this.showCompleted = false,
    this.searchQuery = '',
    this.isRefreshing = false,
  });

  // Get pending tasks
  List<Task> get pendingTasks =>
      tasks.where((task) => !task.completed).toList();

  // Get completed tasks
  List<Task> get completedTasks =>
      tasks.where((task) => task.completed).toList();

  @override
  List<Object?> get props => [
        tasks,
        filteredTasks,
        showCompleted,
        searchQuery,
        isRefreshing,
      ];

  TaskLoadedState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    bool? showCompleted,
    String? searchQuery,
    bool? isRefreshing,
  }) {
    return TaskLoadedState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      showCompleted: showCompleted ?? this.showCompleted,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

// ============ ERROR ============
class TaskErrorState extends TaskState {
  final String message;
  
  const TaskErrorState(this.message);

  @override
  List<Object?> get props => [message];
}