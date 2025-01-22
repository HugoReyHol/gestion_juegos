import 'package:flutter/material.dart';
import 'package:gestion_juegos/components/game_grid_widget.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/models/game.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late final List<Game> _games;
  final TextEditingController _searchCtrll = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() async {
    _games = await GameDao.getGames();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? Text("Cargando") :
      Column(
        spacing: 15,
        children: [
          Row(
            children: [
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
          Expanded(
            child: ListView.builder(
              itemCount: _games.length,
              itemBuilder: (context, index) => GameWidget(game: _games[index], layoutMode: LayoutMode.horizontal),
            )
          ),
        ],
      );
  }
}
