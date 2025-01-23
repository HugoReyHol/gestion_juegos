import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_provider.dart';

class UserGamesNotifier extends StateNotifier<List<UserGame>> {
  UserGame? currentUserGame;
  UserGamesNotifier() : super([]);

  void getUserGames(int idUser) async{
    state = await UserGameDao.getUserGames(idUser);
  }

  void insertUserGame(UserGame userGame) async {
    await UserGameDao.insertUserGame(userGame);
    getUserGames(userGame.idUser);
  }

  void updateUserGame(UserGame userGame) async{
    await UserGameDao.updateUserGame(userGame);
    getUserGames(userGame.idUser);
  }

  void deleteUserGame(UserGame userGame) async {
    await UserGameDao.deleteUserGame(userGame);
    getUserGames(userGame.idUser);
  }

  void filterUserGames(int idUser, States st) async {
    final List<UserGame> userGames = await UserGameDao.getUserGames(idUser);

    state = userGames.where((element) => element.state == st).toList();
  }

  Future<List<Game>> userGames2Games() async {
    final List<Game> games = [];

    for (UserGame userGame in state) {
      games.add((await GameDao.getGameById(userGame.idGame))!);
    }

    games.sort((a, b) => a.title.compareTo(b.title));

    return games;
  }

  void setUserGame(int idUser, int idGame) async {
    currentUserGame = await UserGameDao.getUserGame(idUser, idGame);
  }
}

final userGamesProvider = StateNotifierProvider<UserGamesNotifier, List<UserGame>>((ref) {
  final notifier = UserGamesNotifier();
  notifier.filterUserGames(ref.watch(userProvider)!.idUser!, States.playing);
  return notifier;
});