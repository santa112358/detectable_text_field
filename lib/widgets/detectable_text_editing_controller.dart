import 'package:detectable_text_field/composer/composer.dart';
import 'package:detectable_text_field/detector/detection.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';

class DetectableTextEditingController extends TextEditingController {
  DetectableTextEditingController({
    /// [detectionRegExp] is used by default.
    this.regExp,
    this.detectedStyle,
    super.text,
  });

  final RegExp? regExp;
  final TextStyle? detectedStyle;

  String? get typingDetection {
    final detections = value.text.toDetections(
      textStyle: const TextStyle(),
      detectedStyle: detectedStyle ??
          const TextStyle(
            color: Colors.blue,
          ),
      detectionRegExp: regExp ?? detectionRegExp()!,
    );
    final composer = Composer(
      selection: value.selection.start,
      sourceText: value.text,
      detectedStyle: detectedStyle ??
          const TextStyle(
            color: Colors.blue,
          ),
      detections: detections,
      composing: value.composing,
    );
    final typingRange = composer.typingDetection()?.range;
    if (typingRange == null) {
      return null;
    } else {
      return typingRange.textInside(value.text);
    }
  }

  @override
  TextSpan buildTextSpan({
    BuildContext? context,
    TextStyle? style,
    bool? withComposing,
  }) {
    final regExp = this.regExp ?? detectionRegExp()!;
    final baseStyle = style ?? const TextStyle();
    final detectedStyle = this.detectedStyle ??
        baseStyle.copyWith(
          color: Colors.blue,
        );
    final detections = text.toDetections(
      textStyle: baseStyle,
      detectedStyle: detectedStyle,
      detectionRegExp: regExp,
    );
    final composer = Composer(
      selection: value.selection.start,
      sourceText: value.text,
      detectedStyle: detectedStyle,
      detections: detections,
      composing: value.composing,
    );

    if (detections.isEmpty) {
      /// use same method as default textField to show composing underline
      return super.buildTextSpan(
        context: context!,
        style: baseStyle,
        withComposing: withComposing ?? false,
      );
    }
    return composer.getComposedTextSpan();
  }
}
