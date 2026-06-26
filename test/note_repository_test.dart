import 'package:test/test.dart';

void main() {
  group('NoteRepository._escapeLike', () {
    test('escapes backslash', () {
      expect(_escapeLike(r'\'), equals(r'\\'));
    });

    test('escapes percent', () {
      expect(_escapeLike('%'), equals('\\%'));
    });

    test('escapes underscore', () {
      expect(_escapeLike('_'), equals('\\_'));
    });

    test('escapes double quote', () {
      expect(_escapeLike('"'), equals('\\"'));
    });

    test('escapes multiple special chars', () {
      expect(_escapeLike(r'tag\%_\"name'), equals('tag\\\\\\%\\_\\\\\\"name'));
    });

    test('handles empty string', () {
      expect(_escapeLike(''), equals(''));
    });

    test('escapes underscore in normal string', () {
      expect(_escapeLike('normal_tag'), equals('normal\\_tag'));
    });

    test('escapes tag with quote for JSON LIKE pattern', () {
      final tag = 'tag"with"quotes';
      final escaped = _escapeLike(tag);
      expect(escaped, equals('tag\\"with\\"quotes'));
    });
  });
}

String _escapeLike(String s) {
  return s
    .replaceAll('\\', '\\\\')
    .replaceAll('%', '\\%')
    .replaceAll('_', '\\_')
    .replaceAll('"', '\\"');
}