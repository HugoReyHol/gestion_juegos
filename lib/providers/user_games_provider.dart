import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/game_dao.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/game.dart';
import 'package:gestion_juegos/models/user_game.dart';

class UserGamesNotifier extends StateNotifier<List<UserGame>> {
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
    
    return games;
  }
}

final userGamesProvider = StateNotifierProvider<UserGamesNotifier, List<UserGame>>((ref) {
  final notifier = UserGamesNotifier();
  notifier.filterUserGames(UserDao.user.idUser!, States.playing);
  return notifier;
});