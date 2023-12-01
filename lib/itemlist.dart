import 'package:flutter/material.dart';
import 'myauth.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Item _item = Item();
  List<Map<String, dynamic>> list = []; //홈 화면에서 출력 중인 아이템 리스트

  @override
  Widget build(BuildContext context) {
    Future loadMoreData(var time) async {
      print("!load More Data");
      var result = await _item.getMoreItem(time: time);
      setState(() {
        list.addAll(result);
      });
      print("!add ${result[0]}");
    }

    return Scaffold(
      body: FutureBuilder(
        future: _item.startItemStream(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            list.addAll(snapshot.data!);
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  if (index == list.length - 1) {
                    loadMoreData(list[index][TIMESTAMP]);
                  }
                  return Card(child: Text("${list[0][ITEMID]}$index"));
                });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
