import 'package:codesafari/src/utils/appColors.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white.withOpacity(0.5),
          child: const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.borderColor),
            ],
          )),
        ),
      ],
    );
  }
}
