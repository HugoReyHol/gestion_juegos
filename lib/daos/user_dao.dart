import 'package:gestion_juegos/util/db_manager.dart';
import '../models/user.dart';

class UserDao {
  static Future<User?> getUser(String name) async {
    final db = await DbManager().database;

    final result = await db.query("Users", where: "name = $name");

    return result.isEmpty ? null : User.fromMap(result.first);
  }

  static Future<int> insertUser(User user) async {
    final db = await DbManager().database;

    return await db.insert("Users", user.toMap());
  }
}
