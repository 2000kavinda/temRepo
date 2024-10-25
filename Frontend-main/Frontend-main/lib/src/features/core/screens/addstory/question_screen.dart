import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/features/core/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class QuestionScreen extends StatefulWidget {
  final List<String> questions;
  final List<List<Map<String, String>>> options;
  final List<String> correctAnswers;
  final Map<String, String> hints;

  const QuestionScreen({
    super.key,
    required this.options,
    required this.questions,
    required this.correctAnswers,
    required this.hints,
  });

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedOption;
  final List<String?> _userAnswers = [];
  Timer? _hintTimer;
  Timer? _questionTimer;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _questions = _prepareQuestions();
    _userAnswers.addAll(List<String?>.filled(widget.questions.length, null));
    _startQuestionTimer(); // Start the timer when the question screen is loaded
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  // Method to extract hints from a given string
  Map<String, String> extractHints(String hintString) {
    final hintsMap = <String, String>{};
    final hintParts =
        hintString.split(RegExp(r'\*\*Hint for Question \d+:\*\*'));

    for (int i = 1; i < hintParts.length; i++) {
      final trimmedHint = hintParts[i].trim();
      hintsMap['Hint for Question $i'] = trimmedHint;
    }

    return hintsMap;
  }

  void _startQuestionTimer() {
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // This will be called every second to check if 1 minute has passed
      if (_currentQuestionIndex < _questions.length) {
        final elapsedSeconds = timer.tick;

        if (elapsedSeconds >= 60) {
          // If the user has been on the question for more than 1 minute, show the hint
          setState(() {
            _showHint = true;
          });
        }
      }
    });
  }

  void _startHintTimer() {
    _hintTimer = Timer(const Duration(minutes: 1), () {
      setState(() {
        _showHint = true; // Show hint after 1 minute
      });
    });
  }

  void _answerQuestion(String selectedAnswer) {
    _userAnswers[_currentQuestionIndex] = selectedAnswer;
    final correctAnswer = _questions[_currentQuestionIndex]['answer'];
    if (selectedAnswer == correctAnswer) {
      _score++;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null; // Reset selected option
        _showHint = false; // Hide hint when moving to the next question
        _startQuestionTimer(); // Restart timer for the new question
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackScreen(
            score: _score,
            totalQuestions: _questions.length,
            questions: widget.questions, // Pass questions
            options: widget.options, // Pass options
            correctAnswers: widget.correctAnswers, // Pass correctAnswers
            userAnswers: _userAnswers,
          ),
        ),
      );
    }
  }

  List<Map<String, dynamic>> _prepareQuestions() {
    final questions = <Map<String, dynamic>>[];
    final questionTexts = widget.questions;
    final optionsData = widget.options;
    final correctAnswers = widget.correctAnswers;

    for (int i = 0; i < questionTexts.length; i++) {
      questions.add({
        'question': questionTexts[i],
        'options': optionsData[i], // This is a list of maps for each question
        'answer': correctAnswers[i],
      });
    }
    return questions;
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final optionsList = currentQuestion['options'] as List<Map<String, String>>;
    final hintKey = 'Hint for Question ${_currentQuestionIndex + 1}';
    final hint = widget.hints[hintKey] ?? 'No hint available for this question';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${_currentQuestionIndex + 1}',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: CSAccentColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion['question'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // Display all options for the current question
            ...optionsList.expand<Widget>((optionMap) {
              return optionMap.entries.map<Widget>((entry) {
                final optionKey = entry.key;
                final optionValue = entry.value;
                return ListTile(
                  title: Text(optionValue),
                  leading: Radio<String>(
                    value: optionKey,
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                );
              }).toList();
            }),
            const SizedBox(height: 20),
            if (_showHint) // Show the hint if _showHint is true
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hint,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _selectedOption != null
                    ? () => _answerQuestion(_selectedOption!)
                    : null,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<String> questions;
  final List<List<Map<String, String>>> options;
  final List<String> correctAnswers;
  final List<String?> userAnswers;

  const FeedbackScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.options,
    required this.correctAnswers,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the image and message based on the score
    String imagePath;
    String message;
    if (score <= 1) {
      imagePath = 'assets/images/story/zeroone.png';
      message = 'You have to learn the concept again!';
    } else if (score <= 4) {
      imagePath = 'assets/images/story/twothreefour.png';
      message = 'Keep practicing to improve your skills!';
    } else if (score == 5) {
      imagePath = 'assets/images/story/five.png';
      message =
          'Congratulations! 🎉 You got all the answers correct! You\'re a programming pro! Keep up the great work and continue exploring the world of coding.';
    } else {
      imagePath = 'assets/default.png'; // Fallback image
      message = 'Your score is out of the expected range!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: CSAccentColor, // Use your accent color here
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imagePath,
                width: 300, // Adjust the size as needed
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'You scored $score out of $totalQuestions',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black54,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(
                      questions: questions,
                      options: options,
                      correctAnswers: correctAnswers,
                      userAnswers: userAnswers,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CSAccentColor,
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Review Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final List<String> questions;
  final List<List<Map<String, String>>> options;
  final List<String> correctAnswers;
  final List<String?> userAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.options,
    required this.correctAnswers,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review Quiz',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: CSAccentColor,
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final optionList = options[index];
                  final correctAnswer = correctAnswers[index];
                  final userAnswer = userAnswers[index];

                  // Determine if the user's answer is correct or not
                  final isAnswerCorrect = userAnswer == correctAnswer;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 4,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Q${index + 1}: $question',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 10),
                              ...optionList.expand<Widget>((optionMap) {
                                return optionMap.entries.map<Widget>((entry) {
                                  final optionKey = entry.key;
                                  final optionValue = entry.value;
                                  final isCorrect = optionKey == correctAnswer;
                                  final isSelected = optionKey == userAnswer;
                                  return ListTile(
                                    title: Text(
                                      '$optionKey: $optionValue',
                                      style: TextStyle(
                                        color: isSelected
                                            ? (isCorrect
                                                ? Colors.green
                                                : Colors.red)
                                            : (isCorrect
                                                ? Colors.green
                                                : Colors.black),
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }).toList();
                              }),
                            ],
                          ),
                        ),
                        if (userAnswer != null)
                          Positioned(
                            right: 8.0,
                            top: 8.0,
                            child: Icon(
                              isAnswerCorrect
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  isAnswerCorrect ? Colors.green : Colors.red,
                              size: 24.0,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomeScreen()), // Replace HomeScreen with your home screen widget
                  (Route<dynamic> route) =>
                      false, // Removes all routes from the stack
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CSAccentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 28.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Done'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
