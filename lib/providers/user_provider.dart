import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// El notifier del usuario actual
///
/// El usuario por defecto es null y al iniciar la app busca si hay un usuario
/// cargado en las shared preferences
class UserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  /// Obtiene el usuario de las shared preferences
  ///
  /// Devuelve `true` si lo ha encontrado y `false` en caso contrario
  Future<bool> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();

    final idUser = prefs.getInt("idUser");
    final name = prefs.getString("name");
    final password = prefs.getString("password");

    if (idUser == null || name == null || password == null) return false;

    final User user = User(
      name: name,
      password: password
    );
    user.idUser = idUser;

    state = user;
    return true;
  }

  /// Guarda el usuario actual en las shared preferences
  void saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("idUser", state!.idUser!);
    await prefs.setString("name", state!.name);
    await prefs.setString("password", state!.password);
  }

  /// Borra el usuario actual de las shared preferences
  void deleteSavedUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("idUser");
    await prefs.remove("name");
    await prefs.remove("password");
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }
}

/// El provider del usuario actual
final userProvider = NotifierProvider<UserNotifier, User?>(() => UserNotifier());