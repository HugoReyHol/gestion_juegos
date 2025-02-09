import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/services/game_service.dart';

/// Notifier de los juegos de la base de datos filtrados
///
/// Inicia como una lista vacía mientras carga los juegos de la base de datos
class GamesNotifier extends Notifier<List<Game>> {
  /// Todos los juegos de la base de datos
  late final List<Game> allGames;
  /// El juego selecciona por el usuario
  Game? currentGame;

  @override
  List<Game> build() {
    state = [];
    _getGames();
    return state;
  }

  /// Obtiene todos los juegos de la base de datos
  void _getGames() async {
    allGames = await GameService.getGames();
    state = allGames;
  }

  /// Filtra los juegos por su título
  void filterGamesByTitle([String title = ""]) async {
    state = allGames.where((e) => e.title.toLowerCase().contains(title)).toList();
  }

  /// Vuelve a cargar todos los juegos
  void resetGames() {
    state = allGames;
  }

  /// Obtiene un juego de la lista por su id
  ///
  /// Devuelve un `Game` de la lista de todos los juegos que coincida con el id
  Game getGameById(int idGame) => allGames.firstWhere((e) => e.idGame == idGame);
}

/// Provider de juegos
final gamesProvider = NotifierProvider<GamesNotifier, List<Game>>(() => GamesNotifier());