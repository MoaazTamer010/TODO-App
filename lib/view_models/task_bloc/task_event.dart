import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// ============ LOAD TASKS ============
class LoadTasksEvent extends TaskEvent {
  final bool refresh;
  
  const LoadTasksEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

// ============ ADD TASK ============
class AddTaskEvent extends TaskEvent {
  final Task task;
  
  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// ============ TOGGLE TASK ============
class ToggleTaskEvent extends TaskEvent {
  final int taskId;
  final bool isCompleted;

  const ToggleTaskEvent(this.taskId, this.isCompleted);

  @override
  List<Object?> get props => [taskId, isCompleted];
}

// ============ DELETE TASK ============
class DeleteTaskEvent extends TaskEvent {
  final int taskId;
  
  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// ============ UPDATE TASK ============
class UpdateTaskEvent extends TaskEvent {
  final Task task;
  
  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// ============ SEARCH TASKS ============
class SearchTasksEvent extends TaskEvent {
  final String query;
  
  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// ============ CLEAR SEARCH ============
class ClearSearchEvent extends TaskEvent {
  const ClearSearchEvent();
}

// ============ FILTER TASKS ============
class FilterTasksEvent extends TaskEvent {
  final bool showCompleted;
  
  const FilterTasksEvent(this.showCompleted);

  @override
  List<Object?> get props => [showCompleted];
}

// ============ CLEAR ERROR ============
class ClearErrorEvent extends TaskEvent {
  const ClearErrorEvent();
}