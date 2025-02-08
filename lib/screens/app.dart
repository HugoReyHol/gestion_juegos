import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/games_provider.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/screens/search.dart';
import 'package:gestion_juegos/screens/stats.dart';
import 'package:gestion_juegos/screens/home.dart';
import 'package:gestion_juegos/util/style_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// La pantalla principal de la app
///
/// Contiene la navegación para desplazarse entre las pantallas home, search y
/// stats
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
    _isCompact = MediaQuery.sizeOf(context).width <= 600;
    _marginSize = _isCompact ? compactMargin : normalMargin;
    final Color color = Theme.of(context).textTheme.bodyMedium!.color!;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Si la app no es compacta usa un navigation rail en la izquierda
            // de la ventana
            if (!_isCompact) NavigationRail(
              key: Key("nav_rail"),
              labelType: NavigationRailLabelType.all,
              elevation: 5,
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text(loc.app_home)),
                NavigationRailDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: Text(loc.app_search)),
                NavigationRailDestination(icon: Icon(Icons.table_chart_outlined), selectedIcon: Icon(Icons.table_chart), label: Text(loc.app_stats))
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
                              color: color
                            ),
                            Text(
                              isDarkTheme ? loc.l_mode : loc.d_mode,
                              style: TextStyle(color: color),
                            )
                          ],
                        )
                      ),
                      TextButton(
                        key: Key("logout"),
                        onPressed: () {
                          ref.read(userProvider.notifier).deleteSavedUser(context);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 24,
                              color: color
                            ),
                            Text(
                              loc.logout,
                              style: TextStyle(color: color),
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
            // Las sub-pantallas de la app
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: _marginSize),
                child: _screens[_actualScreen]
              ),
            ),
          ],
        ),
      ),
      // Si la app es compacta usa un navbar
      bottomNavigationBar: _isCompact ? BottomNavigationBar(
        elevation: 5,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: loc.app_home),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: loc.app_search),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: loc.app_profile),
        ],
        currentIndex: _actualScreen,
        onTap: (value) {
          changeScreen(value);
        },
      ) : null,
    );
  }

  /// Cambia la ventana actual por la nuevo seleccionada
  void changeScreen(int screen) {
    setState(() {
      ref.read(gamesProvider.notifier).resetGames();
      _actualScreen = screen;
    });
  }
}
