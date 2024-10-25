import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:codesafari/src/Providers/provider.dart';
import 'package:codesafari/src/Widgets/cardCus.dart';
import 'package:codesafari/src/Widgets/label.dart';
import 'package:codesafari/src/Widgets/labelResponsive.dart';
import 'package:codesafari/src/features/quiz/quizScreen.dart';
import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/appfonts.dart';
import 'package:codesafari/src/utils/pageNavigations.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  Color active = AppColors.black3;
  Color nonactive = AppColors.gray6;
  bool vis1 = true;
  bool vis2 = false;
  bool vis3 = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    initProcess(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        NavigationUtils.navBarNavigation(context, const Mainscreen());
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.gray3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Label(
                        hintText: "Hey, Buddy ✋",
                        textColor: AppColors.black1,
                        fontSize: AppFonts.font18,
                        fontFamily: AppFonts.inter,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: AppColors.gray7,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.gray6,
                            size: 24,
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search your quiz",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  const Column(
                    children: [
                      LabelResponsive(
                        hintText: "Are You Ready for the IT Challenge?",
                        textColor: AppColors.black1,
                        fontSize: AppFonts.font24,
                        fontFamily: AppFonts.inter,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  if (filterCard("IT Basics Explorer"))
                    Cardcus(
                      onPressed: () {
                        final myModel =
                            Provider.of<MyModel>(context, listen: false);
                        myModel.updateCurrentLevel("Easy");
                        myModel.updateLevel("Level 2");
                        myModel.updateTitle("IT Basics Explorer");
                        NavigationUtils.frontNavigationPush(
                            context, const Quizscreen());
                      },
                      text1: "IT Basics Explorer",
                      text2: "Level 1",
                      show1: !vis1,
                      show2: vis1,
                      bgImg: 'assets/l1.png',
                    ),
                  if (filterCard("Mastering Hardware Components"))
                    Cardcus(
                      onPressed: () {
                        final myModel =
                            Provider.of<MyModel>(context, listen: false);
                        myModel.updateCurrentLevel("Medium");
                        myModel.updateLevel("Level 3");
                        myModel.updateTitle("Mastering Hardware Components");
                        NavigationUtils.frontNavigationPush(
                            context, const Quizscreen());
                      },
                      text1: "Mastering Hardware Components",
                      text2: "Level 2",
                      show1: !vis2,
                      bgImg: 'assets/l2.png',
                      show2: vis2,
                    ),
                  if (filterCard("Mastering Hardware Components"))
                    Cardcus(
                      onPressed: () {
                        final myModel =
                            Provider.of<MyModel>(context, listen: false);
                        myModel.updateCurrentLevel("Difficult");
                        myModel.updateLevel("Level 3");
                        myModel.updateTitle("Mastering Hardware Components");
                        NavigationUtils.frontNavigationPush(
                            context, const Quizscreen());
                      },
                      text1: "Mastering Hardware Components",
                      text2: "Level 3",
                      show1: !vis3,
                      show2: vis3,
                      bgImg: 'assets/l3.png',
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initProcess(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('Level 1') == "True") {
      vis1 = true;
    }
    if (prefs.getString('Level 2') == "True") {
      vis2 = true;
    }
    if (prefs.getString('Level 3') == "True") {
      vis3 = true;
    }
    setState(() {});
  }

  bool filterCard(String text) {
    return text.toLowerCase().contains(searchQuery.toLowerCase());
  }
}
