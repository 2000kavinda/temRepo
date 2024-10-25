import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codesafari/src/features/authentication/models/user_model.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:codesafari/src/repository/user_repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart'; // Import Permission Handler

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final ImagePicker _picker = ImagePicker();

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }

  getUserData() {
    final email = _authRepo.firebaseUser?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to Continue");
      //return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  Future<void> updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

  Future<void> uploadProfileImage() async {
    try {
      await requestPermissions();

      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'user_profile_images/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}');
        final uploadTask = storageRef.putFile(File(pickedFile.path));

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Fetch current user data to update it
        final user = await getUserData();
        if (user != null) {
          // Update UserModel with the new profile image URL
          user.profileImage = downloadUrl;

          print('Updated profile image URL: $downloadUrl'); // Log the new URL

          // Update Firestore document
          await _userRepo.updateUserRecord(user);

          // Verify the update
          final updatedDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.id)
              .get();
          print('Document after update: ${updatedDoc.data()}');
        }
      }
    } catch (e) {
      print('Error uploading image: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      // Delete user from authentication service
      await _authRepo.deleteUserAccount();
      // Assuming you have a repository or service for user management
      await _userRepo.deleteUser(userId);
    } catch (e) {
      print('Error deleting user: $e');
      // Handle error appropriately
    }
  }
}
