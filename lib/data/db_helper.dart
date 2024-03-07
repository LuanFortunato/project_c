import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class DBHelper {
  static Database? _db;
  static const String id = 'id';
  static const String barcode = 'barcode';
  static const String table = 'BarcodeTable';
  static const String dbName = 'barcodes.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + dbName;
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table ($id INTEGER PRIMARY KEY, $barcode TEXT)");
  }

  Future<int> saveBarcode(String barcode) async {
    var dbClient = await db;
    var res = await dbClient.insert(table, {barcode: barcode});
    return res;
  }

  Future<List<String>> getBarcodes() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $table');
    List<String> barcodes = [];
    for (int i = 0; i < list.length; i++) {
      barcodes.add(list[i][barcode]);
    }
    return barcodes;
  }
}
