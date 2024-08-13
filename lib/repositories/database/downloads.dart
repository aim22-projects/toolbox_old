import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/base.dart';

class DownloadsRepository {
  BaseDatabaseRepository baseRepository = BaseDatabaseRepository();
  Database? database;
  bool get initialized => database != null;

  DownloadsRepository._internal() {
    init();
  }

  Future<void> init() async {
    database = await baseRepository.database;
    await database?.execute(createTableQuery);
  }

  static DownloadsRepository get _instance => DownloadsRepository._internal();

  factory DownloadsRepository() => _instance;

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS ${DownloadFields.tableName} (
      ${DownloadFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DownloadFields.url} TEXT NOT NULL,
      ${DownloadFields.name} TEXT NOT NULL,
      ${DownloadFields.downloadLocation} TEXT NOT NULL,
      ${DownloadFields.createdAt} TEXT NOT NULL,
      ${DownloadFields.downloadStatus} INTEGER NOT NULL,
      ${DownloadFields.thumbnailUrl} TEXT,
      ${DownloadFields.fileSize} INTEGER NULL
    )
  ''';

  Future<List<Download>?> getDownloads() async {
    try {
      if (database == null) await init();

      var result = await database?.query(DownloadFields.tableName);
      return result?.map((item) => Download.from(item)).toList();
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }

  Future<int?> insertDownload(Download post) async {
    try {
      if (database == null) await init();

      return await database?.insert(DownloadFields.tableName, post.toMap());
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }
}
