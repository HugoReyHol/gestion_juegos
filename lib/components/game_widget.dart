import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';

enum LayoutMode {vertical, horizontal}

class GameWidget extends ConsumerWidget {
  final Game _game;
  final LayoutMode layoutMode;

  const GameWidget({super.key, required Game game, required this.layoutMode}) : _game = game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (layoutMode) {
      case LayoutMode.vertical: return _buildVertical(context, ref);
      case LayoutMode.horizontal: return _buildHorizontal(context, ref);
    }
  }

  Widget _buildVertical(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(gamesProvider.notifier).currentGame = _game;
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

  Widget _buildHorizontal(BuildContext context, WidgetRef ref) {
    final userGamesNotifier = ref.read(userGamesProvider.notifier);
    final UserGame? userGame = ref.watch(userGameProvider(_game.idGame));
    bool isCompact = MediaQuery.of(context).size.width <= 600;

    return AspectRatio(
      aspectRatio: 2.5,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(gamesProvider.notifier).currentGame = _game;
              Navigator.pushNamed(context, "/details");
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: Image(
                      image: MemoryImage(_game.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _game.title,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                        ),
                        Divider(),
                        Expanded(
                          child: Text(
                            isCompact ? _game.getDeveloper() : _game.description,
                            style: TextStyle(fontSize: 18, ),
                            overflow: TextOverflow.fade
                          )
                        )
                      ],
                    ),
                  )
                ]
              )
            )
          ),
          if (userGame == null) Padding(
            padding: const EdgeInsets.all(15),
            child: FloatingActionButton(
              mini: isCompact,
              heroTag: null,
              child: Icon(Icons.add),
              onPressed: () {
                userGamesNotifier.insertUserGame(_game.idGame);
              }
            ),
          )
        ]
      ),
    );
  }
}