import 'package:flutter/material.dart';
import 'package:codesafari/src/constants/colors.dart';

enum Language { english, tamil }

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final double closedHeight;
  final BorderRadius? borderRadius;
  final bool isScrollable;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.data,
    this.closedHeight = 30,
    this.borderRadius,
    this.isScrollable = true,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  Language _selectedLanguage = Language.english;

  final Map<Language, String> _titleTranslations = {
    Language.english: 'English',
    Language.tamil: 'தமிழ்',
  };

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    var headingColor = isDarkMode ? CSAccentHeadingDark : CSAccentHeadingLight;
    var contentColor = isDarkMode ? CSAccentContentDark : CSAccentContentLight;
    var cardColor = isDarkMode ? CSFAQDarkCardBgColor : CSFAQLightCardBgColor;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(4.0),
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16.0),
          ),
          elevation: 6.0,
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16.0),
            child: ExpansionTile(
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              title: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(
                  begin: widget.closedHeight,
                  end: _isExpanded ? 35.0 : widget.closedHeight,
                ),
                builder: (context, height, child) {
                  return SizedBox(
                    height: height,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: CSAccentColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  constraints: BoxConstraints(
                    maxHeight: widget.isScrollable ? double.infinity : double.maxFinite,
                  ),
                  child: Column(
                    children: [
                      widget.isScrollable
                          ? SingleChildScrollView(
                        child: Column(
                          children: widget.data.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              _selectedLanguage == Language.tamil ? item['tamil']! : item['eng']!,
                              style: TextStyle(color: contentColor, fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          )).toList(),
                        ),
                      )
                          : Column(
                        children: widget.data.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            _selectedLanguage == Language.tamil ? item['tamil']! : item['eng']!,
                            style: TextStyle(color: contentColor, fontSize: 18),
                            textAlign: TextAlign.justify,
                          ),
                        )).toList(),
                      ),
                      if (_isExpanded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SegmentedButton<Language>(
                              style: SegmentedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                side: const BorderSide(style: BorderStyle.none),
                                selectedBackgroundColor: CSAccentColor,
                                selectedForegroundColor: Colors.white,
                                foregroundColor: Colors.black,
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
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}