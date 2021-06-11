import 'package:flutter/material.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Test()),
    );
  }
}

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool _check1 = false;
  bool _check2 = true;
  bool _check3 = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Use 'Tab' to cycle through the buttons. Use Enter/Space to press them."),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyCustomButton("Button 1", onPressed: () => print("Click1")),
              MyCustomButton("Button 2", onPressed: () => print("Click2")),
              MyCustomButton("Button 3", onPressed: () => print("Click3")),
            ],
          ),
          SizedBox(height: 30),
          MyCustomCheckbox("Chk1", value: _check1, onChanged: (v) => setState(() => _check1 = v)),
          MyCustomCheckbox("Chk2", value: _check2, onChanged: (v) => setState(() => _check2 = v)),
          MyCustomCheckbox("Chk3", value: _check3, onChanged: (v) => setState(() => _check3 = v)),
        ],
      ),
    );
  }
}

class MyCustomButton extends StatelessWidget {
  const MyCustomButton(this.label, {Key? key, required this.onPressed}) : super(key: key);
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
        onPressed: onPressed,
        builder: (_, control) {
          Color outlineColor = control.isFocused ? Colors.black : Colors.transparent;
          Color bgColor = control.isHovered ? Colors.blue.shade100 : Colors.grey.shade200;
          return Container(
            padding: const EdgeInsets.all(8),
            child: Text(label),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: outlineColor, width: 1),
            ),
          );
        });
  }
}

class MyCustomCheckbox extends StatelessWidget {
  const MyCustomCheckbox(this.label, {Key? key, required this.value, required this.onChanged}) : super(key: key);
  final String label;
  final bool value;
  final void Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
        onPressed: () => onChanged(!value),
        builder: (_, control) {
          Color? contentColor = control.isHovered ? Colors.blue : null;
          return Stack(
            children: [
              // Focus outline
              if (control.isFocused)
                Positioned.fill(
                  child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1))),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkbox
                    Container(
                      width: 20,
                      height: 20,
                      color: contentColor ?? Colors.black,
                      padding: const EdgeInsets.all(4),
                      // Show inner square when value == true
                      child: value ? Container(color: Colors.white) : null,
                    ),
                    const SizedBox(width: 10),
                    // Label
                    Text(label, style: TextStyle(color: control.isHovered ? Colors.blue : null)),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
