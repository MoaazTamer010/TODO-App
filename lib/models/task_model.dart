import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final String? category;
  final String? priority;
  final DateTime? dueDate;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    this.category,
    this.priority,
    this.dueDate,
    required this.createdAt,
  });

  // Copy with method for immutability
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    String? category,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Factory method for creating new tasks
  factory Task.create({
    required String title,
    String? description,
    String? category,
    String? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isDone: false,
      category: category,
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isDone,
    category,
    priority,
    dueDate,
    createdAt,
  ];
}

// Task category enum
enum TaskCategory {
  work('Work'),
  personal('Personal'),
  shopping('Shopping'),
  health('Health'),
  education('Education'),
  other('Other');

  final String label;
  const TaskCategory(this.label);

  static TaskCategory fromString(String value) {
    return TaskCategory.values.firstWhere(
      (e) => e.label == value,
      orElse: () => TaskCategory.other,
    );
  }
}

// Task priority enum
enum TaskPriority {
  low('Low', Colors.green),
  medium('Medium', Colors.orange),
  high('High', Colors.red);

  final String label;
  final Color color;
  const TaskPriority(this.label, this.color);

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (e) => e.label == value,
      orElse: () => TaskPriority.medium,
    );
  }
}