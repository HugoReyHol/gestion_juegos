import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/stats_provider.dart';

class Stats extends ConsumerWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStats = ref.watch(statsProvider);

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
  String text;
  final dynamic value;

  StatInfo({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    text = text[0].toUpperCase() + text.substring(1);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text.replaceAll("_", " ")),
            Text(value == -1 ? "None" : "$value")
          ],
        ),
      ),
    );
  }
}