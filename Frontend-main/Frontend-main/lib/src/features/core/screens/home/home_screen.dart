import 'dart:io';
import 'package:codesafari/src/Providers/navigationProvider.dart';
import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/features/core/screens/addstory/newstory_screen.dart';
import 'package:codesafari/src/features/core/screens/assisting_system/Assisting_System.dart';
import 'package:codesafari/src/features/core/screens/dashboard/dashboard_screen.dart';
import 'package:codesafari/src/features/quiz/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Mainscreen(),
    const NewstoryScreen(),
    const AssistingSystem(),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize PageController with the current index from NavigationProvider
    final initialIndex = context.read<NavigationProvider>().currentIndex;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            navigationProvider.setIndex(index);
          },
          children: _screens,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.deepPurple.shade100,
          onTap: (index) {
            navigationProvider.setIndex(index);
            _pageController.jumpToPage(index);
          },
          index: navigationProvider.currentIndex,
          items: const [
            Icon(Icons.home, color: CSAccentColor2),
            Icon(Icons.bookmark, color: CSAccentColor2),
            Icon(Icons.add, color: CSAccentColor2),
            Icon(Icons.question_answer, color: CSAccentColor2),
          ],
        ),
      ),
    );
  }
}
