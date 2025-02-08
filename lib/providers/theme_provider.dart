import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier para el tema selecciona en la app
///
/// Intenta cargar el guardado en shared preferences y si no lo consigue carga
/// el seleccionado en el sistema
class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadTheme();
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  /// Obtiene el tema seleccionado de las shared preferences
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    state = prefs.getBool("isDarkTheme") ?? state;
  }

  /// Invierte el tema seleccionado
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    state = !state;
    await prefs.setBool("isDarkTheme", state);
  }
}

/// Provider del tema seleccionado
final themeProvider = NotifierProvider<ThemeNotifier, bool>(() => ThemeNotifier());