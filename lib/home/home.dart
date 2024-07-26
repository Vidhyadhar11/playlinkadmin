import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTab = 'M';

  List<BarChartGroupData> getGraphData() {
    switch (selectedTab) {
      case 'D':
        return [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 1, color: Colors.green)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 2, color: Colors.green)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 1.5, color: Colors.green)]),
          BarChartGroupData(
              x: 3, barRods: [BarChartRodData(toY: 1.5, color: Colors.green)]),
          BarChartGroupData(
              x: 4, barRods: [BarChartRodData(toY: 1.5, color: Colors.green)]),
          BarChartGroupData(
              x: 5, barRods: [BarChartRodData(toY: 1.5, color: Colors.green)]),
          BarChartGroupData(
              x: 6, barRods: [BarChartRodData(toY: 1.5, color: Colors.green)]),
        ];
      case 'W':
        return [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 3, color: Colors.green)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 2.5, color: Colors.green)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 3.5, color: Colors.green)]),
        ];
      case 'M':
        return [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 2, color: Colors.green)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 8, color: Colors.green)]),
          BarChartGroupData(
              x: 3, barRods: [BarChartRodData(toY: 14, color: Colors.green)]),
          BarChartGroupData(
              x: 4, barRods: [BarChartRodData(toY: 15, color: Colors.green)]),
          BarChartGroupData(
              x: 5, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
          BarChartGroupData(
              x: 6, barRods: [BarChartRodData(toY: 7, color: Colors.green)]),
          BarChartGroupData(
              x: 7, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
          BarChartGroupData(
              x: 8, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
          BarChartGroupData(
              x: 9, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
          BarChartGroupData(
              x: 10, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
          BarChartGroupData(
              x: 11, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
        ];
      case 'Y':
        return [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 7, color: Colors.green)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 6, color: Colors.green)]),
        ];
      default:
        return [];
    }
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
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
                barGroups: getGraphData(),
                selectedTab: selectedTab,
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
  final Function(String) onTabSelected;

  const BarGraph({
    required this.barGroups,
    required this.selectedTab,
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
                maxY: 15,
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
                          case 7:
                            return const Text('AUG', style: style);
                          case 8:
                            return const Text('SEP', style: style);
                          case 9:
                            return const Text('OCT', style: style);
                          case 10:
                            return const Text('NOV', style: style);
                          case 11:
                            return const Text('DEC', style: style); 
                        }
                        return const Text('', style: style);
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
