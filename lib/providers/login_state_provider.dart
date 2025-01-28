import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/util/extensions.dart';

class LoginStateNotifier extends AutoDisposeNotifier<bool> {

  @override
  bool build() => false;

  Future<void> onLogIn(String name, String password, BuildContext context) async {
    state = true;

    final User? user = await UserDao.getUser(name);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text("El usuario $name no existe")))
      );
      state = false;
      return;
    }

    if (user.password != password.encrypt()) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text("Contraseña incorrecta")))
      );
      state = false;
      return;
    }

    ref.read(userProvider.notifier).state = user;
    Navigator.pushReplacementNamed(context, "/app");
  }

  Future<void> onRegister(String name, String password, BuildContext context) async {
    state = true;

    User? user = await UserDao.getUser(name);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text("El usuario $name ya está registrado")))
      );
      state = false;
      return;
    }

    user = User(name: name, password: password.encrypt());
    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text("No se ha podido crear el usuario")))
      );
      state = false;
      return;
    }

    ref.read(userProvider.notifier).state = user;
    Navigator.pushReplacementNamed(context, "/app");
  }
}

final loginStateProvider = AutoDisposeNotifierProvider<LoginStateNotifier, bool>(() => LoginStateNotifier());