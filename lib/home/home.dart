import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTab = 'M';
  List<BarChartGroupData> barGraphData = [];
  double maxY = 15; // Default max Y value

  @override
  void initState() {
    super.initState();
    fetchGraphData(); // Fetch initial data
  }

  Future<void> fetchGraphData() async {
    final phoneNumber = Mycontroller.getPhoneNumber();
    final formattedPhoneNumber = phoneNumber.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;
    final url = 'http://13.233.98.192:3000/payments/earning?type=${getTypeForTab(selectedTab)}&ownerMobileNo=$formattedPhoneNumber';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['amounts'] != null && data['amounts'].isNotEmpty) {
          setState(() {
            barGraphData = generateBarGraphData(data['amounts']);
            maxY = data['amounts'].map<double>((amount) => amount.toDouble()).reduce((a, b) => a > b ? a : b) + 5; // Set maxY dynamically
          });
        } else {
          setState(() {
            barGraphData = generateBarGraphData(List.filled(getExpectedLength(selectedTab), 0));
            maxY = 15; // Reset maxY if no data
          });
        }
      } else {
        print('Failed to fetch data: ${response.body}');
        setState(() {
          barGraphData = generateBarGraphData(List.filled(getExpectedLength(selectedTab), 0));
          maxY = 15; // Reset maxY if fetch fails
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        barGraphData = generateBarGraphData(List.filled(getExpectedLength(selectedTab), 0));
        maxY = 15; // Reset maxY if error occurs
      });
    }
  }

  String getTypeForTab(String tab) {
    switch (tab) {
      case 'D':
        return 'daily';
      case 'W':
        return 'weekly';
      case 'M':
        return 'monthly';
      case 'Y':
        return 'yearly';
      default:
        return 'daily';
    }
  }

  int getExpectedLength(String tab) {
    switch (tab) {
      case 'D':
        return 7; // 7 days for daily
      case 'W':
        return 4; // 4 weeks for weekly
      case 'M':
        return 12; // 12 months for monthly
      case 'Y':
        return 5; // 5 years for yearly
      default:
        return 0;
    }
  }

  List<BarChartGroupData> generateBarGraphData(List<dynamic> amounts) {
    return List<BarChartGroupData>.generate(amounts.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: amounts[index].toDouble(), color: Colors.green)],
      );
    });
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
      fetchGraphData(); // Fetch data for the selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Gross Transaction Value (GTV)',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const InfoCard(
                title: 'Bookings (GTV)',
                onlineAmount: 'INR 1,500',
                offlineAmount: 'INR 0',
              ),
              const InfoCard(
                title: 'Cancellation (GTV)',
                onlineAmount: 'INR 0',
                offlineAmount: 'INR 0',
              ),
              const SizedBox(height: 20),
              BarGraph(
                barGroups: barGraphData,
                selectedTab: selectedTab,
                maxY: maxY, // Pass the dynamic maxY value
                onTabSelected: onTabSelected,
              ),
              const Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: const CustomNavBar(
          currentIndex: 0,
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String onlineAmount;
  final String offlineAmount;

  const InfoCard({
    super.key,
    required this.title,
    required this.onlineAmount,
    required this.offlineAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Online',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  onlineAmount,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Offline',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  offlineAmount,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BarGraph extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final String selectedTab;
  final double maxY; // Added maxY parameter
  final Function(String) onTabSelected;

  const BarGraph({
    super.key,
    required this.barGroups,
    required this.selectedTab,
    required this.maxY, // Required maxY parameter
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ToggleButton(
                  label: 'D',
                  isActive: selectedTab == 'D',
                  onTap: () => onTabSelected('D')),
              ToggleButton(
                  label: 'W',
                  isActive: selectedTab == 'W',
                  onTap: () => onTabSelected('W')),
              ToggleButton(
                  label: 'M',
                  isActive: selectedTab == 'M',
                  onTap: () => onTabSelected('M')),
              ToggleButton(
                  label: 'Y',
                  isActive: selectedTab == 'Y',
                  onTap: () => onTabSelected('Y')),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY, // Use the dynamic maxY value
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        );
                        if (selectedTab == 'D') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Mon', style: style);
                            case 1:
                              return Text('Tue', style: style);
                            case 2:
                              return Text('Wed', style: style);
                            case 3:
                              return Text('Thu', style: style);
                            case 4:
                              return Text('Fri', style: style);
                            case 5:
                              return Text('Sat', style: style);
                            case 6:
                              return Text('Sun', style: style);
                          }
                        } else if (selectedTab == 'W') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Week 1', style: style);
                            case 1:
                              return Text('Week 2', style: style);
                            case 2:
                              return Text('Week 3', style: style);
                            case 3:
                              return Text('Week 4', style: style);
                            case 4:
                              return Text('Week 5', style: style);
                          }
                        } else if (selectedTab == 'M') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jan', style: style);
                            case 1:
                              return Text('Feb', style: style);
                            case 2:
                              return Text('Mar', style: style);
                            case 3:
                              return Text('Apr', style: style);
                            case 4:
                              return Text('May', style: style);
                            case 5:
                              return Text('Jun', style: style);
                            case 6:
                              return Text('Jul', style: style);
                            case 7:
                              return Text('Aug', style: style);
                            case 8:
                              return Text('Sep', style: style);
                            case 9:
                              return Text('Oct', style: style);
                            case 10:
                              return Text('Nov', style: style);
                            case 11:
                              return Text('Dec', style: style);
                          }
                        } else if (selectedTab == 'Y') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('2020', style: style);
                            case 1:
                              return Text('2021', style: style);
                            case 2:
                              return Text('2022', style: style);
                            case 3:
                              return Text('2023', style: style);
                            case 4:
                              return Text('2024', style: style);
                          }
                        }
                        return Text('', style: style);
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        );
                        if (selectedTab == 'D') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Mon', style: style);
                            case 1:
                              return Text('Tue', style: style);
                            case 2:
                              return Text('Wed', style: style);
                            case 3:
                              return Text('Thu', style: style);
                            case 4:
                              return Text('Fri', style: style);
                            case 5:
                              return Text('Sat', style: style);
                            case 6:
                              return Text('Sun', style: style);
                          }
                        } else if (selectedTab == 'W') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Week 1', style: style);
                            case 1:
                              return Text('Week 2', style: style);
                            case 2:
                              return Text('Week 3', style: style);
                            case 3:
                              return Text('Week 4', style: style);
                            case 4:
                              return Text('Week 5', style: style);
                          }
                        } else if (selectedTab == 'M') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jan', style: style);
                            case 1:
                              return Text('Feb', style: style);
                            case 2:
                              return Text('Mar', style: style);
                            case 3:
                              return Text('Apr', style: style);
                            case 4:
                              return Text('May', style: style);
                            case 5:
                              return Text('Jun', style: style);
                            case 6:
                              return Text('Jul', style: style);
                            case 7:
                              return Text('Aug', style: style);
                            case 8:
                              return Text('Sep', style: style);
                            case 9:
                              return Text('Oct', style: style);
                            case 10:
                              return Text('Nov', style: style);
                            case 11:
                              return Text('Dec', style: style);
                          }
                        } else if (selectedTab == 'Y') {
                          switch (value.toInt()) {
                            case 0:
                              return Text('2020', style: style);
                            case 1:
                              return Text('2021', style: style);
                            case 2:
                              return Text('2022', style: style);
                            case 3:
                              return Text('2023', style: style);
                            case 4:
                              return Text('2024', style: style);
                          }
                        }
                        return Text('', style: style);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: const FlGridData(
                  show: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ToggleButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}