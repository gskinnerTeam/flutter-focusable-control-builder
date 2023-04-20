library focusable_control_builder;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusableControlBuilder extends StatefulWidget {
  const FocusableControlBuilder({
    Key? key,
    required this.builder,
    this.onPressed,
    this.onLongPressed,
    this.onHoverChanged,
    this.onFocusChanged,
    this.semanticButtonLabel,
    this.enabled = true,
    this.requestFocusOnPress = true,
    this.cursor,
    this.actions,
    this.shortcuts,
    this.hitTestBehavior,
    this.autoFocus = false,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
  }) : super(key: key);

  /// Return a widget representing the control based on the current [FocusableControlState]
  final Widget Function(BuildContext context, FocusableControlState control) builder;

  /// Called when the control is pressed.
  final VoidCallback? onPressed;

  /// Called when the control is long pressed.
  final VoidCallback? onLongPressed;

  /// Called after the hover state has changed.
  final void Function(BuildContext context, FocusableControlState control)? onHoverChanged;

  /// Called after the focus state has changed.
  final void Function(BuildContext context, FocusableControlState control)? onFocusChanged;

  /// Optional: If not null, the control will be marked as a semantic button and given a label.
  final String? semanticButtonLabel;

  /// Passed to [FocusableActionDetector]. Controls whether this widget will accept focus or input of any kind.
  final bool enabled;

  /// Whether this control should request focus when it is pressed, defaults to true.
  final bool requestFocusOnPress;

  /// Use a custom cursor. By default, [SystemMouseCursors.click] is used.
  final SystemMouseCursor? cursor;

  /// Optional. Passed to the [FocusableActionDetector]. Defines a set of actions which can bind to shortcuts.
  final Map<Type, Action<Intent>>? actions;

  /// Optional. Passed to the [FocusableActionDetector]. Defines a set of shortcuts, that will trigger associated actions.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Passed along to the [GestureDetector] that handles onPress and onLongPress
  final HitTestBehavior? hitTestBehavior;

  /// Passed along to the [FocusableActionDetector]
  final bool autoFocus;

  /// Passed along to the [FocusableActionDetector]
  final bool descendantsAreFocusable;

  /// Passed along to the [FocusableActionDetector]
  final bool descendantsAreTraversable;

  @override
  State<FocusableControlBuilder> createState() => FocusableControlState();
}

/// The state of a [FocusableControlBuilder] widget.
/// This is passed to the builder function, and can be used to determine the current state of the control.
class FocusableControlState extends State<FocusableControlBuilder> {
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  bool _isHovered = false;
  bool get isHovered => _isHovered;

  bool _isFocused = false;
  bool get isFocused => _isFocused;

  bool get hasPressHandler => widget.onPressed != null;

  bool _wasHovered = false;
  bool get wasHovered => _wasHovered;

  bool _wasFocused = false;
  bool get wasFocused => _wasFocused;

  void _handleHoverChanged(v) {
    setState(() => _isHovered = v);
    widget.onHoverChanged?.call(context, this);
    _wasHovered = v;
  }

  void _handleFocusChanged(v) {
    setState(() => _isFocused = v);
    widget.onFocusChanged?.call(context, this);
    _wasFocused = v;
  }

  void _handlePressed() {
    if (widget.requestFocusOnPress) {
      _focusNode.requestFocus();
    }
    widget.onPressed?.call();
  }

  /// By default, will bind the [ActivateIntent] from the flutter SDK to the onPressed callback.
  /// This will enable SPACE and ENTER keys on most platforms.
  /// Also accepts additional actions provided externally.
  Map<Type, Action<Intent>> _getKeyboardActions() {
    return {
      if (hasPressHandler) ...{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => _handlePressed()),
      },
      ...(widget.actions ?? {}),
    };
  }

  @override
  Widget build(BuildContext context) {
    MouseCursor defaultCursor = hasPressHandler ? SystemMouseCursors.click : MouseCursor.defer;
    MouseCursor cursor = widget.cursor ?? defaultCursor;

    // Create the core FocusableActionDetector
    Widget content = FocusableActionDetector(
      enabled: widget.enabled,
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      onFocusChange: _handleFocusChanged,
      onShowFocusHighlight: _handleFocusChanged,
      onShowHoverHighlight: _handleHoverChanged,
      shortcuts: widget.shortcuts,
      mouseCursor: cursor,
      actions: _getKeyboardActions(),
      child: widget.builder(context, this),
    );

    // Wrap semantics
    if (widget.semanticButtonLabel != null) {
      content = Semantics(
        button: true,
        label: widget.semanticButtonLabel,
        child: content,
      );
    }

    // Wrap gestures
    return GestureDetector(
      behavior: widget.hitTestBehavior,
      onTap: widget.onPressed == null ? null :_handlePressed,
      onLongPress: widget.onLongPressed,
      child: content,
    );
  }
}
