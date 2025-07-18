import 'package:calculator_app/models/calculation_history.dart';
import 'package:flutter/material.dart';

class CalculatorButton {
  CalculatorButton({
    required this.text,
    required this.value,
    required this.type,
    this.color,
    this.textColor,
  });

  final String text;
  final String value;
  final ButtonType type;
  final Color? color;
  final Color? textColor;
}
