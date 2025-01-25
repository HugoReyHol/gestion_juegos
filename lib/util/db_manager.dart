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
        score INTEGER,
        timePlayed INTEGER NOT NULL,
        state TEXT NOT NULL,
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
          "Nintendo Switch: 2022-6-28"
      ),
      Game(idGame: 3,
        title: "The Legend of Zelda: Majora's Mask 3D",
        description: "The Legend of Zelda: Majora's Mask 3D is a remake of the original Nintendo 64 game with more up-to-date graphics, streamlined UI and different additional game modes. Most textures are significantly more detailed, and many models are more faithful to the game's concept and promotional art. In addition, the frame rate has been increased to 30 FPS compared to the original's 20 FPS.",
        image: await File("assets/zelda_mm.png").readAsBytes(),
        details: "Genres: Role-playing (RPG), Adventure, Action, Fantasy\n"
          "Game mode: Single player\n"
          "Developer: Grezzo\n"
          "Publisher: Nintendo",
        releases: "Nintendo 3DS: EU 2015-2-13"
      ),
      Game(idGame: 4,
          title: "BioShock",
          description: "BioShock is a horror-themed first-person shooter set in a steampunk underwater dystopia. The player is urged to turn everything into a weapon: biologically modifying their own body with Plasmids, hacking devices and systems, upgrading their weapons, crafting new ammo variants, and experimenting with different battle techniques are all possible.",
          image: await File("assets/bioshock.png").readAsBytes(),
          details: "Genres: Shooter, Puzzle, Role-playing (RPG), Adventure, Action, Sci-Fi, Horror, Stealth\n"
              "Game mode: Single player\n"
              "Developer: 2K Boston, 2K Australia\n"
              "Publisher: 2K Games",
          releases: "Windows: 2007-8-21\n"
              "Xbox 360: EU 2007-8-24\n"
              "Mac: 2009-10-23"
      ),
      Game(idGame: 5,
          title: "Helldivers 2",
          description: "The Galaxy’s Last Line of Offence. Enlist in the Helldivers and join the fight for freedom across a hostile galaxy in a fast, frantic, and ferocious third-person shooter.",
          image: await File("assets/helldivers_2.png").readAsBytes(),
          details: "Genres: Shooter, Tactical, Action, Sci-Fi\n"
              "Game mode: Single player, Multiplayer, Co-operative\n"
              "Developer: Arrowhead Game Studios\n"
              "Publisher: Sony Interactive Entertainment",
          releases: "Windows: 2024-2-8\n"
              "PlayStation 5: 2024-2-8"
      ),
      Game(idGame: 6,
          title: "Inscryption",
          description: "Inscryption is an inky black card-based odyssey that blends the deckbuilding roguelike, escape-room style puzzles, and psychological horror into a blood-laced smoothie. Darker still are the secrets inscrybed upon the cards...",
          image: await File("assets/inscryption.png").readAsBytes(),
          details: "Genres: Puzzle, Strategy, Adventure, Indie, Card & Board Game, Horror, Mystery\n"
              "Game mode: Single player\n"
              "Developer: Daniel Mullins Games\n"
              "Publisher: Devolver Digital, Daniel Mullins Games",
          releases: "Windows: 2021-10-19\n"
              "Xbox Series X|S: 2023-4-10\n"
              "Xbox One: 2023-4-10\n"
              "PlayStation 5: 2022-8-30\n"
              "PlayStation 4: 2022-8-30\n"
              "Mac: 2021-10-19\n"
              "Linux: 2021-10-19\n"
              "Nintendo Switch: 2022-12-1"
      ),
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