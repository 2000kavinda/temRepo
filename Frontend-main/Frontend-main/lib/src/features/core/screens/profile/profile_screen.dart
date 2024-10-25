import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/constants/image_strings.dart';
import 'package:codesafari/src/features/authentication/models/user_model.dart';
import 'package:codesafari/src/features/core/controllers/profile_controller.dart';
import 'package:codesafari/src/features/core/screens/home/home_screen.dart';
import 'package:codesafari/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:codesafari/src/features/core/screens/profile/widgets/profile_menu.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:codesafari/src/utils/theme/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ThemeController _themeController = Get.put(ThemeController());
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _themeController.syncWithSystem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDark = _themeController.isDarkMode.value;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.offAll(() => const HomeScreen(),
                transition: Transition.leftToRight,
                duration: const Duration(milliseconds: 800)),
            icon: const Icon(LineAwesomeIcons.angle_left_solid,
                color: CSAccentColor),
          ),
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark ? CSWhiteColor : CSDarkColor,
                ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _themeController.toggleTheme,
              icon: Icon(
                isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                color: CSAccentColor,
              ),
            ),
          ],
        ),
        body: FutureBuilder<UserModel>(
          future: _profileController.getUserData(), // Fetch user data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                UserModel user = snapshot.data!;

                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: CSAccentColor,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      LineAwesomeIcons.pencil_alt_solid,
                                      size: 20.0,
                                      color: CSWhiteColor),
                                  onPressed: () =>
                                      Get.to(() => const UpdateProfileScreen()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: isDark ? CSWhiteColor : CSDarkColor,
                              ),
                        ),
                        Text(
                          user.email,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDark ? CSWhiteColor : CSDarkColor,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () => Get.to(
                              () =>
                                  const UpdateProfileScreen(), // Navigate to SignupScreen
                              transition: Transition
                                  .rightToLeft, // Transition from right to left
                              duration: const Duration(
                                  milliseconds:
                                      800), // Duration of the transition
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CSAccentColor,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('Edit Profile',
                                style: TextStyle(color: CSWhiteColor)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(color: Colors.transparent),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                          title: "Settings",
                          icon: LineAwesomeIcons.cog_solid,
                          onPress: () {},
                        ),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                          title: "User Management",
                          icon: LineAwesomeIcons.user_alt_solid,
                          onPress: () {},
                        ),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                          title: "Information",
                          icon: LineAwesomeIcons.info_solid,
                          onPress: () {},
                        ),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                          title: "Logout",
                          icon: LineAwesomeIcons.sign_out_alt_solid,
                          textColor: const Color.fromARGB(255, 207, 74, 65),
                          endIcon: false,
                          onPress: () async {
                            // Trigger the logout function
                            await AuthenticationRepository.instance.logout();
                          },
                        ),
                      ],
                    ),
                  ),
                );
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
      );
    });
  }
}
