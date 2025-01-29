import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  void getSavedUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final idUser = prefs.getInt("idUser");
    final name = prefs.getString("name");
    final password = prefs.getString("password");

    if (idUser == null || name == null || password == null) return;

    final User user = User(
      name: name,
      password: password
    );
    user.idUser = idUser;

    state = user;
    Navigator.pushReplacementNamed(context, "/app");
  }

  void saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("idUser", state!.idUser!);
    await prefs.setString("name", state!.name);
    await prefs.setString("password", state!.password);
  }

  void deleteSavedUser() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(() => UserNotifier());