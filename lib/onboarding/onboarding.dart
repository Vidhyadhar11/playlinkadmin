import 'package:flutter/material.dart';
import 'package:playlinkadmin/onboarding/phn.dart';
import 'package:get/get.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with SingleTickerProviderStateMixin {
  final List<String> imgList = [
    'assets/Cricket-pana.png', 
    'assets/Badminton-bro.png',
    'assets/Beach volleyball-bro.png',
    'assets/Soccer-bro.png',
    'assets/basketball player-bro.png',
    'assets/swimming.png',
    'assets/Golf-bro.png',
    'assets/Grand slam-bro.png',
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showArrow = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(_animationController);

    // Hide arrow after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showArrow = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  itemCount: imgList.length,
                  itemBuilder: (context, index) {
                    return CarouselImage(
                      imagePath: imgList[index],
                    );
                  },
                ),
                if (_showArrow)
                  Positioned(
                    right: 20,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_animation.value, 0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WELCOME TO THE CLUB!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'book places',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const Text(
                  'play games',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(EnterPhoneNumberScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CarouselImage extends StatefulWidget {
  final String imagePath;

  const CarouselImage({super.key, required this.imagePath});

  @override
  _CarouselImageState createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        widget.imagePath,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}