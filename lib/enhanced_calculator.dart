import 'package:calculator_app/models/calculation_history.dart';
import 'package:calculator_app/models/calculator_button.dart';
import 'package:calculator_app/models/calculator_state.dart';
import 'package:calculator_app/services/calculator_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnhancedCalculator extends StatefulWidget {
  const EnhancedCalculator({super.key});

  @override
  State<EnhancedCalculator> createState() => _EnhancedCalculatorState();
}

class _EnhancedCalculatorState extends State<EnhancedCalculator> {
  CalculatorState _state = CalculatorState();

  bool _showHistory = false;
  late FocusNode _focusNode;

  final List<List<CalculatorButton>> _buttonLayout = [
    [
      CalculatorButton(text: "MC", value: "MC", type: ButtonType.memory),
      CalculatorButton(text: "MR", value: "MR", type: ButtonType.memory),
      CalculatorButton(text: "M+", value: "M+", type: ButtonType.memory),
      CalculatorButton(text: "M-", value: "M-", type: ButtonType.memory),
    ],
    [
      CalculatorButton(
          text: "C",
          value: "C",
          type: ButtonType.utility,
          color: Colors.red[400]),
      CalculatorButton(text: "CE", value: "CE", type: ButtonType.utility),
      CalculatorButton(text: "√", value: "√", type: ButtonType.function),
      CalculatorButton(
          text: "÷",
          value: "÷",
          type: ButtonType.operation,
          color: Colors.orange),
    ],
    [
      CalculatorButton(text: "7", value: "7", type: ButtonType.number),
      CalculatorButton(text: "8", value: "8", type: ButtonType.number),
      CalculatorButton(text: "9", value: "9", type: ButtonType.number),
      CalculatorButton(
          text: "x",
          value: "x",
          type: ButtonType.operation,
          color: Colors.orange),
    ],
    [
      CalculatorButton(text: "4", value: "4", type: ButtonType.number),
      CalculatorButton(text: "5", value: "5", type: ButtonType.number),
      CalculatorButton(text: "6", value: "6", type: ButtonType.number),
      CalculatorButton(
          text: "-",
          value: "-",
          type: ButtonType.operation,
          color: Colors.orange),
    ],
    [
      CalculatorButton(text: "1", value: "1", type: ButtonType.number),
      CalculatorButton(text: "2", value: "2", type: ButtonType.number),
      CalculatorButton(text: "3", value: "3", type: ButtonType.number),
      CalculatorButton(
          text: "+",
          value: "+",
          type: ButtonType.operation,
          color: Colors.orange),
    ],
    [
      CalculatorButton(text: "±", value: "±", type: ButtonType.function),
      CalculatorButton(text: "0", value: "0", type: ButtonType.number),
      CalculatorButton(text: ".", value: ".", type: ButtonType.number),
      CalculatorButton(
          text: "=",
          value: "=",
          type: ButtonType.operation,
          color: Colors.blue),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        autofocus: true,
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: _buildCalculatorUI(),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key.keyId >= LogicalKeyboardKey.digit0.keyId &&
          key.keyId <= LogicalKeyboardKey.digit9.keyId) {
        final digit = (key.keyId - LogicalKeyboardKey.digit0.keyId).toString();
        _handleButtonPress(digit);

        return KeyEventResult.handled;
      }

      // Operation keys

      switch (key.keyLabel) {
        case "+":
          _handleButtonPress("+");
          return KeyEventResult.handled;
        case "-":
          _handleButtonPress("-");
          return KeyEventResult.handled;
        case "*":
          _handleButtonPress("x");
          return KeyEventResult.handled;
        case "/":
          _handleButtonPress("÷");
          return KeyEventResult.handled;
        case "=":
        case "Enter":
          _handleButtonPress("=");
          return KeyEventResult.handled;
        case ".":
          _handleButtonPress(".");
          return KeyEventResult.handled;
        case "Escape":
          _handleButtonPress("C");
          return KeyEventResult.handled;
        case "Backspace":
          _handleButtonPress("CE");
          return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  void _handleButtonPress(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      _state = CalculatorLogic.processInput(_state, value);
    });
  }

  Widget _buildCalculatorUI() {
    return Column(
      children: [
        _buildDisplay(),
        _buildHistoryToggle(),
        Expanded(
          child: _showHistory ? _buildHistory() : _buildButtonGrid(),
        )
      ],
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //Memory indicator
          if (_state.memory != 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "M",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

          SizedBox(height: 8),

          // Current operation display
          if (_state.operation != null && _state.previousValue != null)
            Text(
              "${CalculatorLogic.formatDisplay(_state.previousValue!)}${_state.operation}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),

          // Main Display

          Container(
            width: double.infinity,
            child: Text(
              _state.display,
              style: TextStyle(
                color: Colors.white,
                fontSize: _getDisplayFontSize(),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  double _getDisplayFontSize() {
    final length = _state.display.length;
    if (length <= 8) return 48;
    if (length <= 10) return 40;
    if (length <= 12) return 32;

    return 24;
  }

  Widget _buildHistoryToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _showHistory ? "Calculator" : "History(${_state.history.length})",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
            icon: Icon(
              _showHistory ? Icons.calculate : Icons.history,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: _buttonLayout.map((row) {
          return Expanded(
            child: Row(
              children: row.map((button) {
                return Expanded(
                  child: _buildCalculatorButton(button),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalculatorButton(CalculatorButton button) {
    final isPressed = _state.operation == button.value;

    return Container(
      margin: EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleButtonPress(button.value),
          borderRadius: BorderRadius.circular(50),
          child: Container(
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
                  fontSize: 24,
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
        return Colors.grey[300]!;
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

  Widget _buildHistory() {
    if (_state.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey,
            ),
            Text(
              "No calculations yet",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        // Clear history button
        Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _clearHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
            ),
            child: Text("Clear History"),
          ),
        ),

        Expanded(
            child: ListView.builder(
                itemCount: _state.history.length,
                itemBuilder: (context, index) {
                  final historyItem =
                      _state.history[_state.history.length - 1 - index];

                  return _buildHistoryItem(historyItem);
                }))
      ],
    );
  }

  Widget _buildHistoryItem(CalculationHistory item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.grey[850],
      child: ListTile(
        title: Text(
          item.expression,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          "${item.timeStamp.hour.toString().padLeft(2, '0')}:${item.timeStamp.minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () => _useHistoryResult(item.result),
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _state = _state.copyWith(history: []);
    });
  }

  void _useHistoryResult(String result) {
    final value = double.tryParse(result);

    if (value != null) {
      setState(() {
        _state = _state.copyWith(
          display: result,
          currentValue: value,
          shouldResetDisplay: true,
        );

        _showHistory = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
