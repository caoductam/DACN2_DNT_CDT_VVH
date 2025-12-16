import 'package:flutter/material.dart';

class ThemeManager {
  // Tạo singleton để dùng chung cho toàn app
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  // Biến thông báo thay đổi giao diện (Mặc định là Sáng)
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  // Hàm đổi giao diện
  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}