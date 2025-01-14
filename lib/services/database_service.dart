import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/task.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  static DatabaseService get instance => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'task_manager.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT,
            color TEXT NOT NULL,
            font TEXT NOT NULL,
            fontSize REAL NOT NULL,
            isCompleted INTEGER NOT NULL,
            userId INTEGER NOT NULL,
            FOREIGN KEY (userId) REFERENCES users (id)
          );
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) return User.fromMap(result.first);
    return null;
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    final id = await db.insert('tasks', task.toMap()..remove('id')); // Remove `id` if null
    print('Dodano zadanie do bazy z ID: $id');
    return id;
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasksByUserId(int userId) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    print('Pobrane zadania dla userId $userId: ${result.length}');
    return result.map((e) => Task.fromMap(e)).toList();
  }
  Future<void> printDatabasePath() async {
    final path = join(await getDatabasesPath(), 'task_manager.db');
    print('Ścieżka do bazy danych: $path');
  }
}
