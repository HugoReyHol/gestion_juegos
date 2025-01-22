import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void getUser(String name) async {
    state = await UserDao.getUser(name);
  }

  void insertUser(User user) async {
    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) return;

    state = user;
  }

  Future<String> onLogIn(String name, String password) async {
    final User? user = await UserDao.getUser(name);

    if (user == null) {
      state = user;
      return "El usuario $name no existe";
    }

    // TODO implementar encriptacion
    if (user.password != password) {
      state = null;
      return "Contraseña incorrecta";
    }

    state = user;
    return "";
  }

  Future<String> onRegister(String name, String password) async {
    User? user = await UserDao.getUser(name);

    if (user != null) {
      state = null;
      return "El usuario $name ya está registrado";
    }

    user = User(name: name, password: password);

    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) {
      state = null;
      return "No se ha podido crear el usuario";
    }

    state = user;
    return "";
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());