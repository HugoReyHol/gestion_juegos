import 'dart:io';
import 'package:gestion_juegos/models/game.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

class DbManager {

  DbManager._init();
  static final DbManager _dbManager = DbManager._init();

  factory DbManager() => _dbManager;

  static Database? _database;

  Future<Database> get database async {
    _database ??= _database = await _createDatabase();

    return _database!;
  }

  Future<Database> _createDatabase() async {
    sqfliteFfiInit();

    final databaseFactory = databaseFactoryFfi;
    final dbPath = path.join(await databaseFactory.getDatabasesPath(), "gestion_juegos.db");

    final db = await databaseFactory.openDatabase(dbPath);
    await _onCreate(db);

    return db;
  }

  Future<void> _onCreate(Database db) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Users (
        idUser INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      );
      
      CREATE TABLE IF NOT EXISTS Games (
        idGame INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image BLOB NOT NULL,
        details TEXT NOT NULL,
        releases TEXT NOT NULL
      );
      
      CREATE TABLE IF NOT EXISTS Users_Games (
        idUser INTEGER,
        idGame INTEGER,
        score INTEGER DEFAULT NULL,
        timePlayed INTEGER NOT NULL DEFAULT 0,
        state TEXT NOT NULL DEFAULT 'plan_to_play',
        PRIMARY KEY (idUser, idGame),
        FOREIGN KEY (idUser) REFERENCES Users(idUser) ON DELETE CASCADE,
        FOREIGN KEY (idGame) REFERENCES Games(idGame) ON DELETE CASCADE
      )
    """);

    // TODO añadir más juegos a la base de datos
    final List<Game> games = [
      Game(
        idGame: 1,
        title: "The Legend of Zelda: Tears of the Kingdom",
        description: "The Legend of Zelda: Tears of the Kingdom is the sequel to The Legend of Zelda: Breath of the Wild. The setting for Link’s adventure has been expanded to include the skies above the vast lands of Hyrule.",
        image: await File("assets/zelda_totk.png").readAsBytes(),
        details: "Genres: Role-playing (RPG), Adventure, Action, Fantasy, Sci-Fi, Open world\n"
          "Game mode: Single player\n"
          "Developer: Nintendo EPD Production Group No.3\n"
          "Publisher: Nintendo",
        releases: "Nintendo Switch: 2023-5-12"
      ),
      Game(idGame: 2,
        title: "Portal",
        description: "Waking up in a seemingly empty laboratory, the player is made to complete various physics-based puzzle challenges through numerous test chambers in order to test out the new Aperture Science Handheld Portal Device, without an explanation as to how, why or by whom.",
        image: await File("assets/portal.png").readAsBytes(),
        details: "Genres: Shooter, Platform, Puzzle, Sci-Fi, Comedy\n"
          "Game mode: Single player\n"
          "Developer: Valve\n"
          "Publisher: Valve, Electronic Arts",
        releases: "Windows: EU 2007-10-18\n"
          "Xbox 360: EU 2007-10-18\n"
          "PlayStation 3: EU 2007-11-23\n"
          "Mac: 2010-5-12\n"
          "Linux: 2013-5-2\n"
          "Android: 2014-5-12\n"
          "Nintendo Switch: 2022-6-28\n"
      )
    ];

    // TODO comprobar si se puede hacer con DAOs
    for (Game game in games) {
      if ((await db.query("Games", where: "idGame = ?", whereArgs: [game.idGame])).isEmpty) {
        await db.insert("Games", game.toMap());
        print("insert '${game.title}'");

      } else {
        await db.update(
            "Games",
            game.toMap(),
            where: "idGame = ?",
            whereArgs: [game.idGame]
        );
        print("update '${game.title}'");

      }
    }
  }

  Future<void> close() async {
    if (_database != null) await _database!.close();
  }

}