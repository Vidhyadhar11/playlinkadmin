import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:playlinkadmin/models/turfpage_api.dart';

class SlotTimingsPage extends StatefulWidget {
  final List<Map<String, dynamic>> slots;
  final String? turfId; // Make turfId optional

  const SlotTimingsPage({Key? key, required this.slots, this.turfId}) : super(key: key); // Update constructor

  @override
  _SlotTimingsPageState createState() => _SlotTimingsPageState();
}

class _SlotTimingsPageState extends State<SlotTimingsPage> {
  List<Map<String, dynamic>> _slots = [];

  @override
  void initState() {
    super.initState();
    _slots = widget.slots.isNotEmpty
        ? List.from(widget.slots)
        : [{'time': '00:00 - 00:00', 'price': '0'}];
    
    print('Initial slots: $_slots');
  }

  void _addSlot() {
    print('Adding new slot with price type: ${_slots.last['price'].runtimeType}');
    Map<String, dynamic> newSlot = {
      'time': '00:00 - 00:00',
      'price': '0',
    };

    Map<String, String> newSlotString = newSlot.map((key, value) => MapEntry(key, value.toString()));

    setState(() {
      _slots.add(newSlotString);
    });
    print('New slots list: $_slots');
  }

  void _removeSlot(int index) {
    setState(() {
      _slots.removeAt(index);
    });
    print('Slot removed. Current slots: $_slots');
  }

  void _updateSlot(int index, String key, String value) {
    setState(() {
      _slots[index][key] = value;
    });
    print('Slot updated. Current slots: $_slots');
  }

  Future<void> _saveSlots() async {
    // Format slots to ensure 'time' field is a string
    final formattedSlots = _slots.map((slot) {
      return {
        'time': slot['time'].toString(),
        'price': slot['price'].toString(),
      };
    }).toList();

    print('Formatted slots: $formattedSlots');

    if (widget.turfId != null) {
      final url = Uri.parse('http://13.233.98.192:3000/turf/id/${widget.turfId}');
      
      try {
        final requestBody = jsonEncode({
          'slots': formattedSlots,
        });

        print('Request body: $requestBody');

        final response = await http.patch(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestBody,
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Slots updated successfully')),
          );
        } else {
          throw Exception('Failed to update slots: ${response.body}');
        }
      } catch (e) {
        print('Error updating slots: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating slots: $e')),
        );
      }
    } else {
      print('No turfId provided, skipping API call');
    }

    // Return the formatted slots
    Navigator.of(context).pop(formattedSlots);
  }

  // Example of converting _slots before passing it to a function expecting Map<String, String>
  List<Map<String, String>> convertDynamicToStrictString(List<Map<String, dynamic>> dynamicList) {
    return dynamicList.map((map) {
      return map.map((key, value) => MapEntry(key, value.toString()));
    }).toList();
  }

  String? getPrice(int index) {
    var price = _slots[index]['price'];
    return price?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Slots'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: _slots.isEmpty
                ? const Center(child: Text('No slots available'))
                : ListView.builder(
                    itemCount: _slots.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _slots[index]['time'],
                                  decoration: const InputDecoration(labelText: 'Time'),
                                  onChanged: (value) => _updateSlot(index, 'time', value),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: getPrice(index) ?? 'Default Value', // Convert to String
                                  decoration: const InputDecoration(labelText: 'Price'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => _updateSlot(index, 'price', value),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeSlot(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addSlot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50), // full height button
                    ),
                    child: const Text('Add Slot'),
                  ),
                ),
                SizedBox(width: 16), // Add some space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSlots,
                    child: const Text('Save Slots'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(0, 50), // full height button
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}