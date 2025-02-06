import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StringExtensions on String {

  String encrypt() => sha256.convert(utf8.encode(this)).toString();

  String capitalize() => this[0].toUpperCase() + substring(1);

}

extension GameStatesExtensions on GameStates {
  String localize(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    switch (this) {
      case GameStates.playing: return loc.state_playing;
      case GameStates.completed: return loc.state_completed;
      case GameStates.on_hold: return loc.state_hold;
      case GameStates.dropped: return loc.state_dropped;
      case GameStates.plan_to_play: return loc.state_plan;
    }
  }
}