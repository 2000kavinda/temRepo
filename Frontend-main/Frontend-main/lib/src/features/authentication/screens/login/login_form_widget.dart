import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return SingleChildScrollView(
      child: Form(
        key: controller.loginFormKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: CSFormHeight - 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.email,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2_sharp),
                  labelText: CSEmail,
                  hintText: CSEmail,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: CSFormHeight),
              TextFormField(
                controller: controller.password,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint_sharp),
                  labelText: CSPassword,
                  hintText: CSPassword,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: CSFormHeight - 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: const Text(CSForgetPassword),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('Login button pressed');
                    controller.loginLocal();
                  },
                  child: Text(CSLogin.toUpperCase()),
                ),
              ),
              const SizedBox(height: CSFormHeight),
            ],
          ),
        ),
      ),
    );
  }
}
