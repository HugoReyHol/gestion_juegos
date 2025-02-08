import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/util/db_manager.dart';

/// Clase para interactuar con los juegos de un usuario de la base de datos
abstract class UserGameDao {
  /// Inserta un juego de un usuario en la base de datos
  ///
  /// Devuelve un `int` con el valor del id creado
  static Future<int> insertUserGame(UserGame userGame) async {
    final db = await DbManager.database;

    final Map<String, dynamic> game = userGame.toMap();

    return db.insert("Users_Games", game);
  }

  /// Obtiene todos los juegos de un usuario a partir del id del usuario
  ///
  /// Devuelve una `List<UserGame>` con los juegos
  static Future<List<UserGame>> getUserGames(int idUser) async {
    final db = await DbManager.database;

    final result = await db.query("Users_Games", where: "idUser = ?", whereArgs: [idUser]);

    final List<UserGame> userGames = [];

    for (var userGame in result) {
      userGames.add(UserGame.fromMap(userGame));
    }

    return userGames;
  }

  /// Actualiza un juego de un usuario
  ///
  /// Devuelve un `int` con la cantidad de entidades afectadas
  static Future<int> updateUserGame(UserGame userGame) async {
    final db = await DbManager.database;

    return db.update(
      "Users_Games",
      userGame.toMap(),
      where: "idUser = ? AND idGame = ?",
      whereArgs: [userGame.idUser, userGame.idGame]
    );
  }

  /// Borra un juego de un usuario
  ///
  /// Devuelve un `int` con la cantidad de entidades afectadas
  static Future<int> deleteUserGame(UserGame userGame) async {
    final db = await DbManager.database;

    return db.delete(
      "Users_Games",
      where: "idUser = ? AND idGame = ?",
      whereArgs: [userGame.idUser, userGame.idGame]
    );
  }
  
}