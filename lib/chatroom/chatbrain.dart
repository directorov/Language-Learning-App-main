import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatbrain {
  final current = FirebaseAuth.instance.currentUser;
  final store = FirebaseFirestore.instance;
  late String reciver;
  late String chatroom;

  chatbrain({required this.reciver});

  void chatroomid() {
    List id = [
      current!.displayName!.toLowerCase().toString(),
      reciver.toLowerCase().toString()
    ];
    id.sort();
    chatroom = id.join('_');
  }

  //send

  void sendmessage(Map<String, dynamic> data) async {
    await store
        .collection('chat_db')
        .doc(chatroom)
        .collection('chat')
        .add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> recivemessage() {
    return store
        .collection('chat_db')
        .doc(chatroom)
        .collection('chat')
        .orderBy('TimeStamp', descending: false)
        .snapshots();
  }
}
