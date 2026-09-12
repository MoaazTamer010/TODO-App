import '../models/task_model.dart';
import 'task_api_service.dart';

class TaskRepository {
  final TaskApiService _apiService;

  TaskRepository({TaskApiService? apiService})
      : _apiService = apiService ?? TaskApiService();

  // ============ GET TODOS ============
  Future<TodosResponse> getTasks({
    int page = 1,
    int limit = 100, // Get more tasks at once
    int? userId,
    bool? completed,
  }) async {
    return _apiService.getTodos(
      page: page,
      limit: limit,
      userId: userId,
      completed: completed,
    );
  }

  // ============ GET ONE TASK ============
  Future<Task> getTask(int id) async {
    return _apiService.getTodo(id);
  }

  // ============ SEARCH TASKS ============
  Future<List<Task>> searchTasks(String query) async {
    if (query.trim().isEmpty) {
      // Return all tasks if query is empty
      final response = await _apiService.getTodos(limit: 100);
      return response.data;
    }
    
    final response = await _apiService.searchTodos(query);
    return response.results;
  }

  // ============ CREATE TASK ============
  Future<Task> createTask(Task task) async {
    return _apiService.createTodo(task);
  }

  // ============ UPDATE TASK ============
  Future<Task> updateTask(Task task) async {
    if (task.id == null) {
      throw Exception('Cannot update task without ID');
    }
    return _apiService.updateTodo(task.id!, task);
  }

  // ============ TOGGLE TASK ============
  Future<Task> toggleTask(int id, bool completed) async {
    return _apiService.toggleCompleted(id, completed);
  }

  // ============ DELETE TASK ============
  Future<void> deleteTask(int id) async {
    return _apiService.deleteTodo(id);
  }
}