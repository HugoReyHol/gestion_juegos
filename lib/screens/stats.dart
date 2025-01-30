import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/providers/stats_provider.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:gestion_juegos/util/style_constants.dart';

class Stats extends ConsumerWidget {
  Stats({super.key});
  late bool isCompact;
  late bool isDarkTheme;

  // TODO Hacer más bonitas las cards de StatInfo
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    isCompact = MediaQuery.of(context).size.width <= 600;
    isDarkTheme = ref.watch(themeProvider);

    return SingleChildScrollView(
      child: isCompact
        ? _compactStats(context, ref)
        : _normalStats(context, ref)
    );
  }

  Widget _compactStats(BuildContext context, WidgetRef ref) {
    final gameStats = ref.watch(statsProvider);
    final lastGames = ref.watch(lastGamesProvider(2));
    final Color color = Theme.of(context).textTheme.bodyMedium!.color!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Options:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: compactTitle
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              label: Text(
                "Logout",
                style: TextStyle(color: color),
              ),
              icon: Icon(
                Icons.logout,
                size: 25,
                color: color,
              ),
              onPressed: () {
                ref.read(userProvider.notifier).deleteSavedUser(context);
              },
            ),
            TextButton.icon(
              label: Text(
                isDarkTheme ? "Light mode" : "Dark mode",
                style: TextStyle(color: color),
              ),
              icon: Icon(
                isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                size: 25,
                color: color,
              ),
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            )
          ],
        ),
        SizedBox(height: 15,),
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
          layoutMode: LayoutMode.statsCompact
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
          value: gameStats[key],
          isCompact: true,
        ),
      ],
    );
  }

  Widget _normalStats(BuildContext context, WidgetRef ref) {
    final gameStats = ref.watch(statsProvider);
    final lastGames = ref.watch(lastGamesProvider(3));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Last updates:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: normalTitle
                ),
              ),
              Divider(),
              for (var game in lastGames) GameWidget(
                game: game,
                layoutMode: LayoutMode.statsNormal
              )
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Statistics:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: normalTitle
                ),
              ),
              Divider(),
              for (var key in gameStats.keys) StatInfo(
                text: key,
                value: gameStats[key],
                isCompact: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatInfo extends StatelessWidget {
  final String text;
  final dynamic value;
  final bool isCompact;

  const StatInfo({super.key, required this.text, required this.value, required this.isCompact});

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
                fontSize: isCompact ? compactText : normalText
              ),
            ),
            Text(
              value == -1 ? "None" : "$value",
              style: TextStyle(fontSize: isCompact ? compactText : normalText),
            )
          ],
        ),
      ),
    );
  }
}
