import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PanchangEngine {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, "panchang.db");
    var exists = await databaseExists(path);

    if (!exists) {
      // Assets से डेटाबेस कॉपी करके जान फूँकना
      ByteData data = await rootBundle.load(join("assets/database", "panchang.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path);
  }

  static Future<Map<String, dynamic>?> getTodayData(String date) async {
    final db = await database;
    var res = await db.query("panchang_table", where: "date = ?", whereArgs: [date]);
    return res.isNotEmpty ? res.first : null;
  }
}
