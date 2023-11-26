import 'package:flutter/material.dart';
import 'myauth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyUser _myUser = MyUser.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_myUser.getNickname!),
        Text(_myUser.getLocation!),
        Text(_myUser.getUid!)
      ],
    );
  }
}
