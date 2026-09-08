import '../models/task_model.dart';

class TaskRepository {
  // In-memory data store
  static final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'UI/UX Design',
      description: 'Complete the design for the UpTodo app',
      isDone: false,
      category: 'Work',
      priority: 'High',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '2',
      title: 'Morning Workout',
      description: '30 minutes cardio and stretching',
      isDone: true,
      category: 'Health',
      priority: 'Medium',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Task(
      id: '3',
      title: 'Buy Groceries',
      description: 'Milk, eggs, bread, and vegetables',
      isDone: false,
      category: 'Shopping',
      priority: 'Low',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Task(
      id: '4',
      title: 'Team Meeting',
      description: 'Weekly sync with the development team',
      isDone: false,
      category: 'Work',
      priority: 'High',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  // Get all tasks
  List<Task> getTasks() {
    return _tasks;
  }

  // Get pending tasks
  List<Task> getPendingTasks() {
    return _tasks.where((task) => !task.isDone).toList();
  }

  // Get completed tasks
  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isDone).toList();
  }

  // Get tasks by category
  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  // Search tasks
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    return _tasks.where((task) =>
      task.title.toLowerCase().contains(query.toLowerCase()) ||
      (task.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Add a new task
  void addTask(Task task) {
    _tasks.insert(0, task);
  }

  // Toggle task completion
  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
    }
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  // Update a task
  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  // Get task statistics
  Map<String, int> getStats() {
    return {
      'total': _tasks.length,
      'completed': _tasks.where((task) => task.isDone).length,
      'pending': _tasks.where((task) => !task.isDone).length,
    };
  }
}