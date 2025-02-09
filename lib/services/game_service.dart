import "dart:convert";
import "package:http/http.dart" as http;
import "../models/game.dart";

/// Clase para interactuar con los juegos de la API
abstract class GameService {
  /// url de los juegos en la API
  static const String _url = "http://localhost:8000/game/";

  /// Obtiene todos los juegos de la API
  ///
  /// Devuelve una `List<Game>` con los juegos
  static Future<List<Game>> getGames() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) throw Exception("Error getting games");

    final List<Game> games = [];
    for (var game in jsonDecode(response.body)) {
      games.add(Game.fromMap(game));
    }

    return games;
  }
}