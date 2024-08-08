import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:playlinkadmin/onboarding/ca.dart';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/onboarding/otp.dart';
import 'package:playlinkadmin/models/api_config.dart'; // Create this file for API URLs

class EnterPhoneNumberScreen extends StatefulWidget {
  @override
  _EnterPhoneNumberScreenState createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  final Mycontroller myController = Get.find<Mycontroller>();
  final RxBool _phoneNumberValid = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'tell us your\nmobile number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => TextField(
                  controller: myController.phoneNumberController.value,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _phoneNumberValid.value ? null : 'Enter a valid 10-digit number',
                  ),
                  onChanged: (value) {
                    _phoneNumberValid.value = _validatePhoneNumber(value);
                  },
                )),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CreateAccountPage());
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: _handleProceed,
              child: const Row(
                children: [
                  Text('Proceed',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validatePhoneNumber(String value) {
    if (value.length != 10) return false;
    return RegExp(r'^[6-9]\d{9}$').hasMatch(value); 
  }

  void _handleProceed() async {
    if (_phoneNumberValid.value) {
      String phoneNumber = myController.phoneNumberController.value.text;
      Mycontroller.setPhoneNumber('+91$phoneNumber');
      print('Phone number stored: ${Mycontroller.getPhoneNumber()}');

      try {
        final response = await sendPhoneNumber('+91$phoneNumber');
        if (response != null && response.containsKey('orderId')) {
          String orderId = response['orderId']!;
          Get.to(() => EnterOTPScreen(
            orderId: orderId,
            phoneNumber: '+91$phoneNumber',
          ));
          print('Phone number sent successfully');
        } else {
          print('Response is null or does not contain orderId');
          Get.snackbar('Error', 'Failed to send phone number. Please try again.',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Error sending phone number: $e');
        Get.snackbar('Error', 'An error occurred. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Invalid Input', 'Enter a valid 10-digit number',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<Map<String, String>?> sendPhoneNumber(String phoneNumber) async {
    try {
      print('Sending request to: ${ApiConfig.sendOtpUrl}');
      print('Request body: ${jsonEncode({'mobileno': phoneNumber})}');

      final response = await http.post(
        Uri.parse(ApiConfig.sendOtpUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'mobileno': phoneNumber}),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Raw response data: $responseData');
        if (responseData.containsKey('orderId')) {
          return {'orderId': responseData['orderId']};
        } else {
          print('Response data does not contain required keys');
          return null;
        }
      } else {
        print('Failed to send phone number. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in HTTP request: $e');
      return null;
    }
  }
}