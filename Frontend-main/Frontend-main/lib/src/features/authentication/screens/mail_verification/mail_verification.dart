import 'package:codesafari/src/constants/sizes.dart';
import 'package:codesafari/src/constants/text_strings.dart';
import 'package:codesafari/src/features/authentication/controllers/mail_verification_controller.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: CSDefaultSpace, vertical: CSDefaultSpace * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: CSDefaultSpace * 20),
            const Icon(LineAwesomeIcons.envelope_open, size: 100),
            const SizedBox(height: CSDefaultSpace * 2),
            Text(CSEmailVerificationTitle.tr,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: CSDefaultSpace),
            Text(
              CSEmailVerificationSubTitle.tr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CSDefaultSpace * 2),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                  child: Text(CSContinue.tr),
                  onPressed: () =>
                      controller.manuallyCheckEmailVerificationStatus()),
            ),
            const SizedBox(height: CSDefaultSpace * 2),
            TextButton(
              onPressed: () => controller.sendVerificationEmail(),
              child: Text(CSResendEmailLink.tr),
            ),
            TextButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LineAwesomeIcons.long_arrow_alt_left_solid),
                    const SizedBox(width: 5),
                    Text(CSBackToLogin.tr.toLowerCase()),
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}
