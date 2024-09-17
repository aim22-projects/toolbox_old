import 'package:flutter/foundation.dart';
import 'package:toolbox/constants/download_fields.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/repositories/database/base.dart';

class DownloadsRepository {
  static bool? _initialized;

  DownloadsRepository._();

  static Future<void> get initialized async {
    if (_initialized != null && _initialized!) return;
    final db = await BaseDatabaseRepository.database;
    await db.execute(createTableQuery);
  }

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS ${DownloadFields.tableName} (
      ${DownloadFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DownloadFields.url} TEXT NOT NULL,
      ${DownloadFields.name} TEXT NOT NULL,
      ${DownloadFields.downloadLocation} TEXT NOT NULL,
      ${DownloadFields.createdAt} INTEGER NOT NULL,
      ${DownloadFields.downloadStatus} INTEGER NOT NULL,
      ${DownloadFields.thumbnailUrl} TEXT,
      ${DownloadFields.fileSize} INTEGER NULL
    )
  ''';

  static Future<List<DownloadTask>?> getDownloads() async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      var result = await db.query(DownloadFields.tableName);
      return result.map((item) => DownloadTask.fromMap(item)).toList();
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }

  static Future<int?> insertDownload(DownloadTask post) async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      return await db.insert(DownloadFields.tableName, post.toMap());
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }
}
