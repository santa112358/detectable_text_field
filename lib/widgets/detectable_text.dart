import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../detector/text_pattern_detector.dart';

enum TrimMode {
  Length,
  Line,
}

const String _kEllipsis = '\u2026';
const String _kLineSeparator = '\u2028';

/// Show detected text only to be shown
///
/// [onTap] is called when a tagged text is tapped.
class DetectableText extends StatefulWidget {
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
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.moreStyle,
    this.lessStyle,
    this.colorClickableText,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = TrimMode.Length,
    this.delimiter = _kEllipsis + ' ',
    this.onExpansionChanged,
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
  final String delimiter;

  /// Used on TrimMode.Length
  final int trimLength;

  /// Used on TrimMode.Lines
  final int trimLines;

  /// Determines the type of trim. TrimMode.Length takes into account
  /// the number of letters, while TrimMode.Lines takes into account
  /// the number of lines
  final TrimMode trimMode;

  /// TextStyle for expanded text
  final TextStyle? moreStyle;

  /// TextStyle for compressed text
  final TextStyle? lessStyle;

  ///Called when state change between expanded/compress
  final Function(bool val)? onExpansionChanged;

  final String trimExpandedText;
  final String trimCollapsedText;
  final Color? colorClickableText;

  @override
  _DetectableTextState createState() => _DetectableTextState();
}

class _DetectableTextState extends State<DetectableText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() {
      _readMore = !_readMore;
      widget.onExpansionChanged?.call(_readMore);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextStyle style =
        theme.textTheme.titleMedium!.merge(widget.basicStyle);
    final dStyle = widget.detectedStyle ?? style.copyWith(color: Colors.blue);

    final _defaultLessStyle = widget.lessStyle ?? style;
    final _defaultMoreStyle = widget.moreStyle ?? style;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final overflow = DefaultTextStyle.of(context).overflow;
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);
    final _defaultDelimiterStyle = style;

    TextSpan link = TextSpan(
      text: _readMore ? widget.trimCollapsedText : widget.trimExpandedText,
      style: _readMore ? _defaultMoreStyle : _defaultLessStyle,
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    TextSpan _delimiter = TextSpan(
      text: _readMore
          ? widget.trimCollapsedText.isNotEmpty
              ? widget.delimiter
              : ''
          : '',
      style: _defaultDelimiterStyle,
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with data
        final text = TextPatternDetector.getDetectedTextSpan(
          decoratedStyle: dStyle,
          basicStyle: style,
          onTap: widget.onTap,
          source: widget.text,
          detectionRegExp: widget.detectionRegExp,
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: widget.textAlign,
          textDirection: textDirection,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.trimLines,
          ellipsis: overflow == TextOverflow.ellipsis ? widget.delimiter : null,
          locale: locale,
        );
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = _delimiter;
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of data
        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(Offset(
            textDirection == TextDirection.rtl
                ? readMoreSize
                : textSize.width - readMoreSize,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          var pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        var textSpan;
        switch (widget.trimMode) {
          case TrimMode.Length:
            if (widget.trimLength < widget.text.length) {
              textSpan = TextPatternDetector.getDetectedTextSpanWithExtraChild(
                decoratedStyle: dStyle,
                basicStyle: style,
                onTap: widget.onTap,
                source: _readMore
                    ? widget.text.substring(0, widget.trimLength) +
                        (linkLongerThanLine ? _kLineSeparator : '')
                    : widget.text,
                detectionRegExp: widget.detectionRegExp,
                children: <TextSpan>[_delimiter, link],
              );
            } else {
              textSpan = TextPatternDetector.getDetectedTextSpan(
                decoratedStyle: dStyle,
                basicStyle: style,
                onTap: widget.onTap,
                source: widget.text,
                detectionRegExp: widget.detectionRegExp,
              );
            }
            break;
          case TrimMode.Line:
            if (textPainter.didExceedMaxLines) {
              textSpan = TextPatternDetector.getDetectedTextSpanWithExtraChild(
                decoratedStyle: dStyle,
                basicStyle: style,
                onTap: widget.onTap,
                source: _readMore
                    ? widget.text.substring(0, endIndex) +
                        (linkLongerThanLine ? _kLineSeparator : '')
                    : widget.text,
                detectionRegExp: widget.detectionRegExp,
                children: <TextSpan>[_delimiter, link],
              );
            } else {
              textSpan = TextPatternDetector.getDetectedTextSpan(
                decoratedStyle: dStyle,
                basicStyle: style,
                onTap: widget.onTap,
                source: widget.text,
                detectionRegExp: widget.detectionRegExp,
              );
            }

            break;
          default:
            throw Exception(
                'TrimMode type: ${widget.trimMode} is not supported');
        }

        return RichText(
          text: textSpan,
          textAlign: widget.textAlign,
          textDirection: textDirection,
          softWrap: widget.softWrap,
          overflow: widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.maxLines,
          locale: widget.locale,
          strutStyle: widget.strutStyle,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
        );
      },
    );

    return result;
  }
}
