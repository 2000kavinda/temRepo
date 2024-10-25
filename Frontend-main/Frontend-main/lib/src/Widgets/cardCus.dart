import 'package:flutter/material.dart';

import 'package:codesafari/src/Widgets/label.dart';
import 'package:codesafari/src/Widgets/labelResponsive.dart';
import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/appfonts.dart';

class Cardcus extends StatelessWidget {
  final VoidCallback onPressed;
  final String text1;
  final String bgImg;
  final String text2;
  final bool show1;
  final bool show2;

  const Cardcus({
    Key? key,
    required this.onPressed,
    required this.text1,
    required this.text2,
    required this.show1,
    required this.show2,
    required this.bgImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
          width: double.infinity,
          height: 165,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgImg),
              fit: BoxFit.fill,
            ),
            //color: AppColors.gray1,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      //color: Colors.amber,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        children: [
                          LabelResponsive(
                              hintText: text1,
                              textColor: AppColors.white1,
                              fontSize: AppFonts.font20,
                              fontFamily: AppFonts.inter,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          height: 32,
                          width: 110,
                          decoration: BoxDecoration(
                            color: AppColors.white1,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Label(
                                    hintText: text2,
                                    textColor: AppColors.black1,
                                    fontSize: AppFonts.font16,
                                    fontFamily: AppFonts.inter,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: show1,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.gray9,
                          shape: BoxShape.circle,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: AppColors.gray8,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: show2,
                      child: GestureDetector(
                        onTap: onPressed,
                        child: Container(
                            height: 48,
                            width: 101,
                            decoration: BoxDecoration(
                              color: AppColors.white1,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    color: AppColors.black1,
                                    size: 34,
                                  ),
                                  Label(
                                      hintText: "Play",
                                      textColor: AppColors.black1,
                                      fontSize: AppFonts.font18,
                                      fontFamily: AppFonts.inter,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
