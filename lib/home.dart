import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'myauth.dart';
import 'chat.dart';
import 'itemlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MyUser _myUser = MyUser.instance;
  final Item _item = Item();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(_myUser.getNickname!),
          Text(_myUser.getLocation!),
          Text(_myUser.getUid!),
          ElevatedButton(
            onPressed: () async {
              image = await _item.pickImage();
            },
            child: const Text("pick image"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (image == null) return;
              await _item.registItem(
                  image: image!,
                  title: "title",
                  category: "category",
                  price: 1000,
                  description: "description");
            },
            child: const Text("regist item"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ItemList();
                }));
              },
              child: const Text("item list")),
          ElevatedButton(onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ChatPage();
                }));
          }, child: const Text("chat")),
        ],
      ),
    );
  }
}
