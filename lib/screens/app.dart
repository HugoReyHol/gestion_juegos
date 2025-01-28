import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/screens/search.dart';
import 'package:gestion_juegos/screens/stats.dart';
import 'package:gestion_juegos/screens/home.dart';
import 'package:gestion_juegos/util/style_constants.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final List<Widget> _screens = [Home(), Search(), Stats()];
  int _actualScreen = 0;
  late bool _isCompact;
  late double _marginSize;

  // TODO hacer que al pasar de ancho se abra ventana lateral en vez del NavigationBar
  @override
  Widget build(BuildContext context) {
    _isCompact = MediaQuery.of(context).size.width <= 600;
    _marginSize = _isCompact ? compactMargin : normalMargin;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: _marginSize),
          child: _screens[_actualScreen]
        ),
      ),
      bottomNavigationBar: _isCompact ? BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.table_chart_outlined), activeIcon: Icon(Icons.table_chart), label: "Estadísticas"),
        ],
        currentIndex: _actualScreen,
        onTap: (value) {
          changeScreen(value);
        },
      ) : null,
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text("Ventanas"),
            ),
            Divider(),
            ListTile(
              selected: _actualScreen == 0,
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: () => changeScreen(0),
            ),
            ListTile(
              selected: _actualScreen == 1,
              leading: Icon(Icons.search),
              title: Text("Buscar"),
              onTap: () => changeScreen(1),
            ),
            ListTile(
              selected: _actualScreen == 2,
              leading: Icon(Icons.table_chart),
              title: Text("Estadísticas"),
              onTap: () => changeScreen(2),
            ),
          ],
        ),
      ),
    );
  }

  void changeScreen(int screen) {
    setState(() {
      ref.read(gamesProvider.notifier).resetGames();
      _actualScreen = screen;
    });
  }
}
