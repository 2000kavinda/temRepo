import 'package:codesafari/src/constants/image_strings.dart';
import 'package:codesafari/src/constants/sizes.dart';
import 'package:codesafari/src/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_screen_controller.dart';
// Import the WelcomeScreen

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 60 : 30,
              left: splashController.animate.value ? -10 : -40,
              child: Transform.rotate(
                angle: 2.4, // Adjust the angle to rotate the icon (in radians)
                child: const Image(
                  image: AssetImage(CSSplashTopIcon1),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? -5 : -35,
              left: splashController.animate.value ? 60 : 30,
              child: Transform.rotate(
                angle: -0.3, // Adjust the angle to rotate the icon (in radians)
                child: const Image(
                  image: AssetImage(CSSplashTopIcon2),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? -10 : -40,
              right: splashController.animate.value ? 100 : 70,
              child: Transform.rotate(
                angle: -0.3, // Adjust the angle to rotate the icon (in radians)
                child: const Image(
                  image: AssetImage(CSSplashTopIcon4),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 30 : 0,
              left: splashController.animate.value ? 130 : 100,
              child: Transform.rotate(
                angle: -0.4, // Adjust the angle to rotate the icon (in radians)
                child: const Image(
                  image: AssetImage(CSSplashTopIcon6),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 50 : 20,
              right: splashController.animate.value ? 50 : 20,
              child: Transform.rotate(
                angle: 0.5, // Adjust the angle to rotate the icon (in radians)
                child: const Image(
                  image: AssetImage(CSSplashTopIcon3),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 10 : -20,
              right: splashController.animate.value ? -10 : -40,
              child: Transform.rotate(
                angle: 0.5, // Adjust the angle to rotate the icon (in radians)
                child: const Image(
                  image: AssetImage(CSSplashTopIcon5),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: 160,
              left: splashController.animate.value ? CSDefaultSize - 20 : -80,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: splashController.animate.value ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CSAppName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      CSAppTagLine,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 2400),
              bottom: splashController.animate.value ? 100 : 10,
              left: 30,
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: splashController.animate.value ? 1 : 0,
                  child: const Image(image: AssetImage(CSSplashImage))),
            ),
          ),
        ],
      ),
    );
  }
}
