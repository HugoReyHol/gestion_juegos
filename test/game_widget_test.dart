import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_juegos/components/game_widget.dart';
import 'package:gestion_juegos/models/game.dart';

void main() {
  late Game game;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    game = Game(
        idGame: 1,
        title: "The Legend of Zelda: Tears of the Kingdom",
        description: "The Legend of Zelda: Tears of the Kingdom is the sequel to The Legend of Zelda: Breath of the Wild. The setting for Link’s adventure has been expanded to include the skies above the vast lands of Hyrule.",
        image: Uint8List.sublistView(await rootBundle.load("assets/zelda_totk.png")),
        details: "Genres: Role-playing (RPG), Adventure, Action, Fantasy, Sci-Fi, Open world\n"
            "Game mode: Single player\n"
            "Developer: Nintendo EPD Production Group No.3\n"
            "Publisher: Nintendo",
        releases: "Nintendo Switch: 2023-5-12"
    );
  });

  testWidgets("Prueba el widget Game Widget en vertical", (widgetTester) async {
    await widgetTester.pumpWidget(Directionality(textDirection: TextDirection.ltr,child: GameWidget(game: game, layoutMode: LayoutMode.vertical),));

    expect(find.text(game.title), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}