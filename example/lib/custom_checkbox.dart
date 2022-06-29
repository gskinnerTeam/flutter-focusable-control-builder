import 'package:flutter/material.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox(this.label, {Key? key, required this.value, required this.onChanged}) : super(key: key);
  final String label;
  final bool value;
  final void Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
        onPressed: () => onChanged(!value),
        builder: (_, control) {
          return Stack(
            children: [
              // Focus outline
              if (control.isFocused) ...{
                Positioned.fill(child: _buildFocusOutline()),
              },
              // Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Check mark + Bg
                    _buildCheckBg(control),
                    const SizedBox(width: 10),
                    // Label
                    _buildCheckLabel(control),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Text _buildCheckLabel(FocusableControlState control) =>
      Text(label, style: TextStyle(color: control.isHovered ? Colors.blue : null));

  Container _buildCheckBg(FocusableControlState control) {
    Color? contentColor = control.isHovered ? Colors.blue : null;
    return Container(
      width: 20,
      height: 20,
      color: contentColor ?? Colors.black,
      padding: const EdgeInsets.all(4),
      // Show inner square when value == true
      child: value ? Container(color: Colors.white) : null,
    );
  }

  Container _buildFocusOutline() =>
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)));
}
