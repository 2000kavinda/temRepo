import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:codesafari/src/constants/colors.dart';

enum Language { english, tamil }

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const ChatCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> with AutomaticKeepAliveClientMixin {
  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure the mixin works
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: BubbleNormal(
              text: widget.data['question'],
              isSender: true,
              color: Colors.white,
              tail: true,
              textStyle: TextStyle(color: CSAccentColor),
            ),
          ),
          SizedBox(height: 8.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BubbleNormal(
                  text: _selectedLanguage == Language.english
                      ? widget.data['answer']['eng']
                      : widget.data['answer']['tamil'],
                  isSender: false,
                  color: CSAccentColor,
                  tail: true,
                  textStyle: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: SegmentedButton<Language>(
                    style: SegmentedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: const BorderSide(style: BorderStyle.none),
                      selectedBackgroundColor: CSAccentColor,
                      selectedForegroundColor: Colors.white,
                      foregroundColor: CSAccentColor,
                    ),
                    segments: const <ButtonSegment<Language>>[
                      ButtonSegment<Language>(
                        value: Language.english,
                        label: Text('English'),
                      ),
                      ButtonSegment<Language>(
                        value: Language.tamil,
                        label: Text('தமிழ்'),
                      ),
                    ],
                    selected: <Language>{_selectedLanguage},
                    onSelectionChanged: (Set<Language> newSelection) {
                      setState(() {
                        _selectedLanguage = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}