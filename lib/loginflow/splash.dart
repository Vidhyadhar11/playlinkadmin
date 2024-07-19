import 'package:flutter/material.dart';
// import 'package:sporty/screens/login.dart';
// import 'package:sporty/login/onboarding.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/loginflow/onboarding.dart'; // Import your login screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to the login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
       Get.to(const Onboarding());
           });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/playlink.png', height: 250), // Corrected file path
      ),
    );
  }
}