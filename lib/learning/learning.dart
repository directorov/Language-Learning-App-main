import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../learning/progress.dart';
import '../progress_brain.dart/progress.dart';

double height = 250;

class QuestionsUi extends StatefulWidget {
  final String topic;
  final ColorScheme dync;

  const QuestionsUi({super.key, required this.topic, required this.dync});

  @override
  State<QuestionsUi> createState() => _QuestionsUiState();
}

class _QuestionsUiState extends State<QuestionsUi> {
  late int randint;
  bool popinCorrect = false;
  bool popinIncorrect = false;
  double progress = 0.0;
  late List<dynamic> questionList;
  List<List<dynamic>> uQuestion = [];
  late String lang;
  late String langCode;
  final Progress prog = Progress();
  final box = Hive.box("LocalDB");
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    if (!box.containsKey("Data_downloaded")) {
      throw Exception("Данные не загружены! Проверьте ключ 'Data_downloaded'.");
    }

    final rawData = box.get("Data_downloaded") as Map<dynamic, dynamic>?;
    if (rawData == null || !rawData.containsKey(widget.topic)) {
      throw Exception("Нет данных для указанной темы: ${widget.topic}");
    }

    questionList = box.get(widget.topic) as List<dynamic>;
    lang = box.get("Lang")[box.get("current_lang").toString()]['Selected_lang'][0];
    langCode = box.get("Lang")[box.get("current_lang").toString()]['Selected_lang'][1];

    final tempU = rawData[widget.topic] as List<dynamic>;
    for (int i = 0; i < questionList.length; i++) {
      uQuestion.add([tempU[i], questionList[i]]);
    }

    uQuestion.shuffle();
    randint = Random().nextInt(4);
  }

  int nextQuestion() {
    randint = Random().nextInt(4);
    uQuestion.shuffle();
    return randint;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.dync.primary,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 17),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_sharp),
                      ),
                      LinearPercentIndicator(
                        progressColor: Colors.black,
                        percent: progress,
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                      const Icon(Icons.report),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "${uQuestion[randint][0]} in $lang",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 10),
                      GestureDetector(
                        onTap: () async {
                          await flutterTts.setLanguage(trcode[langCode] ?? "en-US");
                          await flutterTts.speak(uQuestion[randint][1]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.dync.primaryContainer,
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                          ),
                          child: const Icon(Icons.audio_file, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        answerOptions(uQuestion[0][1], uQuestion[randint][1]),
                        answerOptions(uQuestion[1][1], uQuestion[randint][1]),
                        answerOptions(uQuestion[2][1], uQuestion[randint][1]),
                        answerOptions(uQuestion[3][1], uQuestion[randint][1]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            incorrect(context),
            correct(context),
          ],
        ),
      ),
    );
  }

  Visibility incorrect(BuildContext context) {
    return Visibility(
      visible: popinIncorrect,
      child: _feedbackOverlay(
        context: context,
        color: Colors.red,
        title: "Incorrect",
        message: "Correct Answer: ${uQuestion[randint][1]}",
        onContinue: () {
          setState(() {
            randint = nextQuestion();
            popinIncorrect = false;
          });
        },
      ),
    );
  }

  Visibility correct(BuildContext context) {
    return Visibility(
      visible: popinCorrect,
      child: _feedbackOverlay(
        context: context,
        color: Colors.green,
        title: "Awesome!",
        onContinue: () {
          setState(() {
            randint = nextQuestion();
            popinCorrect = false;
            progress = (progress + 0.2).clamp(0.0, 1.0);
            if (progress >= 1.0) {
              prog.progress_update(0);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => IndProgress(data: widget.topic, dync: widget.dync),
              ));
            }
          });
        },
      ),
    );
  }

  Widget _feedbackOverlay({
    required BuildContext context,
    required Color color,
    required String title,
    String? message,
    required VoidCallback onContinue,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            if (message != null)
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            GestureDetector(
              onTap: onContinue,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: const Text(
                  "Got it",
                  style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded answerOptions(String value, String answer) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (value == answer) {
              popinCorrect = true;
            } else {
              popinIncorrect = true;
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.dync.primaryContainer,
            border: Border.all(color: widget.dync.onPrimary),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(color: widget.dync.secondary, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

Map<String, String> trcode = {
  "hr": "hr-HR",
  "ko": "ko-KR",
  "mr": "mr-IN",
  "ru": "ru-RU",
  "zh": "zh-TW",
  "hu": "hu-HU",
  "sw": "sw-KE",
  "th": "th-TH",
  "en": "en-US",
  "hi": "hi-IN",
  "fr": "fr-FR",
  "ja": "ja-JP",
  "ta": "ta-IN",
  "ro": "ro-RO"
};
