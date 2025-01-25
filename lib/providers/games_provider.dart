import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/game.dart';

class GamesNotifier extends Notifier<List<Game>> {
  late final List<Game> allGames;
  Game? currentGame;

  @override
  List<Game> build() {
    state = [];
    _getGames();
    return state;
  }

  void _getGames() async {
    allGames = await GameDao.getGames();
    state = allGames;
  }

  void filterGamesByTitle(String title) async {
    state = allGames.where((e) => e.title.toLowerCase().contains(title)).toList();
  }

  Game getGameById(int idGame) => allGames.firstWhere((e) => e.idGame == idGame);
}

final gamesProvider = NotifierProvider<GamesNotifier, List<Game>>(() => GamesNotifier());