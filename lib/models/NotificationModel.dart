class NotificationModel {
  String notificationTitle;
  String notificationBody;
  String tag;
  late String type;
  late int id;
  late String action;
  late DateTime timestamp;
  late int senderId;
  late int receiverId;
  late String status;
  late int notificationId;

  NotificationModel({
    required this.notificationTitle,
    required this.notificationBody,
    required this.tag,
  }) {
    var parts = tag.split('###');
    if (parts.length >= 8) {
      type = parts[0];
      id = int.tryParse(parts[1]) ?? 0;
      action = parts[2];
      timestamp = DateTime.tryParse(parts[3]) ?? DateTime.now();
      senderId = int.tryParse(parts[4]) ?? 0;
      receiverId = int.tryParse(parts[5]) ?? 0;
      status = parts[6];
      notificationId = int.tryParse(parts[7]) ?? 0;
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationTitle: json['notification_title'],
      notificationBody: json['notification_body'],
      tag: json['tag'],
    );
  }
}
