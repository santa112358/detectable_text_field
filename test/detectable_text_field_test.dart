import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final urlRegex = "((http|https)://)(www.)?" +
      "[a-zA-Z0-9@:%._\\+~#?&//=]" +
      "{2,256}\\.[a-z]" +
      "{2,6}\\b([-a-zA-Z0-9@:%" +
      "._\\+~#?&//=]*)";
  test(
    "url detection test",
    () {
      final regex = RegExp(
        urlRegex,
        caseSensitive: false,
        dotAll: true,
      );
      final source = "http://foo.com/blah_blah";
      final matches = extractDetections(source, regex);
      print(matches);
      expect(regex.hasMatch(source), true);
    },
  );
  test(
    "url detection test with hashtags",
    () {
      final regex = RegExp(
        '(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegex',
      );
      final source =
          "Stop dhttp://foo.com/blah_blah oio#firebase notDetectThis @hello noDetection";
      final matches = extractDetections(source, regex);
      print(matches);
      expect(regex.hasMatch(source), true);
    },
  );
}
