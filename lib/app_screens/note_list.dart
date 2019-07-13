import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/database_helper.dart';
import 'package:flutter_app/app_screens/note_details.dart';
import 'package:flutter_app/models/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: _getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB clicked!");
          _navigateToDetails('Add Note', Note('',"",2,""));
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: textStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, this.noteList[position]);
              },
            ),
            onTap: () {
              debugPrint("List Item Tapped!");
              _navigateToDetails('Edit Note', this.noteList[position]);
            },
          ),
        );
      },
    );
  }

  void _navigateToDetails(String title, Note note) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(title, note);
    }));
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await _databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note Deleted Successfully");
      // TODO: refresh list
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = _databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
