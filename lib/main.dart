import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'Splash/inital.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    await Hive.openBox("LocalDB");
  } catch (e) {
    debugPrint("Error initializing Hive: \$e");
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Error initializing Firebase: \$e");
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LANGGG',
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Ubuntu',
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  final ColorScheme dync; // Делаем свойство final.

  const Splash({super.key, this.dync = const ColorScheme.light()});


  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  late ColorScheme dync;

  @override
  void initState() {
    super.initState();
    // Инициализация dync на основе свойства из родительского виджета.
    dync = widget.dync;
  }

  Future<void> checkFirstSeen() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? seen = prefs.getBool('seen');
      print("Значение _seen: $seen"); // Логирование

      if (seen == null) {
        print("Значение _seen равно null");
        seen = false; // Устанавливаем значение по умолчанию, если оно null
      }

      if (seen) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(dync: dync),
          ),
        );
      } else {
        await prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => InitPage(dync: dync),
          ),
        );
      }
    } catch (e) {
      print('Ошибка при проверке первого посещения: $e');
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      body: const Center(child: Text("🐼 🐼 🐼")),
    );
  }
}
