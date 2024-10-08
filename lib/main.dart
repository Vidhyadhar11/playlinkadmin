import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/onboarding/splash.dart';
import 'package:playlinkadmin/onboarding/phn.dart';
import 'package:playlinkadmin/home/home.dart';
import 'package:playlinkadmin/models/mycontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final myController = Get.put(Mycontroller());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sporty App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/enter-phone', page: () => EnterPhoneNumberScreen()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
    );
  }
}