import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:langapp/chatroom/chatbrain.dart';
import 'package:langapp/chatroom/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatUI extends StatefulWidget {
  final String reciver;
  final ColorScheme dync;
  final String reciver_name;

  const ChatUI({
    required this.reciver,
    required this.dync,
    required this.reciver_name,
    super.key,
  });

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  late chatbrain brain;
  String? sender;
  TextEditingController messagefield = TextEditingController();
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    sender = FirebaseAuth.instance.currentUser?.displayName ?? "Unknown User";
    brain = chatbrain(reciver: widget.reciver);
    brain.chatroomid();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    messagefield.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.dync.onPrimaryContainer,
        title: Text(widget.reciver_name),
      ),
      backgroundColor: widget.dync.primary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: brain.recivemessage(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Error occurred. Please try again later."));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages found."));
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      bool isSender = data['Reciver'] != widget.reciver_name;

                      return Align(
                        alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            color: isSender
                                ? widget.dync.primaryContainer
                                : widget.dync.onPrimaryContainer,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                data['Message'] ?? "",
                                style: TextStyle(
                                  color: isSender
                                      ? widget.dync.onPrimaryContainer
                                      : widget.dync.primaryContainer,
                                ),
                              ),
                              Text(
                                data['TimeStamp'] != null
                                    ? timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          (data['TimeStamp'] as Timestamp).millisecondsSinceEpoch,
                                        ),
                                        locale: 'en_short',
                                      )
                                    : "Unknown time",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8,
                                  color: isSender
                                      ? widget.dync.onPrimaryContainer
                                      : widget.dync.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: widget.dync.onPrimaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.dync.inversePrimary,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      height: MediaQuery.of(context).size.width / 6.5,
                      child: TextField(
                        controller: messagefield,
                        cursorColor: widget.dync.primary,
                        style: TextStyle(color: widget.dync.primary),
                        decoration: const InputDecoration(
                          hintText: "Enter your message...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.dync.onPrimary,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (messagefield.text.isNotEmpty) {
                          message msg = message(
                            sender: sender!,
                            reciver: widget.reciver_name,
                            msg: messagefield.text,
                          );

                          messagefield.clear();
                          brain.sendmessage(msg.getFmsg());
                        }
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
