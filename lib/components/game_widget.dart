import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:gestion_juegos/util/style_constants.dart';

enum LayoutMode {vertical, horizontal, statsCompact, statsNormal}

class GameWidget extends ConsumerWidget {
  final Game _game;
  final LayoutMode layoutMode;

  const GameWidget({super.key, required Game game, required this.layoutMode}) : _game = game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (layoutMode) {
      case LayoutMode.vertical: return _buildVertical(context, ref);
      case LayoutMode.horizontal: return _buildHorizontal(context, ref);
      case LayoutMode.statsCompact: return _buildStatsCompact(context, ref);
      case LayoutMode.statsNormal: return _buildStatsNormal(context, ref);
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
    bool isCompact = MediaQuery.sizeOf(context).width <= 600;
    final Color color = Theme.of(context).textTheme.bodyMedium!.color!;

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
                          style: TextStyle(
                            fontSize: isCompact ? compactTitle : normalTitle,
                            fontWeight: FontWeight.bold
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                        ),
                        Divider(),
                        Expanded(
                          child: !isCompact
                            ? Text(
                                _game.description,
                                style: TextStyle(fontSize: normalText),
                                overflow: TextOverflow.fade
                              )
                            : RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Dev: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: compactText, color: color)
                                    ),
                                    TextSpan(
                                      text: "${_game.getDeveloper()}\n",
                                      style: TextStyle(fontSize: compactText, color: color)
                                    ),
                                    TextSpan(
                                      text: "Pub: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: compactText, color: color)
                                    ),
                                    TextSpan(
                                      text: _game.getPublisher(),
                                      style: TextStyle(fontSize: compactText, color: color)
                                    ),
                                  ]
                                ),
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

  Widget _buildStatsCompact(BuildContext context, WidgetRef ref) {
    final UserGame? userGame = ref.watch(userGameProvider(_game.idGame));
    final Color color = Theme.of(context).textTheme.bodyMedium!.color!;

    return AspectRatio(
      aspectRatio: 2.5,
      child: GestureDetector(
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
                      style: TextStyle(
                        fontSize: compactTitle,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    ),
                    Divider(),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Dev: ",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: compactText, color: color)
                            ),
                            TextSpan(
                              text: "${_game.getDeveloper()}\n",
                              style: TextStyle(fontSize: compactText, color: color)
                            ),
                            TextSpan(
                              text: "Pub: ",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: compactText, color: color)
                            ),
                            TextSpan(
                              text: _game.getPublisher(),
                              style: TextStyle(fontSize: compactText, color: color)
                            ),
                          ]
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 15, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Last update: ",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: compactText, color: color),
                                ),
                                TextSpan(
                                  text: "${userGame?.lastChange.spanishDateTime()}",
                                  style: TextStyle(fontSize: compactText, color: color)
                                )
                              ]
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]
          )
        )
      ),
    );
  }

  Widget _buildStatsNormal(BuildContext context, WidgetRef ref) {
    final UserGame? userGame = ref.watch(userGameProvider(_game.idGame));
    final Color color = Theme.of(context).textTheme.bodyMedium!.color!;

    return AspectRatio(
      aspectRatio: 2.5,
      child: GestureDetector(
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
                      style: TextStyle(
                        fontSize: normalTitle,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    ),
                    Divider(),
                    Expanded(
                      child: Text(
                        _game.description,
                        style: TextStyle(fontSize: normalText),
                        overflow: TextOverflow.fade
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 15, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Last update: ",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: normalText, color: color),
                                ),
                                TextSpan(
                                  text: "${userGame?.lastChange.spanishDateTime()}",
                                  style: TextStyle(fontSize: normalText, color: color)
                                )
                              ]
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]
          )
        )
      ),
    );
  }

}

