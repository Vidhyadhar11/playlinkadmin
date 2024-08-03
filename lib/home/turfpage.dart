import 'package:flutter/material.dart';
import 'package:playlinkadmin/home/edit1.dart';
import 'package:playlinkadmin/home/test.dart';
import 'package:playlinkadmin/uicomponents/cards.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';// Import the ProfilePage

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
      rating: 4.4,
      price: 120,
      imageUrl:
          'https://via.placeholder.com/150', // Replace with your image URL
      discount: '15% Off',
      sportType: 'Football', // Pass the sportType
    ),
    SportsField(
      name: 'Gachibowli',
      location: 'Hyderabad',
      rating: 4.4,
      price: 120,
      imageUrl:
          'https://via.placeholder.com/150', // Replace with your image URL
      discount: '10% Off',
      sportType: 'Cricket', // Pass the sportType
    ),
    SportsField(
      name: 'suchitra',
      location: 'chepak',
      rating: 4.4,
      price: 120,
      imageUrl:
          'https://via.placeholder.com/150', // Replace with your image URL
      discount: '10% Off',
      sportType: 'Tennis', // Pass the sportType
    ),
    // Add more SportsField objects if needed
  ];

  List<SportsField> filteredSportsFields = [];
  bool isPressed =
      false; // Define isPressed variable at the beginning of _HomePageState class
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
        title: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu,
                    color: Colors.white), // Set the color to white
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
            const Text(
              'Play',
              style: TextStyle(color: Colors.white),
            ),
            const Text(
              'link',
              style: TextStyle(color: Colors.green),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestPage()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[800],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('Salman Khan',
                    style: TextStyle(color: Colors.white)),
                accountEmail: const Text('salmankhan@gmail.com',
                    style: TextStyle(color: Colors.white)),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
              ),
              ListTile(
                title: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Your Profile',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              ListTile(
                title: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.book, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Bookings', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              ListTile(
                title: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Rewards', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              ListTile(
                title: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.favorite, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Your Wishlist',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              ListTile(
                title: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.help, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Help desk', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              ListTile(
                title: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.settings, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Settings', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestPage()),
                  );
                },
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.logout, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TestPage()),
                    );
                  },
                ),
              ),
            ],
          ),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Interested Sport in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TestPage()), // Replace with your target screen
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
