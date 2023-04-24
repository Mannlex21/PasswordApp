import 'package:password_manager/models/password_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PasswordDatabase {
  static final PasswordDatabase instance = PasswordDatabase._init();

  static Database? _database;

  PasswordDatabase._init();

  final String tablePasswordItems = 'passwordItems';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int? version) async {
    await db.execute('''
    CREATE TABLE $tablePasswordItems(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      password TEXT,
      description TEXT,
      url TEXT
    )
    ''');
  }

  Future<void> insert(PasswordItem item) async {
    final db = await instance.database;
    await db.insert(tablePasswordItems, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PasswordItem>> getAllItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tablePasswordItems);

    return List.generate(maps.length, (i) {
      return PasswordItem(
          id: maps[i]['id'],
          name: maps[i]['name'],
          password: maps[i]['password'],
          description: maps[i]['description'],
          url: maps[i]['url']);
    });
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    db.delete(tablePasswordItems, where: "id = ?", whereArgs: [id]);
  }

  Future<void> update(PasswordItem item) async {
    final db = await instance.database;
    await db.update(tablePasswordItems, item.toMap(),
        where: "id = ?",
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
