class LocalNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  LocalNotification({
    this.id = 0,
    required this.title,
    required this.body,
    required this.payload,
  });
}
