import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'main_1.dart';
import 'dataformat.dart';

MyUser user = MyUser.instance;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AuthWidget());
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  AuthWidgetState createState() => AuthWidgetState();
}

class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String email;
  late String password;

  // login
  Future<bool> signIn() async {
    try {
      UserCredential userInfo = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userInfo.user!.emailVerified) {
        Fluttertoast.showToast(msg: 'login success');
        return true;
      }
      Fluttertoast.showToast(msg: 'emailVerified error');
      return false;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.code);
      throw Error();
    }
  }

  // logout, 사실상 로그인페이지에서는 필요없음
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // register
  signUp() async {
    try {
      UserCredential userInfo = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userInfo.user!.email == null) {
        Fluttertoast.showToast(msg: "email error!");
        return;
      }
      _auth.currentUser?.sendEmailVerification();
      Fluttertoast.showToast(msg: "verify email and retry login");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.code);
    }
  }

  void checkFormState() {
    var currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      throw Error();
    }
    currentState.save();
  }

  void saveInput(String? value, String v) {
    if (value == null) {
      email = "";
      password = "";
    }

    if (v == 'email') {
      email = value!;
    } else if (v == 'password') {
      password = value!;
    } else {
      return;
    }
  }

  String? validateInput(value, String v) {
    if (value == null || value.isEmpty) {
      return 'Please enter content';
    }
    if (v == 'email') {
      email = value!;
    } else if (v == 'password') {
      password = value!;
    } else {
      return 'error!!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auth Test")),
      body: Column(children: [
        const Text('login Page'),
        Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'email'),
              validator: (value) => validateInput(value, 'email'),
              onSaved: (value) => saveInput(value, 'email'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'password'),
              obscureText: true, //안보이게끔
              validator: (value) => validateInput(value, 'password'),
              onSaved: (value) => saveInput(value, 'password'),
            ),
          ]),
        ),
        ElevatedButton(
          onPressed: () async {
            checkFormState();
            bool result = await signIn();
            if (result == false) return; //로그인 실패 시
            result = await user.setMyUserObj(_auth.currentUser!.uid);
            if (result) {
              //등록되어있는 유저일 시
              //asyn gap에 대해 안전할거라 판단.
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()));
            }
            submitNickname(); //등록되어있지 않은 유저일 때
          },
          child: const Text('Sign in'),
        ),
        ElevatedButton(
          onPressed: () {
            checkFormState();
            signUp();
          },
          child: const Text("GO Sign Up!"),
        ),
      ]),
    );
  }

  submitNickname() {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          print("show");
          return AlertDialog(
            title: const Text("회원가입을 환영합니다"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: "닉네임을 입력하세요"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool result = await user.isExisted(controller.text);
                  if (result) {
                    Fluttertoast.showToast(msg: '이미 존재하는 닉네임입니다');
                    return;
                  }
                  user.nickname = controller.text;
                  user.registUser(
                      email: email,
                      nickname: controller.text,
                      uid: _auth.currentUser!.uid);
                },
                child: const Text("submit"),
              )
            ]),
          );
        });
  }
}
