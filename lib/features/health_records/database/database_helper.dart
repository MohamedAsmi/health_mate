import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'healthmate.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        water INTEGER NOT NULL
      )
    ''');
    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    final today = DateTime.now();
    final dummyRecords = [
      HealthRecord(
        date: DateTime(
          today.year,
          today.month,
          today.day,
        ).toIso8601String().split('T')[0],
        steps: 8500,
        calories: 450,
        water: 2000,
      ),
      HealthRecord(
        date: DateTime(
          today.year,
          today.month,
          today.day - 1,
        ).toIso8601String().split('T')[0],
        steps: 10000,
        calories: 520,
        water: 2500,
      ),
      HealthRecord(
        date: DateTime(
          today.year,
          today.month,
          today.day - 2,
        ).toIso8601String().split('T')[0],
        steps: 6500,
        calories: 380,
        water: 1800,
      ),
      HealthRecord(
        date: DateTime(
          today.year,
          today.month,
          today.day - 3,
        ).toIso8601String().split('T')[0],
        steps: 9200,
        calories: 490,
        water: 2200,
      ),
      HealthRecord(
        date: DateTime(
          today.year,
          today.month,
          today.day - 4,
        ).toIso8601String().split('T')[0],
        steps: 7800,
        calories: 420,
        water: 1900,
      ),
    ];

    for (var record in dummyRecords) {
      await db.insert('health_records', record.toMap());
    }
  }

  Future<int> insertRecord(HealthRecord record) async {
    final db = await database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<HealthRecord?> getRecordById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return HealthRecord.fromMap(maps.first);
  }

  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<List<HealthRecord>> getRecordsByDateRange(
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<int> updateRecord(HealthRecord record) async {
    final db = await database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete('health_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllRecords() async {
    final db = await database;
    return await db.delete('health_records');
  }

  Future<Map<String, int>> getTodaySummary() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final records = await getRecordsByDate(today);

    if (records.isEmpty) {
      return {'steps': 0, 'calories': 0, 'water': 0};
    }

    int totalSteps = 0;
    int totalCalories = 0;
    int totalWater = 0;

    for (var record in records) {
      totalSteps += record.steps;
      totalCalories += record.calories;
      totalWater += record.water;
    }

    return {
      'steps': totalSteps,
      'calories': totalCalories,
      'water': totalWater,
    };
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
