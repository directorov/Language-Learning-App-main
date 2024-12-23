import 'package:flutter/material.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:langapp/learning/progress.dart';

class Reading extends StatefulWidget {
  final ColorScheme dync; // Marked as final
  const Reading({required this.dync, super.key});

  @override
  State<Reading> createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  Progress prog = Progress();

  @override
  Widget build(BuildContext context) {
    // Optimizing repeated access to MediaQuery
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: widget.dync.primaryContainer,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: TopheadCLipper(),
            child: Container(
              color: widget.dync.primary,
              height: screenHeight / 3.5,
              child: Center(
                child: Text(
                  "Reading",
                  style: TextStyle(
                      color: widget.dync.secondaryContainer,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight / 1.5,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isLocked = index > prog.progress_get()[0] / 6;

                return GestureDetector(
                  onTap: isLocked
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => IndProgress(
                              data: categories[index],
                              dync: widget.dync,
                            ),
                          ));
                        },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.dync.surface,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: screenHeight / 10,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: widget.dync.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      if (isLocked)
                        Opacity(
                          opacity: 0.9,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.dync.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: screenHeight / 10,
                            width: double.infinity,
                            child: const Center(child: Icon(Icons.lock)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TopheadCLipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height - 80, size.width / 2, size.height - 40);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // if new instance has different data than old instance, return true
  }
}

List<String> categories = [
  "Vocabulary",
  "Phrases and Expressions",
  "Grammar",
  "Dialogues and Conversations",
  "Cultural Insights",
];
