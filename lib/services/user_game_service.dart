import 'dart:convert';
import '../models/user_game.dart';
import "package:http/http.dart" as http;

/// Clase para interactuar con los juegos de un usuario de la API
abstract class UserGameService {
  /// url de los usuarios en la API
  static const String _url = "http://localhost:8000/user_game";

  /// Inserta un juego de un usuario en la API
  static Future<void> insertUserGame(UserGame userGame, String token) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": token
      },
      body: jsonEncode({userGame.toMap()})
    );

    if (response.statusCode != 200) throw Exception("Error insert");
  }

  /// Obtiene todos los juegos de un usuario a partir del token
  ///
  /// Devuelve una `List<UserGame>` con los juegos del usuario
  static Future<List<UserGame>> getUserGames(String token) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Authorization": token
      }
    );

    if (response.statusCode != 200) throw Exception("Error insert");

    final List<UserGame> userGames = [];

    for (var userGame in jsonDecode(response.body)) {
      userGames.add(UserGame.fromMap(userGame));
    }

    return userGames;
  }

  /// Actualiza un juego de un usuario
  static Future<void> updateUserGame(UserGame userGame, String token) async {
    final String endpoint = "/{idGame}?id_game=${userGame.idGame}";

    final response = await http.patch(
      Uri.parse("$_url$endpoint"),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": token
      },
      body: jsonEncode({userGame.toMap()})
    );

    if (response.statusCode != 200) throw Exception("Error update");
  }

  /// Borra un juego de un usuario
  static Future<void> deleteUserGame(UserGame userGame, String token) async {
    final String endpoint = "/{idGame}?id_game=${userGame.idGame}";

    final response = await http.delete(
      Uri.parse("$_url$endpoint"),
      headers: {
        "accept": "application/json",
        "Authorization": token
      }
    );

    if (response.statusCode != 200) throw Exception("Error delete");
  }
}