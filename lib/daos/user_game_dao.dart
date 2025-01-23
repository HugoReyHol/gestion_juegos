import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/util/db_manager.dart';

class UserGameDao {
  static Future<int> insertUserGame(UserGame userGame) async {
    final db = await DbManager().database;

    final Map<String, dynamic> game = userGame.toMap();

    return db.insert("Users_Games", game);
  }

  static Future<UserGame?> getUserGame(int idUser, int idGame) async {
    final db = await DbManager().database;

    final result = await db.query(
      "Users_Games",
      where: "idUser = ? AND idGame = ?",
      whereArgs: [idUser, idGame]
    );

    return result.isEmpty ? null : UserGame.fromMap(result.first);
  }

  static Future<List<UserGame>> getUserGames(int idUser) async {
    final db = await DbManager().database;

    final result = await db.query("Users_Games", where: "idUser = ?", whereArgs: [idUser]);

    final List<UserGame> userGames = [];

    for (var userGame in result) {
      userGames.add(UserGame.fromMap(userGame));
    }

    return userGames;
  }

  static Future<int> updateUserGame(UserGame userGame) async {
    final db = await DbManager().database;

    return db.update(
      "Users_Games",
      userGame.toMap(),
      where: "idUser = ? AND idGame = ?",
      whereArgs: [userGame.idUser, userGame.idGame]
    );
  }

  static Future<int> deleteUserGame(UserGame userGame) async {
    final db = await DbManager().database;

    return db.delete(
      "Users_Games",
      where: "idUser = ? AND idGame = ?",
      whereArgs: [userGame.idUser, userGame.idGame]
    );
  }
  
}