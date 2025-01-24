import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/game.dart';

class GamesNotifier extends StateNotifier<List<Game>> {
  late List<Game> allGames;
  Game? currentGame;
  GamesNotifier() : super([]);

  void getGames() async {
    allGames = await GameDao.getGames();
    state = allGames;
  }

  void filterGamesByTitle(String title) async {
    state = allGames.where((e) => e.title.contains(title)).toList();
  }

  Game getGameById(int idGame) => allGames.firstWhere((e) => e.idGame == idGame);
}

final gamesProvider = StateNotifierProvider<GamesNotifier, List<Game>>((ref) {
  final notifier = GamesNotifier();
  notifier.getGames();
  return notifier;
});