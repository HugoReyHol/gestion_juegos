import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:collection/collection.dart';

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

  Future<UserGame> insertUserGame(int idGame) async {
    final UserGame userGame = UserGame(idGame: idGame, idUser: ref.read(userProvider)!.idUser!);
    await UserGameDao.insertUserGame(userGame);
    allUserGames.add(userGame);
    ref.notifyListeners();
    return userGame;
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
    currentUserGame = allUserGames.firstWhereOrNull((e) => e.idGame == idGame);
  }

  bool containsUserGame(int idGame) {
    return allUserGames.indexWhere((e) => e.idGame == idGame) != -1;
  }
}

final userGamesProvider = NotifierProvider<UserGamesNotifier, List<UserGame>>(() => UserGamesNotifier());

final userGameProvider = Provider.family<UserGame?, int>((ref, id) {
  final userGames = ref.watch(userGamesProvider);
  return ref.read(userGamesProvider.notifier).allUserGames.firstWhereOrNull((e) => e.idGame == id);
});