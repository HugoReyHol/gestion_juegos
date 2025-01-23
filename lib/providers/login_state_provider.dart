import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/login_state.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/providers/user_provider.dart';

class LoginStateNotifier extends StateNotifier<LoginState> {
  final Ref ref;

  LoginStateNotifier(this.ref) : super(LoginState());

  Future<void> onLogIn(String name, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true);

    final User? user = await UserDao.getUser(name);

    if (user == null) {
      state = state.copyWith(errorMsg: "El usuario $name no existe");
      return;
    }

    // TODO Implementar encriptacion
    if (user.password != password) {
      state = state.copyWith(errorMsg: "Contraseña incorrecta");
      return;
    }

    ref.read(userProvider.notifier).setUser(user);
    state = state.copyWith();
    Navigator.pushNamed(context, "/app");
  }

  Future<void> onRegister(String name, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true);

    User? user = await UserDao.getUser(name);

    if (user != null) {
      state = state.copyWith(errorMsg: "El usuario $name ya está registrado");
      return;
    }

    user = User(name: name, password: password);
    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) {
      state = state.copyWith(errorMsg: "No se ha podido crear el usuario");
      return;
    }

    ref.read(userProvider.notifier).setUser(user);
    state = state.copyWith();
    Navigator.pushNamed(context, "/app");
  }

  
}

final loginStateProvider = StateNotifierProvider<LoginStateNotifier, LoginState>((ref) => LoginStateNotifier(ref));