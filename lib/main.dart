import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/screens/app.dart';
import 'package:gestion_juegos/screens/details.dart';
import 'package:gestion_juegos/screens/login.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

/// La clase principal del programa
class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

/// El estado de la clase principal MainApp
class _MainAppState extends ConsumerState<MainApp> {
  late Future<bool> futureUser;

  // Obtiene el usuario guardado en shared preferences
  @override
  void initState() {
    super.initState();
    futureUser = ref.read(userProvider.notifier).getSavedUser();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        "/": (context) => FutureBuilder(
          future: futureUser,
          builder: (context, snapshot) {
            // Mientras obtiene el usuario muestra un circulo de carga
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Si hubiese un error va a la pantalla de login
            if (snapshot.hasError) {
              return Login();
            }

            // Cuando ha cargado si hay un usuario guardado entra en App y si no en Login
            if (snapshot.hasData) {
              return snapshot.data! ? App() : Login();
            }

            return Placeholder();
          },
        ),
        "/login": (context) => Login(),
        "/app": (context) => App(),
        "/details": (context) => Details()
      },
    );
  }
}