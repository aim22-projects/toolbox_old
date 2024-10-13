import 'package:toolbox/constants/download_keys.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/extensions/file.dart';
import 'package:toolbox/models/base_model.dart';

class DownloadTask extends BaseModel {
  int? id;
  String url;
  String name;
  String downloadLocation;
  DateTime createdAt;
  DownloadStatus downloadStatus;
  String? thumbnailUrl;
  int? fileSize;
  int? downloadedSize;

  DownloadTask({
    this.id,
    required this.url,
    required this.name,
    required this.downloadLocation,
    required this.createdAt,
    this.downloadStatus = DownloadStatus.loading,
    this.thumbnailUrl,
    this.fileSize,
    this.downloadedSize,
  }) : super();

  DownloadTask.fromMap(Map<String, dynamic> value)
      : id = value[DownloadKeys.id] as int?,
        url = value[DownloadKeys.url] as String? ?? '',
        name = value[DownloadKeys.name] as String? ?? '',
        downloadLocation =
            value[DownloadKeys.downloadLocation] as String? ?? '',
        createdAt = DateTime.fromMillisecondsSinceEpoch(
            value[DownloadKeys.createdAt] as int? ?? 0),
        downloadStatus = DownloadStatus.fromValue(
            value[DownloadKeys.downloadStatus] as int? ?? 0),
        thumbnailUrl = value[DownloadKeys.thumbnailUrl] as String?,
        fileSize = value[DownloadKeys.fileSize] as int?,
        downloadedSize = value[DownloadKeys.downloadedSize] as int?,
        super.fromMap();

  @override
  Map<String, dynamic> toMap() => {
        DownloadKeys.id: id,
        DownloadKeys.url: url,
        DownloadKeys.name: name,
        DownloadKeys.downloadLocation: downloadLocation,
        DownloadKeys.createdAt: createdAt.millisecondsSinceEpoch,
        DownloadKeys.downloadStatus: downloadStatus.value,
        DownloadKeys.thumbnailUrl: thumbnailUrl,
        DownloadKeys.fileSize: fileSize,
        DownloadKeys.downloadedSize: downloadedSize,
      };

  String get downloadedSizeValue =>
      getFileSizeString(bytes: downloadedSize ?? 0);

  String get fileSizeValue => getFileSizeString(bytes: fileSize ?? 0);

  int get progress => 100 * (downloadedSize ?? 0) ~/ (fileSize ?? 1);

  String get filePath => '$downloadLocation/$name';
}
