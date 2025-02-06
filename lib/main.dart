import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/screens/app.dart';
import 'package:gestion_juegos/screens/details.dart';
import 'package:gestion_juegos/screens/login.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late Future<bool> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = ref.read(userProvider.notifier).getSavedUser();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => FutureBuilder(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }

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