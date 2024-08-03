import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlinkadmin/home/addturf.dart';
import 'package:playlinkadmin/home/home.dart';
import 'package:playlinkadmin/home/test.dart';
import 'package:playlinkadmin/home/turfpage.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({super.key,required this.controller,required this.label,this.keyboardType = TextInputType.text,this.inputFormatters,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}


//add navbar component here with new class

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 0, context),
            _buildNavItem(Icons.sports_soccer, 1, context),
            _buildNavItem(Icons.event, 2, context),
            // _buildNavItem(Icons.people, 3, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: currentIndex == index ? Colors.green : Colors.grey),
      onPressed: () {
        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => turfscreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  TurfPage()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TestPage()));
            break;
        }
      },
    );
  }
}

class ToggleButton extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final ValueChanged<bool> onToggle;

  const ToggleButton({super.key, 
    required this.leftLabel,
    required this.rightLabel,
    required this.onToggle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool isLeftSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2C),
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.all(4.0), // Adjust padding
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLeftSelected = true;
                });
                widget.onToggle(true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isLeftSelected ? const Color(0xFF39FF14) : Colors.transparent,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.leftLabel,
                    style: TextStyle(
                      color: isLeftSelected ? Colors.black : Colors.grey, // Adjust text color
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLeftSelected = false;
                });
                widget.onToggle(false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isLeftSelected ? Colors.transparent : const Color(0xFF39FF14),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.rightLabel,
                    style: TextStyle(
                      color: isLeftSelected ? Colors.grey : Colors.black, // Adjust text color
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}