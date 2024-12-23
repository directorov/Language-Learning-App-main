import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langapp/chatroom/chartui.dart';

import '../chatroom/activity.dart';

class Leaderboard extends StatefulWidget {
  final ColorScheme dync;
  const Leaderboard({required this.dync, super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late Activity onlineOffline;
  User? user;

  @override
  void initState() {
    super.initState();
    onlineOffline = Activity();
    user = FirebaseAuth.instance.currentUser;
    onlineOffline.setstatus(true);
  }

  @override
  void dispose() {
    onlineOffline.setstatus(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: const Center(
            child: Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 600,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading data."));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No users found."));
              }

              var data = snapshot.data!.docs;
              List sortedData = sortData(data);

              return ListView.builder(
                itemCount: sortedData.length,
                itemBuilder: (context, index) {
                  var doc = sortedData[index];
                  var userName = doc.data()?["name"] ?? "Unknown";
                  var rank = doc.data()?["leader_board"] ?? 0;
                  var imageUrl = doc.data()?["avatar_url"] ??
                      "https://via.placeholder.com/150"; // Placeholder image
                  var statusColor = doc.data()?["status"] == true
                      ? Colors.green
                      : Colors.transparent;

                  return leadcont(
                    user: user,
                    name: userName,
                    email: doc.reference.id,
                    dync: widget.dync,
                    imageurl: imageUrl,
                    index: index,
                    shield: rankColors[index < 3 ? index : 3],
                    context: context,
                    rank: rank,
                    status: statusColor,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  List<Color> rankColors = [
    const Color.fromARGB(255, 241, 186, 20),
    const Color.fromARGB(255, 231, 205, 205),
    Colors.brown,
    Colors.white
  ];
}

List sortData(List docs) {
  docs.sort((a, b) {
    var aRank = a.data()?["leader_board"] ?? 0;
    var bRank = b.data()?["leader_board"] ?? 0;
    return bRank.compareTo(aRank); // Sort descending
  });
  return docs;
}

GestureDetector leadcont({
  required User? user,
  required String name,
  required String email,
  required ColorScheme dync,
  required String imageurl,
  required int index,
  required Color shield,
  required BuildContext context,
  required int rank,
  required Color status,
}) {
  return GestureDetector(
    onTap: () {
      if (name.toLowerCase() != user?.displayName?.toLowerCase()) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChatUI(
            reciver: name.toLowerCase(),
            reciver_name: name,
            dync: dync,
          );
        }));
      }
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: name.toLowerCase() == user?.displayName?.toLowerCase()
            ? dync.primaryContainer
            : Colors.white,
        border: Border.all(
          color: name.toLowerCase() != user?.displayName?.toLowerCase()
              ? dync.primaryContainer
              : Colors.white,
          width: 3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            index < 3
                ? Icon(Icons.shield, color: shield)
                : Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: dync.primary,
                    ),
                  ),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageurl),
                  radius: 20,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: status,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: dync.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              rank.toString(),
              style: TextStyle(
                color: dync.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
