import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/services/user_service.dart';

void main() {
  test("Login service", () async{
    final user = await UserService.getUser("test", "test");

    print(user?.idUser);
    print(user?.token);
  });

  test("Insert service", () async {
    final user = await UserService.insertUser(User(name: "test2", password: "test2"));

    print(user.idUser);
    print(user.token);
  });
}