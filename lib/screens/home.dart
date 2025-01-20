import 'package:flutter/material.dart';
import 'package:gestion_juegos/components/game_grid_widget.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  States _selectedState = States.playing;
  final TextEditingController _searchCtrll = TextEditingController();
  late final List<UserGame> _userGames;
  final List<Game> _filteredGames = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() async {
    _userGames = await UserGameDao.getUserGames(UserDao.user.idUser!);

    _userGames.forEach((element) async {
      if (element.state == _selectedState) {
        final Game game = await GameDao.getGameById(element.idGame) as Game;
        _filteredGames.add(game);
      }
    });

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
                    setState(() {
                      // TODO implementar lógica filtrar juegos
                      _selectedState = state!;

                      _filteredGames.clear();

                      _userGames.forEach((element) async {
                        if (element.state == _selectedState) {
                          final Game game = await GameDao.getGameById(element.idGame) as Game;
                          _filteredGames.add(game);
                        }
                      });
                    });
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
          games: _filteredGames
        )
      ]
    );
  }
}