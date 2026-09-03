import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_typography.dart';
import 'todo_tile.dart';
import 'widgets/bottom_nav_bar.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedIndex = 0;
  
  // Sample tasks
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'UI/UX Design', 'done': false},
    {'title': 'Morning Workout', 'done': true},
    {'title': 'Buy Groceries', 'done': false},
    {'title': 'Team Meeting', 'done': false},
    {'title': 'Read Book', 'done': true},
  ];

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Tasks',
          style: AppTypography.heading1,
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.notifications),
            color: AppColors.text,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search/Add Task Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      hintStyle: AppTypography.hint,
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      // ignore: prefer_const_constructors
                      prefixIcon: Icon(
                        AppIcons.edit,
                        color: AppColors.secondaryText,
                      ),
                      // ignore: prefer_const_constructors
                      suffixIcon: Icon(
                        Icons.search,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        setState(() {
                          _tasks.insert(0, {'title': value.trim(), 'done': false});
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Tasks Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Tasks',
                  style: AppTypography.heading2,
                ),
                Text(
                  '${_tasks.length} tasks',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return TodoTile(
                  title: _tasks[index]['title'],
                  isDone: _tasks[index]['done'],
                  onToggle: () => _toggleTask(index),
                  onDelete: () => _deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigate to different screens
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/add_task');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}