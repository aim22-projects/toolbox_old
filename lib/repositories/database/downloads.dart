import 'package:flutter/foundation.dart';
import 'package:toolbox/constants/download_keys.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/repositories/database/base.dart';
import 'package:toolbox/services/background_download_service.dart';

class DownloadsRepository {
  static bool? _initialized;

  DownloadsRepository._() {
    BackgroundDownloadService.updates.listen(updateTask);
  }

  static Future<void> get initialized async {
    if (_initialized != null && _initialized!) return;
    final db = await BaseDatabaseRepository.database;
    await db.execute(createTableQuery);
  }

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS ${DownloadKeys.tableName} (
      ${DownloadKeys.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DownloadKeys.url} TEXT NOT NULL,
      ${DownloadKeys.name} TEXT NOT NULL,
      ${DownloadKeys.downloadLocation} TEXT NOT NULL,
      ${DownloadKeys.createdAt} INTEGER NOT NULL,
      ${DownloadKeys.downloadStatus} INTEGER NOT NULL,
      ${DownloadKeys.thumbnailUrl} TEXT,
      ${DownloadKeys.fileSize} INTEGER NULL,
      ${DownloadKeys.downloadedSize} INTEGER NULL
    )
  ''';

  static Future<List<DownloadTask>?> getTasks() async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      var result = await db.query(DownloadKeys.tableName);
      return result.map((item) => DownloadTask.fromMap(item)).toList();
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }

  static Future<int?> insertTask(DownloadTask task) async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      return await db.insert(DownloadKeys.tableName, task.toMap());
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }

  static Future<int?> updateTask(DownloadTask task) async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      return await db.update(
        DownloadKeys.tableName,
        task.toMap(),
        where: "id = ?",
        whereArgs: [task.id],
      );
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }

  static Future<int?> deleteTask(DownloadTask task) async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      return await db.delete(
        DownloadKeys.tableName,
        where: "id = ?",
        whereArgs: [task.id],
      );
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }
}
