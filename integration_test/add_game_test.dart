import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gestion_juegos/main.dart' as app;

void main() {
  setUp(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    User? testUser = await UserDao.getUser("test");

    if (testUser != null) return;

    testUser = User(name: "test", password: "testtest".encrypt());

    await UserDao.insertUser(testUser);
  });

  testWidgets("Añadir y borrar juego de la lista del usuario", (tester) async {
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

    // Entra en el juego
    await tester.tap(find.byType(GameWidget).first);
    await tester.pumpAndSettle();

    // Añade el juego
    expect(find.byKey(Key("add_btn")), findsOneWidget);

    await tester.tap(find.byKey(Key("add_btn")));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_btn")), findsNothing);

    // Vuelve a home
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Cambia la lista
    expect(find.byType(GameWidget), findsNothing);

    // TODO Arreglar error al pulsarlo
    await tester.tap(find.byKey(Key("dropdown")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("all_games")));
    await tester.pumpAndSettle();

    expect(find.byType(GameWidget), findsOneWidget);

    // Borra el juego
    await tester.tap(find.byType(GameWidget).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("accept_btn")));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_btn")), findsOneWidget);

    // Sale del juego
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(GameWidget), findsNothing);

    // Cierra la sesion
    // TODO Arreglar error al pulsarlo
    await tester.tap(find.byKey(Key("logout")));
  });
}