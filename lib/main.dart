import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/screens/app.dart';
import 'package:gestion_juegos/screens/details.dart';
import 'package:gestion_juegos/screens/login.dart';
import 'package:gestion_juegos/util/style_constants.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // theme: lightTheme,
      // darkTheme: darkTheme,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => FutureBuilder(
          future: ref.read(userProvider.notifier).getSavedUser(),
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
