import 'dart:convert';

class Note {
  final int? id;
  final String? text;
  final List<String> tags;
  final List<String> imagePaths;
  final List<String> audioPaths;
  final List<String> filePaths;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;

  const Note({
    this.id,
    this.text,
    this.tags = const [],
    this.imagePaths = const [],
    this.audioPaths = const [],
    this.filePaths = const [],
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  Note copyWith({
    int? id,
    String? text,
    List<String>? tags,
    List<String>? imagePaths,
    List<String>? audioPaths,
    List<String>? filePaths,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    bool clearLocation = false,
  }) {
    return Note(
      id: id ?? this.id,
      text: text ?? this.text,
      tags: tags ?? this.tags,
      imagePaths: imagePaths ?? this.imagePaths,
      audioPaths: audioPaths ?? this.audioPaths,
      filePaths: filePaths ?? this.filePaths,
      createdAt: createdAt ?? this.createdAt,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'text': text,
      'tags': jsonEncode(tags),
      'image_paths': jsonEncode(imagePaths),
      'audio_paths': jsonEncode(audioPaths),
      'file_paths': jsonEncode(filePaths),
      'created_at': createdAt.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      text: map['text'] as String?,
      tags: _parseJsonList(map['tags'] as String?),
      imagePaths: _parseJsonList(map['image_paths'] as String?),
      audioPaths: _parseJsonList(map['audio_paths'] as String?),
      filePaths: _parseJsonList(map['file_paths'] as String?),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  static List<String> _parseJsonList(String? json) {
    if (json == null || json.isEmpty) return [];
    final list = jsonDecode(json) as List;
    return list.cast<String>();
  }
}
