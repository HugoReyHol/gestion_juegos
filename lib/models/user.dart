class User {
  late int? idUser;
  late String name;
  late String password;

  User({
    // required this.idUser,
    required this.name,
    required this.password
  });

  User.fromMap(Map<String, dynamic> map) {
    idUser = map["idUser"];
    name = map["name"];
    password = map["password"];
  }

  Map<String, dynamic> toMap() => {
    // "idUser": idUser,
    "name": name,
    "password": password
  };

}