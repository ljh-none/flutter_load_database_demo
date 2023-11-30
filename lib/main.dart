import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_load_database_demo/firebase_options.dart';
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
  String email = "ljh09210921@gmail.com";
  String pw = '';

  final MyAuth _auth = MyAuth();
  final TextEditingController con = TextEditingController();

  returnHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return const HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: con, obscureText: true),
          ElevatedButton(
              onPressed: () async {
                pw = con.text;
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
          ),
        ],
      ),
    );
  }
}
