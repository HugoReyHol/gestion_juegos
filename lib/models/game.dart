import 'dart:typed_data';

class Game {
  late int idGame;
  late String title;
  late String description;
  late Uint8List image;
  late String details;
  late String releases;

  Game({
    required this.idGame,
    required this.title,
    required this.description,
    required this.image,
    required this.details,
    required this.releases
  });

  Game.fromMap(Map<String, dynamic> map) {
    idGame = map["idGame"];
    title = map["title"];
    description = map["description"];
    image = map["image"];
    details = map["details"];
    releases = map["releases"];
  }

  Map<String, dynamic> toMap() => {
    "idGame": idGame,
    "title": title,
    "description": description,
    "image": image,
    "details": details,
    "releases": releases
  };

  String getDeveloper() {
    String text = details.split("\n")[2];
    return text.substring(10);

  }

  String getPublisher() {
    String text = details.split("\n")[3];
    return text.substring(10);

  }

}