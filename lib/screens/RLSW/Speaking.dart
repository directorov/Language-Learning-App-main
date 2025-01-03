import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langapp/learning/speakinglearning.dart';
import 'package:langapp/progress_brain.dart/progress.dart';

class Speaking extends StatefulWidget {
  final ColorScheme dync; // Marked as final
  const Speaking({required this.dync, super.key});

  @override
  State<Speaking> createState() => _SpeakingState();
}

class _SpeakingState extends State<Speaking> {
  List<String> speakingcatg = [];
  Progress prog = Progress();

  @override
  void initState() {
    super.initState();
    var box = Hive.box("LocalDB");
    Map Speaking = box.get("SPEAKING");
    Speaking.forEach((key, value) {
      speakingcatg.add(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primaryContainer,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: TopheadCLipper(),
            child: Container(
              color: widget.dync.primary,
              height: MediaQuery.of(context).size.height / 3.5,
              child: Center(
                child: Text(
                  "Speaking",
                  style: TextStyle(
                      color: widget.dync.primaryContainer,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: ListView.builder(
                itemCount: speakingcatg.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      !(index <= prog.progress_get()[2])
                          ? {}
                          : Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Speakinglearning(
                                        cat: speakingcatg[index],
                                        dync: widget.dync,
                                      )));
                    },
                    child: (index <= prog.progress_get()[2])
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: widget.dync.primary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Center(
                              child: Text(
                                speakingcatg[index],
                                style: TextStyle(
                                    color: widget.dync.secondaryContainer,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        : Stack(
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: widget.dync.primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  child: Center(
                                    child: Text(
                                      speakingcatg[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.dync.primaryContainer,
                                          fontSize: 18),
                                    ),
                                  )),
                              Opacity(
                                opacity: 0.8,
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: widget.dync.primary,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height / 10,
                                    child: const Center(child: Icon(Icons.lock))),
                              ),
                            ],
                          ),
                  );
                }),
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
    return true; // Return true to indicate it needs to reclip
  }
}
