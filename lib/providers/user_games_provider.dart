import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Notifier de todos los juegos del usuario en la base de datos
///
/// Por defecto carga una lista vacía y llama a un método para cargar los juegos
/// desde la base de datos
class UserGamesNotifier extends Notifier<List<UserGame>> {

  @override
  List<UserGame> build() {
    state = [];
    _getUserGames();
    return state;
  }

  /// Método privado que carga en el state los userGames desde la base de datos
  void _getUserGames() async{
    state = await UserGameDao.getUserGames(ref.watch(userProvider)!.idUser!);
  }

  /// Método que agrega un userGame a la base de datos
  void insertUserGame(int idGame) async {
    final UserGame userGame = UserGame(idGame: idGame, idUser: ref.read(userProvider)!.idUser!, lastChange: DateTime.now());
    await UserGameDao.insertUserGame(userGame);
    state = [...state, userGame];
  }

  /// Método que actualiza un userGame de la base de datos
  void updateUserGame(UserGame userGame) async{
    userGame.lastChange = DateTime.now();
    await UserGameDao.updateUserGame(userGame);
    state.removeWhere((e) => e.idGame == userGame.idGame);
    state.add(userGame.copyWith());
    ref.notifyListeners();
  }

  /// Método que borra un userGame de la base de datos
  void deleteUserGame(UserGame userGame, BuildContext context) async {
    await UserGameDao.deleteUserGame(userGame);
    state.removeWhere((e) => e.idGame == userGame.idGame);
    ref.notifyListeners();

    // Si el juego se borra correctamente lo notifica con un snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.details_del_snckbar)
        )
      );
    }
  }
}

/// Provider de todos los juegos del usuario en la base de datos
final userGamesProvider = NotifierProvider<UserGamesNotifier, List<UserGame>>(() => UserGamesNotifier());

/// Provider de un juego del usuario individual para el game_widget
///
/// A partir del id de un game obtiene el userGame correspondiente
final userGameProvider = Provider.family<UserGame?, int>((ref, id) {
  final userGames = ref.watch(userGamesProvider);
  return userGames.firstWhereOrNull((e) => e.idGame == id);
});