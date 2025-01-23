import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void getUser(String name) async {
    state = await UserDao.getUser(name);
  }

  void setUser(User user) {
    state = user;
  }

  void insertUser(User user) async {
    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) return;

    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());