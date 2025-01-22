import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';

class GamesNotifier extends StateNotifier<List<Game>> {
  GamesNotifier() : super([]);


}

final gamesProvider = StateNotifierProvider<GamesNotifier, List<Game>>((ref) => GamesNotifier());