# focusable_control_builder

Using `FocusableControlBuilder` you can quickly create a new control that will work properly on all platforms and input devices.

Working "properly" entails support for:
* tab key traversal
* focus / rollover states
* modified mouse cursor
* support for keyboard shortcuts (Enter/Space by default)

<img src="http://screens.gskinner.com/shawn/D1hhJ7d8vX.gif" alt="" />

Under the hood, this builder wraps the built in [`FocusableActionDetector`](https://api.flutter.dev/flutter/widgets/FocusableActionDetector-class.html) and you can read there for more details about how it all works.

For more information on why you'd use these widgets, see this blog post:
https://blog.gskinner.com/archives/2021/06/flutter-building-custom-components-with-focusableactiondetector.html

## 🔨 Installation
```yaml
dependencies:
  focusable_control_builder: ^0.1.0+1
```

### ⚙ Import

```dart
import 'package:focusable_control_builder/focusable_control_builder.dart';
```

## 🕹️ Usage

To create a custom button just implement the `FocusableControlBuilder.builder` method and assign an `onPressed` handler:
```dart
class MyCustomButton extends StatelessWidget {
  const MyCustomButton(this.label, {Key? key, required this.onPressed}) : super(key: key);
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
        onPressed: onPressed,
        builder: (_, FocusableControlState control) {
          // Decide which colors to use, based on .isFocused and .isHovered
          Color outlineColor = control.isFocused ? Colors.black : Colors.transparent;
          Color bgColor = control.isHovered ? Colors.blue.shade100 : Colors.grey.shade200;
          // Return custom button contents
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
```

### Custom Mouse Cursor

`FocusableControlBuilder` will assume you want a "hand" cursor for your control, which is typically the case. If you'd like a different cursor, just assign it:
```
return FocusableControlBuilder(
    cursor: SystemMouseCursors.resizeDown,
    ...
);
```

### Request Focus On Press

`FocusableControlBuilder` will assume you want your control to request focus when it is pressed. To disable, just set this to false:
```
return FocusableControlBuilder(
    requestFocusOnPress: false,
    ...
);
```

### Custom Shortcuts

`FocusableControlBuilder` will create a default activation action which handles [Submit] and [Enter] keys. To create custom keyboard shortcuts you can set the `.shortcuts` and `.actions` parameters. This is a bit beyond the scope of this doc, but if you'd like to learn how, checkout the [`FocusableActionDetector`](https://api.flutter.dev/flutter/widgets/FocusableActionDetector-class.html) docs which contain an example.

## 🐞 Bugs/Requests

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on Github and we'll look into it. Pull request are welcome.

## 📃 License

MIT License


