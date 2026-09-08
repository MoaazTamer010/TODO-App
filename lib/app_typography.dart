import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Titles
  static TextStyle heading1 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0.5,
  );
  
  static TextStyle heading2 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: 0.3,
  );
  
  static TextStyle title = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: 0.3,
  );
  
  // Body text
  static TextStyle body = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    letterSpacing: 0.2,
  );
  
  // Task text
  static TextStyle todo = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    letterSpacing: 0.2,
  );
  
  // Hint/Caption text
  static TextStyle hint = const TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
    letterSpacing: 0.2,
  );
  
  static TextStyle caption = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
    letterSpacing: 0.2,
  );
  
  // Small text
  static TextStyle small = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
    letterSpacing: 0.1,
  );
}