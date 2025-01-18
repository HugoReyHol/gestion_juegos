import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/models/user_game.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  States _selectedState = States.playing;
  final TextEditingController _searchCtrll = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(5, (int index) {
            return Center(child: Text("Prueba $index"));
          })
        )),
      ],
    );
  }
}

