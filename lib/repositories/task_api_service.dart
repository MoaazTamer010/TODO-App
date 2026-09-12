import '../core/network/api_client.dart';
import '../models/task_model.dart';

class TaskApiService {
  final ApiClient _client;

  TaskApiService({ApiClient? client}) : _client = client ?? ApiClient();

  // ============ GET ALL TODOS ============
  /// List todos with pagination
  Future<TodosResponse> getTodos({
    int page = 1,
    int limit = 10,
    String sort = 'id',
    String order = 'asc',
    int? userId,
    bool? completed,
    String? titleLike,
  }) async {
    final queryParams = <String, dynamic>{
      '_page': page,
      '_limit': limit,
      '_sort': sort,
      '_order': order,
      if (userId != null) 'userId': userId,
      if (completed != null) 'completed': completed,
      if (titleLike != null && titleLike.isNotEmpty) 'title_like': titleLike,
    };

    final response = await _client.get<Map<String, dynamic>>(
      '/todos',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      return TodosResponse.fromJson(response.data!);
    }
    
    throw ApiException('Failed to load todos');
  }

  /// Get a single todo by ID
  Future<Task> getTodo(int id) async {
    final response = await _client.get<Map<String, dynamic>>('/todos/$id');

    if (response.statusCode == 200 && response.data != null) {
      return Task.fromJson(response.data!);
    }
    
    throw ApiException('Failed to load todo');
  }

  // ============ SEARCH TODOS ============
  /// Search todos by query
  Future<SearchResponse> searchTodos(String query) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/todos/search',
      queryParameters: {'q': query},
    );

    if (response.statusCode == 200 && response.data != null) {
      return SearchResponse.fromJson(response.data!);
    }
    
    throw ApiException('Failed to search todos');
  }

  /// Create a new todo
  Future<Task> createTodo(Task task) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/todos',
      data: task.toCreateJson(),
    );

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data != null) {
      return Task.fromJson(response.data!);
    }
    
    throw ApiException('Failed to create todo');
  }

  /// Replace a todo entirely
  Future<Task> updateTodo(int id, Task task) async {
    final response = await _client.put<Map<String, dynamic>>(
      '/todos/$id',
      data: task.toCreateJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      return Task.fromJson(response.data!);
    }
    
    throw ApiException('Failed to update todo');
  }

  /// Update selected fields of a todo
  Future<Task> patchTodo(int id, Map<String, dynamic> data) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/todos/$id',
      data: data,
    );

    if (response.statusCode == 200 && response.data != null) {
      return Task.fromJson(response.data!);
    }
    
    throw ApiException('Failed to patch todo');
  }

  // ============ TOGGLE COMPLETED ============
  /// Toggle completion status
  Future<Task> toggleCompleted(int id, bool completed) async {
    return patchTodo(id, {'completed': completed});
  }

  /// Delete a todo
  Future<void> deleteTodo(int id) async {
    final response = await _client.delete('/todos/$id');

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw ApiException('Failed to delete todo');
    }
  }
}