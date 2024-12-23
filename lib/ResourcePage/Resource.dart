import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:langapp/screens/profile_page.dart';
import 'package:lottie/lottie.dart';

class ResourceDownloading extends StatefulWidget {
  final User user;  // Make it final
  final ColorScheme dync;  // Make it final

  const ResourceDownloading({super.key, required this.user, required this.dync});

  @override
  State<ResourceDownloading> createState() => _ResourceDownloadingState();
}

class _ResourceDownloadingState extends State<ResourceDownloading> {
  @override
  void initState() {
    super.initState();
    Progress prog = Progress();
    prog.get_firebase_progress(); // You may want to wait for this async task to complete.

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: widget.user,
            dync: widget.dync,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Center(
        child: LottieBuilder.asset("assets/animation_llgwflgi.json"),
      ),
    );
  }
}
