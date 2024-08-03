import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mycontroller extends GetxController {
  // List of controllers for OTP input fields
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  ).obs;

  // Controller for phone number input
  final phoneNumberController = TextEditingController().obs;

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
  void setPhoneNumber(String number) {
    phoneNumberController.value.text = number;
  }

  // Method to get phone number
  String getPhoneNumber() {
    return phoneNumberController.value.text;
  }
}