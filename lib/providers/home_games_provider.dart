import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';

final homeGamesProvider = Provider<List<Game>>((ref) {
  final games = ref.watch(gamesProvider);
  final userGames = ref.watch(userGamesProvider);

  return games.where((g) => userGames.any((ug) => ug.idGame == g.idGame)).toList();
});