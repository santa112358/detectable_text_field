import 'package:detectable_text_field/composer/composer.dart';
import 'package:detectable_text_field/detector/detector.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';

class DetectableTextEditingController extends TextEditingController {
  DetectableTextEditingController({
    this.regExp,
    this.onTap,
    this.detectedStyle,
    super.text,
  });

  final RegExp? regExp;
  final ValueChanged<String>? onTap;
  final TextStyle? detectedStyle;

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
    final detector = Detector(
      textStyle: baseStyle,
      detectedStyle: detectedStyle,
      detectionRegExp: regExp,
    );
    final detections = detector.getDetections(text);
    final composer = Composer(
      selection: value.selection.start,
      onDetectionTyped: onTap,
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
