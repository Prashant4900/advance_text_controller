import 'package:advance_text_controller/advance_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateEditingController', () {
    test('initializes with default date format', () {
      final controller = DateEditingController();
      expect(controller.dateFormatPattern, 'dd MMM yyyy');
      expect(controller.text, '');
    });

    test('initializes with custom date format', () {
      final controller = DateEditingController(dateFormatPattern: 'yyyy-MM-dd');
      expect(controller.dateFormatPattern, 'yyyy-MM-dd');
      expect(controller.text, '');
    });

    test('sets date and updates text', () {
      final controller = DateEditingController()
        ..setDate(DateTime(2022, 12, 25));
      expect(controller.text, '25 Dec 2022');
    });
  });

  group('TimeEditingController', () {
    test('initializes with default time format', () {
      final controller = TimeEditingController();
      expect(controller.timeFormatPattern, 'hh:mm a');
      expect(controller.text, '');
    });

    test('initializes with custom time format', () {
      final controller = TimeEditingController(timeFormatPattern: 'HH:mm');
      expect(controller.timeFormatPattern, 'HH:mm');
      expect(controller.text, '');
    });

    test('sets time and updates text', () {
      final controller = TimeEditingController()
        ..setTime(const TimeOfDay(hour: 14, minute: 30));
      expect(controller.text, '02:30 PM');
    });
  });

  group('ModelEditingController', () {
    test('initializes with initial value and text', () {
      final controller = ModelEditingController<String>(
        initialValue: 'initial value',
        text: 'initial text',
      );
      expect(controller.model, 'initial value');
      expect(controller.text, 'initial text');
    });

    test('updates model when text changes', () {
      final controller = ModelEditingController<String>(
        initialValue: 'initial value',
        setValue: (model, value) => value,
      )..text = 'new text';
      expect(controller.model, 'new text');
    });
  });

  group('MultiValueEditingController', () {
    test('initializes with key', () {
      final controller = MultiValueEditingController(key: 'initial key');
      expect(controller.key, 'initial key');
      expect(controller.text, 'initial key');
    });

    test('sets key and updates text', () {
      final controller = MultiValueEditingController()..setKey('new key');
      expect(controller.key, 'new key');
      expect(controller.text, 'new key');
    });
  });

  group('NumberEditingController', () {
    test('parses integer input', () {
      final controller = IntegerEditingController()..text = '123';
      expect(controller.numberValue, 123);
    });

    test('parses double input', () {
      final controller = DoubleEditingController()..text = '12.34';
      expect(controller.numberValue, 12.34);
    });
  });
}
