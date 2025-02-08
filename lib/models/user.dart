/// Representa un usuario de la base de datos
class User {
  /// Id del usuario
  late int? idUser;
  /// Nombre del usuario
  late String name;
  /// Contraseña encriptada del usuario
  late String password;

  /// Constructor base
  User({
    required this.name,
    required this.password
  });

  /// Constructor de usuario a partir de un mapa
  ///
  /// Necesarío para crear la clase `User` a partir de los datos de la base de datos
  User.fromMap(Map<String, dynamic> map) {
    idUser = map["idUser"];
    name = map["name"];
    password = map["password"];
  }

  /// Crea un mapa a partir de los datos de `User`
  ///
  /// Necesario para inserta el usuario en la base de datos
  /// Devuelve un `Map<String, dynamic>` con los valores
  Map<String, dynamic> toMap() => {
    // "idUser": idUser,
    "name": name,
    "password": password
  };

}