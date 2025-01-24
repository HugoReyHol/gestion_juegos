import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/game.dart';

class GamesNotifier extends Notifier<List<Game>> {
  late final List<Game> allGames;
  Game? currentGame;

  @override
  List<Game> build() {
    _getGames();
    return allGames;
  }

  void _getGames() async {
    allGames = await GameDao.getGames();
  }

  void filterGamesByTitle(String title) async {
    state.removeWhere((e) => !e.title.contains(title));
    ref.notifyListeners();
  }

  Game getGameById(int idGame) => allGames.firstWhere((e) => e.idGame == idGame);
}

final gamesProvider = NotifierProvider<GamesNotifier, List<Game>>(() => GamesNotifier());