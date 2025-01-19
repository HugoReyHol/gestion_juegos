import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user.dart';

class Search extends StatefulWidget {
  final User user;

  const Search({super.key, required this.user});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Text("SEARCH");
  }
}
