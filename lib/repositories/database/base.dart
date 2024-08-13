import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BaseDatabaseRepository {
  BaseDatabaseRepository._internal();

  static BaseDatabaseRepository get _instance =>
      BaseDatabaseRepository._internal();

  factory BaseDatabaseRepository() => _instance;

  Database? _database;

  Future<Database> get database async {
    // 1. return _database if not null;

    if (_database != null) {
      return _database!;
    }

    // 2. init database, set to _database and return
    _database = await _initDatabase();
    return _database!;

    // 2. init database, set to _database and return
    // it works but facing issues in downloads screen not populating data in start
    //
    // return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    // manage platform
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
    }

    return await openDatabase(path, version: 1);
  }
}
