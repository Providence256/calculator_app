import 'package:calculator_app/models/calculation_history.dart';
import 'package:calculator_app/models/calculator_button.dart';
import 'package:calculator_app/models/calculator_state.dart';
import 'package:flutter/material.dart';

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key, required this.state, this.onTap});

  final CalculatorState state;
  final VoidCallback? onTap;

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  bool _showHistory = false;

  final List<List<CalculatorButton>> _buttonLayout = [
    [
      CalculatorButton(text: "(", value: "(", type: ButtonType.utility),
      CalculatorButton(text: ")", value: ")", type: ButtonType.utility),
      CalculatorButton(text: "MC", value: "MC", type: ButtonType.memory),
      CalculatorButton(text: "M+", value: "M+", type: ButtonType.memory),
      CalculatorButton(text: "M-", value: "M-", type: ButtonType.memory),
      CalculatorButton(text: "MR", value: "MR", type: ButtonType.memory),
    ],
    [
      CalculatorButton(text: "2ⁿᵈ", value: "2ⁿᵈ", type: ButtonType.scientific),
      CalculatorButton(text: "x²", value: "x²", type: ButtonType.scientific),
      CalculatorButton(text: "x³", value: "x³", type: ButtonType.scientific),
      CalculatorButton(text: "xʸ", value: "xʸ", type: ButtonType.scientific),
      CalculatorButton(text: "eˣ", value: "eˣ", type: ButtonType.scientific),
      CalculatorButton(text: "10ˣ", value: "10ˣ", type: ButtonType.scientific),
    ],
    [
      CalculatorButton(text: "1/x", value: "1/x", type: ButtonType.scientific),
      CalculatorButton(text: "√x", value: "√x", type: ButtonType.scientific),
      CalculatorButton(text: "∛x", value: "∛x", type: ButtonType.scientific),
      CalculatorButton(text: "ⁿ√x", value: "ⁿ√x", type: ButtonType.scientific),
      CalculatorButton(text: "ln", value: "ln", type: ButtonType.scientific),
      CalculatorButton(
          text: "log₁₀", value: "log₁₀", type: ButtonType.scientific)
    ],
    [
      CalculatorButton(text: "X!", value: "X!", type: ButtonType.scientific),
      CalculatorButton(text: "sin", value: "sin", type: ButtonType.scientific),
      CalculatorButton(text: "cos", value: "cos", type: ButtonType.scientific),
      CalculatorButton(text: "tan", value: "tan", type: ButtonType.scientific),
      CalculatorButton(text: "e", value: "e", type: ButtonType.scientific),
      CalculatorButton(text: "EE", value: "EE", type: ButtonType.scientific),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return _buildScientifiqueButtonGrid();
  }

  Widget _buildScientifiqueButtonGrid() {
    return Container(
      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: _buttonLayout.map((row) {
          return Row(
            children: row.map((button) {
              return Expanded(
                child: _buildScientificCalculatorButton(button),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScientificCalculatorButton(CalculatorButton button) {
    final isPressed = widget.state.operation == button.value;

    return Container(
      margin: EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isPressed
                  ? Colors.white
                  : button.color ?? _getDefaultButtonColor(button.type),
              borderRadius: BorderRadius.circular(50),
              border:
                  isPressed ? Border.all(color: Colors.orange, width: 2) : null,
            ),
            child: Center(
              child: Text(
                button.text,
                style: TextStyle(
                  color: isPressed
                      ? Colors.orange
                      : button.textColor ?? _getDefaultTextColor(button.type),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getDefaultButtonColor(ButtonType type) {
    switch (type) {
      case ButtonType.number:
        return Colors.grey[800]!;
      case ButtonType.operation:
        return Colors.orange;
      case ButtonType.function:
        return Colors.grey[600]!;
      case ButtonType.memory:
        return Colors.blue[700]!;
      case ButtonType.utility:
        return Colors.grey[600]!;
      case ButtonType.scientific:
        return Colors.grey[500]!;
    }
  }

  Color _getDefaultTextColor(ButtonType type) {
    switch (type) {
      case ButtonType.operation:
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}
