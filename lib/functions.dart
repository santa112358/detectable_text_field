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
  final detections = result
      .where((detection) => detection.style!.color == decoratedTextColor)
      .toList();
  return detections.isNotEmpty;
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
TextSpan getDetectedTextSpan({
  required TextStyle decoratedStyle,
  required TextStyle basicStyle,
  required String source,
  required RegExp detectionRegExp,
  bool alwaysDetectTap = false,
  Function(String)? onTap,
  bool decorateAtSign = false,
}) {
  final detections = Detector(
    detectedStyle: decoratedStyle,
    textStyle: basicStyle,
    detectionRegExp: detectionRegExp,
  ).getDetections(source);
  if (detections.isEmpty) {
    return TextSpan(text: source, style: basicStyle);
  } else {
    detections.sort();
    final span = detections
        .asMap()
        .map(
          (index, item) {
            final recognizer = TapGestureRecognizer()
              ..onTap = () {
                final decoration = detections[index];
                if (decoration.style == decoratedStyle || alwaysDetectTap) {
                  onTap!(decoration.range.textInside(source).trim());
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

TextSpan getDetectedTextSpanWithExtraChild(
    {required TextStyle decoratedStyle,
    required TextStyle basicStyle,
    required String source,
    required RegExp detectionRegExp,
    Function(String)? onTap,
    bool decorateAtSign = false,
      bool alwaysDetectTap = false,
    List<InlineSpan>? children}) {
  final detections = Detector(
    detectedStyle: decoratedStyle,
    textStyle: basicStyle,
    detectionRegExp: detectionRegExp,
  ).getDetections(source);
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
            final recognizer = TapGestureRecognizer()
              ..onTap = () {
                final decoration = detections[index];
                if (decoration.style == decoratedStyle || alwaysDetectTap) {
                  onTap!(decoration.range.textInside(source).trim());
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

    span.addAll(children!);

    return TextSpan(children: span);
  }
}
