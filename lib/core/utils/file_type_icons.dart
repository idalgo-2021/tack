import 'package:flutter/material.dart';

final _typeMap = <String, (IconData, Color)>{
  'pdf':   (Icons.picture_as_pdf, Color(0xFFE53935)),
  'doc':   (Icons.description,    Color(0xFF1E88E5)),
  'docx':  (Icons.description,    Color(0xFF1E88E5)),
  'xls':   (Icons.table_chart,    Color(0xFF43A047)),
  'xlsx':  (Icons.table_chart,    Color(0xFF43A047)),
  'ppt':   (Icons.slideshow,      Color(0xFFFB8C00)),
  'pptx':  (Icons.slideshow,      Color(0xFFFB8C00)),
  'txt':   (Icons.article,        Color(0xFF757575)),
  'csv':   (Icons.article,        Color(0xFF757575)),
  'zip':   (Icons.folder_zip,     Color(0xFFFDD835)),
  'rar':   (Icons.folder_zip,     Color(0xFFFDD835)),
  '7z':    (Icons.folder_zip,     Color(0xFFFDD835)),
  'json':  (Icons.code,           Color(0xFF8E24AA)),
  'xml':   (Icons.code,           Color(0xFF8E24AA)),
  'mp4':   (Icons.video_file,     Color(0xFF00ACC1)),
  'avi':   (Icons.video_file,     Color(0xFF00ACC1)),
  'mkv':   (Icons.video_file,     Color(0xFF00ACC1)),
  'mov':   (Icons.video_file,     Color(0xFF00ACC1)),
  'webm':  (Icons.video_file,     Color(0xFF00ACC1)),
  'mp3':   (Icons.audio_file,     Color(0xFFEC407A)),
  'wav':   (Icons.audio_file,     Color(0xFFEC407A)),
  'm4a':   (Icons.audio_file,     Color(0xFFEC407A)),
  'ogg':   (Icons.audio_file,     Color(0xFFEC407A)),
};

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'};

String _ext(String path) {
  final i = path.lastIndexOf('.');
  return i == -1 ? '' : path.substring(i + 1).toLowerCase();
}

bool isImageFile(String path) => _imageExtensions.contains(_ext(path));

IconData fileIcon(String path) => _typeMap[_ext(path)]?.$1 ?? Icons.insert_drive_file;

Color fileColor(String path) => _typeMap[_ext(path)]?.$2 ?? const Color(0xFF9E9E9E);
