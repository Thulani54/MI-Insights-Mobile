// models/banner.dart
class Banner2 {
  final int id;
  final String title;
  final String description;
  final String fileUrl;
  bool isActive;

  Banner2(
      {required this.id,
      required this.title,
      required this.description,
      required this.fileUrl,
      required this.isActive});

  factory Banner2.fromJson(Map<String, dynamic> json) {
    return Banner2(
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
