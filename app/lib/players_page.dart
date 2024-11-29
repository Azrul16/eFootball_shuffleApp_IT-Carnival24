import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'player_card.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  void _openAddPlayerModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (BuildContext context) {
        return const AddPlayerModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Players'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A11CB),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Player List
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('players').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No players added yet!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final players = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 100),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final playerDoc = players[index];
                  final player = playerDoc.data() as Map<String, dynamic>;

                  return PlayerCard(
                    name: player['name'],
                    studentId: player['studentId'],
                    playerId: playerDoc.id, // Pass document ID for deletion
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddPlayerModal,
        backgroundColor: const Color(0xFF6A11CB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
