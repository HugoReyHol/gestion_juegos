import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "gestion_juegos.db");

    return await openDatabase(path, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int v) async {
    await db.execute("""
      CREATE TABLE Users (
        idUser INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
      
      CREATE TABLE Games (
        idGame INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image BLOB NOT NULL,
        details TEXT NOT NULL,
        releases TEXT NOT NULL
      )
      
      CREATE TABLE Users_Games (
        idUser INTEGER,
        idGame INTEGER,
        score INTEGER DEFAULT NULL,
        timePlayed INTEGER DEFAULT NULL,
        state TEXT NOT NULL DEFAULT 'planToPlay',
        PRIMARY KEY (idUser, idGame),
        FOREIGN KEY (idUser) REFERENCES Users(idUser) ON DELETE CASCADE,
        FOREIGN KEY (idGame) REFERENCES Games(idGame) ON DELETE CASCADE
      )
    """);
  }

  Future<void> close() async {
    if (_database != null) await _database!.close();
  }

}