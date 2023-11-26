import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'dataformat.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Item item = Item();
  @override
  Widget build(BuildContext context) {
    //dummy
    //function space
    // Future<Uint8List?> loadImage() {
    //   return Future<Uint8List?>(() async {
    //     final ref = storage.refFromURL(url);
    //     try {
    //       Uint8List? result = await ref.getData();
    //       return result;
    //     } catch (e) {
    //       print(e);
    //       return null;
    //     }
    //   });
    // }

    Widget buildImage(context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      return Image.memory(snapshot.data!);
      //return Image.network(url);
    }

    return MaterialApp(
      home: ListView(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                //item.addItem('a', 'b', 'c', 'f', 'f', 'd');
              },
              child: const Text('regist Item test'),
            ),
          ),
          // SizedBox(
          //   width: double.infinity,
          //   height: 300,
          //   child: FutureBuilder(
          //     future: loadImage(),
          //     builder: buildImage,
          //   ),
          // ),
        ],
      ),
    );
  }
}
