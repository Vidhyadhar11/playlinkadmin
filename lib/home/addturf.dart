import 'package:flutter/material.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:playlinkadmin/home/slottiming.dart';

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
  String? courts;
  File? _image;
  final picker = ImagePicker();
  List<Map<String, dynamic>> slots = [];

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

  void navigateToSlotsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SlotTimingsPage(slots: slots)),
    );
    if (result != null) {
      setState(() {
        slots = result;
      });
    }
  }

  Future<void> createTurf() async {
    final url = Uri.parse('http://10.0.2.2:3000/turf');
    
    var request = http.MultipartRequest('POST', url);
    
    request.fields['category'] = selectedCategory ?? '';
    request.fields['turfname'] = turfName ?? '';
    request.fields['location'] = selectedLocation ?? '';
    request.fields['description'] = turfDescription ?? '';
    request.fields['rating'] = rating ?? '0';
    request.fields['court'] = courts ?? '0';
    request.fields['slots'] = jsonEncode(slots);  // This now contains the generated slots

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {  // Changed from 201 to 200
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Turf created successfully')),
        );
        // You might want to do something with the created turf data here
        var createdTurf = json.decode(response.body);
        print('Created Turf ID: ${createdTurf['_id']}');
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print("Image selected: ${pickedFile.path}");
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print("Error picking image: $e");
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
                _buildImagePicker(),
                const SizedBox(height: 22),
                _buildDropdownSearch(
                  items: locations,
                  label: 'Select Location',
                  onChanged: (value) => setState(() => selectedLocation = value),
                  selectedItem: selectedLocation,
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Rating',
                  onChanged: (value) => setState(() => rating = value),
                ),
                const SizedBox(height: 22),
                _buildTextFormField(
                  label: 'Courts',
                  onChanged: (value) => setState(() => courts = value),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: navigateToSlotsPage,
                  child: const Text('Add Slot Timings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 22),
                Center(
                  child: TextButton(
                    onPressed: createTurf,
                    child: const Text(
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

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _image == null
          ? Column(
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
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
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