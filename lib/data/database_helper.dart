import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DatabaseHelper {
  static const _databaseName = 'orders.db';
  static const _databaseVersion = 1;

  static const tableCategory = 'category';
  static const tableProduct = 'product';
  static const tableOrder = 'orders';
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
      name TEXT NOT NULL )
          ''');

    await db.execute('''
      CREATE TABLE $tableProduct (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryId INTEGER NOT NULL,
      name TEXT NOT NULL,
      FOREIGN KEY(categoryId) REFERENCES $tableCategory(id) )
          ''');

    await db.execute('''
      CREATE TABLE $tableOrder (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tableNumber INTEGER NOT NULL )
          ''');

    await db.execute('''
      CREATE TABLE $tableOrderItem (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER NOT NULL,
      productId INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      FOREIGN KEY(orderId) REFERENCES $tableOrder(id),
      FOREIGN KEY(productId) REFERENCES $tableProduct(id) )
          ''');

    await db.execute('''
      INSERT INTO $tableCategory (name) VALUES ('Food');
          ''');
    await db.execute('''
      INSERT INTO $tableCategory (name) VALUES ('Drink');
          ''');

    await db.execute('''
      INSERT INTO $tableProduct (categoryId, name) VALUES (1, 'Pizza');
          ''');
    await db.execute('''
      INSERT INTO $tableProduct (categoryId, name) VALUES (1, 'Burger');
          ''');
    await db.execute('''
      INSERT INTO $tableProduct (categoryId, name) VALUES (1, 'Pasta');
          ''');
    await db.execute('''
      INSERT INTO $tableProduct (categoryId, name) VALUES (2, 'Coke');
          ''');
    await db.execute('''
      INSERT INTO $tableProduct (categoryId, name) VALUES (2, 'Coffee');
          ''');
    await db.execute('''
      INSERT INTO $tableProduct (categoryId, name) VALUES (2, 'Tea');
          ''');
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableCategory);
    return List.generate(maps.length, (i) {
      return Category(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableProduct);
    return List.generate(maps.length, (i) {
      return Product(id: maps[i]['id'], categoryId: maps[i]['categoryId'], name: maps[i]['name']);
    });
  }

  Future<Order> createOrder(int tableNumber) async {
    final db = await database;
    final Map<String, dynamic> orderMap = {'tableNumber': tableNumber};
    final int orderId = await db!.insert(tableOrder, orderMap);
    return Order(id: orderId, tableNumber: tableNumber);
  }

  Future<OrderItem> addOrderItem(int orderId, int productId) async {
    final db = await database;
    final Map<String, dynamic> orderItemMap = {
      'orderId': orderId,
      'productId': productId,
      'quantity': 1,
    };
    final int orderItemId = await db!.insert(tableOrderItem, orderItemMap);
    return OrderItem(id: orderItemId, orderId: orderId, productId: productId, quantity: 1);
  }
}