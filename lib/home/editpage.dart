import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:playlinkadmin/models/mycontroller.dart';
import 'package:playlinkadmin/models/turfpage_api.dart';
import 'package:playlinkadmin/slots/slottiming.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';

class EditTurfPage extends StatefulWidget {
  final SportsFieldApi turf;

   const EditTurfPage({super.key, required this.turf});

  @override
  _EditTurfPageState createState() => _EditTurfPageState();
}

class _EditTurfPageState extends State<EditTurfPage> {
  String? selectedLocation;
  String? selectedCategory;
  String? turfName;
  String? turfDescription;
  String? rating;
  String? courts;
  File? _image;
  final picker = ImagePicker();
  final phoneNumber = Mycontroller.getPhoneNumber();
  String? existingImageUrl;

  List<Map<String, dynamic>> slots = [];

  final List<String> categories = [
    'Cricket',
    'Badminton',
    'Volleyball',
    'Football',
    'Basketball',
    'Swimming',
    'Tennis',
    'Golf'
  ];

  final List<String> locations = [
    'Pachalam',
    'Elamakkara',
    'Cheranallur',
    'Palarivattom',
    'Edapally',
    'Kaloor',
    'Marine Drive, Kochi',
    'High Court Junction',
    'Thevara',
    'Panampilly Nagar',
    'Gandhi Nagar, Kochi',
    'Ravipuram',
    'Kathrikadavu',
    'Thammanam',
    'Kadavanthra',
    'Karanakodam',
    'Ernakulam North',
    'Ernakulam South',
    'Kalabhavan Road',
    'Willingdon Island',
    'Fort Kochi',
    'Mattancherry',
    'Thoppumpady',
    'Palluruthy',
    'Chellanam',
    'Kumbalangi',
    'Kattiparambu',
    'Kundannoor',
    'Edakochi',
    'Maradu',
    'Thaikoodam metro station',
    'Chambakkara',
    'Kakkanad',
    'Vennala',
    'Thrikkakara',
    'Vyttila',
    'Tripunithura',
    'Piravom',
    'Kalamassery',
    'Aluva',
    'Angamaly',
    'North Paravur',
    'Eloor',
    'Koonammavu',
    'Vaduthala',
    'Vypin Island',
    'Cherai',
    'Kumbalam',
    'Udayamperoor',
    'Panangad',
    'Eramallur',
    'Vaikom',
    'Kothamangalam',
    'Perumbavoor',
    'Eroor',
    'Thiruvankulam',
    'Kolenchery',
    'Mamala',
    'Kizhakkambalam',
    'Mulanthuruthy',
    'Chottanikkara'
  ];

  String? initialSelectedLocation;
  String? initialSelectedCategory;
  String? initialTurfName;
  String? initialTurfDescription;
  String? initialRating;
  String? initialCourts;
  File? initialImage;
  List<Map<String, dynamic>> initialSlots = [];

@override
void initState() {
  super.initState();
  selectedLocation = widget.turf.location;
  selectedCategory = widget.turf.category;
  turfName = widget.turf.turfName;
  turfDescription = widget.turf.description;
  rating = widget.turf.rating.toString(); // This should already be a string
  courts = widget.turf.courts.toString();
  existingImageUrl = widget.turf.imageUrl;
  slots = List<Map<String, dynamic>>.from(widget.turf.slots ?? []).map((slot) => {
    'time': slot['time'],
    'price': slot['price'].toString()
  }).toList();
  fetchCurrentSlots();
}

  Future<void> fetchCurrentSlots() async {
    final url = Uri.parse('http://13.233.98.192:3000/turf/id/${widget.turf.id}/slots');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedSlots = json.decode(response.body);
        setState(() {
          slots = fetchedSlots.map((slot) => {
            'time': slot['time'] ?? '00:00 - 00:00',
            'price': slot['price']?.toString() ?? '0',
          }).toList();
        });
        print('Fetched slots: $slots');
      } else {
        throw Exception('Failed to load slots. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching slots: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching slots: $e')),
      );
    }
  }

  Future<void> updateTurf() async {
    final url = Uri.parse('http://13.233.98.192:3000/turf/id/${widget.turf.id}');
    var request = http.MultipartRequest('PATCH', url);

    // Prepare the data in the format that works
    Map<String, dynamic> updateData = {
      'category': selectedCategory ?? widget.turf.category,
      'turfname': turfName ?? widget.turf.turfName,
      'location': selectedLocation ?? widget.turf.location,
      'playwithstranger': false,
      'court': courts ?? widget.turf.courts.toString(),
      'description': turfDescription ?? widget.turf.description,
      'amenties': [], // Assuming amenities are not being updated
      'rating': double.parse(rating ?? widget.turf.rating.toString()).round(), // Convert to double then round to int
      'slots': slots.map((slot) => {
        'time': slot['time'],
        'price': int.parse(slot['price'].toString())
      }).toList(),
      'ownerMobileNo': phoneNumber
    };

    // Add all fields as a single JSON string
    request.fields['data'] = jsonEncode(updateData);

    // Add image only if a new image is selected
    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    try {
      print('Sending update request...');
      print('Update data: ${jsonEncode(updateData)}');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response received: ${response.statusCode}');
      print('Response body: ${response.body}');

    if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Turf updated successfully')),
        );
        Navigator.pop(context);
      } else {
        print('Failed to update turf. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update turf. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error updating turf: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating turf: $e')),
      );
    }
  }
// }

// Future<void> updateTurf() async {
//   final url = Uri.parse('http://13.233.98.192:3000/turf/id/${widget.turf.id}');
//   var request = http.MultipartRequest('PATCH', url);

//   // Add fields to the request
//   final formattedPhoneNumber = phoneNumber.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;
//   request.fields['ownerMobileNo'] = formattedPhoneNumber;
//   // request.fields['ownerMobileNo'] = phoneNumber;
//   request.fields['category'] = selectedCategory ?? '';
//   request.fields['turfname'] = turfName ?? '';
//   request.fields['location'] = selectedLocation ?? '';
//   request.fields['description'] = turfDescription ?? '';
//   request.fields['rating'] = rating ?? '0';
//   request.fields['court'] = courts ?? '0';
//   // request.fields['playwithstranger'] = 'false';
//   // request.fields['amenties'] = jsonEncode([]);

//   // Adjusting slot time format and ensuring it matches the API expected format
//   List<Map<String, dynamic>> formattedSlots = slots.map((slot) {
//     String formattedTime = slot['time'].replaceAll('-', 'to');
//     return {
//       'time': formattedTime,
//       'price': slot['price']
//     };
//   }).toList();
//   request.fields['slots'] = jsonEncode(formattedSlots);

//   // Add image only if it's not null and hasn't been added yet
//   if (_image != null && !request.files.any((file) => file.field == 'image')) {
//     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
//   } else if (existingImageUrl != null) {
//     request.fields['image'] = existingImageUrl!;
//   }

//   // Print all fields and files to be sent
//   print('Sending request with the following fields:');
//   request.fields.forEach((key, value) {
//     print('$key: $value');
//   });

//   print('And the following files:');
//   request.files.forEach((file) {
//     print('File field: ${file.field}, File name: ${file.filename}');
//   });

//   try {
//     print('Sending request...');
//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     print('Response received: ${response.statusCode}');
//     if (response.statusCode == 200) {
//       print('Turf updated successfully');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Turf updated successfully')),
//       );
//       Navigator.pop(context);
//     } else {
//       print('Failed to update turf. Status: ${response.statusCode}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update turf. Status: ${response.statusCode}')),
//       );
//     }
//   } catch (e) {
//     print('Error updating turf: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error updating turf: $e')),
//     );
//   }
// }

  // Future<void> updateTurf() async {
  //   final url = Uri.parse('http://13.233.98.192:3000/turf/id/${widget.turf.id}');
  //   var request = http.MultipartRequest('PATCH', url);

  //   print('Updating turf with ID: ${widget.turf.id}');
  //   print('Phone Number: $phoneNumber');
  //   print('Category: $selectedCategory');
  //   print('Turf Name: $turfName');
  //   print('Location: $selectedLocation');
  //   print('Description: $turfDescription');
  //   print('Rating: $rating');
  //   print('Courts: $courts');
    
  //   // Filter out invalid slots
  //   List<Map<String, dynamic>> validSlots = slots.where((slot) =>
  //     slot['time'] != null &&
  //     slot['price'] != null &&
  //     slot['time'].isNotEmpty &&
  //     slot['price'].isNotEmpty
  //   ).toList();

  //   // If no valid slots, add a default one
  //   if (validSlots.isEmpty) {
  //     validSlots = [{'time': '00:00 - 00:00', 'price': '0'}];
  //   }

  //   print('Valid Slots: $validSlots');

  //   final formattedPhoneNumber = phoneNumber.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;
  //   request.fields['ownerMobileNo'] = formattedPhoneNumber;
  //   request.fields['category'] = selectedCategory ?? '';
  //   request.fields['turfname'] = turfName ?? '';
  //   request.fields['location'] = selectedLocation ?? '';
  //   request.fields['description'] = turfDescription ?? '';
  //   request.fields['rating'] = rating ?? '0';
  //   request.fields['court'] = courts ?? '0';
  //   request.fields['slots'] = jsonEncode(validSlots);

  //   print('Slots being sent to API: ${request.fields['slots']}');

  //   if (_image != null) {
  //     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
  //     print('New image added to request');
  //   } else if (existingImageUrl != null) {
  //     request.fields['image'] = existingImageUrl!;
  //     print('Existing image URL sent in request');
  //   } else {
  //     print('No image in request');
  //   }

  //   try {
  //     print('Sending request...');
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     print('Response status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Turf updated successfully')),
  //       );
  //       Navigator.pop(context);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to update turf. Status: ${response.statusCode}')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error updating turf: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error updating turf: $e')),
  //     );
  //   }
  // }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          existingImageUrl = null; // Clear existing image URL when a new image is picked
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
                const Center(
                  child: Text(
                    'Edit Turf',
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
                  onChanged: (value) =>
                      setState(() => selectedCategory = value),
                  selectedItem: selectedCategory,
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Turf Name',
                  onChanged: (value) => setState(() => turfName = value),
                  initialValue: turfName,
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Turf Description',
                  onChanged: (value) => setState(() => turfDescription = value),
                  minLines: 1,
                  maxLines: 3,
                  initialValue: turfDescription,
                ),
                const SizedBox(height: 22),
                _buildImagePicker(),
                const SizedBox(height: 22),
                _buildDropdownSearch(
                  items: locations,
                  label: 'Select Location',
                  onChanged: (value) =>
                      setState(() => selectedLocation = value),
                  selectedItem: selectedLocation,
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Rating',
                  onChanged: (value) => setState(() => rating = value),
                  initialValue: rating,
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Courts',
                  onChanged: (value) => setState(() => courts = value),
                  initialValue: courts,
                ),
                const SizedBox(height: 22),
                // Add a button to navigate to SlotTimingsPage
                ElevatedButton(
                  onPressed: () async {
                    final updatedSlots = await Navigator.push<List<Map<String, dynamic>>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SlotTimingsPage(
                          slots: slots.map((slot) => {
                            'time': slot['time'] ?? '${slot['startTime']} - ${slot['endTime']}',
                            'price': slot['price']?.toString() ?? '0',
                          }).toList(),
                          turfId: widget.turf.id,
                        ),
                      ),
                    );
                    if (updatedSlots != null) {
                      setState(() {
                        slots = updatedSlots;
                      });
                    }
                  },
                  child: const Text('Manage Slots'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: updateTurf,
                  child: const Text('Update Turf'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
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

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _image != null
          ? Image.file(_image!, fit: BoxFit.cover)
          : existingImageUrl != null && existingImageUrl!.isNotEmpty
              ? Image.network(existingImageUrl!, fit: BoxFit.cover)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo, color: Colors.green, size: 50),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap to select turf image',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _showImageSourceActionSheet(context),
                      child: const Text('Select Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
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
            hintStyle: const TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        menuProps: MenuProps(
          backgroundColor: Colors.grey[800],
        ),
        itemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              item,
              style: const TextStyle(color: Colors.white),
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
          labelStyle: const TextStyle(color: Colors.white),
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
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget _buildTextFormField({
    required String label,
    required Function(String) onChanged,
    int maxLines = 1,
    int minLines = 1,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
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
}