import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_grid_widget.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/home_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gestion_juegos/util/extensions.dart';

/// La pantalla inicial de la aplicación
///
/// Muestra los juegos que el usuario ha añadido a su colección y tiene un filtro
/// para organizarlos por categorías
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>{
  final FocusNode focusNode = FocusNode();
  late bool isCompact;


  @override
  void initState() {
    super.initState();

    // Actualiza el estado del widget cuando la searchBar obtiene el foco
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedState = ref.watch(stateProvider);
    final gamesNotifier = ref.read(gamesProvider.notifier);
    final homeGames = ref.watch(homeGamesProvider);
    isCompact = MediaQuery.sizeOf(context).width <= 600;
    final loc = AppLocalizations.of(context)!;

    return Column(
      spacing: 15,
      children: [
        Flexible(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15,
            children: [
              // Si la app es compacta y la searchBar tiene el foco no se muestra
              // el selector para que la esta ocupe toda la pantalla
              if (!(focusNode.hasFocus && isCompact)) Card(
                elevation: 5,
                // Selector para las distintas categorías
                child: DropdownButton<GameStates?>(
                  key: Key("dropdown"),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  value: selectedState,
                  items: GameStates.values.map((GameStates gameState) {
                    return DropdownMenuItem<GameStates>(
                      value: gameState,
                      child: Text(gameState.localize(context).toUpperCase())
                    );
                  }).followedBy([DropdownMenuItem<GameStates>(
                    key: Key("all_games"),
                    value: null,
                    child: Text(loc.home_all)
                  )]).toList(),
                  onChanged: (GameStates? gameState) {
                    ref.read(stateProvider.notifier).state = gameState;
                  }
                )
              ),
              Expanded(
                child: SearchBar(
                  focusNode: focusNode,
                  elevation: WidgetStatePropertyAll(5),
                  leading: Icon(Icons.search),
                  hintText: loc.search_bar,
                  onChanged: (value) {
                    gamesNotifier.filterGamesByTitle(value);
                  },
                  onTapOutside: (event) { // Necesario para Android
                    focusNode.unfocus();
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