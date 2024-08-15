import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:playlinkadmin/home/editpage.dart';
import 'package:playlinkadmin/models/turfpage_api.dart';
import 'package:playlinkadmin/slots/slottiming.dart';

class TurfDetailsPage extends StatelessWidget {
  final SportsFieldApi turf;

   const TurfDetailsPage({super.key, required this.turf});

   Future<void> deleteTurf(String id) async {
    final url = 'http://13.233.98.192:3000/turf/id/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Turf deleted successfully');
    } else {
      print('Failed to delete turf: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(turf.imageUrl), // Use turf image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 10,
                            left: 0,
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(turf.category, style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      turf.turfName,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [const SizedBox(height: 10),
                    Text(
                      turf.location,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 30,),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          turf.rating.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      turf.description,
                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Amenities',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildAmenityItem(Icons.local_parking, 'Parking'),
                            _buildAmenityItem(Icons.wc, 'Rest Room'),
                            _buildAmenityItem(Icons.local_cafe, 'Cafeteria'),
                            _buildAmenityItem(Icons.medical_services, 'First Aid Kit'),
                          ],
                        ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditTurfPage(turf: turf)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), 
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color: Colors.black),
                                SizedBox(width: 8),
                                Text('Edit', style: TextStyle(color: Colors.black, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              deleteTurf(turf.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete Turf', style: TextStyle(color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SlotTimingsPage(slots: turf.slots, turfId: turf.id)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      ),
                      child: const Text('Slot Timings', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAmenityItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

class AmenityWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const AmenityWidget({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}