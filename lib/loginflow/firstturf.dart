import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/home/home.dart';

class NewTurfPage extends StatefulWidget {
  const NewTurfPage({super.key});

  @override
  _NewTurfPageState createState() => _NewTurfPageState();
}

class _NewTurfPageState extends State<NewTurfPage> {
  List<String> _selectedAmenities = [];
  final List<String> _amenities = [
    'UPI Accepted',
    'Card Accepted',
    'Toilets',
    'Changing Rooms',
    'Free Parking',
  ];

  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;

  Future<void> _selectTime(BuildContext context, bool isOpenTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select Time';
    }
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = MaterialLocalizations.of(context).formatTimeOfDay(time);
    return format;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              const Text(
                'Create Venue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              
              // Dropdown for Category
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[900],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelText: 'Select Category',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Category 1', 'Category 2']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 50),

              // TextField for Turf Name
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelText: 'Turf Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),

              // Dropdown for Location
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[900],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelText: 'Select Location',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Location 1', 'Location 2']
                    .map((location) => DropdownMenuItem(
                          value: location,
                          child: Text(location, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 50),

              // Time Selection
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            labelText: 'Open Time',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: TextEditingController(text: _formatTime(_openTime)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            labelText: 'Close Time',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: TextEditingController(text: _formatTime(_closeTime)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Amenities Dropdown
              DropdownButtonFormField<String>(
                isExpanded: true,
                dropdownColor: Colors.grey[900],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelText: 'Select Amenities',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _amenities
                    .map((amenity) => DropdownMenuItem(
                          value: amenity,
                          child: Text(amenity, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (_selectedAmenities.contains(value)) {
                      _selectedAmenities.remove(value);
                    } else {
                      _selectedAmenities.add(value!);
                    }
                  });
                },
                value: null,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: _selectedAmenities
                    .map((amenity) => Chip(
                          backgroundColor: Colors.grey[800],
                          label: Text(amenity, style: const TextStyle(color: Colors.white)),
                          onDeleted: () {
                            setState(() {
                              _selectedAmenities.remove(amenity);
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Proceed button logic here
                  Get.to(() => HomePage());
                },
                child: const Row(
                  children: [
                    Text(
                      'Proceed',
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
            ],
          ),
        ),
      ),
    );
  }
}
