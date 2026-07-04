import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class Note {
  final int? id;
  final String? text;
  final List<String> imagePaths;
  final List<String> audioPaths;
  final List<String> filePaths;
  final List<String> videoPaths;
  final List<String> tagNames;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? latitude;
  final double? longitude;
  final int? color;
  final bool isPinned;

  const Note({
    this.id,
    this.text,
    this.imagePaths = const [],
    this.audioPaths = const [],
    this.filePaths = const [],
    this.videoPaths = const [],
    this.tagNames = const [],
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    this.color,
    this.isPinned = false,
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
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    int? color,
    bool? isPinned,
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
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
      color: clearColor ? null : (color ?? this.color),
      isPinned: isPinned ?? this.isPinned,
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
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'color': color,
      'is_pinned': isPinned ? 1 : 0,
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
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      color: map['color'] as int?,
      isPinned: (map['is_pinned'] as int?) == 1,
    );
  }

  static Document? parseText(String? text) {
    if (text == null || text.isEmpty) return null;
    try {
      final json = jsonDecode(text);
      if (json is List) {
        final delta = Delta.fromJson(json);
        final lastData = delta.last.data;
        if (lastData is String && !lastData.endsWith('\n')) {
          delta.insert('\n');
        }
        return Document.fromDelta(delta);
      }
    } catch (_) {}
    final normalized = text.endsWith('\n') ? text : '$text\n';
    return Document.fromDelta(Delta()..insert(normalized));
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
