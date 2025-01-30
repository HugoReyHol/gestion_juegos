import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';

// Provider para las estadisticas
class StatsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    state = {
      GameStates.playing.name: 0,
      GameStates.completed.name: 0,
      GameStates.on_hold.name: 0,
      GameStates.dropped.name: 0,
      GameStates.plan_to_play.name: 0,
      "total": 0,
      "total_time": 0,
      "average_score": 0,
    };

    _setStats();

    return state;
  }

  void _setStats() {
    final List<UserGame> userGames = ref.watch(userGamesProvider);

    state["total"] = userGames.length;
    int numScores = 0;

    userGames.forEach((ug) {
      state[ug.gameState.name]++;
      state["total_time"] += ug.timePlayed;

      if (ug.score != null) {
        state["average_score"] += ug.score;
        numScores++;
      }
    });

    numScores != 0 ? state["average_score"] /= numScores : state["average_score"] = -1;
    state["average_score"] = (state["average_score"] as double).toStringAsFixed(2);

    ref.notifyListeners();
  }

}

final statsProvider = NotifierProvider<StatsNotifier, Map<String, dynamic>>(() => StatsNotifier());

// Provider de los últimos juegos modificados
final lastGamesProvider = Provider.family<List<Game>, int>((ref, amount) {
  final userGames = ref.watch(userGamesProvider);
  final games = ref.read(gamesProvider.notifier).allGames;

  final List<UserGame> lastUserGames = userGames.isNotEmpty ? userGames.sublist(userGames.length - amount).reversed.toList() : [];
  final List<Game> lastGames = [];
  
  for (UserGame ug in lastUserGames) {
    lastGames.add(games.firstWhere((g) => g.idGame == ug.idGame));
  }

  return lastGames;
});