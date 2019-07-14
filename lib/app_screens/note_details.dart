import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/database_helper.dart';
import 'package:flutter_app/models/note.dart';
import 'package:intl/intl.dart';

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
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

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
                    value: getPriorityAsString(note.priority),
                    onChanged: (value) {
                      setState(() {
                        debugPrint("User selected $value");
                        updatePriorityAsInt(value);
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
                      _updateTitle();
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
                      _updateDescription();
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
                              _saveNote();
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
                              _deleteNote();
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

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void _updateTitle() {
    note.title = titleController.text;
  }

  void _updateDescription() {
    note.description = descriptionController.text;
  }

  void _saveNote() async {

    _moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await _databaseHelper.updateNote(note);
    } else {
      result = await _databaseHelper.insetNote(note);
    }

    if (result != 0) {
      _showAllertDialog("Status", "Note Saved Successfully");
    } else {
      _showAllertDialog("Status", "Problem Saving Note");
    }

    
  }

  void _deleteNote() async {

    _moveToLastScreen();

    if (note.id == null) {
      _showAllertDialog("Status", "No Note was Deleted");
      return;
    }

    int result = await _databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAllertDialog("Status", "Note Deleted Successfully");
    } else {
      _showAllertDialog("Status", "Something went wrong!");
    }

    
  }

  void _showAllertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
