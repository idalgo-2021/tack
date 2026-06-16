class TagParser {
  static List<String> parseFromText(String text) {
    final regex = RegExp(r'#(\w[\wа-яёА-ЯЁ\-]*\w|\w)');
    final matches = regex.allMatches(text);
    return matches.map((m) => m.group(1)!.toLowerCase()).toSet().toList();
  }

  static String parseAndRemoveTags(String text) {
    return text.replaceAll(RegExp(r'#(\w[\wа-яёА-ЯЁ\-]*\w|\w)'), '').trim();
  }
}
