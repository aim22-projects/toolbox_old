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
  static final List<String> values = [id, url, name, location, createdAt];

  // column names
  static const String id = '_id';
  static const String url = 'url';
  static const String name = 'name';
  static const String location = 'location';
  static const String createdAt = 'createdAt';
  static const String downloadStatus = 'downloadStatus';
  static const String thumbnailUrl = 'thumbnailUrl';

  // table name
  static const String tableName = 'downloads';
}

class Download {
  int? id;
  String url;
  String name;
  String location;
  String createdAt;
  DownloadStatus downloadStatus;
  String thumbnailUrl;

  Download({
    this.id,
    required this.url,
    required this.name,
    required this.location,
    required this.createdAt,
    required this.downloadStatus,
    required this.thumbnailUrl,
  });

  Download.from(Map<String, dynamic> value)
      : id = value[DownloadFields.id],
        url = value[DownloadFields.url],
        name = value[DownloadFields.name],
        location = value[DownloadFields.location],
        createdAt = value[DownloadFields.createdAt],
        downloadStatus = DownloadStatus.values.firstWhere(
            (item) => item.value == value[DownloadFields.createdAt],
            orElse: () => DownloadStatus.loading),
        thumbnailUrl = value[DownloadFields.thumbnailUrl];

  factory Download.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'url': String url,
        'name': String name,
        'location': String location,
        'createdAt': String createdAt,
        'downloadStatus': int downloadStatus,
        'thumbnailUrl': String thumbnailUrl,
      } =>
        Download(
            id: id,
            url: url,
            name: name,
            location: location,
            createdAt: createdAt,
            downloadStatus: DownloadStatus.values.firstWhere(
                (item) => item.value == downloadStatus,
                orElse: () => DownloadStatus.loading),
            thumbnailUrl: thumbnailUrl),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  Map<String, dynamic> toMap() => {
        DownloadFields.id: id,
        DownloadFields.url: url,
        DownloadFields.name: name,
        DownloadFields.location: location,
        DownloadFields.createdAt: createdAt,
        DownloadFields.downloadStatus: downloadStatus.value,
        DownloadFields.thumbnailUrl: thumbnailUrl
      };
}
