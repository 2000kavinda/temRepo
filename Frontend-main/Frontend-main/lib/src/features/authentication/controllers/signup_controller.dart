import 'package:codesafari/src/features/authentication/models/user_model.dart';
import 'package:codesafari/src/features/authentication/screens/login/login_screen.dart';
import 'package:codesafari/src/repository/authentication_repository/auth_repository.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:codesafari/src/repository/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final isLoading = false.obs;

  final userRepo = Get.put(UserRepository());

  void registerUser(String email, String password) {
    String? error = AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password) as String?;
    if (error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }

  // Future<void> createUser(UserModel user) async {
  //   await userRepo.createUser(user);
  //   phoneAuthentication(user.phoneNo);
  //   Get.to(() => const OtpScreen());
  // }

  Future<void> createUser() async {
    try {
      isLoading.value = true;

      final user = UserModel(
        email: email.text.trim(),
        password: password.text.trim(),
        fullName: fullName.text.trim(),
        phoneNo: phoneNo.text.trim(),
        createdAt: DateTime.now(),
      );

      final auth = AuthenticationRepository.instance;
      await auth.createUserWithEmailAndPassword(user.email, user.password);
      await UserRepository.instance.createUser(user);
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5));
    }
  }

  Future<void> createUserLocal() async {
    try {
      isLoading.value = true;
      // if (!signupFormKey.currentState!.validate()) {
      //   isLoading.value = false;
      //   return;
      // }

      final user = UserModel(
        email: email.text.trim(),
        password: password.text.trim(),
        fullName: fullName.text.trim(),
        phoneNo: phoneNo.text.trim(),
        createdAt: DateTime.now(),
      );

      final auth = AuthRepositoryLocal();
      var res = await auth.signup(user);
      if(res != null){
        Get.snackbar(
            "Alert",res.message,
            snackPosition: SnackPosition.TOP);
      }

      if (res.message == "Student registered successfully"){
        Get.off(() => const LoginScreen());
      }

    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5));
    }
  }



  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await AuthenticationRepository.instance.phoneAuthentication(phoneNo);
    } catch (e) {
      throw e.toString();
    }
  }
}
