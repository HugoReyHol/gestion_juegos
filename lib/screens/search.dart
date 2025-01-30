import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/providers/games_provider.dart';

class Search extends ConsumerWidget {
  const Search({super.key});

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
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600,
              childAspectRatio: 2.5
            ),
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemCount: games.length,
            itemBuilder: (context, index) => GameWidget(game: games[index], layoutMode: LayoutMode.horizontal),
          )
        ),
      ],
    );
  }
}