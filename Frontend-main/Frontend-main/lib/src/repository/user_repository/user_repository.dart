//2nd step

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codesafari/src/features/authentication/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Get the email of the logged-in user
  String? getLoggedInUserEmail() {
    User? user = _auth.currentUser;
    return user?.email;
  }

  Future<void> createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
              "Success", "Your Account has been created Successfully",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUsers() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    final docRef = _db.collection("Users").doc(user.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final updatedData = user.toJson();

      // Check for null values before updating
      updatedData.removeWhere((key, value) => value == null);

      print('Updating document with data: $updatedData'); // Updated log
      await docRef.update(updatedData);
      print('Document updated successfully.');
    } else {
      print('Document does not exist.');
    }
  }

  Future<void> deleteUser(String userId) async {
    // Code to delete user from database
    await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
  }
}
