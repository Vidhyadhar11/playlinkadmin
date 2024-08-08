import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mycontroller extends GetxController {
  // Static variable to store the phone number
  static final RxString staticPhoneNumber = ''.obs;

  // List of controllers for OTP input fields
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  ).obs;

  // Controller for phone number input
  final phoneNumberController = TextEditingController().obs;

  // Static variable to store the owner ID
  static final RxString ownerId = ''.obs;

  @override
  void onClose() {
    // Dispose of controllers when the controller is closed
    for (var controller in otpControllers) {
      controller.dispose();
    }
    phoneNumberController.value.dispose();
    super.onClose();
  }

  // Method to clear OTP fields
  void clearOTP() {
    for (var controller in otpControllers) {
      controller.clear();
    }
  }

  // Method to get the full OTP as a string
  String getOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  // Method to set phone number
  static void setPhoneNumber(String number) {
    staticPhoneNumber.value = number;
    print('Phone number stored: ${staticPhoneNumber.value}');
  }

  // Method to get phone number
  static String getPhoneNumber() {
    return staticPhoneNumber.value; // Return the static variable
  }

}