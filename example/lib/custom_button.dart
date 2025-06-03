import 'package:flutter/material.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
    this.label, {
    Key? key,
    this.onPressed,
  }) : super(key: key);
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Click1");
      },
      child: FocusableControlBuilder(
          onPressed: onPressed,
          builder: (_, control) {
            Color outlineColor = control.isFocused ? Colors.black : Colors.transparent;
            Color bgColor = control.isHovered ? Colors.blue.shade100 : Colors.grey.shade200;
            if (control.isPressed) {
              bgColor = Colors.blue;
            }
            return Container(
              padding: const EdgeInsets.all(8),
              child: Text(label),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: outlineColor, width: 1),
              ),
            );
          }),
    );
  }
}
