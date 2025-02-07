import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gestion_juegos/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    User? testUser = await UserDao.getUser("test");

    if (testUser != null) return;

    testUser = User(name: "test", password: "testtest".encrypt());

    await UserDao.insertUser(testUser);
  });

  testWidgets("Añadir juego a la lista de usuario", (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Inicia sesion como usuario "test"
    await tester.enterText(find.byKey(Key("name_field")), "test");
    await tester.enterText(find.byKey(Key("pass_field")), "testtest");

    await tester.tap(find.byKey(Key("login_btn")));
    await tester.pumpAndSettle();

    // Uso de la app
    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle();

    // Entra en le juego
    await tester.tap(find.byType(GameWidget).first);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    // Sale del juego
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Cierra la sesion
    await tester.tap(find.byKey(Key("logout")));
  });
}