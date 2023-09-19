import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:reminder/model/reminder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class StateController extends ChangeNotifier {
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
    String path = join(directory.path, 'memo.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    log("database path --> $path");
    notifyListeners();
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE memo (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, subtitle TEXT NOT NULL, category TEXT NOT NULL, time TEXT NOT NULL)"
    );
    notifyListeners();
  }

  Future<Reminder> insertData({required Reminder reminder}) async {
    var dbClient = await db;
    await dbClient!.insert("memo", reminder.toJson());
    notifyListeners();
    return reminder;
  }

  Future<List<Reminder>> getData() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query("memo");
    return queryResult.map((e) => Reminder.fromJson(e)).toList();
  }

  Future<int> deleteData({required int id}) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'memo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
