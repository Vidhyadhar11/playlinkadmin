import 'package:flutter/material.dart';

// Define the SportsField class to handle both types of cards
class SportsField {
  final String name;
  final String location;
  final String imageUrl;
  final String sportType; // Add sportType property
  final String? slot;
  final int? players;
  final int? maxPlayers;

  SportsField({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.sportType, // Initialize sportType
    this.slot,
    this.players,
    this.maxPlayers,
  });
}

// Define the first type of sports field card
class SportsFieldCard extends StatefulWidget {
  final SportsField sportsField;
  final VoidCallback onTap;

  const SportsFieldCard({Key? key, required this.sportsField, required this.onTap}) : super(key: key);

  @override
  _SportsFieldCardState createState() => _SportsFieldCardState();
}

class _SportsFieldCardState extends State<SportsFieldCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.network(widget.sportsField.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    child: Text(widget.sportsField.sportType, style: const TextStyle(color: Colors.white)), // Use sportType
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.sportsField.name}, ${widget.sportsField.location}', style: const TextStyle(color: Colors.white)),
                 
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}