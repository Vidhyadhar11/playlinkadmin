import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:playlinkadmin/onboarding/phn.dart';

class CreateAccountController extends GetxController {
  final isLoading = false.obs;
  final isAccountCreated = false.obs;

  Future<void> createAccount(Map<String, String> userData) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/admin/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        isAccountCreated.value = true;
        Get.snackbar('Success', 'Account created successfully');
      } else {
        isAccountCreated.value = false;
        Get.snackbar('Error', 'Failed to create account');
      }
    } catch (e) {
      isAccountCreated.value = false;
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final CreateAccountController controller = Get.put(CreateAccountController());
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _accountHolderNameController,
                label: 'Account holder name',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _ifscCodeController,
                label: 'IFSC Code',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _accountNumberController,
                label: 'Account Number',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _mobileNumberController,
                label: 'Mobile Number',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value!;
                      });
                    },
                    fillColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                  ),
                  const Expanded(
                    child: Text(
                      'I understood the terms & policy.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  child:const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Signup', style: TextStyle(color: Colors.green)),
                          Icon(Icons.arrow_forward, color: Colors.green),
                        ],
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignup() async {
    if (!_termsAccepted) {
      Get.snackbar('Error', 'Please accept the terms and policy');
      return;
    }

    // Collect data from controllers
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String mobileNumber = _mobileNumberController.text;
    String ifscCode = _ifscCodeController.text;
    String accountNumber = _accountNumberController.text;
    String accountHolderName = _accountHolderNameController.text;

    // Print collected data
    print('Collected Data:');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Account Holder Name: $accountHolderName');
    print('IFSC Code: $ifscCode');
    print('Account Number: $accountNumber');
    print('Mobile Number: $mobileNumber');

    // Prepare the data to be sent
    Map<String, dynamic> requestData = {
      'firstname': firstName,
      'lastname': lastName,
      'mobileno': "+91$mobileNumber",
      'ifscCode': ifscCode,
      'accountNumber': accountNumber,
      'accountName': accountHolderName,
    };

    print('Request Data:');
    print(jsonEncode(requestData));

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/admin/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Get.snackbar('Success', 'Account created successfully');
        Get.off(() => EnterPhoneNumberScreen());
      } else {
        Get.snackbar('Error', 'Failed to create account. Status code: ${response.statusCode}');
        print('Error Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error in HTTP request: $e');
      Get.snackbar('Error', 'An error occurred. Please check the console for details.');
      print('Stack Trace:');
      print(StackTrace.current);
    }
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade800),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: false,
      ),
    );
  }
}