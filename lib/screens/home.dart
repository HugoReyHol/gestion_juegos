import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_grid_widget.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';


class Home extends ConsumerWidget {
  States _selectedState = States.playing;
  final TextEditingController _searchCtrll = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGames = ref.watch(userGamesProvider);
    final userNotifier = ref.read(userGamesProvider.notifier);

    return Column(
      spacing: 15,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 15,
          children: [
            Card(
              elevation: 5,
              child: DropdownButton<States>(
                  padding: EdgeInsets.all(10),
                  value: _selectedState,
                  items: States.values.map((States state) {
                    return DropdownMenuItem<States>(
                        value: state,
                        child: Text(state.name.replaceAll("_", " ").toUpperCase())
                    );
                  }).toList(),
                  onChanged: (States? state) {
                    _selectedState = state!;

                    userNotifier.filterUserGames(UserDao.user.idUser!, _selectedState);
                  }
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
        FutureBuilder(
          future: userNotifier.userGames2Games(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return GameGridWidget(
              games: snapshot.data!,
            );
          },
        ),
      ]
    );
  }
}