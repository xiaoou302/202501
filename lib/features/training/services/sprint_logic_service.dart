import 'dart:math';

class Question {
  final int operand1;
  final int operand2;
  final String operator;
  final int correctAnswer;

  Question({
    required this.operand1,
    required this.operand2,
    required this.operator,
    required this.correctAnswer,
  });

  String get displayText => '$operand1 $operator $operand2';
}

class SprintLogicService {
  static final Random _random = Random();
  
  static Question generateQuestion(int difficulty) {
    switch (difficulty) {
      case 1: // Easy: Single digit multiplication
        return _generateSingleDigitMultiplication();
      case 2: // Medium: Two digit multiplication
        return _generateTwoDigitMultiplication();
      case 3: // Hard: Mixed operations
        return _generateMixedOperation();
      default:
        return _generateSingleDigitMultiplication();
    }
  }

  static Question _generateSingleDigitMultiplication() {
    final operand1 = _random.nextInt(9) + 1; // 1-9
    final operand2 = _random.nextInt(9) + 1; // 1-9
    return Question(
      operand1: operand1,
      operand2: operand2,
      operator: '×',
      correctAnswer: operand1 * operand2,
    );
  }

  static Question _generateTwoDigitMultiplication() {
    final operand1 = _random.nextInt(90) + 10; // 10-99
    final operand2 = _random.nextInt(9) + 1; // 1-9
    return Question(
      operand1: operand1,
      operand2: operand2,
      operator: '×',
      correctAnswer: operand1 * operand2,
    );
  }

  static Question _generateMixedOperation() {
    final operations = ['+', '-', '×'];
    final operation = operations[_random.nextInt(operations.length)];
    
    switch (operation) {
      case '+':
        return _generateAddition();
      case '-':
        return _generateSubtraction();
      case '×':
        return _generateTwoDigitMultiplication();
      default:
        return _generateAddition();
    }
  }

  static Question _generateAddition() {
    final operand1 = _random.nextInt(900) + 100; // 100-999
    final operand2 = _random.nextInt(900) + 100; // 100-999
    return Question(
      operand1: operand1,
      operand2: operand2,
      operator: '+',
      correctAnswer: operand1 + operand2,
    );
  }

  static Question _generateSubtraction() {
    final operand1 = _random.nextInt(900) + 100; // 100-999
    final operand2 = _random.nextInt(operand1); // 0 to operand1-1
    return Question(
      operand1: operand1,
      operand2: operand2,
      operator: '-',
      correctAnswer: operand1 - operand2,
    );
  }

  static int calculateDifficulty(int questionNumber) {
    if (questionNumber <= 5) return 1; // Easy for first 5 questions
    if (questionNumber <= 10) return 2; // Medium for next 5
    return 3; // Hard for remaining questions
  }

  static bool isAnswerCorrect(Question question, String userAnswer) {
    try {
      final userAnswerInt = int.parse(userAnswer);
      return userAnswerInt == question.correctAnswer;
    } catch (e) {
      return false;
    }
  }
}