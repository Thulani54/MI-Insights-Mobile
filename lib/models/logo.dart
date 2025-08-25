// models/logo.dart
class Logo {
  final int id;
  final String title;
  final String description;
  final String fileUrl;
  final bool isActive;

  Logo(
      {required this.id,
      required this.title,
      required this.description,
      required this.fileUrl,
      required this.isActive});

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      id: json['file_id'],
      title: json['title'],
      description: json['description'],
      fileUrl: json['file'],
      isActive: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file': fileUrl,
      'active': isActive,
    };
  }
}
