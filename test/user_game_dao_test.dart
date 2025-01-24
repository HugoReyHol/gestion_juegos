
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/util/db_manager.dart';

void main() {
  test("Insertar juegos a usuario", () async {
    await UserGameDao.insertUserGame(UserGame(idGame: 1, idUser: 1));
    await UserGameDao.insertUserGame(UserGame(idGame: 2, idUser: 1));
  });

  test("Leer juegos a usuario", () async {
    List<UserGame> games = await UserGameDao.getUserGames(1);

    print(games.length);

    for (UserGame game in games) {
      print(game.toMap());
    }
  });

  test("Eliminar juegos de usuairo", () async {
    await UserGameDao.deleteUserGame(UserGame(idGame: 1, idUser: 1));
    await UserGameDao.deleteUserGame(UserGame(idGame: 1, idUser: 2));

  });

  test("Obtener el userGame con su game", () async {
    final db = await DbManager().database;

    print(await db.rawQuery("""
      SELECT *
      FROM Users_Games, Games
      WHERE Users_Games.idUser = 1 
      AND Users_Games.idGame = Games.idGame
    """));
  });

}