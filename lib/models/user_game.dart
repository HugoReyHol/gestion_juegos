class UserGame {

  int idGame;
  int idUser;
  int? score;
  int? timePlayed;
  States state;

  UserGame({
    required this.idGame,
    required this.idUser,
    required this.score,
    required this.timePlayed,
    required this.state
  });

  void fromMap(Map<String, dynamic> map) {
    idGame = map["idGame"];
    idUser = map["idUser"];
    score = map["score"];
    timePlayed = map["timePlayed"];
    state = map["state"];
  }

  Map<String, dynamic> toMap() => {
    "idGame": idGame,
    "idUser": idUser,
    "score": score,
    "timePlayed": timePlayed,
    "state": state
  };

}

enum States {playing, completed, onHold, dropped, planToPlay}