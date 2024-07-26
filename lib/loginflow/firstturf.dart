import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
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
                'Venue Selection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              
              // Dropdown for Category
              DropdownButtonFormField<String>(
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
                          child: Text(category, style: const TextStyle(color: Colors.black)),
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
                          child: Text(location, style: const TextStyle(color: Colors.black)),
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

              // Amenities MultiSelect
              MultiSelectDialogField(
                items: _amenities.map((e) => MultiSelectItem(e, e)).toList(),
                title: const Text('Amenities', style: TextStyle(color: Colors.white)),
                selectedColor: Colors.green,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                buttonText: const Text(
                  'Select Amenities',
                  style: TextStyle(color: Colors.white),
                ),
                onConfirm: (values) {
                  setState(() {
                    _selectedAmenities = values.cast<String>();
                  });
                },
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: Colors.grey[800],
                  textStyle: const TextStyle(color: Colors.white),
                ),
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
