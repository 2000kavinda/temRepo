import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'package:codesafari/firebase_options.dart';
import 'package:codesafari/src/Providers/navigationProvider.dart';
import 'package:codesafari/src/Providers/provider.dart';
import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:codesafari/src/repository/authentication_repository/authentication_repository.dart';
import 'package:codesafari/src/repository/user_repository/user_repository.dart';

import 'src/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) {
    Get.put(AuthenticationRepository());
    Get.put(UserRepository()); // Initialize UserRepository
  });

  await GetStorage.init();

  Get.put(LoginController(), permanent: true);

  runApp(const App());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyModel()),
        ChangeNotifierProvider(
            create: (context) =>
                NavigationProvider()), // Add NavigationProvider
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const App(),
      ),
    ),
  );

  //FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: CSAppTheme.lightTheme,
      darkTheme: CSAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
  /*@override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }*/
}
