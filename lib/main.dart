import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String url =
      'https://firebasestorage.googleapis.com/v0/b/ljh-firebase-for-flutter.appspot.com/o/IMG-0463.jpg?alt=media&token=046d8d63-7de8-47a7-86a7-02d5fcf92710';
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<int> delay() {
    return Future<int>(() async {
      var msec = 2000;
      await Future.delayed(Duration(milliseconds: msec));
      return msec;
    });
  }

  @override
  Widget build(BuildContext context) {
    //function space
    Future<Uint8List?> loadImage() {
      return Future<Uint8List?>(() async {
        final ref = _storage.refFromURL(url);
        try {
          Uint8List? result = await ref.getData();
          return result;
        } catch (e) {
          print(e);
          return null;
        }
      });
    }

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: loadImage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Image.memory(snapshot.data!);
            //return Image.network(url);
          },
        ),
      ),
    );
  }
}
