
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tableNote = "note_table";
  String colId = "id";
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initDatabase();
    }

    return _database;
  }

  Future<Database> initDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'noteapp.db';

    // Open/Create database in given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    String sql = 'CREATE TABLE $tableNote($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)';
    await db.execute(sql);

  }

  Future<List<Note>> getNoteList() async {

    var noteListMap = await getNoteMapList();
    List<Note> noteList = List<Note>();
    for (var item in noteListMap) {
      noteList.add(Note.fromMapObject(item));
    }
    return noteList;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {

    Database db = await this.database;
    //String sql = 'SELECT * FROM $tableNote order by $colPriority ASC';
    //var result = await db.rawQuery(sql);
    var result = await db.query(tableNote, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insetNote(Note note) async {

    Database db = await this.database;
    var result = await db.insert(tableNote, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {

    Database db = await this.database;
    var result = await db.update(tableNote, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {

    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $tableNote WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {

    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableNote');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
