import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';


class Details extends ConsumerWidget {
  Details({super.key});

  final List<String> _scoreValues = ["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0", "Sin seleccionar"];
  final TextEditingController _timePlayedCtrll = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Game game = ref.read(gamesProvider.notifier).currentGame!;
    final UserGame? userGame = ref.read(userGamesProvider.notifier).currentUserGame;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        actions: userGame == null
          ? null
          : [
              IconButton(
                onPressed: () async {
                  await UserGameDao.deleteUserGame(userGame);
                  // TODO funcionalidad borrar juego de la DB usando un método del provider
                },
                icon: Icon(Icons.delete)
              )
            ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
        child: Column(
          spacing: 15,
          children: [
            Row(
              spacing: 15,
              children: [
                Image.memory(game.image),
                userGame == null
                  ? ElevatedButton( // Boton para registra un _userGame si no existe
                      onPressed: () {
                        // TODO funcionalidad insertar juego de la DB usando un método del provider
                      },
                      child: Text("Añadir a la lista")
                    )
                  : Column( // Si _userGame existe
                      spacing: 15,
                      children: [
                        Row(
                          spacing: 15,
                          children: [
                            Text("Nota"),
                            DropdownButton<String>(
                              padding: EdgeInsets.all(5),
                              value: userGame.score == null ? "Sin seleccionar" : "${userGame.score}",
                              items: _scoreValues.map((String score) =>
                                DropdownMenuItem<String>(
                                  value: score,
                                  child: Text(score)
                                )).toList(),
                              onChanged: (value) {
                                userGame.score = value == "Sin seleccionar" ? null : int.parse(value!);
                                // TODO implementar lógica para cambiar la nota en el DB
                              },
                            )
                          ],
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            Text("Estado"),
                            DropdownButton<States>(
                              value: userGame.state,
                              items: States.values.map((States state) {
                                return DropdownMenuItem<States>(
                                  value: state,
                                  child: Text(state.name.replaceAll("_", " ").toUpperCase())
                                );
                              }).toList(),
                              onChanged: (value) {
                                userGame.state = value!;
                                // TODO implementar lógica para cambiar el estado en la DB
                              },
                            )
                          ],
                        ),
                        Row( // TODO hacer que empiece en el mismo sitio que el resto de componentes
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
                                  // TODO logica de cambiar tiempo jugado en la DB
                                  if (_timePlayedCtrll.text.isEmpty) return;

                                  userGame.timePlayed = int.parse(_timePlayedCtrll.text);
                                  _timePlayedCtrll.text = "${userGame.timePlayed}";
                                },
                                onSubmitted: (value) {
                                  // TODO copiar logica onChanged
                                  // TODO logica de cambiar tiempo jugado en la DB
                                  if (_timePlayedCtrll.text.isEmpty) return;

                                    userGame.timePlayed = int.parse(_timePlayedCtrll.text);
                                    _timePlayedCtrll.text = "${userGame.timePlayed}";
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    )
              ],
            ),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
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
                          Text(game.description),
                          Text(game.details),
                          Text(game.releases)
                        ]
                      )
                    )
                  ],
                )
              )
            ),
          ],
        )
      )
    );
  }
}