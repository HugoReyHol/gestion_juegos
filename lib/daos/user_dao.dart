import 'package:gestion_juegos/util/db_manager.dart';
import '../models/user.dart';

/// Clase para interactuar con los usuario de la base de datos
abstract class UserDao {
  /// Obtiene un usuario a partir de su nombre
  ///
  /// Devuelve un `User` si existe y `null` si no lo hace
  static Future<User?> getUser(String name) async {
    final db = await DbManager.database;

    final result = await db.query("Users", where: "name = ?", whereArgs: [name]);

    return result.isEmpty ? null : User.fromMap(result.first);
  }

  /// Inserta un usuario en la base de datos
  ///
  /// Devuelve un `int` con el valor del id creado
  static Future<int> insertUser(User user) async {
    final db = await DbManager.database;

    return await db.insert("Users", user.toMap());
  }
}
