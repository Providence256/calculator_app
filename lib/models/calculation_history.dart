class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timeStamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timeStamp,
  });
}

enum ButtonType {
  number,
  operation,
  function,
  memory,
  utility,
  scientific,
}
