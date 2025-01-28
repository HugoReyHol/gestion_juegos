import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';

final stateProvider = StateProvider<GameStates?>((ref) => GameStates.playing);

final homeGamesProvider = Provider<List<Game>>((ref) {
  final games = ref.watch(gamesProvider);
  final userGames = ref.watch(userGamesProvider);
  final gameState = ref.watch(stateProvider);

  final filteredUserGames = gameState != null ? userGames.where((ug) => ug.gameState == gameState) : userGames;

  return games.where((g) => filteredUserGames.any((ug) => ug.idGame == g.idGame)).toList();
});