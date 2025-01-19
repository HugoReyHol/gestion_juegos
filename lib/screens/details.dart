import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
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
  final TextEditingController _scoreCtrll = TextEditingController();
  final TextEditingController _timePlayedCtrll = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void _loadGameInfo() async {
    if (_userGame != null) return;

    _userGame = ModalRoute.of(context)?.settings.arguments as UserGame;
    _game = await GameDao.getGameById(_userGame!.idGame);
    _scoreCtrll.text = "${_userGame!.score}";
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
                      Expanded(
                        child: Row(
                          spacing: 15,
                          children: [
                            Text("Nota"),
                            Expanded(
                                child: TextField(
                                  controller: _scoreCtrll,
                                  decoration: InputDecoration(
                                      labelText: "?"
                                  ),
                                )
                            )
                          ],
                        )
                      ),
                      // Row(
                      //   spacing: 15,
                      //   children: [
                      //     Text("Nota"),
                      //     Expanded(
                      //       child: TextField(
                      //         controller: _scoreCtrll,
                      //         decoration: InputDecoration(
                      //           labelText: "?"
                      //         ),
                      //       )
                      //     )
                      //   ],
                      // )
                    ],
                  )
                ],
              ),
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
