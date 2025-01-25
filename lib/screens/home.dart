import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_grid_widget.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/screens_providers.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';

class Home extends ConsumerWidget {
  States _selectedState = States.playing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGamesNotifier = ref.read(userGamesProvider.notifier);
    final gamesNotifier = ref.read(gamesProvider.notifier);
    final homeGames = ref.watch(homeGamesProvider);

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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                value: _selectedState,
                items: States.values.map((States state) {
                  return DropdownMenuItem<States>(
                    value: state,
                    child: Text(state.name.replaceAll("_", " ").toUpperCase())
                  );
                }).toList(),
                onChanged: (States? state) {
                  _selectedState = state!;

                  userGamesNotifier.filterUserGames(_selectedState);
                }
              )
            ),
            Expanded(
              child: SearchBar(
                elevation: WidgetStatePropertyAll(5),
                leading: Icon(Icons.search),
                hintText: "Busca el nombre de un juego",
                onChanged: (value) {
                  print(value);
                  gamesNotifier.filterGamesByTitle(value);
                },
              )
            )
          ],
        ),
        GameGridWidget(
          games: homeGames
        )
      ]
    );
  }
}