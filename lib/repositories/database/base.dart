import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BaseDatabaseRepository {
  BaseDatabaseRepository._();

  static Database? _database;

  static Future<Database> get database async {
    // 1. return _database if not null;
    if (_database != null) return _database!;

    // 2. init database, set to _database and return
    return _database = await _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    // manage platform
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(path, version: 1);
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
