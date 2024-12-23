import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../screens/register_page.dart';
import 'package:animate_do/animate_do.dart';

class InitPage extends StatelessWidget {
  final ColorScheme dync;
  const InitPage({super.key, required this.dync});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    //final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: dync.primary,
      body: Stack(
        children: [
          ZoomIn(
            child: Align(
              alignment: const Alignment(3, -1.3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 3000),
                height: screenHeight / 3.2,
                width: screenHeight / 3.2,
                decoration: BoxDecoration(
                    color: dync.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(200))),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight / 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "To have another language is to possess a second soul".toUpperCase(),
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold, height: 1.0),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight / 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                      RotateAnimatedText(
                        "Try the Worlds leading online language tutorial center",
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      RotateAnimatedText(
                        "世界をリードするオンライン言語チュートリアル センターを試してください",
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      RotateAnimatedText(
                        "உலகின் முன்னணி ஆன்லைன் மொழி பயிற்சி மையத்தை முயற்சிக்கவும்",
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                    ]),
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 9),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(dync: dync),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: dync.onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  height: screenHeight / 17,
                  child: Center(
                    child: Text(
                      'Get started',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: dync.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
