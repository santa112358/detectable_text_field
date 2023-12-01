import 'package:detectable_text_field/widgets/detectable_text_editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const useDetectableTextEditingController =
    _DetectableTextEditingControllerHookCreator();

class _DetectableTextEditingControllerHookCreator {
  const _DetectableTextEditingControllerHookCreator();

  /// Creates a [TextEditingController] that will be disposed automatically.
  ///
  /// The [text] parameter can be used to set the initial value of the
  /// controller.
  DetectableTextEditingController call({
    String? text,
    RegExp? regExp,
    ValueChanged<String>? onTap,
    TextStyle? detectedStyle,
    List<Object?>? keys,
  }) {
    return use(
      _DetectableTextEditingControllerHook(
        initialText: text,
        regExp: regExp,
        onTap: onTap,
        detectedStyle: detectedStyle,
      ),
    );
  }
}

class _DetectableTextEditingControllerHook
    extends Hook<DetectableTextEditingController> {
  const _DetectableTextEditingControllerHook({
    required this.initialText,
    required this.regExp,
    required this.onTap,
    required this.detectedStyle,
  });

  final String? initialText;
  final RegExp? regExp;
  final ValueChanged<String>? onTap;
  final TextStyle? detectedStyle;

  @override
  _DetectableTextEditingControllerHookState createState() {
    return _DetectableTextEditingControllerHookState();
  }
}

class _DetectableTextEditingControllerHookState extends HookState<
    DetectableTextEditingController, _DetectableTextEditingControllerHook> {
  late final _controller = DetectableTextEditingController(
    text: hook.initialText,
    regExp: hook.regExp,
    detectedStyle: hook.detectedStyle,
  );

  @override
  DetectableTextEditingController build(BuildContext context) => _controller;

  @override
  void dispose() => _controller.dispose();

  @override
  String get debugLabel => 'useDetectableTextEditingController';
}
