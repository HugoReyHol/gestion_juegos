import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/providers/stats_provider.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:gestion_juegos/util/style_constants.dart';

class Stats extends ConsumerWidget {
  Stats({super.key});
  late bool isCompact;

  // TODO Si no es compact dividir las stats en 2 columnas
  // TODO Hacer más bonitas las cards de StatInfo
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStats = ref.watch(statsProvider);
    final lastGames = ref.watch(lastGamesProvider(isCompact ? 2 : 4));
    isCompact = MediaQuery.of(context).size.width <= 600;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last updates:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: compactTitle
            ),
          ),
          Divider(),
          for (var game in lastGames) GameWidget(
            game: game,
            layoutMode: LayoutMode.stats
          ),
          SizedBox(height: 15,),
          Text(
            "Statistics:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: compactTitle
            ),
          ),
          Divider(),
          for (var key in gameStats.keys) StatInfo(
            text: key,
            value: gameStats[key]
          ),
        ],
      ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text.capitalize().replaceAll("_", " "),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(value == -1 ? "None" : "$value")
          ],
        ),
      ),
    );
  }
}