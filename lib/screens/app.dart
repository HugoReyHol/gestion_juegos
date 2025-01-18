import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final User user;

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)?.settings.arguments as User;
    print(user.toMap());

    return const Placeholder();
  }
}

