import 'package:toolbox/constants/download_fields.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/base_model.dart';

class DownloadTask extends BaseModel {
  int? id;
  String url;
  String name;
  String downloadLocation;
  DateTime createdAt;
  DownloadStatus downloadStatus;
  String thumbnailUrl;
  int? fileSize;

  DownloadTask({
    this.id,
    required this.url,
    required this.name,
    required this.downloadLocation,
    required this.createdAt,
    required this.downloadStatus,
    required this.thumbnailUrl,
    this.fileSize,
  }) : super();

  DownloadTask.fromMap(Map<String, dynamic> value)
      : id = value[DownloadFields.id] as int?,
        url = value[DownloadFields.url] as String? ?? '',
        name = value[DownloadFields.name] as String? ?? '',
        downloadLocation =
            value[DownloadFields.downloadLocation] as String? ?? '',
        createdAt = DateTime.fromMillisecondsSinceEpoch(
            value[DownloadFields.createdAt] as int? ?? 0),
        downloadStatus = DownloadStatus.fromValue(
            value[DownloadFields.createdAt] as int? ?? 0),
        thumbnailUrl = value[DownloadFields.thumbnailUrl] as String? ?? '',
        fileSize = value[DownloadFields.fileSize] as int?,
        super.fromMap();

  @override
  Map<String, dynamic> toMap() => {
        DownloadFields.id: id,
        DownloadFields.url: url,
        DownloadFields.name: name,
        DownloadFields.downloadLocation: downloadLocation,
        DownloadFields.createdAt: createdAt.millisecondsSinceEpoch,
        DownloadFields.downloadStatus: downloadStatus.value,
        DownloadFields.thumbnailUrl: thumbnailUrl,
        DownloadFields.fileSize: fileSize
      };
}
