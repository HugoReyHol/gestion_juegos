import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadTheme();
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    state = prefs.getBool("isDarkTheme") ?? state;
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    state = !state;
    await prefs.setBool("isDarkTheme", state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() => ThemeNotifier());