import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// Load tasks event
class LoadTasksEvent extends TaskEvent {}

// Add task event
class AddTaskEvent extends TaskEvent {
  final Task task;
  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// Toggle task event
class ToggleTaskEvent extends TaskEvent {
  final String taskId;
  const ToggleTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Delete task event
class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Update task event
class UpdateTaskEvent extends TaskEvent {
  final Task task;
  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// Search tasks event
class SearchTasksEvent extends TaskEvent {
  final String query;
  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// Filter tasks event
class FilterTasksEvent extends TaskEvent {
  final bool showCompleted;
  const FilterTasksEvent(this.showCompleted);

  @override
  List<Object?> get props => [showCompleted];
}