import 'package:codesafari/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  bool _obscureText = true; // Initial state for password visibility

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: CSFormHeight - 10),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullName,
              decoration: const InputDecoration(
                label: Text(CSFullName),
                prefixIcon: Icon(Icons.person_2_sharp),
              ),
            ),
            const SizedBox(height: CSFormHeight - 20),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                label: Text(CSEmail),
                prefixIcon: Icon(Icons.email_sharp),
              ),
            ),
            const SizedBox(height: CSFormHeight - 20),
            TextFormField(
              controller: controller.phoneNo,
              decoration: const InputDecoration(
                label: Text(CSContactNo),
                prefixIcon: Icon(Icons.call),
              ),
            ),
            const SizedBox(height: CSFormHeight - 20),
            TextFormField(
              controller: controller.password,
              obscureText: _obscureText, // Toggle visibility of the password
              decoration: InputDecoration(
                label: const Text(CSPassword),
                prefixIcon: const Icon(Icons.fingerprint_sharp),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle the visibility
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: CSFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    SignupController.instance.createUserLocal();
                  }
                },
                child: Text(CSSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
