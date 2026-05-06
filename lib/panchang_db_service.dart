import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PanchangDBService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'panchang_50years.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // 50 साल के डेटा के लिए टेबल (तिथि, नक्षत्र, मुहूर्त, साल)
      await db.execute('''
        CREATE TABLE panchang (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          tithi TEXT,
          nakshatra TEXT,
          shubh_muhurat TEXT,
          year INTEGER
        )
      ''');
    });
  }

  // डेटा डालने का फंक्शन (यहाँ 2026 से 2076 तक का डेटा लूप होगा)
  Future<void> insertPanchangData(Map<String, dynamic> data) async {
    final dbClient = await db;
    await dbClient.insert('panchang', data);
  }

  // आज का पंचांग खोजने की कोडिंग
  Future<List<Map<String, dynamic>>> getTodayPanchang(String todayDate) async {
    final dbClient = await db;
    return await dbClient.query('panchang', where: 'date = ?', whereArgs: [todayDate]);
  }
}
