import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final bool completed;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  const Task({
    this.id,
    required this.title,
    this.description,
    this.completed = false,
    this.userId = 1,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  // From JSON (API response)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      completed: json['completed'] as bool? ?? false,
      userId: json['userId'] as int? ?? 1,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt']) 
          : null,
      user: json['user'] != null 
          ? User.fromJson(json['user'] as Map<String, dynamic>) 
          : null,
    );
  }

  // To JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'completed': completed,
      'userId': userId,
    };
  }

  // For create requests (no id, no timestamps)
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'completed': completed,
      'userId': userId,
    };
  }

  // Copy with
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        completed,
        userId,
        createdAt,
        updatedAt,
        user,
      ];

  get priority => null;

  bool? get isDone => null;

  get category => null;

  bool? get isCompleted => null;

  // ignore: body_might_complete_normally_nullable
  static Object? create({required String title, String? description, String? category, String? priority, DateTime? dueDate}) {}
}

// User model (nested in todo response)
class User extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [id, name, username, email];
}

// Pagination model
class Pagination extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrev: json['hasPrev'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [page, limit, total, totalPages, hasNext, hasPrev];
}

// API Response wrapper
class TodosResponse {
  final List<Task> data;
  final Pagination pagination;

  TodosResponse({
    required this.data,
    required this.pagination,
  });

  factory TodosResponse.fromJson(Map<String, dynamic> json) {
    return TodosResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

// Search response wrapper
class SearchResponse {
  final String query;
  final int total;
  final List<Task> results;

  SearchResponse({
    required this.query,
    required this.total,
    required this.results,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      query: json['query'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}