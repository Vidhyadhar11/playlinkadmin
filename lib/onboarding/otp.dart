import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:playlinkadmin/home/home.dart';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/models/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:playlinkadmin/onboarding/onboarding.dart';

class EnterOTPScreen extends StatefulWidget {
  final String orderId;
  final String phoneNumber;

  const EnterOTPScreen({super.key, required this.orderId, required this.phoneNumber});

  @override
  _EnterOTPScreenState createState() => _EnterOTPScreenState();
}

class _EnterOTPScreenState extends State<EnterOTPScreen> {
  final Mycontroller myController = Mycontroller();

  @override
  void initState() {
    super.initState();
    print('Phone number received: ${widget.phoneNumber}');
    print('Order ID received: ${widget.orderId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: myController.otpControllers[index],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                            decoration: const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              if (value.length == 1 && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
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
                  onTap: _handleVerifyOTP,
                  child: const Row(
                    children: [
                      Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    Get.offAll(() => const Onboarding());
  }

  void _handleVerifyOTP() async {
    var formatterphnno = widget.phoneNumber.replaceFirst('+91', '');
    String enteredOTP = myController.otpControllers.map((controller) => controller.text).join();
    print('Verifying OTP for phone number: $formatterphnno with order ID: ${widget.orderId} and OTP: $enteredOTP');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(widget.phoneNumber);
    
    await prefs.setString('phoneNumber', formatterphnno);

    try {
      final response = await verifyOTP(widget.phoneNumber, enteredOTP, widget.orderId);
      if (response != null && response['message'] == 'Admin User verified successfully') {
        await Get.offAll(() => HomePage());
      } else {
        print('OTP verification failed. Clearing input fields...');
        for (var controller in myController.otpControllers) {
          controller.clear();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    } catch (e) {
      print('Error during OTP verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<Map<String, dynamic>?> verifyOTP(String phoneNumber, String otp, String orderId) async {
    try {
      final requestBody = jsonEncode({
        'mobileno': phoneNumber,
        'otp': otp,
        'orderId': orderId,
      });
      print('Request body: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConfig.verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print('Decoded response: $decodedResponse');
        return decodedResponse;
      } else {
        print('Failed to verify OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in HTTP request: $e');
      return null;
    }
  }

  @override
  void dispose() {
    for (var controller in myController.otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}