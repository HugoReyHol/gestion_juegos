import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/screens/app.dart';
import 'package:gestion_juegos/screens/details.dart';
import 'package:gestion_juegos/screens/login.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => Login(),
        "/app": (context) => App(),
        "/details": (context) => Details()
      },
    );
  }
}
