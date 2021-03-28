import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../functions.dart';

/// Show detected text only to be shown
///
/// [onTap] is called when a tagged text is tapped.
class DetectableText extends StatelessWidget {
  DetectableText({
    required this.text,
    required this.detectionRegExp,
    this.basicStyle,
    this.detectedStyle,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  });

  final String text;
  final TextStyle? basicStyle;
  final TextStyle? detectedStyle;
  final Function(String)? onTap;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final RegExp detectionRegExp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextStyle style = theme.textTheme.subtitle1!.merge(basicStyle);
    final dStyle = detectedStyle ?? style.copyWith(color: Colors.blue);
    return RichText(
      text: getDetectedTextSpan(
        decoratedStyle: dStyle,
        basicStyle: style,
        onTap: onTap,
        source: text,
        detectionRegExp: detectionRegExp,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
