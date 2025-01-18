import 'package:flutter/material.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/models/game.dart';

class GameWidget extends StatefulWidget {
  final UserGame userGame;

  const GameWidget({super.key, required this.userGame});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  late final Game game;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  void _loadGame() async{
    game = (await GameDao.getGameById(widget.userGame.idGame))!;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading ?
      Text("Cargando") :
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(game.image),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(game.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), softWrap: true)
            )
          ],
        ),
      );
  }
}
