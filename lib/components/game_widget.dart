import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/game.dart';

class GameWidget extends StatelessWidget {
  final Game _game;

  const GameWidget({super.key, required Game game}) : _game = game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/details", arguments: {"game": _game}),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(_game.image),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(_game.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis, )
            )
          ],
        ),
      ),
    );
  }
}
