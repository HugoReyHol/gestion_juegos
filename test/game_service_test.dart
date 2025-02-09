import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/services/game_service.dart';

void main() {
  test("Get games", () async {
    final games = await GameService.getGames();

    print(games.length);

    for (var game in games) {
      print(game.title);
    }
  });
}