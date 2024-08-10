import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A custom [TextEditingController] for handling date input.
///
/// This controller allows you to format and manage dates with customizable
/// date and time patterns. If no patterns are provided,
/// default formats are used.
class DateEditingController extends TextEditingController {
  /// Creates a [DateEditingController] with an optional initial [date].
  ///
  /// You can also specify custom [dateFormatPattern] and [timeFormatPattern]
  /// to format the date and time according to your needs.
  DateEditingController({
    DateTime? date,
    this.dateFormatPattern = 'dd MMM yyyy', // Default date format
    this.timeFormatPattern = 'hh:mm a', // Default time format
  }) {
    _dateTime = date;
    // Initialize the date and time formatters with the given patterns
    dateFormatter = DateFormat(dateFormatPattern);
    timeFormatter = DateFormat(timeFormatPattern);
    // Set the initial text based on the provided date, if any
    text = _dateTime != null ? dateFormatter.format(_dateTime!) : '';
  }

  /// The format pattern used for displaying dates. Defaults to 'dd MMM yyyy'.
  final String dateFormatPattern;

  /// The format pattern used for displaying times. Defaults to 'hh:mm a'.
  final String timeFormatPattern;

  /// Formatter for dates using the provided or default pattern.
  late final DateFormat dateFormatter;

  /// Formatter for times using the provided or default pattern.
  late final DateFormat timeFormatter;

  /// The current date and time managed by this controller.
  DateTime? _dateTime;

  /// Returns the current [DateTime] value managed by this controller.
  DateTime? get dateTime => _dateTime;

  /// Returns the current date as a formatted string.
  String get date => _dateTime != null ? dateFormatter.format(_dateTime!) : '';

  /// Returns the current time as a formatted string.
  String get time => _dateTime != null ? timeFormatter.format(_dateTime!) : '';

  /// Updates the date part of the [DateTime] and refreshes the controller's text.
  ///
  /// The time part of the [DateTime] remains unchanged.
  void setDate(DateTime date) {
    // Update the date part while preserving the time part, if any
    _dateTime = (_dateTime ?? DateTime(0)).copyWith(
      year: date.year,
      month: date.month,
      day: date.day,
    );
    // Update the controller's text with the new formatted date
    text = dateFormatter.format(_dateTime!);
  }

  /// Updates the time part of the [DateTime] and refreshes the controller's text.
  ///
  /// The date part of the [DateTime] remains unchanged.
  void setTime(TimeOfDay time) {
    // Update the time part while preserving the date part, if any
    _dateTime = (_dateTime ?? DateTime(0)).copyWith(
      hour: time.hour,
      minute: time.minute,
    );
    // Update the controller's text with the new formatted time
    text = dateFormatter.format(_dateTime!);
  }

  /// Sets the full [DateTime] value and refreshes the controller's text.
  void setDateTime(DateTime dateTime) {
    _dateTime = dateTime;
    // Update the controller's text with the new formatted date
    text = dateFormatter.format(dateTime);
  }
}

/// A custom [TextEditingController] for handling time input.
///
/// This controller allows you to format and manage times with a customizable
/// time pattern. If no pattern is provided, a default format is used.
class TimeEditingController extends TextEditingController {
  /// Creates a [TimeEditingController] with an optional initial [time].
  ///
  /// You can also specify a custom [timeFormatPattern] to format the time
  /// according to your needs.
  TimeEditingController({
    TimeOfDay? time,
    this.timeFormatPattern = 'hh:mm a', // Default time format
  }) {
    // Initialize the time formatter with the given pattern
    timeFormatter = DateFormat(timeFormatPattern);
    if (time != null) {
      setTime(time);
    }
  }

  /// The format pattern used for displaying times. Defaults to 'hh:mm a'.
  final String timeFormatPattern;

  /// Formatter for times using the provided or default pattern.
  late final DateFormat timeFormatter;

  /// The current time managed by this controller as a [TimeOfDay] object.
  TimeOfDay? _timeOfDay;

  /// Returns the current [TimeOfDay] value managed by this controller.
  TimeOfDay? get timeOfDay => _timeOfDay;

  /// Updates the time and refreshes the controller's text.
  void setTime(TimeOfDay time) {
    _timeOfDay = time;
    // Create a DateTime object to use with the formatter
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    // Update the controller's text with the new formatted time
    text = timeFormatter.format(dateTime);
  }
}

/// A generic [TextEditingController] for managing a model with custom value
/// conversion functions.
///
/// This controller supports initializing with a model and updating the model
/// based on text changes. It also provides methods to update and apply model values.
class ModelEditingController<T> extends TextEditingController {
  /// Creates a [ModelEditingController] with optional initial values and
  /// conversion functions.
  ///
  /// [initialValue] is used to set the initial value of the model.
  /// [text] sets the initial text, overriding [initialValue] if provided.
  /// [getValue] is a function to convert a model to a string for display.
  /// [setValue] is a function to convert text back into a model.
  ModelEditingController({
    T? initialValue,
    String? text,
    String Function(T model)? getValue,
    T Function(T model, String value)? setValue,
  })  : _getValue = getValue,
        _setValue = setValue {
    // Set initial text based on provided text or initialValue
    if (text != null) {
      this.text = text;
    } else if (initialValue != null && _getValue != null) {
      this.text = _getValue(initialValue);
    }
    _model = initialValue;
    // Add listener to update the model when text changes
    addListener(_updateModel);
  }

  // Function to convert a model to a string
  final String Function(T model)? _getValue;

  // Function to convert text back into a model
  final T Function(T model, String value)? _setValue;

  // The current model value
  T? _model;

  /// Returns the current model value.
  T? get model => _model;

  /// Updates the model based on the current text input.
  ///
  /// If [setValue] is provided, it updates the model and reflects any changes in
  /// the text field.
  void _updateModel() {
    if (_model != null && _setValue != null) {
      _model = _setValue(_model as T, text);
    }
  }

  /// Updates the controller's model and text.
  ///
  /// [model] is the new model value. The text field is updated based on [getValue].
  void updateModel(T model) {
    _model = model;
    if (_getValue != null) {
      text = _getValue(model);
    }
  }

  /// Applies changes from the text field to the current model.
  ///
  /// The model is updated using [setValue] based on the current text.
  void applyToModel(T model) {
    if (_setValue != null) {
      _model = _setValue(model, text);
    }
  }
}

/// A [TextEditingController] for handling a single string key value.
///
/// This controller allows setting and retrieving a key, which can be used
/// for various purposes, such as identifying multiple values.
class MultiValueEditingController extends TextEditingController {
  /// Creates a [MultiValueEditingController] with an optional initial key value.
  ///
  /// If [key] is provided, it initializes the controller with this key.
  MultiValueEditingController({String? key}) {
    if (key != null) {
      setKey(key);
    }
  }

  // The current key value
  String? _key;

  /// Returns the current key value.
  String? get key => _key;

  /// Sets the key value and updates the text field.
  ///
  /// This method updates the internal key and the text displayed in the
  /// controller.
  void setKey(String value) {
    _key = value;
    text = value;
  }
}

/// A generic [TextEditingController] for parsing and managing numerical input.
///
/// This controller handles both integer and double values, with the specific
/// type determined by the subclass. It listens to text input changes and updates
/// the internal numerical value accordingly.
abstract class NumberEditingController<T extends num>
    extends TextEditingController {
  /// Constructor for [NumberEditingController].
  ///
  /// Accepts an optional initial value, which is set if provided.
  NumberEditingController({T? initialValue}) {
    if (initialValue != null) {
      setValue(initialValue);
    }
    // Listen for changes in the text and parse the input accordingly
    addListener(_parseInput);
  }

  /// The current parsed numerical value.
  T? _numberValue;

  /// Getter for the current numerical value.
  T? get numberValue => _numberValue;

  /// Parses the text input to update the internal numerical value.
  ///
  /// The specific parsing logic is implemented in the subclasses.
  void _parseInput() {
    if (text.isEmpty) {
      _numberValue = null;
    } else {
      final rawText = text.trim().replaceAll(',', '');
      _numberValue = parseValue(rawText);
    }
  }

  /// Parses the raw text input into the appropriate numerical type.
  ///
  /// Must be implemented by subclasses to handle specific types like [int] or [double].
  T? parseValue(String rawText);

  /// Sets the numerical value and updates the text in the controller.
  void setValue(T value) {
    _numberValue = value;
    text = value.toString();
  }
}

/// A [TextEditingController] for handling integer input.
///
/// This controller parses the text as an integer and manages the internal integer value.
class IntegerEditingController extends NumberEditingController<int> {
  /// Creates an [IntegerEditingController] with an optional initial integer value.
  IntegerEditingController({super.initialValue});

  /// Parses the raw text input into an [int].
  ///
  /// Returns `null` if the input cannot be parsed as an integer.
  @override
  int? parseValue(String rawText) => int.tryParse(rawText);
}

/// A [TextEditingController] for handling double input.
///
/// This controller parses the text as a double and manages the internal double value.
class DoubleEditingController extends NumberEditingController<double> {
  /// Creates a [DoubleEditingController] with an optional initial double value.
  DoubleEditingController({super.initialValue});

  /// Parses the raw text input into a [double].
  ///
  /// Returns `null` if the input cannot be parsed as a double.
  @override
  double? parseValue(String rawText) => double.tryParse(rawText);
}
