import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/onboarding/onboarding.dart';
import 'package:playlinkadmin/models/api_service.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> _fetchDataFuture;
  int _selectedIndex = 0;
  Map<String, List<BarChartGroupData>> barGraphData = {
    'D': [],
    'W': [],
    'M': [],
    'Y': [],
  };
  Map<String, double> maxY = {
    'D': 15,
    'W': 15,
    'M': 15,
    'Y': 15,
  };
  Map<String, List<String>> xLabels = {
    'D': [],
    'W': [],
    'M': [],
    'Y': [],
  };

  final ApiService apiService = ApiService();
  String selectedGraph = 'D';

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchAllGraphData();
  }

  Future<void> fetchAllGraphData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phoneNumber');
    await fetchGraphData(phoneNumber!, 'day');
    await fetchGraphData(phoneNumber, 'week');
    await fetchGraphData(phoneNumber, 'month');
    await fetchGraphData(phoneNumber, 'year');
  }

  Future<void> fetchGraphData(String phoneNumber, String interval) async {
    final data = await apiService.fetchGraphData(phoneNumber, interval);

    if (data.isNotEmpty) {
      setState(() {
        barGraphData[interval[0].toUpperCase()] = generateBarGraphData(data);
        maxY[interval[0].toUpperCase()] = data.map<double>((entry) => entry['totalAmount'].toDouble()).reduce((a, b) => a > b ? a : b) + 5;

        xLabels[interval[0].toUpperCase()] = data.map<String>((entry) {
          String month = entry['interval'].toString();
          return _getShortMonthName(month);
        }).toList();
      });
    } else {
      setState(() {
        barGraphData[interval[0].toUpperCase()] = [];
        maxY[interval[0].toUpperCase()] = 15;
        xLabels[interval[0].toUpperCase()] = [];
      });
    }
  }

  String _getShortMonthName(String month) {
    switch (month.toLowerCase()) {
      case 'january':
        return 'Jan';
      case 'february':
        return 'Feb';
      case 'march':
        return 'Mar';
      case 'april':
        return 'Apr';
      case 'may':
        return 'May';
      case 'june':
        return 'Jun';
      case 'july':
        return 'Jul';
      case 'august':
        return 'Aug';
      case 'september':
        return 'Sep';
      case 'october':
        return 'Oct';
      case 'november':
        return 'Nov';
      case 'december':
        return 'Dec';
      default:
        return month;
    }
  }

  List<BarChartGroupData> generateBarGraphData(List<dynamic> data) {
    return List<BarChartGroupData>.generate(data.length, (index) {
      final amount = data[index]['totalAmount'].toDouble();
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: Colors.green,
          ),
        ],
      );
    });
  }

  Future<Map<String, dynamic>> fetchWeeklyData(String phoneNumber) async {
  final formattedPhoneNumber = phoneNumber.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;

  final body = {
    "ownerMobileNo": formattedPhoneNumber,
  };

  try {
    final response = await http.post(
      Uri.parse("http://65.1.5.180:3000/payments/week"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print('Response status: ${response.statusCode}'); // Debugging line
    print('Response body: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      var data = json.decode(response.body); // Assuming data is a Map<String, dynamic>
      print('Data received: $data'); // Print the entire data
      print('Amount: ${data['amount']}'); // Print the specific amount
      return data; // Return the parsed JSON object (Map<String, dynamic>)
    } else {
      print('Failed to fetch weekly data: ${response.body}');
      return {};
    }
  } catch (e) {
    print('Error fetching weekly data: $e');
    return {};
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            FutureBuilder(
  future: SharedPreferences.getInstance().then((prefs) {
    String? phoneNumber = prefs.getString('phoneNumber');
    return fetchWeeklyData(phoneNumber!); // Fetch weekly data with phone number
  }),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || (snapshot.data as Map<String, dynamic>).isEmpty) {
      return Center(child: Text('No data available'));
    } else {
      // Cast snapshot.data to Map<String, dynamic> and extract amount
      final data = snapshot.data as Map<String, dynamic>;
      final amount = data["amount"] ?? 0; // Safely access the amount

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Weekly Earnings",
              style: const TextStyle(color: Colors.green, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: ₹$amount', // Display the amount with currency symbol
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      );
    }
  },
),

            const SizedBox(height: 20),
            _buildGraphSelectionButtons(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BarGraph(
                  barGroups: barGraphData[selectedGraph]!,
                  maxY: maxY[selectedGraph]!,
                  xLabels: xLabels[selectedGraph]!,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar( // Add CustomNavBar
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: _handleLogout,
        ),
      ],
    );
  }

  Widget _buildGraphSelectionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOptionButton('D', 'Day'),
          _buildOptionButton('W', 'Week'),
          _buildOptionButton('M', 'Month'),
          _buildOptionButton('Y', 'Year'),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String graphKey, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ), backgroundColor: selectedGraph == graphKey ? Colors.green : Colors.grey[700],
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        setState(() {
          selectedGraph = graphKey;
        });
      },
      child: Text(graphKey),
    );
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    Get.offAll(() => const Onboarding());
  }
}

class BarGraph extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final double maxY;
  final List<String> xLabels;

  const BarGraph({
    super.key,
    required this.barGroups,
    required this.maxY,
    required this.xLabels,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Increased height for better visibility
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: barGroups,
          gridData: FlGridData(show: true), // Show grid lines
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < xLabels.length) {
                    return Text(
                      xLabels[index],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}