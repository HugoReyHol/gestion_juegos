import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';

enum LayoutMode {vertical, horizontal}

class GameWidget extends ConsumerWidget {
  final Game _game;
  final LayoutMode layoutMode;

  const GameWidget({super.key, required Game game, required this.layoutMode}) : _game = game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userGamesProvider.notifier).setUserGame(_game.idGame);

    switch (layoutMode) {
      case LayoutMode.vertical: return _buildVertical(context, ref);
      case LayoutMode.horizontal: return _buildHorizontal(context, ref);
    }
  }

  Widget _buildVertical(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(gamesProvider.notifier).currentGame = _game;
        ref.read(userGamesProvider.notifier).setUserGame(_game.idGame);
        Navigator.pushNamed(context, "/details");
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: MemoryImage(_game.image),
              fit: BoxFit.cover
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(_game.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ]
        )
      )
    );
  }

  // TODO mejorar el display horizontal
  // TODO si el usuario ya tiene el juego no mostrar el boton
  Widget _buildHorizontal(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(gamesProvider.notifier).currentGame = _game;
            ref.read(userGamesProvider.notifier).setUserGame(_game.idGame);
            Navigator.pushNamed(context, "/details");
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(_game.image),
                Expanded(
                  child: SizedBox(
                    height: 352,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_game.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                        Divider(),
                        Expanded(child: Text(_game.description, style: TextStyle(fontSize: 18, ), overflow: TextOverflow.fade))
                      ],
                    ),
                  )
                )
              ]
            )
          )
        ),
        if (ref.read(userGamesProvider.notifier).currentUserGame == null) Padding(
          padding: const EdgeInsets.all(15),
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () {
              print("Logica añadir juego");
              print("Pulsado ${_game.title}");
            }
          ),
        )
      ]
    );
  }
}