import 'package:calculator_app/models/calculator_state.dart';
import 'package:calculator_app/services/calculator_logic.dart';
import 'dart:math' as math;

class ScientificCalculatorLogic extends CalculatorLogic {
  static CalculatorState handleScientificFunction(
      CalculatorState state, String function) {
    final current = state.currentValue ?? 0;

    double? result;

    switch (function) {
      case "sin":
        result = math.sin(current * math.pi / 180);
        break;
      case "cos":
        result = math.cos(current * math.pi / 180);
        break;
      case "tan":
        result = math.tan(current * math.pi / 180);
        break;
      case "log₁₀":
        if (current <= 0) return state.copyWith(display: "Error");
        result = math.log(current) / math.ln10;
        break;
      case "ln":
        if (current <= 0) return state.copyWith(display: "Error");
        result = math.log(current);
        break;
      case "x²":
        result = current * current;
        break;
      case "x³":
        result = current * current * current;
        break;
      case "1/x":
        if (current == 0) return state.copyWith(display: "Error");
        result = 1 / current;
        break;
      case "eˣ":
        result = math.exp(current);
        break;
      case "10ˣ":
        result = math.pow(10, current).toDouble();
        break;
      case "√x":
        if (current < 0) return state.copyWith(display: "Error");
        result = math.sqrt(current);
        break;
      case "∛x":
        result = math.pow(current, 1 / 3).toDouble();
        break;
      case "X!":
        if (current < 0 || current != current.toInt() || current > 170) {
          return state.copyWith(display: "Error");
        }
        result = _factorial(current.toInt()).toDouble();
        break;
      case "e":
        result = math.e;
        break;
      case "π":
        result = math.pi;
        break;
      case "MC":
        return state.copyWith(memory: 0);
      case "MR":
        return state.copyWith(
          display: CalculatorLogic.formatDisplay(state.memory),
          currentValue: state.memory,
          shouldResetDisplay: true,
        );
      case "M+":
        return state.copyWith(memory: state.memory + current);
      case "M-":
        return state.copyWith(memory: state.memory - current);

      default:
        return state;
    }

    return state.copyWith(
      display: CalculatorLogic.formatDisplay(result),
      currentValue: result,
      shouldResetDisplay: true,
    );
  }

  static int _factorial(int n) {
    if (n <= 1) return 1;

    int result = 1;

    for (int i = 2; i <= n; i++) {
      result *= i;
    }

    return result;
  }

  static CalculatorState handleAdvancedOperation(
      CalculatorState state, String operation) {
    switch (operation) {
      case "xʸ":
        return state.copyWith(
          previousValue: state.currentValue ?? 0,
          operation: "^",
          shouldResetDisplay: true,
        );
      case "ⁿ√x":
        return state.copyWith(
          previousValue: state.currentValue ?? 0,
          operation: "√",
          shouldResetDisplay: true,
        );

      default:
        return state;
    }
  }

  static double? calculateAdvanced(double a, double b, String operation) {
    try {
      switch (operation) {
        case "^":
          return math.pow(a, b).toDouble();
        case "√":
          if (a <= 0) return null;
          return math.pow(b, 1 / a).toDouble();
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}
