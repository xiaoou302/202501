import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';
import 'package:zenithsprint/features/training/services/sprint_logic_service.dart';
import 'package:zenithsprint/data/models/sprint_session.dart';

class SprintScreen extends StatefulWidget {
  const SprintScreen({super.key});

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

class _SprintScreenState extends State<SprintScreen> {
  late Timer _timer;
  int _start = 180; // 3 minutes
  String _currentInput = "";
  final int _totalQuestions = 15;
  int _currentQuestion = 1;
  late Question _currentQuestionData;
  int _correctAnswers = 0;
  List<bool> _answerHistory = [];
  late DateTime _startTime;
  bool _showFeedback = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _generateNewQuestion();
    startTimer();
  }

  void _generateNewQuestion() {
    final difficulty = SprintLogicService.calculateDifficulty(_currentQuestion);
    _currentQuestionData = SprintLogicService.generateQuestion(difficulty);
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _navigateToResults();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _navigateToResults() {
    _timer.cancel();
    final session = SprintSession(
      startTime: _startTime,
      durationInSeconds: 180 - _start,
      totalQuestions: _answerHistory.length, // Use actual answered questions
      correctAnswers: _correctAnswers,
      answerHistory: _answerHistory,
    );

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.sprintResults,
      arguments: session,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == '↵') {
        // Submit answer
        if (_currentInput.isNotEmpty) {
          final isCorrect = SprintLogicService.isAnswerCorrect(
              _currentQuestionData, _currentInput);
          _answerHistory.add(isCorrect);
          if (isCorrect) {
            _correctAnswers++;
          }

          // Show feedback briefly
          _showFeedback = true;
          _lastAnswerCorrect = isCorrect;

          // Wait a moment before moving to next question
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _showFeedback = false;
              if (_currentQuestion < _totalQuestions) {
                _currentQuestion++;
                _currentInput = "";
                _generateNewQuestion();
              } else {
                _navigateToResults();
              }
            });
          });
        }
      } else if (value == 'del') {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        }
      } else {
        _currentInput += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_start ~/ 60).toString().padLeft(2, '0');
    String seconds = (_start % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$minutes:$seconds',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: LinearProgressIndicator(
                      value: _currentQuestion / _totalQuestions,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                  Text('$_currentQuestion/$_totalQuestions',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
                ],
              ),
              // Question
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentQuestionData.displayText,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold),
                      ),
                      if (_showFeedback) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                _lastAnswerCorrect ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _lastAnswerCorrect ? 'Correct!' : 'Wrong',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Input and Keyboard
              _buildKeyboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['del', '0', '↵'],
    ];

    return Container(
      padding: const EdgeInsets.all(AppValues.padding_small),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppValues.radius_large),
      ),
      child: Column(
        children: [
          // Display
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.padding, vertical: AppValues.padding),
            alignment: Alignment.centerRight,
            child: Text(
              _currentInput.isEmpty ? ' ' : _currentInput,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: AppColors.white),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: AppValues.margin_small),
          // Buttons
          ...keys.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () => _onKeyPressed(key),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: key == '↵'
                            ? AppColors.accent
                            : Colors.white.withValues(alpha: 0.2),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppValues.radius),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: key == 'del'
                          ? const Icon(Icons.backspace_outlined)
                          : Text(
                              key,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}
