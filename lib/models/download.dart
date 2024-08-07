enum DownloadStatus {
  loading(0),
  inProcess(1),
  completed(2),
  paused(3),
  failed(4);

  final int value;
  const DownloadStatus(this.value);
}

class DownloadFields {
  // all column names
  static final List<String> values = [
    id,
    url,
    name,
    downloadLocation,
    createdAt
  ];

  // column names
  static const String id = '_id';
  static const String url = 'url';
  static const String name = 'name';
  static const String downloadLocation = 'downloadLocation';
  static const String createdAt = 'createdAt';
  static const String downloadStatus = 'downloadStatus';
  static const String thumbnailUrl = 'thumbnailUrl';
  static const String fileSize = 'fileSize';

  // table name
  static const String tableName = 'downloads';
}

class Download {
  int? id;
  String url;
  String name;
  String downloadLocation;
  String createdAt;
  DownloadStatus downloadStatus;
  String thumbnailUrl;
  int? fileSize;

  Download({
    this.id,
    required this.url,
    required this.name,
    required this.downloadLocation,
    required this.createdAt,
    required this.downloadStatus,
    required this.thumbnailUrl,
    this.fileSize,
  });

  Download.from(Map<String, dynamic> value)
      : id = value[DownloadFields.id],
        url = value[DownloadFields.url],
        name = value[DownloadFields.name],
        downloadLocation = value[DownloadFields.downloadLocation],
        createdAt = value[DownloadFields.createdAt],
        downloadStatus = DownloadStatus.values.firstWhere(
            (item) => item.value == value[DownloadFields.createdAt],
            orElse: () => DownloadStatus.loading),
        thumbnailUrl = value[DownloadFields.thumbnailUrl],
        fileSize = value[DownloadFields.fileSize];

  factory Download.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        DownloadFields.id: int id,
        DownloadFields.url: String url,
        DownloadFields.name: String name,
        DownloadFields.downloadLocation: String location,
        DownloadFields.createdAt: String createdAt,
        DownloadFields.downloadStatus: int downloadStatus,
        DownloadFields.thumbnailUrl: String thumbnailUrl,
        DownloadFields.fileSize: int fileSize,
      } =>
        Download(
            id: id,
            url: url,
            name: name,
            downloadLocation: location,
            createdAt: createdAt,
            downloadStatus: DownloadStatus.values.firstWhere(
                (item) => item.value == downloadStatus,
                orElse: () => DownloadStatus.loading),
            thumbnailUrl: thumbnailUrl,
            fileSize: fileSize),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  Map<String, dynamic> toMap() => {
        DownloadFields.id: id,
        DownloadFields.url: url,
        DownloadFields.name: name,
        DownloadFields.downloadLocation: downloadLocation,
        DownloadFields.createdAt: createdAt,
        DownloadFields.downloadStatus: downloadStatus.value,
        DownloadFields.thumbnailUrl: thumbnailUrl,
        DownloadFields.fileSize: fileSize
      };
}
