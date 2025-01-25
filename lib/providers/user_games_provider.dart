import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_provider.dart';

class UserGamesNotifier extends Notifier<List<UserGame>> {
  late final List<UserGame> allUserGames;
  UserGame? currentUserGame;

  @override
  List<UserGame> build() {
    state = [];
    _getUserGames();
    return state;
  }

  void _getUserGames() async{
    allUserGames = await UserGameDao.getUserGames(ref.watch(userProvider)!.idUser!);
    filterUserGames();
  }

  void insertUserGame(UserGame userGame) async {
    await UserGameDao.insertUserGame(userGame);
    allUserGames.add(userGame);
  }

  void updateUserGame(UserGame userGame) async{
    await UserGameDao.updateUserGame(userGame);
    allUserGames[allUserGames.indexWhere((e) => e.idGame == userGame.idGame)] = userGame;
    // state = state.map((e) => e.idGame == userGame.idGame ? userGame : e).toList();
  }

  void deleteUserGame(UserGame userGame) async {
    await UserGameDao.deleteUserGame(userGame);
    allUserGames.remove(userGame);
    // state = state.where((e) => e.idGame == userGame.idGame).toList();
  }

  void filterUserGames([States st = States.playing]) async {
    state = allUserGames.where((e) => e.state == st).toList();
  }

  void setUserGame(int idGame) async {
    currentUserGame = await UserGameDao.getUserGame(ref.watch(userProvider)!.idUser!, idGame);
  }
}

final userGamesProvider = NotifierProvider<UserGamesNotifier, List<UserGame>>(() => UserGamesNotifier());