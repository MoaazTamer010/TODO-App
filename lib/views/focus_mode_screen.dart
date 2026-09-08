import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../view_models/task_bloc/task_bloc.dart';
import '../view_models/task_bloc/task_state.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  bool _isTimerRunning = false;
  int _seconds = 1500; // 25 minutes default
  String _selectedTask = 'Focus on your task';
  List<String> _taskTitles = [];
  
  // Timer for countdown
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    // Get task titles from BLoC state
    final state = context.read<TaskBloc>().state;
    if (state is TaskLoadedState) {
      _taskTitles = state.tasks.map((task) => task.title).toList();
      if (_taskTitles.isNotEmpty) {
        _selectedTask = _taskTitles[0];
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _isTimerRunning = false;
          _timer.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    _isTimerRunning = false;
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 1500;
      _isTimerRunning = false;
    });
  }

  void _toggleTimer() {
    setState(() {
      if (_isTimerRunning) {
        _pauseTimer();
      } else {
        _isTimerRunning = true;
        _startTimer();
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('🎉 Time\'s Up!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 64,
              color: AppColors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Great job staying focused!',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You completed your focus session.',
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Task to Focus On',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: 16),
            if (_taskTitles.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No tasks available. Add a task first!',
                    style: AppTypography.body.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              )
            else
              ..._taskTitles.map((title) {
                return ListTile(
                  leading: Icon(
                    Icons.task,
                    color: _selectedTask == title
                        ? AppColors.primary
                        : AppColors.secondaryText,
                  ),
                  title: Text(
                    title,
                    style: AppTypography.body.copyWith(
                      color: _selectedTask == title
                          ? AppColors.primary
                          : AppColors.text,
                    ),
                  ),
                  trailing: _selectedTask == title
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedTask = title;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    final progress = 1 - (_seconds / 1500);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  Text(
                    'Focus Mode',
                    style: AppTypography.heading1.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              
              const Spacer(),

              // Task selection button
              GestureDetector(
                onTap: _showTaskSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.task_alt,
                        color: AppColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedTask,
                        style: AppTypography.body.copyWith(
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Timer Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: progress,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                      backgroundColor: AppColors.white.withOpacity(0.2),
                      strokeWidth: 8,
                    ),
                  ),
                  // Timer text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$minutes:$seconds',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isTimerRunning ? 'FOCUSING...' : 'READY',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset button
                  _buildControlButton(
                    icon: Icons.restart_alt,
                    label: 'Reset',
                    onPressed: _resetTimer,
                    isSecondary: true,
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Play/Pause button
                  _buildControlButton(
                    icon: _isTimerRunning ? Icons.pause : Icons.play_arrow,
                    label: _isTimerRunning ? 'Pause' : 'Start',
                    onPressed: _toggleTimer,
                    isMain: true,
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Skip button
                  _buildControlButton(
                    icon: Icons.skip_next,
                    label: 'Skip',
                    onPressed: () {
                      _showTimeUpDialog();
                    },
                    isSecondary: true,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Time presets
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimePreset(15, '15m'),
                  const SizedBox(width: 12),
                  _buildTimePreset(25, '25m', isActive: true),
                  const SizedBox(width: 12),
                  _buildTimePreset(45, '45m'),
                ],
              ),

              const Spacer(),

              // Motivational quote
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '"Focus on being productive instead of busy."',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isMain = false,
    bool isSecondary = false,
  }) {
    if (isMain) {
      return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.white,
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 32,
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSecondary
                  ? AppColors.white.withOpacity(0.15)
                  : AppColors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePreset(int minutes, String label, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        if (!_isTimerRunning) {
          setState(() {
            _seconds = minutes * 60;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.white
              : AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.white
                : AppColors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            color: isActive ? AppColors.primary : AppColors.white,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}