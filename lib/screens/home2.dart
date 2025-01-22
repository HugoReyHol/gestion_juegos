import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/game.dart';
import '../components/game_grid_widget.dart';
import '../models/user_game.dart';
import '../providers/user_games_provider.dart';

class Home2 extends ConsumerWidget {
  States _selectedState = States.playing;
  final TextEditingController _searchCtrll = TextEditingController();

  // List<Game> userGames2Games(List<UserGame> userGames) {
  //   List<Game> games = [];
  //   Game game;
  //
  //   // TODO buscar forma de pasar de userGame a game
  //   // TODO arreglar se devuelve games antes de acabar el forEach
  //   userGames.forEach((element) async{
  //     game = (await GameDao.getGameById(element.idGame))!;
  //     games.add(game);
  //   });
  //
  //   print("Cantidad de UserGames ${userGames.length}");
  //   print("Cantidad de games ${games.length}");
  //
  //   return games;
  // }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGames = ref.watch(userGamesProvider);

    return FutureBuilder(
      future: ref.read(userGamesProvider.notifier).userGames2Games(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            spacing: 15,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<States>(
                        value: _selectedState,
                        items: States.values.map((States state) {
                          return DropdownMenuItem<States>(
                            value: state,
                            child: Text(state.name.replaceAll("_", " ").toUpperCase())
                          );
                        }).toList(),
                        onChanged: (States? state) {
                          _selectedState = state!;

                          ref.read(userGamesProvider.notifier).filterUserGames(UserDao.user.idUser!, _selectedState);
                        }
                      )
                    ),
                  ),
                  Expanded(
                    child: SearchBar(
                      elevation: WidgetStatePropertyAll(5),
                      controller: _searchCtrll,
                      leading: Icon(Icons.search),
                      hintText: "Busca el nombre de un juego",
                      onChanged: (_) {
                        // TODO lógica de filtar lista juegos
                      },
                    )
                  )
                ],
              ),
              GameGridWidget(
                games: snapshot.data!,
              )
            ]
          );
        }
      },
    );
  }
}

//
// Column(
// spacing: 15,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// spacing: 15,
// children: [
// Card(
// elevation: 5,
// child: Padding(
// padding: EdgeInsets.all(10),
// child: DropdownButton<States>(
// value: _selectedState,
// items: States.values.map((States state) {
// return DropdownMenuItem<States>(
// value: state,
// child: Text(state.name.replaceAll("_", " ").toUpperCase())
// );
// }).toList(),
// onChanged: (States? state) {
// _selectedState = state!;
//
// ref.read(userGamesProvider.notifier).filterUserGames(UserDao.user.idUser!, _selectedState);
// }
// )
// ),
// ),
// Expanded(
// child: SearchBar(
// elevation: WidgetStatePropertyAll(5),
// controller: _searchCtrll,
// leading: Icon(Icons.search),
// hintText: "Busca el nombre de un juego",
// onChanged: (_) {
// // TODO lógica de filtar lista juegos
// },
// )
// )
// ],
// ),
// GameGridWidget(
// games: userGames2Games(userGames),
// )
// ]
// );