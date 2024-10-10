import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://65.1.5.180:3000/payments/earnings';

  Future<List<dynamic>> fetchGraphData(String phoneNumber, String interval) async {
    final formattedPhoneNumber = phoneNumber.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;

    final body = {
      "ownerMobileNo": formattedPhoneNumber,
      "interval": interval,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch data: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}