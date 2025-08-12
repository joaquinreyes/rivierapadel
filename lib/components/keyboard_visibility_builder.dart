// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    double bottomInset,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  State<KeyboardVisibilityBuilder> createState() =>
      KeyboardVisibilityBuilderState();
}

class KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  double _bottomInset = 0;
  bool get isKeyboardVisible => _isKeyboardVisible;
  double get bottomInset => _bottomInset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _bottomInset = EdgeInsets.fromWindowPadding(
            WidgetsBinding.instance.window.viewInsets,
            WidgetsBinding.instance.window.devicePixelRatio)
        .bottom;
    final newValue = _bottomInset > 0.0;
    setState(() {
      _isKeyboardVisible = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.child,
      _bottomInset,
      _isKeyboardVisible,
    );
  }
}
