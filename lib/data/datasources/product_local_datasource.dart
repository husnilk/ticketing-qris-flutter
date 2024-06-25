import 'dart:ffi';

import 'package:myapp/data/models/response/product_response.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasource{

  ProductLocalDatasource._init();

  static final ProductLocalDatasource instance = ProductLocalDatasource._init();

  final String tableProducts = 'products';
  final String tableOrders = 'orders';
  final String tableOrderItems = 'order_items';
  final String tableCategory = 'categories';

  static Database? _database;

  Future<void> _createDatabase(Database db, int version) async {
    final String sqlCategories = '''
    CREATE TABLE $tableCategory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
          categoryId INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          image TEXT,
          created_at TEXT,
          updated_at TEXT
      )
    ''';
    final String sqlProducts = '''
    CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        category_id INTEGER,
        name TEXT NOT NULL,
        description TEXT,
        image TEXT,
        price TEXT,
        stock INTEGER,
        status INTEGER,
        is_favorite INTEGER,
        created_at TEXT,
        updated_at TEXT,
        criteria TEXT
      )
    ''';
    final String sqlOrders = '''
    CREATE TABLE $tableOrders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nominal INTEGER,
        payment_method TEXT,
        payment_amount INTEGER,
        total_price INTEGER,
        total_item INTEGER,
        cashier_id INTEGER,
        cashier_name TEXT,
        transaction_time TEXT,
        is_sync INTEGER DEFAULT 0
      )
    ''';
    final String sqlOrderItems = '''
    CREATE TABLE $tableOrderItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_order INTEGER,
        id_product INTEGER,
        quantity INTEGER,
        price INTEGER
      )
    ''';
    await db.execute(sqlCategories);
    await db.execute(sqlProducts);
    await db.execute(sqlOrders);
    await db.execute(sqlOrderItems);
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ticketing.db';
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase
    );
  }

  Future<Database> get database async {
    if (_database != null)
      return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> insertAllProduct(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(
        tableProducts,
        product.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  //Remove all data product
  Future<void> removeAllProduct() async {
    final db = await instance.database;
    await db.delete(tableProducts);
  }

  //Get All Data Product
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, c.id as category_id, c.name as category_name, c.description as category_description,
             c.image as category_image, c.created_at as category_created_at, c.updated_at as category_updated_at
      FROM $tableProducts p
      LEFT JOIN $tableCategory c ON p.category_id = c.id
    ''');
    return List.generate(maps.length, (i) {
      final productMap = maps[i];
      final categoryMap = {
        'id': productMap['category_id'],
        'name': productMap['category_name'],
        'description': productMap['category_description'],
        'image': productMap['category_image'],
        'created_at': productMap['category_created_at'],
        'updated_at': productMap['category_updated_at'],
      };
      return Product.fromLocalMap(productMap).copyWith(
        category: Category.fromMap(categoryMap),
      );
    });
  }

  // Future<int> insertOrder(OrderModel order) async {
  //   final db = await instance.database;
  //   int id = await db.insert(
  //     tableOrders,
  //     order.toMapForLocal(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //
  //   for (var orderItem in order.orders) {
  //     await db.insert(
  //       tableOrderItems,
  //       orderItem.toMapForLocal(id),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   }
  //   return id;
  // }
  //
  // Future<List<OrderModel>> getAllOrder() async {
  //   final db = await instance.database;
  //   final result = await db.query('orders', orderBy: 'id DESC');
  //
  //   return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  // }
}