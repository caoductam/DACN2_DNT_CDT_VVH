import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const background = Colors.white;
  static const border = Color(0xFFCED4DA);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const progressBg = Color(0xFFE5E7EB);
  static const progressActive = Color(0xFF2563EB);
  static const completed = Color(0xFF22C55E);
  static const locked = Color(0xFFD1D5DB);
  static const cardShadow = Color(0x0D000000);
}

class AppTextStyles {
  static const header = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const topicTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const topicSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
  static const progressLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
