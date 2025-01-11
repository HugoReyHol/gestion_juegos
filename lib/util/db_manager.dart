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
    // TODO Crear estructura de la base de datos
    await db.execute("""
    """);
  }

  Future<void> close() async {
    if (_database != null) await _database!.close();
  }
  
  
}