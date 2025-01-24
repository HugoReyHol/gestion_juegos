import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/util/db_manager.dart';

class GameDao {
  @Deprecated("Usar la función getGames() del provider")
  static Future<Game?> getGameById(int idGame) async {
    final db = await DbManager().database;

    final result = await db.query("Games", where: "idGame = ?", whereArgs: [idGame]);

    return result.isEmpty ? null : Game.fromMap(result.first);
  }
  
  @Deprecated("Usar la función filterGamesByTitle() del provider")
  static Future<List<Game>> getGamesByTitle(String title) async {
    final db = await DbManager().database;

    final result = await db.query("Games", where: "title LIKE ?", whereArgs: ["%$title%"], orderBy: "title");

    final List<Game> games = [];
    for (var game in result) {
      games.add(Game.fromMap(game));
    }

    return games;
  }

  static Future<List<Game>> getGames() async {
    final db = await DbManager().database;

    final result = await db.query("Games", orderBy: "title");

    final List<Game> games = [];
    for (var game in result) {
      games.add(Game.fromMap(game));
    }

    return games;
  }

  static Future<int> insertGame(Game game) async {
    final db = await DbManager().database;

    return await db.insert("Games", game.toMap());
  }
}