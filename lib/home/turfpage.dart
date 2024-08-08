import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlinkadmin/models/turfcontroller.dart';
import 'package:http/http.dart' as http;
import 'package:playlinkadmin/uicomponents/elements.dart';

class Turfspage extends StatelessWidget {
  const Turfspage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TurfsController controller = Get.put(TurfsController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Text('Play', style: TextStyle(color: Colors.white)),
            Text('link', style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.apiResponse.isEmpty) {
          return const Center(child: Text('No turfs found', style: TextStyle(color: Colors.white)));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.apiResponse.length,
            itemBuilder: (context, index) {
              final turf = controller.apiResponse[index];
              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            turf.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              turf.category,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            turf.turfName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  turf.location,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                turf.rating.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 1,
      ),
    );
  }
}