import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'detection.dart';

class TextPatternDetector {
  TextPatternDetector._();

  /// Check if the text has detection
  static bool isDetected(String value, RegExp detectionRegExp) {
    final decoratedTextColor = Colors.blue;
    final result = value.toDetections(
      textStyle: TextStyle(),
      detectedStyle: TextStyle(
        color: decoratedTextColor,
      ),
      detectionRegExp: detectionRegExp,
    );
    final detections = result
        .where((detection) => detection.style!.color == decoratedTextColor)
        .toList();
    return detections.isNotEmpty;
  }

  /// Extract detections from the text
  static List<String> extractDetections(
    String value,
    RegExp detectionRegExp,
  ) {
    final decoratedTextColor = Colors.blue;
    final decorations = value.toDetections(
      textStyle: TextStyle(),
      detectedStyle: TextStyle(color: decoratedTextColor),
      detectionRegExp: detectionRegExp,
    );
    final taggedDecorations = decorations
        .where((decoration) => decoration.style!.color == decoratedTextColor)
        .toList();
    final result = taggedDecorations.map((decoration) {
      final text = decoration.range.textInside(value);
      return text.trim();
    }).toList();
    return result;
  }

  /// Returns textSpan with detected text
  ///
  /// Used in [DetectableText]
  static TextSpan getDetectedTextSpan({
    required TextStyle decoratedStyle,
    required TextStyle basicStyle,
    required String source,
    required RegExp detectionRegExp,
    Function(String)? onTap,
    bool decorateAtSign = false,
  }) {
    final detections = source.toDetections(
      detectedStyle: decoratedStyle,
      textStyle: basicStyle,
      detectionRegExp: detectionRegExp,
    );
    if (detections.isEmpty) {
      return TextSpan(text: source, style: basicStyle);
    } else {
      detections.sort();
      final span = detections
          .asMap()
          .map(
            (index, item) {
              TapGestureRecognizer? recognizer;
              final decoration = detections[index];
              if (decoration.style == decoratedStyle && onTap != null) {
                recognizer = TapGestureRecognizer()
                  ..onTap = () {
                    onTap(decoration.range.textInside(source).trim());
                  };
              }
              return MapEntry(
                index,
                TextSpan(
                  style: item.style,
                  text: item.range.textInside(source),
                  recognizer: (onTap == null) ? null : recognizer,
                ),
              );
            },
          )
          .values
          .toList();

      return TextSpan(children: span);
    }
  }

  static TextSpan getDetectedTextSpanWithExtraChild(
      {required TextStyle decoratedStyle,
      required TextStyle basicStyle,
      required String source,
      required RegExp detectionRegExp,
      Function(String)? onTap,
      bool decorateAtSign = false,
      List<InlineSpan>? children}) {
    final detections = source.toDetections(
      detectedStyle: decoratedStyle,
      textStyle: basicStyle,
      detectionRegExp: detectionRegExp,
    );
    if (detections.isEmpty) {
      // return TextSpan(text: source, style: basicStyle);
      return TextSpan(
        style: basicStyle,
        text: source,
        children: children,
      );
    } else {
      detections.sort();
      List<InlineSpan> span = detections
          .asMap()
          .map(
            (index, item) {
              TapGestureRecognizer? recognizer;
              final decoration = detections[index];
              if (decoration.style == decoratedStyle && onTap != null) {
                recognizer = TapGestureRecognizer()
                  ..onTap = () {
                    onTap(decoration.range.textInside(source).trim());
                  };
              }
              return MapEntry(
                index,
                TextSpan(
                  style: item.style,
                  text: item.range.textInside(source),
                  recognizer: (onTap == null) ? null : recognizer,
                ),
              );
            },
          )
          .values
          .toList();

      span.addAll(children!);

      return TextSpan(children: span);
    }
  }
}
