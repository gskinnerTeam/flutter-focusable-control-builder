library focusable_control_builder;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusableControlBuilder extends StatefulWidget {
  const FocusableControlBuilder({
    Key? key,
    required this.builder,
    this.onPressed,
    this.requestFocusOnPress = true,
    this.cursor,
    this.actions,
    this.shortcuts,
  }) : super(key: key);

  final Widget Function(BuildContext context, FocusableControlState control) builder;
  final VoidCallback? onPressed;
  final bool requestFocusOnPress;
  final SystemMouseCursor? cursor;
  final Map<Type, Action<Intent>>? actions;
  final Map<ShortcutActivator, Intent>? shortcuts;

  @override
  State<FocusableControlBuilder> createState() => FocusableControlState();
}

class FocusableControlState extends State<FocusableControlBuilder> {
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  bool _isHovered = false;
  bool get isHovered => _isHovered;

  bool _isFocused = false;
  bool get isFocused => _isFocused;

  bool get hasPressHandler => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    MouseCursor defaultCursor = hasPressHandler ? SystemMouseCursors.click : MouseCursor.defer;
    MouseCursor cursor = widget.cursor ?? defaultCursor;
    return GestureDetector(
      onTap: _handlePressed,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        actions: {
          if (hasPressHandler) ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => _handlePressed()),
          ...(widget.actions ?? {}),
        },
        shortcuts: widget.shortcuts,
        mouseCursor: cursor,
        child: widget.builder(context, this),
      ),
    );
  }

  void _handlePressed() {
    if (widget.onPressed == null) return;
    if (widget.requestFocusOnPress) {
      _focusNode.requestFocus();
    }
    widget.onPressed?.call();
  }
}
