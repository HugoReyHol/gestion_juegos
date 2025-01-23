import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/game.dart';

class GamesNotifier extends StateNotifier<List<Game>> {
  Game? currentGame;
  GamesNotifier() : super([]);

  void getGames() async {
    state = await GameDao.getGames();
  }

  void getGamesByTitle(String title) async {
    state = await GameDao.getGamesByTitle(title);
  }

}

final gamesProvider = StateNotifierProvider<GamesNotifier, List<Game>>((ref) => GamesNotifier());