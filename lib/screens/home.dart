import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_grid_widget.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/home_providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>{
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final selectedState = ref.watch(stateProvider);
    final gamesNotifier = ref.read(gamesProvider.notifier);
    final homeGames = ref.watch(homeGamesProvider);

    return Column(
      spacing: 15,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15,
            children: [
              if (!focusNode.hasFocus) Card(
                elevation: 5,
                child: DropdownButton<GameStates>(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  value: selectedState,
                  items: GameStates.values.map((GameStates gameState) {
                    return DropdownMenuItem<GameStates>(
                      value: gameState,
                      child: Text(gameState.name.replaceAll("_", " ").toUpperCase())
                    );
                  }).toList(),
                  onChanged: (GameStates? gameState) {
                    ref.read(stateProvider.notifier).state = gameState!;
                  }
                )
              ),
              Expanded(
                child: SearchBar(
                  focusNode: focusNode,
                  elevation: WidgetStatePropertyAll(5),
                  leading: Icon(Icons.search),
                  hintText: "Busca el nombre de un juego",
                  onChanged: (value) {
                    gamesNotifier.filterGamesByTitle(value);
                  },
                  onTap: () {
                    setState(() {});
                  },
                  onTapOutside: (_) {
                    setState(() {
                      focusNode.unfocus();
                    });
                  },
                  onSubmitted: (_) {
                    setState(() {
                      focusNode.unfocus();
                    });
                  },
                )
              )
            ],
          ),
        ),
        GameGridWidget(
            games: homeGames
        )
      ]
    );
  }


}