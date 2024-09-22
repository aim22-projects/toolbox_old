enum DownloadStatus {
  loading(0),
  inProcess(1),
  completed(2),
  paused(3),
  failed(4);

  final int value;
  const DownloadStatus(this.value);

  // Precompute the map for quick lookup
  static Map<int, DownloadStatus> get _valueMap =>
      {for (var status in DownloadStatus.values) status.value: status};

  // Optimized fromValue method using the precomputed map
  static DownloadStatus fromValue(int value) {
    // return _valueMap[value] ??
    //   DownloadStatus.loading; // default to loading if not found

    return _valueMap.containsKey(value)
        ? _valueMap[value]!
        : DownloadStatus.loading; // default to loading if not found
  }
}
