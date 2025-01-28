import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';
import 'package:gestion_juegos/util/style_constants.dart';


class Details extends ConsumerWidget {
  Details({super.key});

  final List<String> _scoreValues = ["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0", "Sin seleccionar"];
  final TextEditingController _timePlayedCtrll = TextEditingController();
  late double marginSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Game game = ref.read(gamesProvider.notifier).currentGame!;
    final UserGame? userGame = ref.watch(userGameProvider(game.idGame));
    _timePlayedCtrll.text = "${userGame?.timePlayed}";
    marginSize = MediaQuery.of(context).size.width <= 600 ? compactMargin : normalMargin;

    // TODO con el movil rotado el formulario entra en las tabbars
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(game.title),
          actions: userGame == null
            ? null
            : [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("¿Borrar ${game.title} de la colección?"),
                        content: Text("Esta acción no se puede deshacer"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("Cancelar")
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(userGamesProvider.notifier).deleteUserGame(userGame);
                              Navigator.of(context).pop(true);
                            },
                            child: Text("Aceptar")
                          ),
                        ],
                      ),
                    ).then((value) {
                      if (value == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Juego borrado de la colección")
                        )
                      );
                      }
                    });
                  },
                  icon: Icon(Icons.delete)
                )
              ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: marginSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image(
                        image: MemoryImage(game.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: userGame == null
                        ? ElevatedButton( // Boton para registra un userGame si no existe
                            onPressed: () {
                              ref.read(userGamesProvider.notifier).insertUserGame(game.idGame);
                            },
                            child: Text("Añadir a la lista")
                          )
                        : Column( // Si userGame existe
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                spacing: 15,
                                children: [
                                  Text("Nota"),
                                  DropdownButton<String>(
                                    padding: EdgeInsets.all(5),
                                    value: userGame.score == null ? _scoreValues.last : "${userGame.score}",
                                    items: _scoreValues.map((String score) =>
                                      DropdownMenuItem<String>(
                                        value: score,
                                        child: Text(score)
                                      )).toList(),
                                    onChanged: (value) {
                                      userGame.score = value == _scoreValues.last ? null : int.parse(value!);
                                      ref.read(userGamesProvider.notifier).updateUserGame(userGame);
                                    },
                                  )
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Text("Estado"),
                                  DropdownButton<GameStates>(
                                    value: userGame.gameState,
                                    items: GameStates.values.map((GameStates gameState) {
                                      return DropdownMenuItem<GameStates>(
                                        value: gameState,
                                        child: Text(gameState.name.replaceAll("_", " ").toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      userGame.gameState = value!;
                                      ref.read(userGamesProvider.notifier).updateUserGame(userGame);
                                    },
                                  )
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Text("Tiempo jugado"),
                                  SizedBox(
                                    width: 75,
                                    child: TextField(
                                      controller: _timePlayedCtrll,
                                      decoration: InputDecoration(
                                        suffixText: "h"
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        userGame.timePlayed = value.isEmpty ? 0 : int.parse(value);
                                      },
                                      onSubmitted: (value) {
                                        ref.read(userGamesProvider.notifier).updateUserGame(userGame);
                                      },
                                      onTapOutside: (event) {
                                        ref.read(userGamesProvider.notifier).updateUserGame(userGame);
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                    )
                  ],
                ),
              ),
              TabBar(
                tabs: <Tab>[
                  Tab(text: "Descripcion"),
                  Tab(text: "Detalles"),
                  Tab(text: "Lanzamientos")
                ]
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(child: Text(game.description)),
                    SingleChildScrollView(child: Text(game.details)),
                    SingleChildScrollView(child: Text(game.releases))
                  ]
                )
              ),
            ],
          )
        )
      ),
    );
  }
}