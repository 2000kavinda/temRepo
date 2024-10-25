import 'package:codesafari/src/common_widgets/form/form_header_widget.dart';
import 'package:codesafari/src/constants/image_strings.dart';
import 'package:codesafari/src/constants/sizes.dart';
import 'package:codesafari/src/constants/text_strings.dart';
import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:codesafari/src/features/authentication/screens/login/login_screen.dart';
import 'package:codesafari/src/features/authentication/screens/signup/widgets/signup_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(CSDefaultSize),
          child: Column(
            children: [
              const FormHeaderWidget(
                image: CSLogoImage,
                title: CSSignupTitle,
                subTitle: CSSignUpSubTitle,
                textAlign: TextAlign.center,
              ),
              const SignUpFormWidget(),
              Column(
                children: [
                  const Text("OR"),
                  const SizedBox(height: CSFormHeight - 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Image(
                        image: AssetImage(CSGoogleLogoImage),
                        width: 20.0,
                      ),
                      onPressed: () => controller.googleSignIn(),
                      label: const Text(CSSignInWithGoogle),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(
                      () => const LoginScreen(), // Navigate to SignupScreen
                      transition: Transition
                          .rightToLeft, // Transition from right to left
                      duration: const Duration(
                          milliseconds: 800), // Duration of the transition
                    ),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: CSAlreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: CSLogin,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: CSAccentColor),
                      )
                    ])),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
