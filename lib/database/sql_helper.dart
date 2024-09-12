import 'package:password_manager/model/password_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> initDatabase() async {}

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE passwords(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    site TEXT,
    username TEXT,
    password TEXT NOT NULL,
    note TEXT,
    dateTime TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
""");

    await database.execute("""CREATE TABLE pin(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      pin_code TEXT NOT NULL
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('password_manager.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  Future<int> addPassword(
      String siteParam, usernameParam, passwordParam, noteParam) async {
    try {
      final db = await SqlHelper.db();
      PasswordModel passwordModel1 = PasswordModel(
        site: siteParam,
        username: usernameParam,
        password: passwordParam,
        note: noteParam,
        dateTime: DateTime.now().toString(),
      );
      final result = await db.insert(
        'passwords',
        passwordModel1.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      passwordModel1.id = result;
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future<List<PasswordModel>> getPasswords() async {
    final db = await SqlHelper.db();
    final result = await db.query('passwords', orderBy: 'id');
    return result.map((json) => PasswordModel.fromJson(json)).toList();
  }

  Future<int> updatePasswords(
      int id, String siteParam, usernameParam, passwordParam, noteParam) async {
    try {
      final db = await SqlHelper.db();
      PasswordModel passwordModel = PasswordModel(
        id: id,
        site: siteParam,
        username: usernameParam,
        password: passwordParam,
        note: noteParam,
        dateTime: DateTime.now().toString(),
      );

      final myMap = passwordModel.toUpdateMap();
      myMap['created_at'] = DateTime.now().toString();
      final result = await db.update(
        'passwords',
        myMap,
        where: "id = ?",
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future<void> deletePasswords(int id) async {
    final db = await SqlHelper.db();
    await db.delete(
      'passwords',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> addPin(String pinCode) async {
    final db = await SqlHelper.db();
    Map<String, dynamic> m1 = {
      'pin_code': pinCode,
    };
    final result = await db.insert(
      'pin',
      m1,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getPin() async {
    final db = await SqlHelper.db();
    final result = await db.query('pin', orderBy: 'id');
    return result;
  }

  Future<int> updatePin(int id, String newPinCode) async {
    final db = await SqlHelper.db();
    Map<String, dynamic> m4 = {
      'pin_code': newPinCode,
    };
    final result = await db.update(
      'pin',
      m4,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<void> deletePin(int id) async {
    final db = await SqlHelper.db();
    await db.delete(
      'pin',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getSpecificPin(int id) async {
    final db = await SqlHelper.db();
    final result = await db.query(
      'pin',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result;
  }
}
