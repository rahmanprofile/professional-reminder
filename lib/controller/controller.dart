import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import '../model/models.dart';

class DBController extends ChangeNotifier{
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      notifyListeners();
      return _db;
    } else {
      _db = await initDatabase();
      notifyListeners();
    }
  }


  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'notes.db');
    var db = await openDatabase(path, version: 2, onCreate: onCreate);
    log("database path --> $path");
    notifyListeners();
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, body NOT NULL)");
    notifyListeners();
  }

  Future<Models> insertData({required Models models}) async {
    var dbClient = await db;
    await dbClient!.insert("notes", models.toMap());
    notifyListeners();
    return models;
  }

  Future<List<Models>> getData() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query("notes");
    return queryResult.map((e) => Models.fromMap(e)).toList();
  }

  Future<int> deleteData({required int id}) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}
