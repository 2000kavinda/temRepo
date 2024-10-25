import 'package:codesafari/src/features/core/screens/dashboard/dashboard_screen.dart';
import 'package:codesafari/src/features/core/screens/home/home_screen.dart';
import 'package:codesafari/src/repository/authentication_repository/auth_repository.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final showPassword = false.obs;
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  Future<void> login() async {
    print('Login method called');
    try {
      isLoading.value = true;
      if (loginFormKey.currentState == null ||
          !loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      final auth = AuthenticationRepository.instance;
      await auth.loginWithEmailAndPassword(
          email.text.trim(), password.text.trim());
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      print('Error during login: $e');
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5));
    }
  }

  Future<void> loginLocal() async {
    try {
      isLoading.value = true;
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      final auth = AuthRepositoryLocal();
      var res = await auth.login(email.text.trim(), password.text.trim());

      if(res.accessToken != null){
        saveAccessToken(res.accessToken);
        saveFullName(res.fullname);
        saveUsername(res.username);
        saveQaHistory(res.qa_history);
      }else{
        Get.snackbar("Error", res.message,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5));
      }

      if (res.accessToken != null) {
        Get.offAll(() => const HomeScreen());
        clearForm();
      }

    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5));
    }
  }

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthenticationRepository.instance;
      await auth.signInWithGoogle();
      isGoogleLoading.value = false;
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isGoogleLoading.value = false;
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5));
    }
  }
  Future<void> saveAccessToken(String accessToken) async {
    final box = GetStorage();
    await box.write('accessToken', accessToken);
  }

  Future<String?> getAccessToken() async {
    final box = GetStorage();
    return box.read('accessToken');
  }

  Future<void> clearAccessToken() async {
    final box = GetStorage();
    await box.write('accessToken', null);
  }

  Future<void> saveFullName(String fullName) async {
    final box = GetStorage();
    await box.write('fullName', fullName);
  }

  Future<void> saveUsername(String username) async {
    final box = GetStorage();
    await box.write('username', username);
  }

  Future<String?> getFullName() async {
    final box = GetStorage();
    return box.read('fullName');
  }

  Future<String?> getUsername() async {
    final box = GetStorage();
    return box.read('username');
  }

  Future<void> saveQaHistory(List<Map<String, dynamic>> qaHistory) async {
    final box = GetStorage();
    await box.write('qa_history', qaHistory);
  }
  Future<List<Map<String, dynamic>>?> getQaHistory() async {
    final box = GetStorage();
    return (box.read('qa_history') as List<dynamic>?)
        ?.map((item) => {
      'question': item['question'] as String,
      'answer': item['answer'] as Map<String, dynamic>,
    })
        .toList();
  }
  void clearForm() {
    username.clear();
    password.clear();
    loginFormKey.currentState?.reset();
  }
}
