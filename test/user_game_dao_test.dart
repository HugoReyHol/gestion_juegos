import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/models/user_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("Crear usuario", () async {
    User testUser = User(name: "test", password: "test");

    testUser.idUser = await UserDao.insertUser(testUser);

    expect(testUser.idUser, isNonZero);
  });

  test("Insertar juegos a usuario", () async {
    User? testUser = await UserDao.getUser("test");

    await UserGameDao.insertUserGame(UserGame(idGame: 1, idUser: testUser!.idUser!, lastChange: DateTime.now()));
    await UserGameDao.insertUserGame(UserGame(idGame: 2, idUser: testUser.idUser!, lastChange: DateTime.now()));

    List<UserGame> games = await UserGameDao.getUserGames(testUser.idUser!);

    expect(games.length, 2);
    print(games.length);
  });

  test("Eliminar juegos de usuario", () async {
    User? testUser = await UserDao.getUser("test");

    await UserGameDao.deleteUserGame(UserGame(idGame: 1, idUser: testUser!.idUser!, lastChange: DateTime.now()));
    await UserGameDao.deleteUserGame(UserGame(idGame: 2, idUser: testUser.idUser!, lastChange: DateTime.now()));

    List<UserGame> games = await UserGameDao.getUserGames(testUser.idUser!);

    expect(games.length, isZero);
    print(games.length);
  });
}