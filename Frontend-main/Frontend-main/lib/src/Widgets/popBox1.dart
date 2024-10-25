import 'package:flutter/material.dart';

import 'package:codesafari/src/utils/appColors.dart';
import 'package:codesafari/src/utils/appfonts.dart';

class Popbox1 extends StatelessWidget {
  final VoidCallback onOptionSelected;

  const Popbox1({
    Key? key,
    required this.onOptionSelected,
  }) : super(key: key);

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
            child: Text(
              'How Sure Are You',
              style: TextStyle(
                  fontFamily: AppFonts.inter,
                  fontSize: AppFonts.font24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'About Your Answer?',
            style: TextStyle(
                fontFamily: AppFonts.inter,
                fontSize: AppFonts.font24,
                fontWeight: FontWeight.bold),
          ),
        ],
      )),
      content: SizedBox(
        width: (MediaQuery.of(context).size.width * 332) / 412,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onOptionSelected();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/e1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onOptionSelected();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/e2.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onOptionSelected();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/e3.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
