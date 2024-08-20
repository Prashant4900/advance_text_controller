# Advanced Text Controllers

A Flutter package that provides advanced text editing controllers for managing and formatting various types of inputs, including dates, times, models, and numerical values.

## Features

- **DateEditingController**: Manages and formats date input with customizable date and time patterns.
- **TimeEditingController**: Handles time input with customizable formatting.
- **ModelEditingController**: Supports binding and updating custom models with text input fields.
- **MultiValueEditingController**: Manages a single string key value, useful for identifying multiple values.
- **IntegerEditingController**: Parses and handles integer input.
- **DoubleEditingController**: Parses and handles double input.

## Installation

Add the following line to your `pubspec.yaml` under dependencies:

```bash
dependencies:
  advance_text_controller: latest_version
```

You can install packages from the command line:

```bash
flutter pub add advance_text_controller
```

## Controllers Overview

### DateEditingController

A controller for managing and formatting date input.

```dart
final dateController = DateEditingController(
  dateFormatPattern: 'dd MMM yyyy',
);
```

### TimeEditingController

A controller for managing and formatting time input.

```dart
final timeController = TimeEditingController(
  timeFormatPattern: 'hh:mm a',
);
```

### ModelEditingController

A controller for managing input based on a custom model.

```dart
final modelController = ModelEditingController<ProductModel>(
  getValue: (model) => model.name,
  setValue: (model, value) => model.copyWith(name: value),
);
```

### IntegerEditingController

A controller for managing integer input.

```dart
final integerController = IntegerEditingController();
```

### DoubleEditingController

A controller for managing double input.

```dart
final doubleController = DoubleEditingController();
```

## Example

<img src="https://github.com/user-attachments/assets/d683a50f-cb1f-4cfd-b6b3-c08c1523b2a0" width="300" height="600" />

See [Example page](https://github.com/Prashant4900/advance_text_controller/blob/main/example/lib/main.dart) for example code.

## Contributing

Feel free to open issues or submit pull requests on GitHub.

## License

This project is licensed under the [MIT License](https://github.com/Prashant4900/advance_text_controller/blob/main/LICENSE) - see the LICENSE file for details.
