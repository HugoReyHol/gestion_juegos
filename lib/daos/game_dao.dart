import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/util/db_manager.dart';

/// Clase para interactuar con los juegos de la base de datos
abstract class GameDao {
  /// Obtiene todos los juegos de la base de datos
  ///
  /// Devuelve una `List<Game>` con los juegos
  static Future<List<Game>> getGames() async {
    final db = await DbManager.database;

    final result = await db.query("Games", orderBy: "title");

    final List<Game> games = [];
    for (var game in result) {
      games.add(Game.fromMap(game));
    }

    return games;
  }
}