import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:codesafari/src/features/core/screens/addstory/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class StoryScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String genreImage;



  const StoryScreen({
    super.key,
    required this.data,
    required this.genreImage,
  });

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final FlutterTts flutterTts = FlutterTts();


  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    var languages = await flutterTts.getLanguages;

    if (languages.isNotEmpty) {
      await flutterTts.speak(text);
    } else {
      print('TTS engine is not available.');
    }
  }


  @override
  Widget build(BuildContext context) {
    print(
        "**********************************************************************************************************************************");
    final title = widget.data['title'] ?? 'No Title';
    print(title);
    final story = widget.data['story'] ?? 'No Story Available';
    print(story);
    final List<String> questions = (widget.data['questions'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ??
        [];
    print(questions);

    // Convert options data to the expected format
    final List<List<Map<String, String>>> options =
        (widget.data['options'] as List<dynamic>?)?.map((item) {
              if (item is Map) {
                // Wrap each map in a list
                return [item.cast<String, String>()];
              }
              return <Map<String, String>>[];
            }).toList() ??
            [];
    print(options);

    final List<String> correctAnswers =
        (widget.data['correct_answers'] as List<dynamic>?)
                ?.map((item) => item.toString())
                .toList() ??
            [];
    print(correctAnswers);

    final dynamic rawHints = widget.data['hints'];
    print(rawHints);

    // Check if rawHints is a Map or a String and handle accordingly
    final Map<String, String> hints = (rawHints is Map<String, dynamic>)
        ? Map<String, String>.from(
            rawHints.map((key, value) => MapEntry(key, value.toString())))
        : extractHints(rawHints.toString());

    print(hints);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.genreImage.isNotEmpty)
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset(
                  widget.genreImage,
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: CSAccentColor,
                              ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      story,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                _speak('$title. $story');
              },
              backgroundColor: CSAccentColor,
              heroTag: 'speak',
              child: const Icon(Icons.volume_up),
            ),
          ),
          Positioned(
            right: 80,
            bottom: 2,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionScreen(
                            questions: questions,
                            options: options,
                            correctAnswers: correctAnswers,
                            hints: hints,
                          )),
                );
              },
              backgroundColor: Colors.orangeAccent,
              heroTag: 'challenge',
              child: const Icon(Icons.question_answer),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, String> extractHints(String hintString) {
  final hintsMap = <String, String>{};
  final hintParts = hintString.split(RegExp(r'\*\*Question \d+:\*\*'));

  for (int i = 1; i < hintParts.length; i++) {
    final trimmedHint = hintParts[i].trim();
    hintsMap['Hint for Question $i'] = trimmedHint;
  }

  return hintsMap;
}
