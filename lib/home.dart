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
  String _receiver = "c";
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
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ChatList();
                }));
              },
              child: const Text("chat")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  //아이템의 상세 정보가 올라와있다고 가정
                  return ChatPage(_receiver);
                }));
              },
              child: const Text("아이템 상세페이지에서 채팅하기 누를 시")),
        ],
      ),
    );
  }
}
