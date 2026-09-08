import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_colors.dart';
import 'repositories/task_repository.dart';
import 'view_models/task_bloc/task_bloc.dart';
import 'view_models/task_bloc/task_event.dart';
import 'views/screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'views/focus_mode_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        repository: TaskRepository(),
      )..add(LoadTasksEvent()),
      child: MaterialApp(
        title: 'UpTodo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.text,
            elevation: 0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/add_task': (context) => const AddTaskScreen(),
          '/search': (context) => const SearchScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/focus': (context) => const FocusModeScreen(), // Add this
        },
      ),
    );
  }
}