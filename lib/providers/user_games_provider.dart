import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/daos/user_game_dao.dart';
import 'package:gestion_juegos/models/user_game.dart';
import 'package:gestion_juegos/providers/home_providers.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:collection/collection.dart';

// Provider de todos los juegos en la base de datos
class UserGamesNotifier extends Notifier<List<UserGame>> {
  UserGame? currentUserGame;

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
    final UserGame userGame = UserGame(idGame: idGame, idUser: ref.read(userProvider)!.idUser!);
    await UserGameDao.insertUserGame(userGame);
    state = [...state, userGame];
  }

  void updateUserGame(UserGame userGame) async{
    await UserGameDao.updateUserGame(userGame);
    state[state.indexWhere((e) => e.idGame == userGame.idGame)] = userGame;
    ref.notifyListeners();
  }

  void deleteUserGame(UserGame userGame) async {
    await UserGameDao.deleteUserGame(userGame);
    state.removeWhere((e) => e.idGame == userGame.idGame);
    ref.notifyListeners();
  }

  void setUserGame(int idGame) async {
    currentUserGame = state.firstWhereOrNull((e) => e.idGame == idGame);
  }
}

final userGamesProvider = NotifierProvider<UserGamesNotifier, List<UserGame>>(() => UserGamesNotifier());

// Provider de los juegos filtrados, a partir de todos los juegos en la base de datos
class FilteredUserGamesNotifier extends Notifier<List<UserGame>> {
  @override
  List<UserGame> build() {
    _filterUserGames();
    return state;
  }

  void _filterUserGames() {
    final userGames = ref.watch(userGamesProvider);
    final gameState = ref.watch(stateProvider);
    state = userGames.where((e) => e.gameState == gameState).toList();
  }
}

final filteredUserGamesProvider = NotifierProvider<FilteredUserGamesNotifier, List<UserGame>>(() => FilteredUserGamesNotifier());

// Provider de un juego individual para el game_widget
final userGameProvider = Provider.family<UserGame?, int>((ref, id) {
  final userGames = ref.watch(userGamesProvider);
  return userGames.firstWhereOrNull((e) => e.idGame == id);
});