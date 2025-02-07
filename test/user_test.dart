import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/util/db_manager.dart';

void main() {
  test("eliminar", () async {
    final db = await DbManager.database;

    db.delete("Users", where: "name = ?", whereArgs: ["test"]);
  });
}