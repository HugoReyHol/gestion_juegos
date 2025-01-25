import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/providers/games_provider.dart';

class Search extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    final gamesNotifer = ref.read(gamesProvider.notifier);

    return Column(
      spacing: 15,
      children: [
        Row(
          children: [
            Expanded(
              child: SearchBar(
                elevation: WidgetStatePropertyAll(5),
                leading: Icon(Icons.search),
                hintText: "Busca el nombre de un juego",
                onChanged: (value) {
                  gamesNotifer.filterGamesByTitle(value);
                },
              )
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) => GameWidget(game: games[index], layoutMode: LayoutMode.horizontal),
          )
        ),
      ],
    );
  }
}