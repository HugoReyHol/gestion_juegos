class UserGame {
  late int idGame;
  late int idUser;
  int? score;
  int timePlayed;
  GameStates gameState;
  DateTime lastChange;

  UserGame({
    required this.idGame,
    required this.idUser,
    this.score,
    this.timePlayed = 0,
    this.gameState = GameStates.plan_to_play,
    required this.lastChange
  });

  UserGame copyWith() {
    return UserGame(
      idGame: idGame,
      idUser: idUser,
      score: score,
      timePlayed: timePlayed,
      gameState: gameState,
      lastChange: lastChange
    );
  }

  factory UserGame.fromMap(Map<String, dynamic> map) {
    return UserGame(
      idGame: map["idGame"],
      idUser: map["idUser"],
      score: map["score"],
      timePlayed: map["timePlayed"],
      gameState: GameStates.values.firstWhere((element) => element.name.toString() == map["state"]),
      lastChange: DateTime.fromMillisecondsSinceEpoch(map["lastChange"])
    );
  }

  Map<String, dynamic> toMap() => {
    "idGame": idGame,
    "idUser": idUser,
    "score": score,
    "timePlayed": timePlayed,
    "state": gameState.name,
    "lastChange": lastChange.millisecondsSinceEpoch
  };

}

enum GameStates {playing, completed, on_hold, dropped, plan_to_play}