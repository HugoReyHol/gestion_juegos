import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/stats_provider.dart';
import 'package:gestion_juegos/util/string_extensions.dart';

class Stats extends ConsumerWidget {
  const Stats({super.key});

  // TODO Si no es compact dividir las stats en 2 columnas
  // TODO Agregar 3 últimos juegos modificados
  // TODO Hacer más bonitas las cards de StatInfo
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStats = ref.watch(statsProvider);
    final lastGames = ref.watch(lastGamesProvider(3));

    return ListView.builder(
      itemCount: gameStats.length,
      itemBuilder: (context, index) {
        final actualItem = gameStats.keys.elementAt(index);

        return StatInfo(text: actualItem, value: gameStats[actualItem]);
      },
    );
  }
}

class StatInfo extends StatelessWidget {
  final String text;
  final dynamic value;

  const StatInfo({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text.capitalize().replaceAll("_", " ")),
            Text(value == -1 ? "None" : "$value")
          ],
        ),
      ),
    );
  }
}