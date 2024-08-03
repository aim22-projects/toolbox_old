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

  Download({
    this.id,
    required this.url,
    required this.name,
    required this.location,
    required this.createdAt,
    required this.downloadStatus,
  });

  Download.from(Map<String, dynamic> value)
      : id = value[DownloadFields.id],
        url = value[DownloadFields.url],
        name = value[DownloadFields.name],
        location = value[DownloadFields.location],
        createdAt = value[DownloadFields.createdAt],
        downloadStatus = DownloadStatus.values[value[DownloadFields.id]];

  Map<String, dynamic> toMap() => {
        DownloadFields.id: id,
        DownloadFields.url: url,
        DownloadFields.name: name,
        DownloadFields.location: location,
        DownloadFields.createdAt: createdAt,
        DownloadFields.downloadStatus: downloadStatus.value
      };
}
