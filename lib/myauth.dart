import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: constant_identifier_names
const String UID = "uid";
const String NICKNAME = "nickname";
const String LOCATION = "location";

class MyAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MyUser _myUser = MyUser.instance;
  final String _uri = "/UserData";

  Future _getDocs(String key, String value) async {
    //key: doc's index, value: document
    var result =
        await _firestore.collection(_uri).where(key, isEqualTo: value).get();
    var docs = result.docs.asMap();
    return docs;
  }

  Future _authenticateUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException {
      Fluttertoast.showToast(msg: "!log in failed");
      return;
    }
  }

  _loadUserData(String uid) async {
    var docs = await _getDocs(UID, uid);
    if (docs == null || docs.isEmpty || docs[0] == null) {
      print("!docs null or empty");
      return;
    }
    Map data = docs[0].data() as Map;
    if (data[UID] == null || data[NICKNAME] == null || data[LOCATION] == null) {
      print("!null from user database");
      return;
    }
    if (data.isEmpty) {
      print("!user not exist");
      return;
    }
    return data;
  }

  _isNicknameTaken(String nickname) async {
    var data = await _getDocs(NICKNAME, nickname);
    if (data == null || data.isEmpty) {
      return false;
    }
    return true;
  }

  Future _verifyUser(String email, String password) async {
    try {
      UserCredential userInfo = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userInfo.user!.email == null) {
        print("!null from email");
        return;
      }
      _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }
  }

  //sign in
  signIn({required String email, required String password}) async {
    User? user = await _authenticateUser(email, password);
    if (user == null) {
      print("!failed verifying user");
      return;
    }
    Map<String, dynamic>? data = await _loadUserData(user.uid);
    if (data == null) {
      print("!failed load data");
      return;
    }
    _myUser.setUser(
        uid: data[UID], nickname: data[NICKNAME], location: data[LOCATION]);
    return true;
  }

  //sign out
  Future signOut() async => await FirebaseAuth.instance.signOut();

  //sign up
  signUp(
      {required String email,
      required String password,
      required String nickname}) async {
    if (await _isNicknameTaken(nickname)) {
      Fluttertoast.showToast(msg: "nickname already exist");
      return;
    }
    await _verifyUser(email, password);
    Fluttertoast.showToast(msg: "sign in after email verification");
  }
}

class MyUser {
  //singleton
  MyUser._privateConstructor();
  static final MyUser _instance = MyUser._privateConstructor();
  static MyUser get instance => _instance;
  //member variable
  String? _uid;
  String? _nickname;
  String? _location;

  String? get getUid => _uid;
  String? get getNickname => _nickname;
  String? get getLocation => _location;

  setUser(
      {required String uid,
      required String nickname,
      required String location}) {
    _uid = uid;
    _nickname = nickname;
    _location = location;
  }
}
