import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/screens/home.dart';
import 'package:gestion_juegos/screens/search.dart';
import 'package:gestion_juegos/screens/stats.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Widget> _screens = [];
  int _actualScren = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screens.addAll([Home(), Search(), Stats()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
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
            _actualScren = value;
          });
        },
      ),
    );
  }
}

