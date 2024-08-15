import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Slotstimings extends StatefulWidget {
  const Slotstimings({Key? key}) : super(key: key);

  @override
  _SlotstimingsState createState() => _SlotstimingsState();
}

class _SlotstimingsState extends State<Slotstimings> {
  List<Map<String, dynamic>> slots = [];
  late final turf; // Assuming turf is defined in SlotTimingsPage

  Future<List<Map<String, dynamic>>> fetchCurrentSlots() async {
    final url = Uri.parse('http://13.233.98.192:3000/turf/id/$turf.id/slots');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse the JSON response and return the list of slots
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load slots. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching slots: $e')),
      );
      return []; // Return an empty list on error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSlots(); // Fetch slots when the page initializes
  }

  Future<void> fetchSlots() async {
    try {
      final fetchedSlots = await fetchCurrentSlots(); // Your existing fetch function
      if (fetchedSlots.isNotEmpty) {
        setState(() {
          slots = fetchedSlots; // Only set if there are slots
        });
      } else {
        // Handle the case where there are no slots
        setState(() {
          slots = []; // Ensure slots is an empty list
        });
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching slots: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: slots.length,
      itemBuilder: (context, index) {
        if (index < slots.length) {
          final slot = slots[index];
          return ListTile(
            title: Text('${slot['day']}: ${slot['startTime']} - ${slot['endTime']}'),
          );
        } else {
          return const SizedBox.shrink(); // Return an empty widget if index is out of bounds
        }
      },
    );
  }
}