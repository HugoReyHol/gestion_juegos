import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/util/extensions.dart';

void main() {
  User? testUser;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    testUser = await UserDao.getUser("test");

    if (testUser != null) return;

    testUser = User(username: "test", password: "testtest".encrypt());

    await UserDao.insertUser(testUser!);
  });

  test("Insertar juegos a usuario", () async {
    await UserGameDao.insertUserGame(UserGame(idGame: 1, idUser: testUser!.idUser!, lastChange: DateTime.now()));
    await UserGameDao.insertUserGame(UserGame(idGame: 2, idUser: testUser!.idUser!, lastChange: DateTime.now()));

    List<UserGame> games = await UserGameDao.getUserGames(testUser!.idUser!);

    expect(games.length, 2);
    print(games.length);
  });

  test("Eliminar juegos de usuario", () async {
    await UserGameDao.deleteUserGame(UserGame(idGame: 1, idUser: testUser!.idUser!, lastChange: DateTime.now()));
    await UserGameDao.deleteUserGame(UserGame(idGame: 2, idUser: testUser!.idUser!, lastChange: DateTime.now()));

    List<UserGame> games = await UserGameDao.getUserGames(testUser!.idUser!);

    expect(games.length, isZero);
    print(games.length);
  });

  tearDown(() async {
    List<UserGame> games = await UserGameDao.getUserGames(testUser!.idUser!);

    games.forEach((game) async {
      await UserGameDao.deleteUserGame(game);
    });
  });
}