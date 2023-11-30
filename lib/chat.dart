import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'myauth.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController txtcontrollor = TextEditingController();
  final MyUser _myUser = MyUser.instance;
  final Chat _chat = Chat();

  Widget buildChatList(context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return const Text("err!");
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Text("no data");
    }

    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      reverse: true,
      itemBuilder: (context, index) {
        var doc = snapshot.data!.docs[index];
        var data = doc.data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data[CONTENT]),
          subtitle: Text(data[SENDER]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //navigator push로 정보를 가져온다. 어떤 방식이든 상관없다.
    //아이템 정보 전체이든, 등록자 uid이든 상대방 유저의 uid만 있으면 됨.
    //상대방 uid를 otherUid 파라미터에 넣으면 채팅방 생성 및 로드 가능.
    var chatRoom = _chat.getChattingRoom(otherUid: "otherUid");

    Future<void> sendMessage() async {
      String temp = txtcontrollor.text;
      await chatRoom.add({
        CONTENT: temp,
        SENDER: _myUser.getNickname,
        TIMESTAMP: FieldValue.serverTimestamp(),
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("chat")),
      body: StreamBuilder(
        stream: chatRoom.orderBy(TIMESTAMP, descending: true).snapshots(),
        builder: buildChatList,
      ),
      bottomNavigationBar: Row(children: [
        Expanded(
          child: TextField(
            controller: txtcontrollor,
            decoration: const InputDecoration(
              labelText: "input",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(onPressed: sendMessage, child: const Text("send"))
      ]),
    );
  }
}
