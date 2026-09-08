import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../models/task_model.dart';
import '../../view_models/task_bloc/task_bloc.dart';
import '../../view_models/task_bloc/task_event.dart';
import '../views/widgets/custom_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPriority;
  DateTime? _selectedDate;

  final List<String> _categories = ['Work', 'Personal', 'Shopping', 'Health', 'Education', 'Other'];
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task', style: AppTypography.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.text,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('Task Title *', style: AppTypography.body),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text('Description', style: AppTypography.body),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              Text('Category', style: AppTypography.body),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                hint: const Text('Select category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              Text('Priority', style: AppTypography.body),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                hint: const Text('Select priority'),
                items: _priorities.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Due Date
              Text('Due Date', style: AppTypography.body),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select due date',
                        style: AppTypography.body.copyWith(
                          color: _selectedDate != null
                              ? AppColors.text
                              : AppColors.secondaryText,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Add Task Button
              CustomButton(
                text: 'Add Task',
                onPressed: () {
                  if (_titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a task title')),
                    );
                    return;
                  }

                  final task = Task.create(
                    title: _titleController.text.trim(),
                    description: _descController.text.trim().isEmpty
                        ? null
                        : _descController.text.trim(),
                    category: _selectedCategory,
                    priority: _selectedPriority,
                    dueDate: _selectedDate,
                  );

                  context.read<TaskBloc>().add(AddTaskEvent(task));
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}