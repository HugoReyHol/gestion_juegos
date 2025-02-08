import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extensiones para `String`
extension StringExtensions on String {

  /// Encripta un `String`
  ///
  /// Devuelve un `String` encriptado en sha256
  String encrypt() => sha256.convert(utf8.encode(this)).toString();

  /// Capitaliza un `String`
  ///
  /// Devuelve un `String` con la primera letra en mayúscula y el resto en
  /// minúsculas
  String capitalize() => this[0].toUpperCase() + substring(1).toLowerCase();

}

/// Extensiones para `GameStates`
extension GameStatesExtensions on GameStates {

  /// Localiza los valores de `GameStates`
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