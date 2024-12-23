import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class Progress {
  User? user = FirebaseAuth.instance.currentUser;
  var box = Hive.box("LocalDB");

  List progress_get() {
    // print(box.get("Lang")[]);
    List lastProg = box.get("Progress");
    return lastProg;
  }

  void progress_update(pos) {
    List lastProg = box.get("Progress");
    lastProg[pos] += 1;
    box.put("Progress", lastProg);
    update_firebase();
  }

  void update_firebase() {
    List lastProg = box.get("Progress");

    CollectionReference userBase =
        FirebaseFirestore.instance.collection('user');

    userBase.doc(user!.email.toString()).update({
      'Selected_lang': box.get("Lang")['Selected_lang'],
      'Progress': lastProg,
      'leader_board': box.get("Lang")['leader_board'] + 1
      //;eader/////******* */
    });
  }

  void get_firebase_progress() async {
    CollectionReference userBase =
        FirebaseFirestore.instance.collection('user');
    userBase.doc(user!.email.toString()).get().then((value) async {
      box.put("Lang", (value.data()));
      print(box.get("Lang").toString() + box.get("current_lang").toString());
      box.put(
          "Progress",
          await box.get("Lang")[box.get("current_lang").toString()]
              ['Progress']);
    });
  }
}
