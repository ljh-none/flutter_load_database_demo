/*
read me
파이어스토어에 등록하기 위해선 map객체를 add해야됨.
플러터 앱 전체에서, 유저클래스의 객체는 사용자 하나만 존재한다.
나머지 유저는 불특정하고 유동적이므로, 그때그때 DB에서 가져오는게 나을듯.

변경 내역
유저 평가 지수 삭제
지역 리스트 이쪽으로 옯김
*/
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'main.dart';

const String IMAGE_URI = 'imageUri';
const String TITLE = "title";
const String CATEGORY = "category";
const String PRICE = "price";
const String DESCRIPTION = "description";
const String TIMESTAMP = "timestamp";
const String REGISTER = "register";
const String EMAIL = "email";
const String LOCATION = "location";
const String NICKNAME = "nickname";
const String UID = "uid";

class MyUser {
  //singletone pattern
  MyUser._privateConstructor();
  static final MyUser _instance = MyUser._privateConstructor();
  static MyUser get instance => _instance;
  //member variable
  final String _uri = "/UserData";
  String? _nickname = "";
  String? _email;
  String? _location;
  String? _uid;
  //getter
  String? get getNickName => _nickname;
  String? get getEmail => _email;
  String? get getLocation => _location;
  String? get getuid => _uid;

  set nickname(String nickname) {
    _nickname = nickname;
  }

  Future _getDocs(String str) async {
    FirebaseFirestore firestore =
        FirebaseFirestore.instance; //key: doc's index, value: document
    var result =
        await firestore.collection(_uri).where(NICKNAME, isEqualTo: str).get();
    var docs = result.docs.asMap();
    print("get docs\n");
    return docs;
  }

  _getCollection() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var result = firestore.collection(_uri); //collection함수에서 오류처리 해주네
    print("get collection\n");
    return result;
  }

  Future<bool> setMyUserObj(String uid) async {
    var docs = await _getDocs(uid);
    if (docs.isEmpty) {
      print("docs are empty");
      return false;
    }
    _email = docs[0]?.data()[EMAIL]; //uid는 유일하므로 인덱스 0씀
    _nickname = docs[0]?.data()[NICKNAME];
    _location = docs[0]?.data()[LOCATION];
    _uid = uid;
    return true;
  }

  void registUser(
      {required String email, required String nickname, required String uid}) {
    var collection = _getCollection();
    collection.add(
        {EMAIL: _email, NICKNAME: _nickname, LOCATION: _location, UID: uid});
  }

  Future<bool> isExisted(String nickname) async {
    var docs = await _getDocs(nickname);
    if (docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

class Item {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  final String _ITEM_DATABASE = '/ItemData';

  void addItem(imageUri, title, category, price, description, timestamp,
      {required MyUser user}) {
    Map<String, dynamic> item = {
      IMAGE_URI: imageUri,
      TITLE: title,
      CATEGORY: category,
      PRICE: price,
      DESCRIPTION: description,
      TIMESTAMP: timestamp,
      REGISTER: user.getNickName,
      EMAIL: user.getEmail,
      LOCATION: user.getLocation,
    };
    _firestore.collection(_ITEM_DATABASE).add(item);
  }
}

final List<String> _availableLocations = [
  '양호동',
  '선주 원남동',
  '도량동',
  '양포동',
  '상모 사곡동',
  '광평동',
  '칠곡',
  '진미동',
  '인동동',
  '양포동',
  '임오동',
  '도량동',
  '지산동',
  '송정동',
  '형곡동',
  '원평동',
  '신평동',
  '비산동',
  '공단동',
];

///더미데이터, 맘껏 만드세영////////////////////////////////////////////////