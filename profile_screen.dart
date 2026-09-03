import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              // ignore: deprecated_member_use
              backgroundColor: AppColors.primary.withOpacity(0.1),
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.person,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'User Name',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'user@email.com',
              style: AppTypography.body.copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildProfileItem(Icons.task, 'Total Tasks', '12'),
                  const Divider(),
                  _buildProfileItem(Icons.check_circle, 'Completed', '5'),
                  const Divider(),
                  _buildProfileItem(Icons.pending, 'Pending', '7'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(label, style: AppTypography.body),
            ],
          ),
          Text(value, style: AppTypography.heading2),
        ],
      ),
    );
  }
}