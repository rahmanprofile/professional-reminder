import 'package:reminder/model/reminder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  late Database _database;

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'reminders.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        title TEXT,
        subtitle TEXT,
        category TEXT,
        time TEXT
      )
    ''');
  }

  Future<int> addReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toJson());
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder.fromJson(maps[i]);
    });
  }

  Future<int> deleteReminder(String id) async {
    final db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
