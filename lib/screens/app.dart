import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/screens/search.dart';
import 'package:gestion_juegos/screens/stats.dart';
import 'package:gestion_juegos/screens/home.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final List<Widget> _screens = [Home(), Search(), Stats()];
  int _actualScren = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: _screens[_actualScren]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.table_chart_outlined), activeIcon: Icon(Icons.table_chart), label: "Estadísticas"),
        ],
        currentIndex: _actualScren,
        onTap: (value) {
          setState(() {
            ref.read(gamesProvider.notifier).resetGames();
            _actualScren = value;
          });
        },
      ),
    );
  }
}

