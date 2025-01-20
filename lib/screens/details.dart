import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
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
  final List<String> _scoreValues = ["Sin seleccionar", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"].reversed.toList();
  final TextEditingController _timePlayedCtrll = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void _loadGameInfo() async {
    if (_userGame != null) return;

    _userGame = ModalRoute.of(context)?.settings.arguments as UserGame;
    _game = await GameDao.getGameById(_userGame!.idGame);
    _timePlayedCtrll.text = "${_userGame!.timePlayed}";

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadGameInfo();

    return _loading ? Text("Cargando") :
      Scaffold(
        appBar: AppBar(
          title: Text(_game!.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            spacing: 15,
            children: [
              Row(
                spacing: 15,
                children: [
                  Image.memory(_game!.image),
                  Column(
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
                                _userGame!.state = value;
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
                                setState(() {
                                  _userGame!.timePlayed = int.parse(_timePlayedCtrll.text);
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
              DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      tabs: <Tab>[
                        Tab(text: "Descripcion"),
                        Tab(text: "Detalles"),
                        Tab(text: "Lanzamientos"),
                      ]
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      Text(_game!.description),
                      Text(_game!.details),
                      Text(_game!.releases)
                    ]
                  ),
                )
              )
            ],
          )
        ),
      );
      // : Scaffold(
      //     appBar: AppBar(
      //       title: Text(_game!.title),
      //       centerTitle: true,
      //     ),
      //     body: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       spacing: 15,
      //       children: [
      //         Row(
      //           spacing: 15,
      //           children: [
      //             Image.memory(_game!.image),
      //             Column(
      //               spacing: 15,
      //               children: [
      //                 Expanded(child: Row(
      //                   spacing: 15,
      //                   children: [
      //                     Text("Nota"),
      //                     Expanded(
      //                         child: TextField(
      //                             controller: _scoreCtrll,
      //                             keyboardType: TextInputType.number,
      //                             inputFormatters: [
      //                               FilteringTextInputFormatter.digitsOnly
      //                             ],
      //                             onChanged: (value) {
      //                               // TODO lógica actualizar userGame y DB
      //                               print("Cambiado nota");
      //                             }
      //                         )
      //                     )
      //                   ],
      //                 ))
      //                 // Row(
      //                 //   spacing: 15,
      //                 //   children: [
      //                 //     Text("Nota"),
      //                 //     Expanded(
      //                 //       child: TextField(
      //                 //         controller: _scoreCtrll,
      //                 //         keyboardType: TextInputType.number,
      //                 //         inputFormatters: [
      //                 //           FilteringTextInputFormatter.digitsOnly
      //                 //         ],
      //                 //         onChanged: (value) {
      //                 //           // TODO lógica actualizar userGame y DB
      //                 //           print("Cambiado nota");
      //                 //         }
      //                 //       )
      //                 //     )
      //                 //   ],
      //                 // )
      //               ],
      //             )
      //           ],
      //         )
      //       ],
      //     ),
      // );
  }
}
