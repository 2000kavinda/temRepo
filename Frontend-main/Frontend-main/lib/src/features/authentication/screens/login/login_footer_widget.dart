import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:codesafari/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: CSFormHeight,
        ),
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
        const SizedBox(
          height: CSFormHeight - 20,
        ),
        TextButton(
          onPressed: () => Get.to(
            () => const SignupScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 800),
          ),
          child: Text.rich(
            TextSpan(
                text: CSDontHaveAnAccount,
                style: Theme.of(context).textTheme.bodyLarge,
                children: const [
                  TextSpan(
                    text: CSSignup,
                    style: TextStyle(color: CSAccentColor),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
