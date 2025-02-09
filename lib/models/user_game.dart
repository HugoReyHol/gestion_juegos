/// Representa el juego de un usuario de la base de datos
class UserGame {
  /// Id del juego al que añade información
  late int idGame;
  /// Id del usuario al que pertenece
  late int idUser;
  /// Nota que ha puesto el usuario
  int? score;
  /// Tiempo jugado por el usuario
  int timePlayed;
  /// Estado en el que se encuentra el juego
  GameStates gameState;
  /// La última vez que se actualizó el juego
  DateTime lastChange;

  /// Constructor base
  UserGame({
    required this.idGame,
    required this.idUser,
    this.score,
    this.timePlayed = 0,
    this.gameState = GameStates.plan_to_play,
    required this.lastChange
  });

  /// Devuelve una copia del juego de usuario
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

  /// Constructor de juegos de usuario a partir de un mapa
  ///
  /// Necesarío para crear la clase `UserGame` a partir de los datos de la base de datos
  factory UserGame.fromMap(Map<String, dynamic> map) {
    return UserGame(
      idGame: map["idGame"],
      idUser: map["idUser"],
      score: map["score"],
      timePlayed: map["timePlayed"],
      gameState: GameStates.values.firstWhere((element) => element.name.toString() == map["gameState"]),
      lastChange: DateTime.fromMillisecondsSinceEpoch(map["lastChange"])
    );
  }

  /// Crea un mapa a partir de los datos de `UserGame`
  ///
  /// Necesario para inserta el juego en la base de datos
  /// Devuelve un `Map<String, dynamic>` con los valores
  Map<String, dynamic> toMap() => {
    "idGame": idGame,
    // "idUser": idUser,
    "score": score,
    "timePlayed": timePlayed,
    "gameState": gameState.name,
    "lastChange": lastChange.millisecondsSinceEpoch
  };

}

/// Enum con los distintos estados que puede tener un juego de usuario
enum GameStates {playing, completed, on_hold, dropped, plan_to_play}