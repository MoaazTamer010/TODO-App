import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../repositories/task_repository.dart';
import '../../models/task_model.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;

  TaskBloc({required TaskRepository repository})
    : _repository = repository,
      super(TaskInitialState()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskEvent>(_onToggleTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<SearchTasksEvent>(_onSearchTasks);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  // Load tasks handler
  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      final tasks = _repository.getTasks();
      emit(TaskLoadedState(
        tasks: tasks,
        filteredTasks: tasks,
        showCompleted: false,
      ));
    } catch (e) {
      emit(TaskErrorState('Failed to load tasks: $e'));
    }
  }

  // Add task handler
  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoadedState) {
      _repository.addTask(event.task);
      final currentState = state as TaskLoadedState;
      final updatedTasks = _repository.getTasks();
      emit(currentState.copyWith(
        tasks: updatedTasks,
        filteredTasks: currentState.showCompleted
            ? _repository.getCompletedTasks()
            : updatedTasks,
      ));
    }
  }

  // Toggle task handler
  void _onToggleTask(ToggleTaskEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoadedState) {
      _repository.toggleTask(event.taskId);
      final currentState = state as TaskLoadedState;
      final updatedTasks = _repository.getTasks();
      emit(currentState.copyWith(
        tasks: updatedTasks,
        filteredTasks: currentState.showCompleted
            ? _repository.getCompletedTasks()
            : updatedTasks,
      ));
    }
  }

  // Delete task handler
  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoadedState) {
      _repository.deleteTask(event.taskId);
      final currentState = state as TaskLoadedState;
      final updatedTasks = _repository.getTasks();
      emit(currentState.copyWith(
        tasks: updatedTasks,
        filteredTasks: currentState.showCompleted
            ? _repository.getCompletedTasks()
            : updatedTasks,
      ));
    }
  }

  // Update task handler
  void _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoadedState) {
      _repository.updateTask(event.task);
      final currentState = state as TaskLoadedState;
      final updatedTasks = _repository.getTasks();
      emit(currentState.copyWith(
        tasks: updatedTasks,
        filteredTasks: currentState.showCompleted
            ? _repository.getCompletedTasks()
            : updatedTasks,
      ));
    }
  }

  // Search tasks handler
  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoadedState) {
      final currentState = state as TaskLoadedState;
      final results = _repository.searchTasks(event.query);
      emit(currentState.copyWith(
        filteredTasks: results,
      ));
    }
  }

  // Filter tasks handler
  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoadedState) {
      final currentState = state as TaskLoadedState;
      final filteredTasks = event.showCompleted
          ? _repository.getCompletedTasks()
          : _repository.getTasks();
      emit(currentState.copyWith(
        filteredTasks: filteredTasks,
        showCompleted: event.showCompleted,
      ));
    }
  }
}