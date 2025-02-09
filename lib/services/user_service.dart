import "dart:convert";
import "package:http/http.dart" as http;
import "../models/user.dart";

/// Clase para interactuar con los usuario de la API
abstract class UserService {
  /// url de los usuarios en la API
  static const String _url = "http://localhost:8000/user";

  /// Obtiene un usuario a partir de su nombre
  ///
  /// Devuelve un `User` si existe y `null` si no lo hace
  static Future<User?> getUser(String name, String pass) async {
    const String endpoint = "/login";

    final response = await http.post(
      Uri.parse("$_url$endpoint"),
      headers: {
        "accept": "application/x-www-form-urlencoded",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: 'grant_type=password&username=$name&password=$pass&scope=&client_id=string&client_secret=string'
    );

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) throw Exception("Error login");

    final data = jsonDecode(response.body);

    final User user = User(
      idUser: data["idUser"],
      name: name,
      password: pass,
      token: data["token"]
    );

    return user;
  }

  /// Inserta un usuario en la API
  ///
  /// Devuelve el `User` con el token e id añadido
  static Future<User> insertUser(User user) async {
    const String endpoint = "/insert";

    final response = await http.post(
      Uri.parse("$_url$endpoint"),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "username": user.name,
        "password": user.password
      })
    );

    if (response.statusCode == 400) throw Exception("User already exists");
    if (response.statusCode != 200) throw Exception("Error insert");

    final data = jsonDecode(response.body);
    user.idUser = data["idUser"];
    user.token = data["token"];

    return user;
  }
}