import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/providers/stats_provider.dart';
import 'package:gestion_juegos/providers/theme_provider.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/util/style_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// La pantalla que hace de perfil y estadísticas
///
/// En caso de tener la app en modo compacto muestra las opciones además de
/// las últimas actualizaciones y las estadísticas
class Stats extends ConsumerWidget {
  Stats({super.key});
  late bool isCompact;
  late bool isDarkTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    isCompact = MediaQuery.sizeOf(context).width <= 600;
    isDarkTheme = ref.watch(themeProvider);

    return SingleChildScrollView(
      child: isCompact
        ? _compactStats(context, ref)
        : _normalStats(context, ref)
    );
  }

  // La versión cuando la app es compacta
  Widget _compactStats(BuildContext context, WidgetRef ref) {
    final gameStats = ref.watch(statsProvider);
    final lastGames = ref.watch(lastGamesProvider(2));
    final Color color = Theme.of(context).textTheme.bodyMedium!.color!;
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.stats_options,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: compactTitle
          ),
        ),
        Divider(),
        // Los botones para logout y cambio de tema
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              key: Key("logout"),
              label: Text(
                loc.logout,
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
                isDarkTheme ? loc.l_mode : loc.d_mode,
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
          loc.stats_updates,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: compactTitle
          ),
        ),
        Divider(),
        // Muestra los últimos juegos actualizados
        for (var game in lastGames) GameWidget(
          game: game,
          layoutMode: LayoutMode.statsCompact
        ),
        SizedBox(height: 15,),
        Text(
          loc.stats_stats,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: compactTitle
          ),
        ),
        Divider(),
        // Instancia una card para cada estadística
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
    final loc = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.stats_updates,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: normalTitle
                ),
              ),
              Divider(),
              // Muestra los últimos juegos actualizados
              for (var game in lastGames) GameWidget(
                game: game,
                layoutMode: LayoutMode.statsNormal
              )
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.stats_stats,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: normalTitle
                ),
              ),
              Divider(),
              // Instancia una card para cada estadística
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

/// Representa la información de las estadísticas
///
/// Se compone por una card que en su lado izquierdo muestra el nombre de la
/// estadística y en la derecha su valor
class StatInfo extends StatelessWidget {
  /// El nombre de la estadística
  final String text;
  /// El valor de la estadística
  final dynamic value;
  /// Si la app es compacta o no
  final bool isCompact;

  const StatInfo({super.key, required this.text, required this.value, required this.isCompact});

  // Devuelve la localización de la estadística
  String key2LocString(String key, BuildContext context) {
    switch (key) {
      case "playing": return AppLocalizations.of(context)!.state_playing;
      case "completed": return AppLocalizations.of(context)!.state_completed;
      case "on_hold": return AppLocalizations.of(context)!.state_hold;
      case "dropped": return AppLocalizations.of(context)!.state_dropped;
      case "plan_to_play": return AppLocalizations.of(context)!.state_plan;
      case "total": return AppLocalizations.of(context)!.stats_total;
      case "total_time": return AppLocalizations.of(context)!.stats_t_time;
      case "average_score": return AppLocalizations.of(context)!.stats_avg_score;
    }

    return key;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key2LocString(text, context),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? compactText : normalText
              ),
            ),
            Text(
              value == -1 ? loc.none : "$value",
              style: TextStyle(fontSize: isCompact ? compactText : normalText),
            )
          ],
        ),
      ),
    );
  }
}