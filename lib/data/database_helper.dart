import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'orders.db';
  static const _databaseVersion = 1;

  static const tableCategory = 'category';
  static const tableProduct = 'product';
  static const tableOrder = 'order';
  static const tableOrderItem = 'orderItem';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategory (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
          ''');

    await db.execute('''
      CREATE TABLE $tableProduct (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryId INTEGER NOT NULL,
      name TEXT NOT NULL,
      FOREIGN KEY(categoryId) REFERENCES $tableCategory(id)
          ''');

    await db.execute('''
      CREATE TABLE $tableOrder (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tableNumber INTEGER NOT NULL
          ''');

    await db.execute('''
      CREATE TABLE $tableOrderItem (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER NOT NULL,
      productId INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      FOREIGN KEY(orderId) REFERENCES $tableOrder(id),
      FOREIGN KEY(productId) REFERENCES $tableProduct(id)
          ''');
  }
}