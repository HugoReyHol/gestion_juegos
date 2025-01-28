import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/user_game.dart';
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

    ref.notifyListeners();
  }

}

final statsProvider = NotifierProvider<StatsNotifier, Map<String, dynamic>>(() => StatsNotifier());

// Provider de los últimos juegos modificados
final lastUserGamesProvider = Provider.family<List<UserGame>, int>((ref, amount) {
  final userGames = ref.watch(userGamesProvider);
  return userGames.sublist(userGames.length - amount);
});