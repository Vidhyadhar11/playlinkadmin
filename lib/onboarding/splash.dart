import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:sporty/screens/login.dart';
// import 'package:sporty/login/onboarding.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/home/home.dart';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/onboarding/onboarding.dart'; // Import your login screen
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? finalPhoneNumber;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phoneNumber');
    
    setState(() {
      finalPhoneNumber = phoneNumber;
    });

    // Navigate after checking status
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => finalPhoneNumber == null ? const Onboarding() : HomePage()
        ),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/playlink.png', height: 250),
      ),
    );
  }
}