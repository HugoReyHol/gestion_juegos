import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadTheme();
    return false;
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO Hacer que cargue por defecto el del sistema
    state = prefs.getBool("isDarkTheme") ?? false;
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    state = !state;
    await prefs.setBool("isDarkTheme", state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() => ThemeNotifier());