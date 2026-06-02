import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  bool get isDark => mode.value == ThemeMode.dark;

  void setDark(bool value) {
    mode.value = value ? ThemeMode.dark : ThemeMode.light;
  }
}
