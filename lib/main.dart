import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_load_database_demo/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myauth.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email = "";

  String pw = "";

  final MyAuth _auth = MyAuth();

  returnHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              var result = await _auth.signIn(email: email, password: pw);
              if (result == null) {
                print("!failed log in");
                return;
              }
              returnHomePage();
            },
            child: const Text("log in")),
        ElevatedButton(
          onPressed: () {
            _auth.signUp(email: email, password: pw, nickname: "d");
          },
          child: const Text("sign up"),
        )
      ],
    );
  }
}
