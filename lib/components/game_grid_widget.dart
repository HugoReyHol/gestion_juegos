import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/game.dart';
import 'game_widget.dart';

class GameGridWidget extends StatelessWidget {
  final List<Game> _games;

  const GameGridWidget({super.key, required games}) : _games = games;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 264,
              childAspectRatio: 264/450,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5
          ),
          itemCount: _games.length,
          itemBuilder: (context, index) {
            return GameWidget(game: _games[index], layoutMode: LayoutMode.vertical);
          },
        )
    );
  }
}

// Expanded(child: GridView.count(
//   crossAxisSpacing: 15,
//   mainAxisSpacing: 15,
//   crossAxisCount: 2,
//   children: List.generate(_userGames.length, (int index) {
//     return GameWidget(userGame: _userGames[index]);
//   })
// )),
// GameWidget(userGame: _userGames[0])