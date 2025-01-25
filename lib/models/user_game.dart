class UserGame {
  late int idGame;
  late int idUser;
  int? score;
  int timePlayed;
  GameStates gameState;

  UserGame({
    required this.idGame,
    required this.idUser,
    this.score,
    this.timePlayed = 0,
    this.gameState = GameStates.plan_to_play
  });

  factory UserGame.fromMap(Map<String, dynamic> map) {
    return UserGame(
      idGame: map["idGame"],
      idUser: map["idUser"],
      score: map["score"],
      timePlayed: map["timePlayed"],
      gameState: GameStates.values.firstWhere((element) => element.name.toString() == map["state"])
    );
  }

  Map<String, dynamic> toMap() => {
    "idGame": idGame,
    "idUser": idUser,
    "score": score,
    "timePlayed": timePlayed,
    "state": gameState.name
  };

}

enum GameStates {playing, completed, on_hold, dropped, plan_to_play}