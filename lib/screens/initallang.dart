import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:langapp/ResourcePage/Resource.dart';
import '../ResourcePage/resourcedownloading.dart';

class RegisterLang extends StatefulWidget {
  final ColorScheme dync;  // Make dync final

  const RegisterLang({super.key, required this.dync});

  @override
  _RegisterLang createState() => _RegisterLang();
}

class _RegisterLang extends State<RegisterLang> {
  bool _isSendingVerification = false;  // Переменная для отслеживания состояния отправки верификации

  late User _currentUser;
  List<dynamic> LangAvail = [
    ["German", "de", "DE"],
    ["Japanese", "ja", "JP"],
    ["Russian", "ru", "RU"],
    ["Korean", "ko", "KR"],
    ["French", "fr", "PM"],
    ["Malayalam", "ml", "IN"],
    ["Tamil", "ta", "IN"],
    ["Hindi", "hi", "IN"],
    ["Kannada", "kn", "IN"],
  ];

  int selected = 0;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  // Асинхронная функция для имитации отправки верификации
  Future<void> sendVerification() async {
    setState(() {
      _isSendingVerification = true; // Начинаем процесс верификации
    });

    // Симуляция сетевого запроса или реальной логики верификации
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isSendingVerification = false; // Завершаем процесс верификации
    });
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
                  itemCount: LangAvail.length - 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print("index");
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
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "You have selected " +
                                              LangAvail[selected][0],
                                          style: TextStyle(
                                              color:
                                                  widget.dync.primaryContainer,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isSendingVerification = true; // Начинаем процесс
                                        });

                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: double.infinity,
                                                  child: const Center(
                                                    child: SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive()),
                                                  ));
                                            });

                                        ResourceBrain resourcebrain =
                                            ResourceBrain();
                                        await resourcebrain.addUserdetails(
                                            LangAvail[selected],
                                            _currentUser.email.toString());
                                        await resourcebrain
                                            .initaldownloadlang();

                                        setState(() {
                                          _isSendingVerification = false; // Завершаем процесс
                                        });

                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResourceDownloading(
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
                                          child: _isSendingVerification
                                              ? const CircularProgressIndicator() // Показываем индикатор загрузки
                                              : Text(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  width: 2,
                                  color: const Color.fromRGBO(31, 255, 134, 255))),
                          margin:
                              const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
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
                                  LangAvail[index][0],
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
                                    "assets/flag/${LangAvail[index][2]}.svg"),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
