import 'dart:convert';

import 'package:get/get.dart';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/models/turfpage_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TurfsController extends GetxController {
  var apiResponse = <SportsFieldApi>[].obs;
  var isLoading = true.obs;


  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 500), () {
      fetchSportsFields();
    });
    super.onInit();
  }

  void fetchSportsFields() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phoneNumber');
      print('Current phone number: $phoneNumber');
      final formattedPhoneNumber = phoneNumber!.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;
      print('Fetching sports fields for phone number: $formattedPhoneNumber');

      final response = await http.get(Uri.parse('http://65.1.5.180:3000/turf/owner/$formattedPhoneNumber'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print('Decoded response data: $responseData');

        final List<SportsFieldApi> turfs = responseData
            .map((item) => SportsFieldApi.fromJson(item))
            .where((turf) => turf != null)
            .cast<SportsFieldApi>()
            .toList();

        print('Parsed turfs: $turfs');
        apiResponse.assignAll(turfs);
      } else {
        print('Failed to fetch sports fields. Status code: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch sports fields. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sports fields: $e');
      Get.snackbar('Error', 'Failed to fetch sports fields: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}