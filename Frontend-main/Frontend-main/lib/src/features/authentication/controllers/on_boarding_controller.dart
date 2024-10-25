import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../models/model_on_boarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';
import '../screens/welcome/welcome_screen.dart';

class OnBoardingController extends GetxController{
  final LiquidController controller = LiquidController();
  RxInt currentPage = 0.obs;
  late List<OnBoardingPageWidget> pages;

  OnBoardingController(Size size) {
    pages = [
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: CSOnBoardingImage1,
          title: CSOnBoardingTitle1,
          subTitle: CSOnBoardingSubTitle1,
          counterText: CSOnBoardingCounter1,
          height: size.height,
          bgColor: CSOnBoardingPage1Color,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: CSOnBoardingImage2,
          title: CSOnBoardingTitle2,
          subTitle: CSOnBoardingSubTitle2,
          counterText: CSOnBoardingCounter2,
          height: size.height,
          bgColor: CSOnBoardingPage2Color,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: CSOnBoardingImage3,
          title: CSOnBoardingTitle3,
          subTitle: CSOnBoardingSubTitle3,
          counterText: CSOnBoardingCounter3,
          height: size.height,
          bgColor: CSOnBoardingPage3Color,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
            image: CSOnBoardingImage4,
            title: CSOnBoardingTitle4,
            subTitle: CSOnboardingSubTitle4,
            counterText: CSOnBoardingCounter4,
            height: size.height,
            bgColor: CSOnBoardingPage4Color),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
            image: CSOnBoardingImage5,
            title: CSOnBoardingTitle5,
            subTitle: CSOnBoardingSubTitle5,
            counterText: CSOnBoardingCounter5,
            height: size.height,
            bgColor: CSOnBoardingPage5Color),
      )
    ];
  }

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    if (nextPage < pages.length) {
      controller.animateToPage(page: nextPage);
    } else {
      Get.to(
            () => const WelcomeScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 800),
      );
    }
  }

  skip() {
    Get.to(
          () => const WelcomeScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 800),
    );
  }

  onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
  }
}
