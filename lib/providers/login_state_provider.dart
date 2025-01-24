import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/login_state.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/providers/user_provider.dart';

class LoginStateNotifier extends AutoDisposeNotifier<LoginState> {

  @override
  LoginState build() {
    ref.onDispose(() {
      print("LoginNotifier eliminado");
    });

    return LoginState();
  }

  Future<void> onLogIn(String name, String password, BuildContext context) async {
    _updateState(true);

    final User? user = await UserDao.getUser(name);

    if (user == null) {
      _updateState(false, "El usuario $name no existe");
      return;
    }

    // TODO Implementar encriptacion
    if (user.password != password) {
      _updateState(false, "Contraseña incorrecta");
      return;
    }

    ref.read(userProvider.notifier).state = user;
    Navigator.pushReplacementNamed(context, "/app");
  }

  Future<void> onRegister(String name, String password, BuildContext context) async {
    _updateState(true);

    User? user = await UserDao.getUser(name);

    if (user != null) {
      _updateState(false, "El usuario $name ya está registrado");
      return;
    }

    user = User(name: name, password: password);
    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) {
      _updateState(false, "No se ha podido crear el usuario");
      return;
    }

    ref.read(userProvider.notifier).state = user;
    Navigator.pushReplacementNamed(context, "/app");
  }

  void _updateState(bool isLoading, [String errorMsg = ""]) {
    state.isLoading = isLoading;
    state.errorMsg = errorMsg;
    ref.notifyListeners();
  }
}

final loginStateProvider = NotifierProvider.autoDispose<LoginStateNotifier, LoginState>(() => LoginStateNotifier());