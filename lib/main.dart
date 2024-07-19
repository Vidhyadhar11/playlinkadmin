import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/loginflow/splash.dart';
import 'package:playlinkadmin/loginflow/onboarding.dart';
import 'package:playlinkadmin/loginflow/phn.dart';


void main() {
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
        // GetPage(name: '/home', page: () => HomePage()),
      ],
    );
  }
}