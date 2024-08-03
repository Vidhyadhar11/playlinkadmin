import 'package:flutter/material.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TurfPage extends StatefulWidget {
  const TurfPage({super.key});

  @override
  _TurfPageState createState() => _TurfPageState();
}

class _TurfPageState extends State<TurfPage> {
  String? selectedLocation;
  String? selectedCategory;
  String? turfName;
  String? turfDescription;
  String? rating;
  String? price;
  String? courts;
  
  final List<String> categories = [
    'Cricket', 'Badminton', 'Volleyball', 'Football', 
    'Basketball', 'Swimming', 'Tennis', 'Golf'
  ];

  final List<String> locations = [
    'Pachalam', 'Elamakkara', 'Cheranallur', 'Palarivattom', 'Edapally',
    'Kaloor', 'Marine Drive, Kochi', 'High Court Junction', 'Thevara',
    'Panampilly Nagar', 'Gandhi Nagar, Kochi', 'Ravipuram', 'Kathrikadavu',
    'Thammanam', 'Kadavanthra', 'Karanakodam', 'Ernakulam North',
    'Ernakulam South', 'Kalabhavan Road', 'Willingdon Island', 'Fort Kochi',
    'Mattancherry', 'Thoppumpady', 'Palluruthy', 'Chellanam', 'Kumbalangi',
    'Kattiparambu', 'Kundannoor', 'Edakochi', 'Maradu', 'Thaikoodam metro station',
    'Chambakkara', 'Kakkanad', 'Vennala', 'Thrikkakara', 'Vyttila', 'Tripunithura',
    'Piravom', 'Kalamassery', 'Aluva', 'Angamaly', 'North Paravur', 'Eloor',
    'Koonammavu', 'Vaduthala', 'Vypin Island', 'Cherai', 'Kumbalam', 'Udayamperoor',
    'Panangad', 'Eramallur', 'Vaikom', 'Kothamangalam', 'Perumbavoor', 'Eroor',
    'Thiruvankulam', 'Kolenchery', 'Mamala', 'Kizhakkambalam', 'Mulanthuruthy',
    'Chottanikkara'
  ];

  List<Map<String, dynamic>> slotRanges = [];
  List<Map<String, dynamic>> generatedSlots = [];

  Future<void> createTurf() async {
    final url = Uri.parse('http://10.0.2.2:3000/turf');
    
    // Print collected data for debugging
    print('Collected Turf Data:');
    print('Category: $selectedCategory');
    print('Turf Name: $turfName');
    print('Location: $selectedLocation');
    print('Description: $turfDescription');
    print('Rating: $rating');
    print('Price: $price');
    print('Courts: $courts');

    final body = <String, dynamic>{
      'image': 'turf2.jpeg',
      'category': selectedCategory,
      'turfname': turfName,
      'location': selectedLocation,
      'description': turfDescription,
      'rating': double.tryParse(rating ?? '') ?? 0.0,
      'slots': generatedSlots,
      'court': int.tryParse(courts ?? '') ?? 0,
    };

    print('API Request Body:');
    print(jsonEncode(body));

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Turf created successfully')),
        );
      } else {
        print('Failed to create turf. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create turf. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error creating turf: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating turf: $e')),
      );
    }
  }

  void generateSlots() {
    generatedSlots.clear();
    for (var range in slotRanges) {
      TimeOfDay currentTime = range['startTime'];
      while (currentTime.hour < range['endTime'].hour || 
             (currentTime.hour == range['endTime'].hour && currentTime.minute < range['endTime'].minute)) {
        TimeOfDay nextHour = TimeOfDay(
          hour: (currentTime.hour + 1) % 24,
          minute: currentTime.minute,
        );
        generatedSlots.add({
          'time': '${currentTime.format(context)} - ${nextHour.format(context)}',
          'price': range['price'],
        });
        currentTime = nextHour;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center( 
                  child: Text('Add Turf',  
                    style: TextStyle(
                      color: Colors.green, 
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildDropdownSearch(
                  items: categories,
                  label: 'Select Category',
                  onChanged: (value) => setState(() => selectedCategory = value),
                  selectedItem: selectedCategory,
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Turf Name',
                  onChanged: (value) => setState(() => turfName = value),
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Turf Description',
                  onChanged: (value) => setState(() => turfDescription = value),
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: 22),
                _buildDropdownSearch(
                  items: locations,
                  label: 'Select Location',
                  onChanged: (value) => setState(() => selectedLocation = value),
                  selectedItem: selectedLocation,
                ),
                const SizedBox(height: 22),
                Column(
                  children: [
                    ...slotRanges.map((range) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('${range['startTime'].format(context)} - ${range['endTime'].format(context)}, Price: ${range['price']}', 
                              style: TextStyle(color: Colors.white)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                slotRanges.remove(range);
                                generateSlots();
                              });
                            },
                          ),
                        ],
                      ),
                    )).toList(),
                    // ElevatedButton(
                    //   child: Text('Add Slot Range'),
                    //   onPressed: () async {
                    //     await showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
                    //         TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);
                    //         String price = '';
                    //         return AlertDialog(
                    //           title: Text('Add Slot Range'),
                    //           content: Column(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Expanded(
                    //                     child: TextButton(
                    //                       child: Text('Start Time: ${startTime.format(context)}'),
                    //                       onPressed: () async {
                    //                         TimeOfDay? picked = await showTimePicker(
                    //                           context: context,
                    //                           initialTime: startTime,
                    //                         );
                    //                         if (picked != null) startTime = picked;
                    //                       },
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: TextButton(
                    //                       child: Text('End Time: ${endTime.format(context)}'),
                    //                       onPressed: () async {
                    //                         TimeOfDay? picked = await showTimePicker(
                    //                           context: context,
                    //                           initialTime: endTime,
                    //                         );
                    //                         if (picked != null) endTime = picked;
                    //                       },
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               TextField(
                    //                 decoration: InputDecoration(labelText: 'Price per hour'),
                    //                 keyboardType: TextInputType.number,
                    //                 onChanged: (value) => price = value,
                    //               ),
                    //             ],
                    //           ),
                    //           actions: [
                    //             TextButton(
                    //               child: Text('Add'),
                    //               onPressed: () {
                    //                 if (price.isNotEmpty) {
                    //                   setState(() {
                    //                     slotRanges.add({
                    //                       'startTime': startTime,
                    //                       'endTime': endTime,
                    //                       'price': int.parse(price),
                    //                     });
                    //                     generateSlots();
                    //                   });
                    //                   Navigator.of(context).pop();
                    //                 }
                    //               },
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    // SizedBox(height: 20),
                    // Text('Generated Slots:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    // ...generatedSlots.map((slot) => Padding(
                    //   padding: const EdgeInsets.only(bottom: 4.0),
                    //   child: Text('${slot['time']}, Price: ${slot['price']}', style: TextStyle(color: Colors.white)),
                    // )).toList(),
                  ],
                ),
                // const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Rating',
                  onChanged: (value) => setState(() => rating = value),
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Price',
                  onChanged: (value) => setState(() => price = value),
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'courts',
                  onChanged: (value) => setState(() => courts = value),
                ),
                const SizedBox(height: 22),
                Center(
                  child: TextButton(
                    onPressed: createTurf,
                    child: Text(
                      'Create New Turf',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavBar(
          currentIndex: 2,
        ),
      ),
    );
  }

  Widget _buildDropdownSearch({
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
    required String? selectedItem,
  }) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        showSelectedItems: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search $label",
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        ),
        menuProps: MenuProps(
          backgroundColor: Colors.grey[800],
        ),
        itemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      items: items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onChanged: onChanged,
      selectedItem: selectedItem,
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem ?? label,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget _buildTextFormField({
    required String label,
    required Function(String) onChanged,
    int maxLines = 1,
    int minLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      maxLines: maxLines,
    );
  }

  Widget _buildDropdownButtonFormField({
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dropdownColor: Colors.grey[800],
      style: const TextStyle(color: Colors.white),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
    );
  }
}