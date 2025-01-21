import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Game? _game;
  UserGame? _userGame;
  bool _loading = true;
  final List<String> _scoreValues = ["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0", "Sin seleccionar"];
  final TextEditingController _timePlayedCtrll = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void _loadGameInfo() async {
    if (!_loading) return;
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    _userGame = args["userGame"] != null ? args["userGame"] as UserGame : null;
    _game = args["game"] != null ? args["game"] as Game : null;

    // Si se pasa el userGame y game es null se carga su game
    _game ??= await GameDao.getGameById(_userGame!.idGame);

    // Si se pasa el game y existe userGame se carga el userGame si no existe userGame se queda null
    _userGame ??= await UserGameDao.getUserGame(UserDao.user.idUser!, _game!.idGame);

    _timePlayedCtrll.text = "${_userGame?.timePlayed}";

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadGameInfo();

    return _loading
      ? Text("Cargando")
      : Scaffold(
        appBar: AppBar(
          title: Text(_game!.title),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
          child: Column(
            spacing: 15,
            children: [
              Row(
                spacing: 15,
                children: [
                  Image.memory(_game!.image),
                  _userGame == null ?
                  ElevatedButton( // Boton para registra un _userGame si no existe
                    onPressed: () {
                      _userGame = UserGame(idGame: _game!.idGame, idUser: UserDao.user.idUser!);
                      UserGameDao.insertUserGame(_userGame!);

                      _timePlayedCtrll.text = "0";

                      setState(() {});
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
                            value: _userGame!.score == null ? "Sin seleccionar" : "${_userGame!.score}",
                            items: _scoreValues.map((String score) =>
                              DropdownMenuItem<String>(
                                value: score,
                                child: Text(score)
                              )
                            ).toList(),
                            onChanged: (value) {
                              // TODO implementar lógica para cambiar la nota
                              setState(() {
                                _userGame!.score = value == "Sin seleccionar" ? null : int.parse(value!);
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        spacing: 15,
                        children: [
                          Text("Estado"),
                          DropdownButton<States>(
                            value: _userGame!.state,
                            items: States.values.map((States state) {
                              return DropdownMenuItem<States>(
                                  value: state,
                                  child: Text(state.name.replaceAll("_", " ").toUpperCase())
                              );
                            }).toList(),
                            onChanged: (value) {
                              // TODO implementar lógica para cambiar el estado
                              setState(() {
                                _userGame!.state = value!;
                              });
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
                                // TODO logica de cambiar tiempo jugado
                                if (_timePlayedCtrll.text.isEmpty) return;

                                setState(() {
                                  _userGame!.timePlayed = int.parse(_timePlayedCtrll.text);
                                  _timePlayedCtrll.text = "${_userGame!.timePlayed}";
                                });
                              },
                              onSubmitted: (value) {
                                // TODO copiar logica onChanged
                                // TODO logica de cambiar tiempo jugado
                                if (_timePlayedCtrll.text.isEmpty) return;

                                setState(() {
                                  _userGame!.timePlayed = int.parse(_timePlayedCtrll.text);
                                  _timePlayedCtrll.text = "${_userGame!.timePlayed}";
                                });
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
                      TabBar(tabs:
                      <Tab>[
                        Tab(text: "Descripcion"),
                        Tab(text: "Detalles"),
                        Tab(text: "Lanzamientos")
                      ]
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Text(_game!.description),
                            Text(_game!.details),
                            Text(_game!.releases)
                          ]
                        )
                      )
                    ],
                  )
                )
              ),
            ],
          )
        ),
      );
  }
}
