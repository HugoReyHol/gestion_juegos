import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

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

  void saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("idUser", state!.idUser!);
    await prefs.setString("name", state!.name);
    await prefs.setString("password", state!.password);
  }

  void deleteSavedUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("idUser");
    await prefs.remove("name");
    await prefs.remove("password");
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(() => UserNotifier());