import 'package:flutter/material.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/models/user_game.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  States _selectedState = States.playing;
  final TextEditingController _searchCtrll = TextEditingController();
  late final List<UserGame> _userGames;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() async {
    _userGames = await UserGameDao.getUserGames(widget.user.idUser!);
    setState(() {
      _loading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _loading ? Text("Cargando") :

      Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      spacing: 15,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
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
                    });
                  }
                )
              ),
            ),
            SearchBar(
              elevation: WidgetStatePropertyAll(5),
              controller: _searchCtrll,
              leading: Icon(Icons.search),
              hintText: "Busca el nombre de un juego",
              onChanged: (_) {
                // TODO lógica de filtar lista juegos
              },
            )
          ],
        ),
        Expanded(child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 264,
            childAspectRatio: 264/450,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
          ),
          itemCount: _userGames.length,
          itemBuilder: (context, index) {
            return GameWidget(userGame: _userGames[index]);
          },
        )),
        // Expanded(child: GridView.count(
        //   crossAxisSpacing: 15,
        //   mainAxisSpacing: 15,
        //   crossAxisCount: 2,
        //   children: List.generate(_userGames.length, (int index) {
        //     return GameWidget(userGame: _userGames[index]);
        //   })
        // )),
        // GameWidget(userGame: _userGames[0])
      ],
    );
  }
}

