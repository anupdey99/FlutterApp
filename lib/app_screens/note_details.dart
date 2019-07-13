import 'package:flutter/material.dart';
import 'package:flutter_app/models/note.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetails(this.appBarTitle, this.note);

  @override
  State<StatefulWidget> createState() {
    return _NoteDetailsState(appBarTitle, note);
  }
}

class _NoteDetailsState extends State<NoteDetails> {
  String appBarTitle;
  Note note;
  static var _priorities = ['High', 'Low'];

  _NoteDetailsState(this.appBarTitle, this.note);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        onWillPop: () {
          _moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                debugPrint("Arrow back pressed");
                _moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: _priorities[1],
                    onChanged: (value) {
                      setState(() {
                        debugPrint("User selected $value");
                      });
                    },
                  ),
                ),
                //Second element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      debugPrint("Title changed");
                    },
                  ),
                ),
                // Third Elements
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      debugPrint("Description changed");
                    },
                  ),
                ),
                // Forth
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Save",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button pressed");
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Delete",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button pressed");
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
    }
  }

  void _moveToLastScreen() {
    Navigator.pop(context);
  }
}
