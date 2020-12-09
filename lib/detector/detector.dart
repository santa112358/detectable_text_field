import 'package:flutter/cupertino.dart';

/// DataModel to explain the unit of word in decoration system
class Detection extends Comparable<Detection> {
  Detection({@required this.range, this.style, this.emojiStartPoint});

  final TextRange range;
  final TextStyle style;
  final int emojiStartPoint;

  @override
  int compareTo(Detection other) {
    return range.start.compareTo(other.range.start);
  }
}

/// Hold functions to detect text
///
/// Return the list of [Detection] in [getDetections]
class Detector {
  final TextStyle textStyle;
  final TextStyle detectedStyle;
  final RegExp detectionRegExp;

  Detector({
    @required this.textStyle,
    @required this.detectedStyle,
    @required this.detectionRegExp,
  });

  List<Detection> _getSourceDetections(
      List<RegExpMatch> tags, String copiedText) {
    TextRange previousItem;
    final result = List<Detection>();
    for (var tag in tags) {
      ///Add undetected content
      if (previousItem == null) {
        if (tag.start > 0) {
          result.add(Detection(
              range: TextRange(start: 0, end: tag.start), style: textStyle));
        }
      } else {
        result.add(Detection(
            range: TextRange(start: previousItem.end, end: tag.start),
            style: textStyle));
      }

      ///Add detected content
      result.add(Detection(
          range: TextRange(start: tag.start, end: tag.end),
          style: detectedStyle));
      previousItem = TextRange(start: tag.start, end: tag.end);
    }

    ///Add remaining undetected content
    if (result.last.range.end < copiedText.length) {
      result.add(Detection(
          range:
              TextRange(start: result.last.range.end, end: copiedText.length),
          style: textStyle));
    }
    return result;
  }

  ///filter out the ones includes emoji.
  List<Detection> _getEmojiFilteredDetections(
      {List<Detection> source,
      String copiedText,
      List<RegExpMatch> emojiMatches}) {
    final result = List<Detection>();
    for (var item in source) {
      int emojiStartPoint;
      for (var emojiMatch in emojiMatches) {
        final decorationContainsEmoji = (item.range.start < emojiMatch.start &&
            emojiMatch.end <= item.range.end);
        if (decorationContainsEmoji) {
          /// If the current Emoji's range.start is the smallest in the tag, update emojiStartPoint
          emojiStartPoint = (emojiStartPoint != null)
              ? ((emojiMatch.start < emojiStartPoint)
                  ? emojiMatch.start
                  : emojiStartPoint)
              : emojiMatch.start;
        }
      }
      if (item.style == detectedStyle && emojiStartPoint != null) {
        result.add(Detection(
          range: TextRange(start: item.range.start, end: emojiStartPoint),
          style: detectedStyle,
        ));
        result.add(Detection(
            range: TextRange(start: emojiStartPoint, end: item.range.end),
            style: textStyle));
      } else {
        result.add(item);
      }
    }
    return result;
  }

  /// Return the list of decorations with tagged and untagged text
  List<Detection> getDetections(String copiedText) {
    /// Text to change emoji into replacement text
    final fullWidthRegExp = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

    final fullWidthRegExpMatches =
        fullWidthRegExp.allMatches(copiedText).toList();
    final tokenRegExp =
        RegExp(r'[・ぁ-んーァ-ヶ一-龥\u1100-\u11FF\uAC00-\uD7A3０-９ａ-ｚＡ-Ｚ　]');
    final emojiMatches = fullWidthRegExpMatches
        .where((match) => (!tokenRegExp
            .hasMatch(copiedText.substring(match.start, match.end))))
        .toList();

    /// This is to avoid the error caused by 'regExp' which counts the emoji's length 1.
    emojiMatches.forEach((emojiMatch) {
      final emojiLength = emojiMatch.group(0).length;
      final replacementText = "a" * emojiLength;
      copiedText = copiedText.replaceRange(
          emojiMatch.start, emojiMatch.end, replacementText);
    });

    final tags = detectionRegExp.allMatches(copiedText).toList();
    if (tags.isEmpty) {
      return [];
    }

    final sourceDetections = _getSourceDetections(tags, copiedText);

    final emojiFilteredResult = _getEmojiFilteredDetections(
        copiedText: copiedText,
        emojiMatches: emojiMatches,
        source: sourceDetections);

    return emojiFilteredResult;
  }
}
