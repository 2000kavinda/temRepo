import 'package:codesafari/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StoryDetailScreen extends StatelessWidget {
  final String storyTitle;
  final String storyContent;
  final String storyImage;
  final FlutterTts flutterTts = FlutterTts();

  speak(String storyContent) async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(storyContent);
  }

  StoryDetailScreen({
    super.key,
    required this.storyTitle,
    required this.storyContent,
    required this.storyImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Story',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: CSAccentColor,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  storyImage,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(storyTitle,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(storyContent, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          speak('$storyTitle. $storyContent');
        },
        backgroundColor: CSAccentColor,
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}
