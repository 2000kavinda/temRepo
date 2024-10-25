import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/constants/image_strings.dart';
import 'package:codesafari/src/constants/sizes.dart';
import 'package:codesafari/src/constants/text_strings.dart';
import 'package:codesafari/src/features/authentication/models/user_model.dart';
import 'package:codesafari/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:codesafari/src/features/core/controllers/profile_controller.dart';
import 'package:codesafari/src/features/core/screens/profile/profile_screen.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAll(
            () => const ProfileScreen(), // Navigate to SignupScreen
            transition: Transition.leftToRight, // Transition from right to left
            duration:
                const Duration(milliseconds: 800), // Duration of the transition
          ),
          icon: const Icon(LineAwesomeIcons.angle_left_solid,
              color: CSAccentColor),
        ),
        title: Text(
          CSEditProfile,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(CSDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;

                  final email = TextEditingController(text: user.email);
                  final password = TextEditingController(text: user.password);
                  final fullName = TextEditingController(text: user.fullName);
                  final phoneNo = TextEditingController(text: user.phoneNo);

                  return Column(children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: user.profileImage != null
                                ? Image.network(user
                                    .profileImage!) // Display the user's profile image
                                : const Image(
                                    image: AssetImage(CSProfileImage)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await controller.uploadProfileImage();
                            },
                            child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: CSAccentColor),
                                child: const Icon(LineAwesomeIcons.camera_solid,
                                    size: 20.0, color: CSWhiteColor)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    Form(
                        child: Column(
                      children: [
                        TextFormField(
                          controller: fullName,
                          decoration: const InputDecoration(
                            label: Text(CSFullName),
                            prefixIcon: Icon(
                              LineAwesomeIcons.user,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSFormHeight - 20),
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            label: Text(CSEmail),
                            prefixIcon: Icon(
                              LineAwesomeIcons.envelope_solid,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSFormHeight - 20),
                        TextFormField(
                          controller: phoneNo,
                          decoration: const InputDecoration(
                            label: Text(CSContactNo),
                            prefixIcon: Icon(
                              LineAwesomeIcons.phone_alt_solid,
                            ),
                          ),
                        ),
                        const SizedBox(height: CSFormHeight - 20),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            label: const Text(CSPassword),
                            prefixIcon: const Icon(
                              Icons.fingerprint_sharp,
                            ),
                            suffixIcon: IconButton(
                                icon: const Icon(LineAwesomeIcons.eye_slash),
                                onPressed: () {}),
                          ),
                        ),
                        const SizedBox(height: CSFormHeight),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Fetch the current user data to ensure profileImage is up-to-date
                              final currentUser =
                                  await controller.getUserData();

                              final updatedUser = UserModel(
                                id: user.id,
                                email: email.text.trim(),
                                password: password.text.trim(),
                                fullName: fullName.text.trim(),
                                phoneNo: phoneNo.text.trim(),
                                profileImage: currentUser
                                    ?.profileImage, // Use current user's profile image
                                createdAt: user.createdAt,
                              );

                              await controller.updateRecord(updatedUser);
                              Get.off(() => const ProfileScreen());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CSAccentColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text(CSEditProfile,
                                style: TextStyle(color: CSWhiteColor)),
                          ),
                        ),
                        const SizedBox(height: CSFormHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text.rich(TextSpan(
                              text: CSJoined,
                              style: const TextStyle(fontSize: 12.0),
                              children: [
                                TextSpan(
                                  text:
                                      DateFormat('dd MMMM yyyy').format(user.createdAt),
                                  //text: user.createdAt.toLocal().toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            )),
                            ElevatedButton(
                                onPressed: () async {
                                  if (user.id != null) {
                                    final result = await Get.defaultDialog(
                                      title: 'Confirm Deletion',
                                      middleText:
                                          'Are you sure you want to delete your account?',
                                      textConfirm: 'Yes',
                                      textCancel: 'No',
                                      onConfirm: () async {
                                        // Log out user
                                        await AuthenticationRepository.instance
                                            .logout();
                                        // Call delete method
                                        await controller.deleteUser(user
                                            .id!); // Use ! to assert non-null
                                        // Navigate to signup screen
                                        Get.offAll(() => const SignupScreen());
                                      },
                                    );
                                  } else {
                                    // Handle the case where user.id is null
                                    Get.snackbar(
                                        'Error', 'User ID is not available.');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.1),
                                    elevation: 0,
                                    foregroundColor: Colors.red,
                                    shape: const StadiumBorder(),
                                    side: BorderSide.none),
                                child: const Text(CSDelete)),
                          ],
                        )
                      ],
                    ))
                  ]);
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
