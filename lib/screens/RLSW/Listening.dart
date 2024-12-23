import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

var box = Hive.box("LocalDB");

class Listening extends StatefulWidget {
  final ColorScheme dync;

  const Listening({required this.dync, super.key});

  @override
  State<Listening> createState() => _ListeningState();
}

class _ListeningState extends State<Listening> {
  late Future<DocumentSnapshot> onetimebuilder;
  var lang =
      box.get("Lang")[box.get("current_lang").toString()]['Selected_lang'];

  @override
  void initState() {
    super.initState();
    onetimebuilder = FirebaseFirestore.instance
        .collection('DataBase')
        .doc('Listening')
        .get();
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Handle the error or show a dialog
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: widget.dync.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Listening",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.28,
              child: FutureBuilder<DocumentSnapshot>(
                future: onetimebuilder,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("loading"));
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  }
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    var langData = data[lang[0]] as List<dynamic>;

                    return ListView.builder(
                      itemCount: langData.length,
                      itemBuilder: (context, index) {
                        String moduleUrl = langData[index].toString();
                        return GestureDetector(
                          onTap: () => _launchUrl(moduleUrl),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.dync.primaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            height: MediaQuery.of(context).size.height / 12,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Module ${index + 1}",
                                style: TextStyle(
                                  color: widget.dync.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
