import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'notesmodel.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, age INTEGER NOT NULL, description TEXT NOT NULL, email TEXT)",
    );
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbclient = await db;
    await dbclient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNotesList() async {
    var dbclient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbclient!.query('notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> delete(int? id) async {
    var dbclient = await db;
    return await dbclient!.delete('notes', where: 'id=?', whereArgs: [id]);
  }

  Future<int> update(NotesModel notesModel) async {
    var dbclient = await db;
    return await dbclient!.update('notes', notesModel.toMap(),
        where: 'id=?', whereArgs: [notesModel.id]);
  }
}
