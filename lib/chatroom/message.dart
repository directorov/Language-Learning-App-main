import 'package:cloud_firestore/cloud_firestore.dart';

class message {
  late String reciver;
  late String msg;
  late String sender;

  message({
    required this.sender,
    required this.reciver,
    required this.msg,
  });

  Map<String, dynamic> getFmsg() {
    return {
      "Sender": sender,
      "Reciver": reciver,
      "Message": msg,
      "TimeStamp": Timestamp.now()
    };
  }
}
