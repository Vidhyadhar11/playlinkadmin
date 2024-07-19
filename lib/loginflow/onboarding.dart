import 'package:flutter/material.dart';
import 'package:playlinkadmin/loginflow/phn.dart';

import 'package:get/get.dart';



class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<String> imgList = [
    'assets/Cricket-pana.png', 
    'assets/Badminton-bro.png',
    'assets/Beach volleyball-bro.png',
    'assets/Soccer-bro.png',
    'assets/basketball player-bro.png',
    'assets/swimming.png',
    'assets/Tennis-bro.png',
    'assets/Golf-bro.png',
    'assets/Grand slam-bro.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: imgList.length,
              itemBuilder: (context, index) {
                return CarouselImage(
                  imagePath: imgList[index],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              Text(
                'WELCOME TO THE CLUB!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const SizedBox(height:10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              Text(
                'book places',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              Text(
                'play games',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.to(() => EnterPhoneNumberScreen());
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CarouselImage extends StatefulWidget {
  final String imagePath;

  const CarouselImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _CarouselImageState createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}