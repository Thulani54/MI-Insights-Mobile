// models/notification.dart
class Notification2 {
  final int id;
  final String title;
  final String content;
  final String notificationType;
  final int cecClientId;
  final int uploadedBy;
  final String displayFrom;
  final String displayUntil;
  final String eventDate;
  final bool isActive;

  Notification2({
    required this.id,
    required this.title,
    required this.content,
    required this.notificationType,
    required this.cecClientId,
    required this.uploadedBy,
    required this.displayFrom,
    required this.displayUntil,
    required this.isActive,
    required this.eventDate,
  });

  factory Notification2.fromJson(Map<String, dynamic> json) {
    return Notification2(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      content: json['content'] ?? "",
      notificationType: json['notification_type'] ?? "",
      cecClientId: json['cec_client_id'] ?? 0,
      uploadedBy: json['uploaded_by'] ?? 0,
      displayFrom: json['display_from'] ?? "",
      displayUntil: json['display_until'] ?? "",
      eventDate: json['event_date'] ?? "",
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'notification_type': notificationType,
      'cec_client_id': cecClientId,
      'uploaded_by': uploadedBy,
      'display_from': displayFrom,
      'display_until': displayUntil,
      'is_active': isActive,
    };
  }
}
