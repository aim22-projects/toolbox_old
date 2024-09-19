import 'package:flutter/foundation.dart';
import 'package:toolbox/constants/download_fields.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/repositories/database/base.dart';
import 'package:toolbox/services/download_service.dart';

class DownloadsRepository {
  static bool? _initialized;

  DownloadsRepository._() {
    DownloadService.updates.listen(updateTask);
  }

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
      ${DownloadFields.fileSize} INTEGER NULL,
      ${DownloadFields.downloadedSize} INTEGER NULL
    )
  ''';

  static Future<List<DownloadTask>?> getTasks() async {
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

  static Future<int?> insertTask(DownloadTask task) async {
    try {
      await initialized;
      final db = await BaseDatabaseRepository.database;

      return await db.insert(DownloadFields.tableName, task.toMap());
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
        DownloadFields.tableName,
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
        DownloadFields.tableName,
        where: "id = ?",
        whereArgs: [task.id],
      );
    } catch (error) {
      if (kDebugMode) print(error);

      return null;
    }
  }
}
