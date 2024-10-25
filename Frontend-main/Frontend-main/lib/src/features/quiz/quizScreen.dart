import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:codesafari/src/Providers/provider.dart';
import 'package:codesafari/src/Service/quizService.dart';
import 'package:codesafari/src/Widgets/button.dart';
import 'package:codesafari/src/Widgets/loading.dart';
import 'package:codesafari/src/Widgets/popBox1.dart';
import 'package:codesafari/src/Widgets/popBox2.dart';
import 'package:codesafari/src/Widgets/popBox3.dart';
import 'package:codesafari/src/Widgets/snackBar.dart';
import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/appfonts.dart';

class Quizscreen extends StatefulWidget {
  const Quizscreen({super.key});

  @override
  State<Quizscreen> createState() => _QuizscreenState();
}

class _QuizscreenState extends State<Quizscreen> {
  int _currentQuestionIndex = 0;
  bool isLoading = false;
  Timer? _timer;
  int _correctAnswersCount = 0;
  int _selectedAnswerIndex = -1;
  int _totalElapsedTime = 0;

  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    initProcess(context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MyModel>(context, listen: false);
    final myModel = Provider.of<MyModel>(context, listen: false);

    if (_questions.isEmpty) {
      return Stack(children: [
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }
            Navigator.pop(context);
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.deepPurple.shade100,
              appBar: AppBar(
                backgroundColor: Colors.deepPurple.shade100,
                title: Text(
                  myModel.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: CSAccentColor,
                      ),
                ),
                centerTitle: true,
              ),
              body: const Center(),
            ),
          ),
        ),
        const Loading()
      ]);
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final answerOptions =
        List<String>.from(currentQuestion['answers'] as List<dynamic>);

    return Stack(children: [
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.deepPurple.shade100,
            appBar: AppBar(
              backgroundColor: Colors.deepPurple.shade100,
              title: Text(
                myModel.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: CSAccentColor,
                    ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_currentQuestionIndex + 1}/${_questions.length}',
                          style: const TextStyle(
                              fontSize: AppFonts.font18,
                              fontFamily: AppFonts.inter,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black2),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.gray1,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled,
                                  size: 20.0,
                                  color: AppColors.black2,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  _formatTime(_totalElapsedTime),
                                  style: const TextStyle(
                                      fontSize: AppFonts.font16,
                                      fontFamily: AppFonts.inter,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      minHeight: 10.0,
                      value: (_currentQuestionIndex + 1) / _questions.length,
                      backgroundColor: AppColors.gray3,
                      color: AppColors.gray2,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Text(
                        "Q${_currentQuestionIndex + 1}. ${currentQuestion['question']}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: AppFonts.font20,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.inter,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...answerOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String answer = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedAnswerIndex == index
                                ? AppColors.gray4
                                : AppColors.gray1,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedAnswerIndex = index;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                answer,
                                style: const TextStyle(
                                    fontFamily: AppFonts.inter,
                                    fontSize: AppFonts.font18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black1),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Button(
                            onPressed: () {
                              btnClick(context);
                            },
                            text: "Next",
                            buttonColor: AppColors.purple1,
                            width:
                                (MediaQuery.of(context).size.width * 138) / 412,
                            fontSize: AppFonts.font16,
                            fontWeight: FontWeight.bold),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      if (isLoading) const Loading(),
    ]);
  }

  void btnClick(BuildContext context) {
    if (_selectedAnswerIndex == -1) {
      SnackbarUtils.showDefaultSnackBar(
        context,
        "Please select an answer",
        AppColors.errorcolor,
      );
    } else {
      _checkAnswerAndProceed();
    }
  }

  Future<void> initProcess(BuildContext context) async {
    final myModel = Provider.of<MyModel>(context, listen: false);
    Quizservice quizservice = Quizservice();
    await quizservice.fetchQuestions(context).then((value) {
      setState(() {
        _questions = myModel.questions;
      });
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalElapsedTime++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkAnswerAndProceed() {
    final correctAnswerIndex =
        _questions[_currentQuestionIndex]['correctAnswerIndex'] as int;

    if (_selectedAnswerIndex == correctAnswerIndex) {
      _correctAnswersCount++;
    }

    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = -1;
      } else {
        _showHowSureDialog();
      }
    });
  }

  void _showHowSureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Popbox1(onOptionSelected: _showQuizResult),
    );
  }

  void _showQuizResultF() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Popbox3(
          onClose: () async {
            final myModel = Provider.of<MyModel>(context, listen: false);
            if (myModel.kLevel > 0.68) {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setString(myModel.level, "True");
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  void _showQuizResult() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Popbox2(
        correctAnswersCount: _correctAnswersCount,
        totalQuestions: _questions.length,
        elapsedTime: _formatTime1(_totalElapsedTime),
        onRetry: _restartQuiz,
        onCheckKnowledge: () async {
          if (isLoading == false) {
            setState(() {
              isLoading = true;
            });
            Quizservice quizservice = Quizservice();

            await quizservice
                .fetchKnowledgeLevel(
                    context, _correctAnswersCount, _totalElapsedTime)
                .then((value) {
              setState(() {
                isLoading = false;
              });
              _showQuizResultF();
            });
          }
        },
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswersCount = 0;
      _selectedAnswerIndex = -1;
      _totalElapsedTime = 0;
      _startTimer();
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}min ${remainingSeconds.toString().padLeft(2, '0')}s';
  }

  String _formatTime1(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
