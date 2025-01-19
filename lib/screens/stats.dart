import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user.dart';

class Stats extends StatelessWidget {
  final User user;

  const Stats({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Text("STATS");
  }
}
