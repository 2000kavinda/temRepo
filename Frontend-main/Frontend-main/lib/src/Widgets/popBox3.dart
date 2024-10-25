import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:codesafari/src/Providers/provider.dart';
import 'package:codesafari/src/features/core/screens/home/home_screen.dart';
import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/appfonts.dart';
import 'package:codesafari/src/utils/pageNavigations.dart';

class Popbox3 extends StatelessWidget {
  final VoidCallback onClose;

  const Popbox3({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<MyModel>(context, listen: false);
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
                    NavigationUtils.frontNavigation(
                        context, const HomeScreen());
                    onClose();
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
              child: Text(
                'Your IT Knowledge',
                style: TextStyle(
                  fontFamily: AppFonts.inter,
                  fontSize: AppFonts.font24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              'Performance!',
              style: TextStyle(
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(myModel.levelImg),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      myModel.levelText,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: AppFonts.font20,
                        fontWeight: FontWeight.bold,
                        color: myModel.textCol,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      myModel.levelPara,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: AppFonts.font16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.gray5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
