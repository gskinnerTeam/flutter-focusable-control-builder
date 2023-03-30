import 'package:example/custom_button.dart';
import 'package:example/custom_checkbox.dart';
import 'package:flutter/material.dart';

//TODO: Add tests for additional properties added in 1.0 (enabled, semantics, longPress, etc)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: CustomButtonsAndCheckboxesDemo(),
      ),
    );
  }
}

class CustomButtonsAndCheckboxesDemo extends StatefulWidget {
  const CustomButtonsAndCheckboxesDemo({Key? key}) : super(key: key);

  @override
  State<CustomButtonsAndCheckboxesDemo> createState() => _CustomButtonsAndCheckboxesDemoState();
}

class _CustomButtonsAndCheckboxesDemoState extends State<CustomButtonsAndCheckboxesDemo> {
  bool _check1 = false;
  bool _check2 = true;
  bool _check3 = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Use 'Tab' to cycle through the buttons. Use Enter/Space to press them."),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomButton("Button 1"),
              CustomButton("Button 2", onPressed: () => debugPrint("Click2")),
              CustomButton("Button 3", onPressed: () => debugPrint("Click3")),
            ],
          ),
          const SizedBox(height: 30),
          CustomCheckbox("Chk1", value: _check1, onChanged: (v) => setState(() => _check1 = v)),
          CustomCheckbox("Chk2", value: _check2, onChanged: (v) => setState(() => _check2 = v)),
          CustomCheckbox("Chk3", value: _check3, onChanged: (v) => setState(() => _check3 = v)),
        ],
      ),
    );
  }


}
