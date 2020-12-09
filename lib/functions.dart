import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'detector/detector.dart';

/// Check if the text has detection
bool isDetected(String value, RegExp detectionRegExp) {
  final decoratedTextColor = Colors.blue;
  final detector = Detector(
    textStyle: TextStyle(),
    detectedStyle: TextStyle(
      color: decoratedTextColor,
    ),
    detectionRegExp: detectionRegExp,
  );
  final result = detector.getDetections(value);
  final taggedDecorations = result
      .where((decoration) => decoration.style.color == decoratedTextColor)
      .toList();
  return taggedDecorations.isNotEmpty;
}

/// Extract detections from the text
List<String> extractDetections(String value, RegExp detectionRegExp) {
  final decoratedTextColor = Colors.blue;
  final decorator = Detector(
    textStyle: TextStyle(),
    detectedStyle: TextStyle(color: decoratedTextColor),
    detectionRegExp: detectionRegExp,
  );
  final decorations = decorator.getDetections(value);
  final taggedDecorations = decorations
      .where((decoration) => decoration.style.color == decoratedTextColor)
      .toList();
  final result = taggedDecorations.map((decoration) {
    final text = decoration.range.textInside(value);
    return text.trim();
  }).toList();
  return result;
}

/// Returns textSpan with detected text
///
/// Used in [HashTagText]
TextSpan getDetectedTextSpan({
  @required TextStyle decoratedStyle,
  @required TextStyle basicStyle,
  @required String source,
  @required RegExp detectionRegExp,
  Function(String) onTap,
  bool decorateAtSign = false,
}) {
  final decorations = Detector(
    detectedStyle: decoratedStyle,
    textStyle: basicStyle,
    detectionRegExp: detectionRegExp,
  ).getDetections(source);
  if (decorations.isEmpty) {
    return TextSpan(text: source, style: basicStyle);
  } else {
    decorations.sort();
    final span = decorations
        .asMap()
        .map(
          (index, item) {
            final recognizer = TapGestureRecognizer()
              ..onTap = () {
                final decoration = decorations[index];
                if (decoration.style == decoratedStyle) {
                  onTap(decoration.range.textInside(source).trim());
                }
              };
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
