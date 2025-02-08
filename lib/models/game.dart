import 'dart:typed_data';

/// Representa un juego de la base de datos
class Game {
  /// El id del juego en la base de datos
  late int idGame;
  /// El título del juego
  late String title;
  /// La descripción del juego
  late String description;
  /// La imagen del juego
  late Uint8List image;
  /// Los detalles del juego
  late String details;
  /// Los lanzamientos del juego
  late String releases;

  /// Constructor base
  Game({
    required this.idGame,
    required this.title,
    required this.description,
    required this.image,
    required this.details,
    required this.releases
  });

  /// Constructor de juegos a partir de un mapa
  ///
  /// Necesarío para crear la clase `Game` a partir de los datos de la base de datos
  Game.fromMap(Map<String, dynamic> map) {
    idGame = map["idGame"];
    title = map["title"];
    description = map["description"];
    image = map["image"];
    details = map["details"];
    releases = map["releases"];
  }

  /// Crea un mapa a partir de los datos de `Game`
  ///
  /// Necesario para inserta el juego en la base de datos
  /// Devuelve un `Map<String, dynamic>` con los valores
  Map<String, dynamic> toMap() => {
    "idGame": idGame,
    "title": title,
    "description": description,
    "image": image,
    "details": details,
    "releases": releases
  };

  /// Obtiene el desarrollador de un juego
  ///
  /// Devuelve un `String` con su nombre
  String getDeveloper() {
    String text = details.split("\n")[2];
    return text.substring(10);

  }

  /// Obtiene la editora y/o distribuidora de un juego
  ///
  /// Devuelve un `String` con su nombre
  String getPublisher() {
    String text = details.split("\n")[3];
    return text.substring(10);

  }

}