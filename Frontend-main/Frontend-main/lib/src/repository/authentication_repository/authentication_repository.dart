import 'package:codesafari/src/exceptions/cs_exceptions.dart';
import 'package:codesafari/src/features/authentication/screens/login/login_screen.dart';
import 'package:codesafari/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:codesafari/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:codesafari/src/features/core/screens/home/home_screen.dart';
import 'package:codesafari/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  final _phoneVerificationId = ''.obs;
  //late final GoogleSignInAccount _googleUser;

  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? "";
  String get getUseEmail => firebaseUser?.email ?? "";

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    //ever(_firebaseUser, _setInitialScreen);
  }

  setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => SplashScreen());
    } else {
      if (user.emailVerified) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const MailVerification());
      }
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the Dashboard screen on successful login
      //Get.offAll(() => const DashboardScreen());
      if (_auth.currentUser != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar("Login Failed", "Failed to retrieve user data.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent);
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthExceptions
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = "The credential data is malformed or has expired.";
          break;
        case 'user-not-found':
          errorMessage = "No user found for this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password provided.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        default:
          errorMessage = "An unknown error occurred: ${e.code}.";
          break;
      }

      Get.snackbar("Login Failed", errorMessage,
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.redAccent);

      if (kDebugMode) {
        print('Firebase Auth Exception - $errorMessage');
        print('Error Code: ${e.code}');
        print('Error Message: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions
      Get.snackbar("Login Failed", "An unknown error occurred.",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.redAccent);

      if (kDebugMode) {
        print('Exception - ${e.toString()}');
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      setInitialScreen(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      final ex = SignupEmailPasswordFailure.code(e.code);
      if (kDebugMode) {
        print('Firebase Auth Exception - ${ex.message}');
      }
      throw ex;
    } catch (_) {
      const ex = SignupEmailPasswordFailure();
      if (kDebugMode) {
        print('Exception - ${ex.message}');
      }
      throw ex;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = CSExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = CSExceptions();
      throw ex.message;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = CSExceptions.fromCode(e.code);
      print(ex);
      throw ex.message;
    } catch (_) {
      const ex = CSExceptions();
      throw ex.message;
    }
  }

  loginWithPhoneNo(String phoneNumber) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNumber);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        Get.snackbar("Error", "Invalid Phone Number!");
      }
    } catch (_) {
      Get.snackbar("Error", "Something went wrong!");
    }
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        _phoneVerificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _phoneVerificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again');
        }
      },
    );
  }

  // Future<bool> verifyOTP(String otp) async {
  //   var credentials = await _auth.signInWithCredential(
  //       PhoneAuthProvider.credential(
  //           verificationId: _phoneVerificationId.value, smsCode: otp));
  //   return credentials.user != null ? true : false;
  // }

  Future<bool> verifyOTP(String otp, String verificationId) async {
    try {
      // Perform OTP verification with Firebase Auth
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      // Handle verification error
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Unable to logout. Try again.';
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      throw Exception("Failed to delete user account: $e");
    }
  }
}
