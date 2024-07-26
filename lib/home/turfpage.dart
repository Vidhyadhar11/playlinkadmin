import 'package:flutter/material.dart';
import 'package:playlinkadmin/home/turfdetails.dart';
import 'package:playlinkadmin/loginflow/test.dart';
import 'package:playlinkadmin/uicomponents/cards.dart';
import 'package:playlinkadmin/uicomponents/elements.dart'; // Import the ProfilePage

class turfscreen extends StatefulWidget {
  const turfscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _turfscreenState createState() => _turfscreenState();
}

class _turfscreenState extends State<turfscreen> {
  final List<SportsField> sportsFields = [
    SportsField(
      name: 'KPHB',
      location: 'Hyderabad',
      imageUrl: 'https://via.placeholder.com/150',
      sportType: 'Football',
    ),
    SportsField(
      name: 'Gachibowli',
      location: 'Hyderabad',
      imageUrl: 'https://via.placeholder.com/150',
      sportType: 'Cricket',
    ),
    SportsField(
      name: 'suchitra',
      location: 'chepak',
      imageUrl: 'https://via.placeholder.com/150',
      sportType: 'Tennis',
    ),
    // Add more SportsField objects if needed
  ];

  List<SportsField> filteredSportsFields = [];
  bool isPressed =false;
  int _currentIndex = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSportsFields = sportsFields;
    searchController.addListener(_filterSportsFields);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterSportsFields() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSportsFields = sportsFields.where((field) {
        return field.name.toLowerCase().contains(query) ||
            field.location.toLowerCase().contains(query) ||
            field.sportType.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // Ensure this is set to false
        title: const Row(
          children: [
            SizedBox(width: 30),
            Text(
              'Play',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'link',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                    color: Colors.white), // Set the text color to white
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),

            ...filteredSportsFields.map((field) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: SportsFieldCard(
                    sportsField: field,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TurfDetailsPage(),
                        ),
                      );
                    },
                  ),
                )),
            const SizedBox(height: 200), // Adding space for the floating navbar
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
