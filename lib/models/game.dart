import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

class Game {

  int idGame;
  String title;
  String description;
  Uint8List image;
  String details;
  String releases;

  Game({
    required this.idGame,
    required this.title,
    required this.description,
    required this.image,
    required this.details,
    required this.releases
  });

  void fromMap(Map<String, dynamic> map) {
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

}