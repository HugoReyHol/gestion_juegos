import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_form_widget.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';
import 'package:gestion_juegos/util/style_constants.dart';


class Details extends ConsumerStatefulWidget {
  const Details({super.key});

  @override
  ConsumerState<Details> createState() => _DetailsState();
}

class _DetailsState extends ConsumerState<Details> with TickerProviderStateMixin {

  late bool isCompact;
  late double marginSize;
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    final Game game = ref.read(gamesProvider.notifier).currentGame!;
    final UserGame? userGame = ref.watch(userGameProvider(game.idGame));
    isCompact = MediaQuery.sizeOf(context).width <= 600;
    tabController = TabController(length: isCompact ? 3 : 4, vsync: this);
    marginSize = isCompact ? compactMargin : normalMargin;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(game.title),
        actions: userGame == null
          ? null
          : [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("¿Borrar ${game.title} de la colección?"),
                      content: Text("Esta acción no se puede deshacer"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("Cancelar")
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(userGamesProvider.notifier).deleteUserGame(userGame);
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Aceptar")
                        ),
                      ],
                    ),
                  ).then((value) {
                    if (value == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Juego borrado de la colección")
                        )
                      );
                    }
                  });
                },
                icon: Icon(Icons.delete)
              )
            ],
      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: marginSize),
            child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 15,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Image(
                              image: MemoryImage(game.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: userGame == null
                              ? ElevatedButton( // Boton para registra un userGame si no existe
                                  onPressed: () {
                                    ref.read(userGamesProvider.notifier).insertUserGame(game.idGame);
                                  },
                                  child: Text("Añadir a la lista")
                                )
                              : GameFormWidget(
                                  userGame: userGame
                                ),
                          )
                        ],
                      ),
                    ),
                    TabBar(
                      controller: tabController,
                        tabs: <Tab>[
                          Tab(text: "Descripcion"),
                          Tab(text: "Detalles"),
                          Tab(text: "Lanzamientos")
                        ]
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          SingleChildScrollView(child: Text(game.description)),
                          SingleChildScrollView(child: Text(game.details)),
                          SingleChildScrollView(child: Text(game.releases))
                        ]
                      )
                    ),
                  ],
                )
              : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        Image(
                          image: MemoryImage(game.image),
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Column(
                            spacing: 15,
                            children: [
                              TabBar(
                                controller: tabController,
                                tabs: <Tab>[
                                  Tab(text: "Editar",),
                                  Tab(text: "Descripcion"),
                                  Tab(text: "Detalles"),
                                  Tab(text: "Lanzamientos")
                                ]
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  children: <Widget>[
                                    userGame == null
                                      ? Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: ElevatedButton( // Boton para registrar un userGame si no existe
                                                onPressed: () {
                                                  ref.read(userGamesProvider.notifier).insertUserGame(game.idGame);
                                                },
                                                child: Text("Añadir a la lista")
                                              ),
                                            )
                                          ],
                                        )
                                      : GameFormWidget(
                                            userGame: userGame
                                          ),
                                    SingleChildScrollView(child: Text(game.description)),
                                    SingleChildScrollView(child: Text(game.details)),
                                    SingleChildScrollView(child: Text(game.releases))
                                  ]
                                )
                              ),
                            ],
                          ),
                        )
                      ],
                    )
          ),
        )
    );
  }
}