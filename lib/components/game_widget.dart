import 'package:flutter/material.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/models/game.dart';

class GameWidget extends StatefulWidget {
  final Game _game;

  const GameWidget({super.key, required Game game}) : _game = game;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/details", arguments: {"game": widget._game}),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(widget._game.image),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(widget._game.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis, )
            )
          ],
        ),
      ),
    );
  }
}
