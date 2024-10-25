import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:codesafari/src/Providers/provider.dart';
import 'package:codesafari/src/Widgets/snackBar.dart';
import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/constValues.dart';

class Quizservice {
  Future<void> fetchKnowledgeLevel(BuildContext context,
      int correctAnswersCount, int totalElapsedTime) async {
    final myModel = Provider.of<MyModel>(context, listen: false);
    final url = Uri.parse('${ConstValues.baseUrl}/it_knowledge/predict');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Average Correctness': correctAnswersCount,
          'Average Time Taken': totalElapsedTime,
          'Confidence Level': 2,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double knowledgeLevel = data['it_knowledge_level'];
        myModel.updateKLevel(knowledgeLevel);
        if (knowledgeLevel < 0.68) {
          myModel.updateLevelText("Bad");
          myModel.updateTextCol(AppColors.msgCol3);
          myModel.updateLevelPara(
              "Good effort! Don’t worry, keep practicing and you’ll improve!");
          myModel.updateLevelImg("assets/wonB.png");
        } else if (knowledgeLevel < 0.8) {
          myModel.updateLevelText("Good");
          myModel.updateTextCol(AppColors.msgCol2);
          myModel.updateLevelPara("Well done! Keep pushing forward!");
          myModel.updateLevelImg("assets/wonG.png");
        } else if (knowledgeLevel > 0.8) {
          myModel.updateLevelText("Excellent");
          myModel.updateTextCol(AppColors.msgCol1);
          myModel.updateLevelPara("Great job! You’re an IT Pro!");
          myModel.updateLevelImg("assets/won.png");
        }
      } else {
        SnackbarUtils.showDefaultSnackBar(
          context,
          "Failed to load knowledge level",
          AppColors.errorcolor,
        );
        throw Exception('Failed to load knowledge level');
      }
    } catch (error) {
      SnackbarUtils.showDefaultSnackBar(
        context,
        error.toString(),
        AppColors.errorcolor,
      );
    }
  }

  Future<void> fetchQuestions(BuildContext context) async {
    final myModel = Provider.of<MyModel>(context, listen: false);
    final url = Uri.parse('${ConstValues.baseUrl}/level');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'level': myModel.currentLevel}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> questionsData = data['questions'];

        myModel.updateQs(questionsData.map((q) {
          return {
            'question': q['question'],
            'answers': q['options'],
            'correctAnswerIndex': q['options'].indexOf(q['answer']),
          };
        }).toList());
      } else {
        SnackbarUtils.showDefaultSnackBar(
          context,
          'Failed to load questions',
          AppColors.errorcolor,
        );
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      SnackbarUtils.showDefaultSnackBar(
        context,
        error.toString(),
        AppColors.errorcolor,
      );
    }
  }
}
