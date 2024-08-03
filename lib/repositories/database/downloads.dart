import 'package:sqflite/sqflite.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/base.dart';

class DownloadsRepository {
  BaseDatabaseRepository baseRepository = BaseDatabaseRepository();
  Database? database;
  bool initialized = false;

  DownloadsRepository._internal() {
    init();
  }

  Future<void> init() async {
    database = await baseRepository.database;
    await database?.execute(createTableQuery);
    initialized = true;
    print("database service started");
  }

  static DownloadsRepository get _instance => DownloadsRepository._internal();

  factory DownloadsRepository() => _instance;

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS ${DownloadFields.tableName} (
      ${DownloadFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DownloadFields.url} TEXT NOT NULL,
      ${DownloadFields.name} TEXT NOT NULL,
      ${DownloadFields.location} TEXT NOT NULL,
      ${DownloadFields.createdAt} TEXT NOT NULL
    )
  ''';

  Future<List<Download>?> getDownloads() async {
    if (database == null || !initialized) return null;
    var result = await database?.query(DownloadFields.tableName);
    return result?.map((item) => Download.from(item)).toList();
  }

  Future<int?> insertDownload(Download post) async {
    if (database == null || !initialized) return null;
    return await database?.insert(DownloadFields.tableName, post.toMap());
  }
}
