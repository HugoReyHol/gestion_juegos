import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gestion_juegos/models/game.dart';
import 'game_widget.dart';

class GameGridWidget extends StatelessWidget {
  final List<Game> _games;

  const GameGridWidget({super.key, required games}) : _games = games;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AlignedGridView.extent(
        maxCrossAxisExtent: 264,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemCount: _games.length,
        itemBuilder: (context, index) => GameWidget(game: _games[index], layoutMode: LayoutMode.vertical),
      ),
    );
  }
}