import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    _isCompact = MediaQuery.of(context).size.width <= 600;
    _marginSize = _isCompact ? compactMargin : normalMargin;

    // TODO hacer que la navbar y el navrail tengan los mismos colores
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isCompact) NavigationRail(
              labelType: NavigationRailLabelType.all,
              elevation: 5,
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text("Inicio")),
                NavigationRailDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: Text("Buscar")),
                NavigationRailDestination(icon: Icon(Icons.table_chart_outlined), selectedIcon: Icon(Icons.table_chart), label: Text("Estadísticas"))
              ],
              trailing: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                        child: Column(
                          children: [
                            Icon(
                              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                              size: 24,
                              // color: Theme.of(context).,
                            ),
                            Text(
                              isDarkTheme ? "Light mode" : "Dark mode",
                              // style: TextStyle(color: Colors.black),
                            )
                          ],
                        )
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(userProvider.notifier).deleteSavedUser(context);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 24,
                              // color: Colors.black,
                            ),
                            Text(
                              "Logout",
                              // style: TextStyle(color: Colors.black),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
              selectedIndex: _actualScreen,
              onDestinationSelected: (value) {
                changeScreen(value);
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: _marginSize),
                child: _screens[_actualScreen]
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isCompact ? BottomNavigationBar(
        elevation: 5,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: "Perfil"),
        ],
        currentIndex: _actualScreen,
        onTap: (value) {
          changeScreen(value);
        },
      ) : null,
    );
  }

  void changeScreen(int screen) {
    setState(() {
      ref.read(gamesProvider.notifier).resetGames();
      _actualScreen = screen;
    });
  }
}
