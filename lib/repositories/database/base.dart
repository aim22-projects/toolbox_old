import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatabaseRepository {
  BaseDatabaseRepository._internal();

  static BaseDatabaseRepository get _instance =>
      BaseDatabaseRepository._internal();

  factory BaseDatabaseRepository() => _instance;

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // return _database;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return await openDatabase(path, version: 1);
  }

  void _createTables(Database db, int version) async {
    // await db.execute(PostService.createTableQuery);
    // await db.execute(DownloadService.createTableQuery);
  }
}
