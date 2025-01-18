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
  User? _user;
  final List<Widget> _screens = [];
  int _actualScren = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user ??= ModalRoute.of(context)?.settings.arguments as User;
    _screens.addAll([Home(user: _user!), Search(user: _user!), Stats(user: _user!)]);
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

