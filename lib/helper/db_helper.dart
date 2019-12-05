import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> userDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'users.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY,balance INT,name TEXT,phone CHAR(10))');
      return db.insert('users', {
        'id': DateTime.now().toString(),
        'name': 'Self',
        'balance': 0,
        'phone': 0
      });
    }, version: 1);
  }

  static Future<Database> txDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'txs.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE txs(id TEXT PRIMARY KEY,amount INT,description TEXT,type TEXT,user TEXT)');
    }, version: 1);
  }

  static Future<void> insertUser(Map<String, Object> data) async {
    final db = await DBHelper.userDatabase();
    db.insert(
      'users',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    db.close();
  }

  static Future<List<Map<String, dynamic>>> getUserData() async {
    final db = await DBHelper.userDatabase();
    var a = db.query('users');
    db.close();
    return a;
  }

  static Future<void> updateUserBalance(Map<String, Object> data) async {
    final db = await DBHelper.userDatabase();
    int updateCount = await db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
    db.close();
    print(updateCount);
  }

  static Future<void> insertTransaction(Map<String, Object> data) async {
    final db = await DBHelper.txDatabase();
    try {
      db.insert(
        'txs',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } catch (error) {
      print(error);
    }
    print("done");
    db.close();
  }

  static Future<List<Map<String, dynamic>>> getTxs() async {
    final db = await DBHelper.txDatabase();
    var a = db.query('txs');
    db.close();
    return a;
  }

  static Future<void> deletetx(String txId) async {
    final db = await DBHelper.txDatabase();
    db.delete('txs', where: 'id = ?', whereArgs: [txId]);
    db.close();
  }
}
