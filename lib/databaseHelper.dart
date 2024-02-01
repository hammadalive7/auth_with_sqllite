import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        is_logged_in INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
// Existing DatabaseHelper class remains the same

// Add a method to get the logged-in user's data
  Future<Map<String, dynamic>?> getLoggedInUser() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('users', where: 'is_logged_in = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }


  // Inside DatabaseHelper class
  Future<void> updateLoggedInStatus(int userId, int status) async {
    Database db = await instance.database;
    await db.update('users', {'is_logged_in': status}, where: 'id = ?', whereArgs: [userId]);
  }



}
