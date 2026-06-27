import 'dart:convert';

class Note {
  final int? id;
  final String? text;
  final List<String> imagePaths;
  final List<String> audioPaths;
  final List<String> filePaths;
  final List<String> videoPaths;
  final List<String> tagNames;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final int? color;

  const Note({
    this.id,
    this.text,
    this.imagePaths = const [],
    this.audioPaths = const [],
    this.filePaths = const [],
    this.videoPaths = const [],
    this.tagNames = const [],
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.color,
  });

  Note copyWith({
    int? id,
    String? text,
    List<String>? imagePaths,
    List<String>? audioPaths,
    List<String>? filePaths,
    List<String>? videoPaths,
    List<String>? tagNames,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    int? color,
    bool clearColor = false,
    bool clearLocation = false,
  }) {
    return Note(
      id: id ?? this.id,
      text: text ?? this.text,
      imagePaths: imagePaths ?? this.imagePaths,
      audioPaths: audioPaths ?? this.audioPaths,
      filePaths: filePaths ?? this.filePaths,
      videoPaths: videoPaths ?? this.videoPaths,
      tagNames: tagNames ?? this.tagNames,
      createdAt: createdAt ?? this.createdAt,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
      color: clearColor ? null : (color ?? this.color),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'text': text,
      'image_paths': jsonEncode(imagePaths),
      'audio_paths': jsonEncode(audioPaths),
      'file_paths': jsonEncode(filePaths),
      'video_paths': jsonEncode(videoPaths),
      'created_at': createdAt.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'color': color,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      text: map['text'] as String?,
      imagePaths: _parseJsonList(map['image_paths'] as String?),
      audioPaths: _parseJsonList(map['audio_paths'] as String?),
      filePaths: _parseJsonList(map['file_paths'] as String?),
      videoPaths: _parseJsonList(map['video_paths'] as String?),
      tagNames: _parseTagNames(map['tag_names'] as String?),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      color: map['color'] as int?,
    );
  }

  static List<String> _parseJsonList(String? json) {
    if (json == null || json.isEmpty) return [];
    final list = jsonDecode(json) as List;
    return list.cast<String>();
  }

  static List<String> _parseTagNames(String? grouped) {
    if (grouped == null || grouped.isEmpty) return [];
    return grouped.split(',');
  }
}
