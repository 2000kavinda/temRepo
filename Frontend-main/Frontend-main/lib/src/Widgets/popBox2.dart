import 'package:flutter/material.dart';

import 'package:codesafari/src/Widgets/button.dart';
import 'package:codesafari/src/Widgets/labelResponsive.dart';
import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/appfonts.dart';

class Popbox2 extends StatelessWidget {
  final int correctAnswersCount;
  final int totalQuestions;
  final String elapsedTime;
  final VoidCallback onRetry;
  final VoidCallback onCheckKnowledge;

  const Popbox2({
    super.key,
    required this.correctAnswersCount,
    required this.totalQuestions,
    required this.elapsedTime,
    required this.onRetry,
    required this.onCheckKnowledge,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: AppColors.white1,
      contentPadding: const EdgeInsets.all(26.0),
      title: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 16.0,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: LabelResponsive(
                hintText: "Awesome! You Finished the Quiz!",
                textColor: AppColors.black1,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.inter,
                fontSize: AppFonts.font24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Column(
            children: [
              Container(
                height: 180,
                width: 206,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/win.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Time taken : ',
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: AppFonts.font16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.gray5,
                      ),
                    ),
                    Text(
                      elapsedTime,
                      style: const TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: AppFonts.font16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Correct Answers : ',
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: AppFonts.font16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray5,
                    ),
                  ),
                  Text(
                    '$correctAnswersCount/$totalQuestions',
                    style: const TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: AppFonts.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.0,
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry();
                    },
                    text: "Retry",
                    textColor: AppColors.black1,
                    bordColor: AppColors.black1,
                    buttonColor: AppColors.white1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fontSize: AppFonts.font16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCheckKnowledge();
                    },
                    text: "Check Knowledge",
                    buttonColor: AppColors.purple1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fontSize: AppFonts.font16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
