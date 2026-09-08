import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

// Initial state
class TaskInitialState extends TaskState {}

// Loading state
class TaskLoadingState extends TaskState {}

// Loaded state
class TaskLoadedState extends TaskState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final bool showCompleted;

  const TaskLoadedState({
    required this.tasks,
    required this.filteredTasks,
    this.showCompleted = false,
  });

  // Get pending tasks
  List<Task> get pendingTasks => tasks.where((task) => !task.isDone).toList();

  // Get completed tasks
  List<Task> get completedTasks => tasks.where((task) => task.isDone).toList();

  @override
  List<Object?> get props => [tasks, filteredTasks, showCompleted];

  // Copy with method
  TaskLoadedState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    bool? showCompleted,
  }) {
    return TaskLoadedState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}

// Error state
class TaskErrorState extends TaskState {
  final String message;
  const TaskErrorState(this.message);

  @override
  List<Object?> get props => [message];
}