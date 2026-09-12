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
    on<ClearSearchEvent>(_onClearSearch);
    on<FilterTasksEvent>(_onFilterTasks);
    on<ClearErrorEvent>(_onClearError);
  }

  // ============ LOAD TASKS ============
  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    // If refreshing, keep current state and show refresh indicator
    if (event.refresh && state is TaskLoadedState) {
      final currentState = state as TaskLoadedState;
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const TaskLoadingState(message: 'Loading tasks...'));
    }

    try {
      final response = await _repository.getTasks();
      final tasks = response.data;

      // Preserve existing filter/search state
      if (state is TaskLoadedState) {
        final currentState = state as TaskLoadedState;
        final filtered = _applyFilters(tasks, currentState);
        
        emit(TaskLoadedState(
          tasks: tasks,
          filteredTasks: filtered,
          showCompleted: currentState.showCompleted,
          searchQuery: currentState.searchQuery,
          isRefreshing: false,
        ));
      } else {
        emit(TaskLoadedState(
          tasks: tasks,
          filteredTasks: tasks,
        ));
      }
    } catch (e) {
      emit(TaskErrorState(_getErrorMessage(e)));
    }
  }

  // ============ ADD TASK ============
  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TaskLoadedState) return;

    final currentState = state as TaskLoadedState;

    try {
      // Show loading state
      emit(currentState.copyWith(isRefreshing: true));

      // Call API
      final createdTask = await _repository.createTask(event.task);

      // Add to local list (at the beginning)
      final updatedTasks = [createdTask, ...currentState.tasks];
      final filtered = _applyFilters(updatedTasks, currentState);

      emit(TaskLoadedState(
        tasks: updatedTasks,
        filteredTasks: filtered,
        showCompleted: currentState.showCompleted,
        searchQuery: currentState.searchQuery,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(TaskErrorState(_getErrorMessage(e)));
      // Restore previous state
      emit(currentState);
    }
  }

  // ============ TOGGLE TASK ============
 Future<void> _onToggleTask(
  ToggleTaskEvent event,
  Emitter<TaskState> emit,
) async {
  if (state is! TaskLoadedState) return;

  final currentState = state as TaskLoadedState;

  final updatedTasks = currentState.tasks.map((task) {
    if (task.id == event.taskId) {
      return task.copyWith(completed: event.isCompleted);
    }
    return task;
  }).toList();

  final filtered = _applyFilters(updatedTasks, currentState);

  emit(TaskLoadedState(
    tasks: updatedTasks,
    filteredTasks: filtered,
    showCompleted: currentState.showCompleted,
    searchQuery: currentState.searchQuery,
    isRefreshing: false,
  ));

  try {
    await _repository.toggleTask(event.taskId, event.isCompleted);
  } catch (e) {
    final revertedTasks = currentState.tasks.map((task) {
      if (task.id == event.taskId) {
        return task; 
      }
      return task;
    }).toList();

    emit(TaskLoadedState(
      tasks: revertedTasks,
      filteredTasks: _applyFilters(revertedTasks, currentState),
      showCompleted: currentState.showCompleted,
      searchQuery: currentState.searchQuery,
      isRefreshing: false,
    ));

    emit(TaskErrorState(_getErrorMessage(e)));
  }
}

  // ============ DELETE TASK ============
  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TaskLoadedState) return;

    final currentState = state as TaskLoadedState;

    // Optimistic delete
    final updatedTasks =
        currentState.tasks.where((task) => task.id != event.taskId).toList();
    final filtered = _applyFilters(updatedTasks, currentState);

    emit(TaskLoadedState(
      tasks: updatedTasks,
      filteredTasks: filtered,
      showCompleted: currentState.showCompleted,
      searchQuery: currentState.searchQuery,
    ));

    try {
      await _repository.deleteTask(event.taskId);
    } catch (e) {
      // Revert on error
      emit(TaskErrorState(_getErrorMessage(e)));
      emit(currentState);
    }
  }

  // ============ UPDATE TASK ============
  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TaskLoadedState) return;

    final currentState = state as TaskLoadedState;

    try {
      emit(currentState.copyWith(isRefreshing: true));

      final updatedTask = await _repository.updateTask(event.task);
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == updatedTask.id) return updatedTask;
        return task;
      }).toList();

      final filtered = _applyFilters(updatedTasks, currentState);

      emit(TaskLoadedState(
        tasks: updatedTasks,
        filteredTasks: filtered,
        showCompleted: currentState.showCompleted,
        searchQuery: currentState.searchQuery,
      ));
    } catch (e) {
      emit(TaskErrorState(_getErrorMessage(e)));
      emit(currentState);
    }
  }

  // ============ SEARCH TASKS ============
  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TaskLoadedState) return;

    final currentState = state as TaskLoadedState;

    if (event.query.trim().isEmpty) {
      // Clear search - show all tasks
      final filtered = currentState.showCompleted
          ? currentState.completedTasks
          : currentState.tasks;
      
      emit(currentState.copyWith(
        filteredTasks: filtered,
        searchQuery: '',
      ));
      return;
    }

    try {
      // Call search API
      final results = await _repository.searchTasks(event.query);
      
      emit(currentState.copyWith(
        filteredTasks: results,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(TaskErrorState(_getErrorMessage(e)));
      emit(currentState);
    }
  }

  // ============ CLEAR SEARCH ============
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<TaskState> emit,
  ) {
    if (state is! TaskLoadedState) return;

    final currentState = state as TaskLoadedState;
    final filtered = currentState.showCompleted
        ? currentState.completedTasks
        : currentState.tasks;

    emit(currentState.copyWith(
      filteredTasks: filtered,
      searchQuery: '',
    ));
  }

  // ============ FILTER TASKS ============
  void _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) {
    if (state is! TaskLoadedState) return;

    final currentState = state as TaskLoadedState;
    
    final filtered = event.showCompleted
        ? currentState.completedTasks
        : currentState.tasks;

    emit(currentState.copyWith(
      filteredTasks: filtered,
      showCompleted: event.showCompleted,
    ));
  }

  // ============ CLEAR ERROR ============
  void _onClearError(
    ClearErrorEvent event,
    Emitter<TaskState> emit,
  ) {
    if (state is TaskLoadedState) {
      emit(state);
    } else {
      add(const LoadTasksEvent());
    }
  }

  // ============ HELPER: Apply Filters ============
  List<Task> _applyFilters(List<Task> tasks, TaskLoadedState state) {
    if (state.searchQuery.isNotEmpty) {
      // If searching, filter by query locally
      final query = state.searchQuery.toLowerCase();
      return tasks.where((task) =>
          task.title.toLowerCase().contains(query) ||
          (task.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }
    
    if (state.showCompleted) {
      return tasks.where((task) => task.completed).toList();
    }
    
    return tasks;
  }

  // ============ HELPER: Error Message ============
  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }
}