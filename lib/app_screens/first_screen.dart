import 'dart:math';

import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.white, child: initListView()

      /*Center(
          child: Text(generateLuckyNumber(),
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white, fontSize: 24.0)),
      )*/
    );
  }

  String generateLuckyNumber() {
    var random = Random();
    return "Your lucky number is ${random.nextInt(10)}";
  }

  List<String> getListItem() {
    var items = List<String>.generate(1000, (counter) => "Item $counter");
    return items;
  }

  Widget initListView() {
    var itemList = getListItem();
    var listView = ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.arrow_right),
        title: Text(itemList[index]),
        onTap: () {
          showSnackBar(context, itemList[index]);
        },
      );
    });
    return listView;
  }

  void showSnackBar(BuildContext context, String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(label: "Undo", onPressed: () {
        debugPrint("Undo button clicked");
      }),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
