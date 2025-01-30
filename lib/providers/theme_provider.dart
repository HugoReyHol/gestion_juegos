import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadTheme();
    return false;
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool("isDarkTheme") ?? MediaQuery.of(context as BuildContext).platformBrightness == Brightness.dark;
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    state = !state;
    await prefs.setBool("isDarkTheme", state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() => ThemeNotifier());