import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_games_provider.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameFormWidget extends ConsumerWidget {
  GameFormWidget({super.key, required this.userGame});

  UserGame userGame;

  final List<String> _scoreValues = ["10", "9", "8", "7", "6", "5", "4", "3", "2", "1", "0", "No score"];
  final TextEditingController _timePlayedCtrll = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _timePlayedCtrll.text = "${userGame.timePlayed}";
    final loc = AppLocalizations.of(context)!;
    _scoreValues[_scoreValues.length-1] = loc.game_form_none;

    return Column( // Si userGame existe
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 15,
          children: [
            Text(loc.game_form_score),
            DropdownButton<String>(
              padding: EdgeInsets.all(5),
              value: userGame.score == null ? _scoreValues.last : "${userGame.score}",
              items: _scoreValues.map((String score) =>
                DropdownMenuItem<String>(
                  value: score,
                  child: Text(score)
                )).toList(),
              onChanged: (value) {
                userGame.score = value == _scoreValues.last ? null : int.parse(value!);
                ref.read(userGamesProvider.notifier).updateUserGame(userGame);
              },
            )
          ],
        ),
        Row(
          spacing: 15,
          children: [
            Text(loc.game_form_state),
            DropdownButton<GameStates>(
              value: userGame.gameState,
              items: GameStates.values.map((GameStates gameState) {
                return DropdownMenuItem<GameStates>(
                  value: gameState,
                  child: Text(gameState.localize(context).toUpperCase())
                );
              }).toList(),
              onChanged: (value) {
                userGame.gameState = value!;
                ref.read(userGamesProvider.notifier).updateUserGame(userGame);
              },
            )
          ],
        ),
        Row(
          spacing: 15,
          children: [
            Text(loc.game_form_time),
            SizedBox(
              width: 75,
              child: TextField(
                controller: _timePlayedCtrll,
                decoration: InputDecoration(
                  suffixText: loc.game_form_time_suf
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  userGame.timePlayed = value.isEmpty ? 0 : int.parse(value);
                },
                onSubmitted: (value) {
                  ref.read(userGamesProvider.notifier).updateUserGame(userGame);
                },
                onTapOutside: (event) {
                  ref.read(userGamesProvider.notifier).updateUserGame(userGame);
                },
              ),
            )
          ],
        )
      ],
    );
  }


}