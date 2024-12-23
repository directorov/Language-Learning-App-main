import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:langapp/ResourcePage/Resource.dart';

import '../ResourcePage/resourcedownloading.dart';

class AdditionalLang extends StatefulWidget {
  final User user;
  final ColorScheme dync; // Make it final
  final List langAvail; // Make it final

  const AdditionalLang({
    super.key, 
    required this.user, 
    required this.dync, 
    required this.langAvail,
  });

  @override
  _AdditionalLang createState() => _AdditionalLang();
}

class _AdditionalLang extends State<AdditionalLang> {
  late User _currentUser;
  int selected = 0;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.inversePrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 18),
            decoration: BoxDecoration(
                color: widget.dync.primary,
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            height: MediaQuery.of(context).size.height / 4,
            width: double.infinity,
            child: const Center(
              child: Text(
                "What would you like to learn?",
                style: TextStyle(fontSize: 27, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.55,
            child: ListView.builder(
              itemCount: widget.langAvail.length, // Use widget.langAvail
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index;
                    });
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: widget.dync.primary,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "You have selected " +
                                          widget.langAvail[selected][0],
                                      style: TextStyle(
                                          color: widget.dync.primaryContainer,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    ResourceBrain resourcebrain =
                                        ResourceBrain();

                                    await resourcebrain.appendlang(
                                        widget.langAvail[selected],
                                        _currentUser.email.toString(),
                                        _currentUser.displayName.toString());

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => ResourceDownloading(
                                          user: _currentUser,
                                          dync: widget.dync,
                                        ),
                                      ),
                                    );
                                  },
                                  child: AbsorbPointer(
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: widget.dync.surface,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text(
                                        "Tap to continue",
                                        style: TextStyle(
                                            color: widget.dync.primary),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: AbsorbPointer(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: widget.dync.primary,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              width: 2,
                              color: const Color.fromRGBO(31, 255, 134, 255))),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 8),
                      height: MediaQuery.of(context).size.height / 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.langAvail[index][0],
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                                "assets/flag/${widget.langAvail[index][2]}.svg"),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
