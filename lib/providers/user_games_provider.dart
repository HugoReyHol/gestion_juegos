import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:collection/collection.dart';

// Provider de todos los juegos en la base de datos
class UserGamesNotifier extends Notifier<List<UserGame>> {

  @override
  List<UserGame> build() {
    state = [];
    _getUserGames();
    return state;
  }

  void _getUserGames() async{
    state = await UserGameDao.getUserGames(ref.watch(userProvider)!.idUser!);
  }

  void insertUserGame(int idGame) async {
    final UserGame userGame = UserGame(idGame: idGame, idUser: ref.read(userProvider)!.idUser!, lastChange: DateTime.now());
    await UserGameDao.insertUserGame(userGame);
    state = [...state, userGame];
  }

  void updateUserGame(UserGame userGame) async{
    userGame.lastChange = DateTime.now();
    await UserGameDao.updateUserGame(userGame);
    state.removeWhere((e) => e.idGame == userGame.idGame);
    state.add(userGame.copyWith());
    ref.notifyListeners();
  }

  void deleteUserGame(UserGame userGame, BuildContext context) async {
    await UserGameDao.deleteUserGame(userGame);
    state.removeWhere((e) => e.idGame == userGame.idGame);
    ref.notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Juego borrado de la colección")
        )
      );
    }
  }
}

final userGamesProvider = NotifierProvider<UserGamesNotifier, List<UserGame>>(() => UserGamesNotifier());

// Provider de un juego individual para el game_widget
final userGameProvider = Provider.family<UserGame?, int>((ref, id) {
  final userGames = ref.watch(userGamesProvider);
  return userGames.firstWhereOrNull((e) => e.idGame == id);
});