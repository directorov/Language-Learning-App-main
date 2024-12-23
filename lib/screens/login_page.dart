import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:langapp/ResourcePage/Resource.dart';
import 'package:langapp/ResourcePage/resourcedownloading.dart';
import 'package:langapp/admin/inshome.dart';
import 'package:langapp/screens/register_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:langapp/utils/validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final ColorScheme dync;

  const LoginPage({super.key, required this.dync});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  Future<void> displayMessage(String message) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResourceDownloading(
            user: user,
            dync: widget.dync,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: widget.dync.onPrimaryContainer,
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      tophead(context, widget.dync.primary),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      formfield(context),
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget tophead(BuildContext context, Color col) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: MediaQuery.of(context).size.height / 3.4,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: col,
        image: const DecorationImage(
          image: AssetImage("assets/Studentbackpack.png"),
          scale: 1.4,
          alignment: Alignment.bottomRight,
        ),
      ),
      child: const Text(
        "Hi user\nWelcome\nback",
        style: TextStyle(fontSize: 36, color: Colors.white),
      ),
    );
  }

  Form formfield(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget.dync.inversePrimary,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              controller: _emailTextController,
              focusNode: _focusEmail,
              validator: (value) => Validator.validateEmail(
                email: value,
              ),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 15),
                  hintText: "Enter your email id",
                  hintStyle:
                      TextStyle(fontSize: 16, color: widget.dync.primary),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget.dync.inversePrimary,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              controller: _passwordTextController,
              focusNode: _focusPassword,
              obscureText: true,
              validator: (value) => Validator.validatePassword(
                password: value,
              ),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 15),
                  hintStyle:
                      TextStyle(fontSize: 16, color: widget.dync.primary),
                  hintText: "Your Password",
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 24.0),
          _isProcessing
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    Expanded(child: signinbutton(context)),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don’t have an account ? "),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          dync: widget.dync,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Color.fromARGB(200, 139, 61, 241)),
                  )),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Instructor Login? "),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InsHome(
                          dync: widget.dync,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Click Here",
                    style: TextStyle(color: Color.fromARGB(200, 139, 61, 241)),
                  )),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          GestureDetector(
            onTap: () async {
              _googleSignIn.signIn().then((googleUser) async {
                if (googleUser != null) {
                  final googleAuth = await googleUser.authentication;

                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  final userCredential = await FirebaseAuth.instance
                      .signInWithCredential(credential);

                  if (userCredential.user != null) {
                    ResourceBrain resourceBrain = ResourceBrain();
                    resourceBrain.initaldownloadlang();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ResourceDownloading(
                          user: userCredential.user!,
                          dync: widget.dync,
                        ),
                      ),
                    );
                  }
                }
              });
            },
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: widget.dync.inversePrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                height: MediaQuery.of(context).size.height / 13,
                child: Image.asset('assets/Google__G__Logo.svg.png'))),
        ],
      ),
    );
  }

  GestureDetector signinbutton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _focusEmail.unfocus();
        _focusPassword.unfocus();

        if (_formKey.currentState!.validate()) {
          setState(() {
            _isProcessing = true;
          });

          User? user = await FireAuth.signInUsingEmailPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );

          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text,
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.code)));
          }

          setState(() {
            _isProcessing = false;
          });

          if (user != null) {
            ResourceBrain resourceBrain = ResourceBrain();

            await resourceBrain.initaldownloadlang();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ResourceDownloading(
                  user: user,
                  dync: widget.dync,
                ),
              ),
            );
          }
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: widget.dync.primary,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        width: 100,
        child: const Center(
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
