import 'dart:ui';

import 'package:detectable_text_field/composer/composer.dart';
import 'package:detectable_text_field/detector/detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Show detected text while user is inputting text.
///
/// EditableText which detects the text with [detectionRegExp]
class DetectableEditableText extends EditableText {
  DetectableEditableText({
    Key? key,
    FocusNode? focusNode,
    required TextEditingController controller,
    required TextStyle basicStyle,
    required this.detectedStyle,
    required this.detectionRegExp,
    required Color cursorColor,
    required this.onDetectionTyped,
    required this.onDetectionFinished,
    required this.matchFirst,
    required this.ignoring,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    int? maxLines,
    int? minLines,
    TextInputType? keyboardType,
    bool? autofocus,
    bool obscureText = false,
    bool readOnly = false,
    bool forceLine = true,
    ToolbarOptions toolbarOptions = const ToolbarOptions(
      copy: true,
      cut: true,
      paste: true,
      selectAll: true,
    ),
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Locale? locale,
    double? textScaleFactor,
    bool expands = false,
    Color? selectionColor,
    TextSelectionControls? selectionControls,
    TextInputAction? textInputAction,
    VoidCallback? onEditingComplete,
    SelectionChangedCallback? onSelectionChanged,
    VoidCallback? onSelectionHandleTapped,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    bool cursorOpacityAnimates = false,
    Offset? cursorOffset,
    bool paintCursorAboveText = false,
    BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
    BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
    Brightness keyboardAppearance = Brightness.light,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    bool? showCursor,
    bool showSelectionHandles = false,
    bool rendererIgnoresPointer = true,
    Color backgroundCursorColor = CupertinoColors.inactiveGray,
    bool enableInteractiveSelection = true,
    Color? autocorrectionTextRectColor,
    String obscuringCharacter = '•',
    AppPrivateCommandCallback? onAppPrivateCommand,
    MouseCursor? mouseCursor,
    Iterable<String>? autofillHints,
    String? restorationId,
    double? cursorHeight,
  }) : super(
          key: key,
          focusNode: (focusNode) ?? FocusNode(),
          controller: controller,
          cursorColor: cursorColor,
          style: basicStyle,
          keyboardType: (keyboardType) ?? TextInputType.text,
          autofocus: (autofocus) ?? false,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          backgroundCursorColor: backgroundCursorColor,
          maxLines: maxLines,
          minLines: minLines,
          obscureText: obscureText,
          readOnly: readOnly,
          forceLine: forceLine,
          toolbarOptions: toolbarOptions,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          textCapitalization: textCapitalization,
          locale: locale,
          textScaleFactor: textScaleFactor,
          expands: expands,
          selectionColor: selectionColor,
          selectionControls: selectionControls,
          textInputAction: textInputAction,
          onEditingComplete: onEditingComplete,
          onSelectionChanged: onSelectionChanged,
          onSelectionHandleTapped: onSelectionHandleTapped,
          inputFormatters: inputFormatters,
          cursorWidth: cursorWidth,
          cursorRadius: cursorRadius,
          cursorOpacityAnimates: cursorOpacityAnimates,
          cursorOffset: cursorOffset,
          paintCursorAboveText: paintCursorAboveText,
          selectionHeightStyle: selectionHeightStyle,
          selectionWidthStyle: selectionWidthStyle,
          keyboardAppearance: keyboardAppearance,
          scrollPadding: scrollPadding,
          dragStartBehavior: dragStartBehavior,
          scrollController: scrollController,
          scrollPhysics: scrollPhysics,
          showCursor: showCursor,
          showSelectionHandles: showSelectionHandles,
          rendererIgnoresPointer: rendererIgnoresPointer,
          enableInteractiveSelection: enableInteractiveSelection,
          autocorrectionTextRectColor: autocorrectionTextRectColor,
          obscuringCharacter: obscuringCharacter,
          onAppPrivateCommand: onAppPrivateCommand,
          mouseCursor: mouseCursor,
          autofillHints: autofillHints,
          restorationId: restorationId,
          cursorHeight: cursorHeight,
        );

  final TextStyle detectedStyle;

  final RegExp detectionRegExp;

  final ValueChanged<String>? onDetectionTyped;

  final VoidCallback? onDetectionFinished;

  ///Matches only the initial detection
  final bool matchFirst;

  ///Ignores the detection
  final bool ignoring;

  @override
  DetectableEditableTextState createState() => DetectableEditableTextState();
}

/// State of [DetectableEditableText]
///
/// Return detected text by using functions in [Detector]
class DetectableEditableTextState extends EditableTextState {
  @override
  DetectableEditableText get widget => super.widget as DetectableEditableText;

  late Detector detector;

  Detection? prevTypingDetection;

  @override
  void initState() {
    super.initState();
    detector = Detector(
      textStyle: widget.style,
      detectedStyle: widget.detectedStyle,
      detectionRegExp: widget.detectionRegExp,
      matchFirst: widget.matchFirst,
    );
    widget.controller.addListener(() {
      if(!widget.ignoring){
        _onValueUpdated.call();
      }
    });
  }

  void _onValueUpdated() {
    final detections = detector.getDetections(textEditingValue.text);
    final composer = Composer(
      selection: textEditingValue.selection.start,
      onDetectionTyped: widget.onDetectionTyped,
      sourceText: textEditingValue.text,
      detectedStyle: widget.detectedStyle,
      detections: detections,
      composing: textEditingValue.composing,
    );

    final typingDetection = composer.typingDetection();
    if (prevTypingDetection != null && typingDetection == null) {
      widget.onDetectionFinished?.call();
    }
    prevTypingDetection = typingDetection;
    if (detections.isNotEmpty) {
      /// use [dComposer] to show composing underline
      detections.sort();
      if (widget.onDetectionTyped != null) {
        composer.callOnDetectionTyped();
      }
    }
  }

  @override
  TextSpan buildTextSpan() {
    final detections = detector.getDetections(textEditingValue.text);
    final composer = Composer(
      selection: textEditingValue.selection.start,
      onDetectionTyped: widget.onDetectionTyped,
      sourceText: textEditingValue.text,
      detectedStyle: widget.detectedStyle,
      detections: detections,
      composing: textEditingValue.composing,
    );

    if (detections.isEmpty) {
      /// use same method as default textField to show composing underline
      return widget.controller.buildTextSpan(
        context: context,
        style: widget.style,
        withComposing: !widget.readOnly,
      );
    }
    return composer.getComposedTextSpan();
  }
}
