import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final String studentId;
  final String playerId; // Add this to uniquely identify the player in Firebase

  const PlayerCard({
    super.key,
    required this.name,
    required this.studentId,
    required this.playerId,
  });

  // Function to delete a player from Firebase
  void _deletePlayer(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Player"),
          content: const Text("Are you sure you want to delete this player?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('players')
          .doc(playerId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name has been deleted."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Player Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Student ID: $studentId",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              // Delete Button
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 28,
                ),
                onPressed: () => _deletePlayer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
