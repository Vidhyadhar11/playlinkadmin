import 'package:flutter/material.dart';
import 'package:playlinkadmin/home/edit1.dart';
import 'package:playlinkadmin/home/test.dart';
import 'package:playlinkadmin/uicomponents/cards.dart';
import 'package:playlinkadmin/uicomponents/elements.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:playlinkadmin/models/turfpage_api.dart';

class SportsFieldController extends GetxController {
  var sportsFields = <SportsFieldApi>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchSportsFields();
    super.onInit();
  }

  void fetchSportsFields() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('http://localhost:3000/api/sports-fields'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as List;
        sportsFields.value = jsonData.map((field) => SportsFieldApi.fromJson(field)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch sports fields');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch sports fields');
    } finally {
      isLoading(false);
    }
  }
}

class SportsFieldApi {
  final int id;
  final String turfName;
  final String location;
  final double rating;
  final int courts;
  final String imageUrl;
  final int discounts;
  final String category;

  SportsFieldApi({
    required this.id,
    required this.turfName,
    required this.location,
    required this.rating,
    required this.courts,
    required this.imageUrl,
    required this.discounts,
    required this.category,
  });

  factory SportsFieldApi.fromJson(Map<String, dynamic> json) {
    return SportsFieldApi(
      id: json['id'],
      turfName: json['turfName'],
      location: json['location'],
      rating: json['rating'],
      courts: json['courts'],
      imageUrl: json['imageUrl'],
      discounts: json['discounts'],
      category: json['category'],
    );
  }
}

class turfscreen extends StatefulWidget {
  const turfscreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _turfscreenState createState() => _turfscreenState();
}

class _turfscreenState extends State<turfscreen> {
  final SportsFieldController controller = Get.put(SportsFieldController());
  final UserController userController = Get.put(UserController());
  TextEditingController searchController = TextEditingController();
  List<SportsFieldApi> filteredSportsFields = [];

  @override
  void initState() {
    super.initState();
    filteredSportsFields = controller.sportsFields;
    searchController.addListener(_filterSportsFields);
    userController.fetchUserDetails();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterSportsFields() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSportsFields = controller.sportsFields.where((field) {
        return field.turfName.toLowerCase().contains(query) ||
            field.location.toLowerCase().contains(query) ||
            field.category.toLowerCase().contains(query);
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
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredSportsFields.length,
                    itemBuilder: (context, index) {
                      final field = filteredSportsFields[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TurfDetailsPage(),
                            ),
                          );
                        },
                        // child: SportsFieldCard(
                        //   sportsFieldApi: field,
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => TurfDetailsPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
                      );
                    },
                  ),
                );
              }
            }),
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

class UserController extends GetxController {
  var userDetails = {}.obs;

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  void fetchUserDetails() {
    userDetails.value = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    };
  }
}