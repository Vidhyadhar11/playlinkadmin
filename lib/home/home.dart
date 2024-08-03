import 'package:flutter/material.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
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
                const SizedBox(height: 10),
                const InfoCard(
                  title: 'Cancellation (GTV)',
                  onlineAmount: 'INR 0',
                  offlineAmount: 'INR 0',
                ),
                const SizedBox(height: 20),
                BarGraph(),
                const SizedBox(height: 20), // Add some bottom padding
              ],
            ),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ToggleButton(label: 'D', isActive: false),
              ToggleButton(label: 'W', isActive: false),
              ToggleButton(label: 'M', isActive: true),
              ToggleButton(label: 'Y', isActive: false),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 15,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 10,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero, // Set borderRadius to zero for pointed edges
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 2,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 8,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 14,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 15,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [
                      BarChartRodData(
                        toY: 10,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 6,
                    barRods: [
                      BarChartRodData(
                        toY: 5,
                        color: Colors.green,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                ],
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
                        return Text(value.toInt().toString(), style: style);
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
                        switch (value.toInt()) {
                          case 0:
                            return const Text('JAN', style: style);
                          case 1:
                            return const Text('FEB', style: style);
                          case 2:
                            return const Text('MAR', style: style);
                          case 3:
                            return const Text('APR', style: style);
                          case 4:
                            return const Text('MAY', style: style);
                          case 5:
                            return const Text('JUN', style: style);
                          case 6:
                            return const Text('JUL', style: style);
                        }
                        return const Text('', style: style);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false, // Remove the border
                ),
                gridData: const FlGridData(
                  show: false, // Remove the background lines
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

  const ToggleButton({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}