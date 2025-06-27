import 'dart:convert';

class Blog {
  final String? id;
  final String title;
  final String description;
  final String postUrl;
  final String blogType;
  final String thumbnailUrl;
  final DateTime timestamp;

  Blog({
    this.id,
    required this.title,
    required this.description,
    required this.postUrl,
    required this.blogType,
    required this.thumbnailUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title.trim(),
      'description': description.trim(),
      'postUrl': postUrl,
      'thumbnailUrl': thumbnailUrl,
      'timestamp': timestamp.toIso8601String(),
      'blogType': blogType,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String,
      postUrl: map['postUrl'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      timestamp: DateTime.parse(map['timestamp']),
      blogType: map['blogType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Blog.fromJson(String source) =>
      Blog.fromMap(json.decode(source) as Map<String, dynamic>);

  Blog copyWith({
    String? id,
    String? title,
    String? description,
    String? postUrl,
    String? thumbnailUrl,
    DateTime? timestamp,
    String? blogType,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      postUrl: postUrl ?? this.postUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      timestamp: timestamp ?? this.timestamp,
      blogType: this.blogType,
    );
  }
}
