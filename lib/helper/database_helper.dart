import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:currency_converter_app/model/conversion_history.dart';
import 'package:currency_converter_app/model/rate_alert.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // ===================history==========================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'conversion_history.db'),
      version: 3, // Increment the version number
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE conversion_history(date TEXT PRIMARY KEY, fromCurrency TEXT, toCurrency TEXT, amount REAL, convertedAmount REAL, rate REAL)',
        );
        await db.execute(
          'CREATE TABLE rate_alerts(id INTEGER PRIMARY KEY AUTOINCREMENT, fromCurrency TEXT, toCurrency TEXT, threshold REAL, notify INTEGER)',
        );
        await db.execute(
          'CREATE TABLE base_currencies(id INTEGER PRIMARY KEY, baseCurrency TEXT, secondaryBaseCurrency TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE rate_alerts(id INTEGER PRIMARY KEY AUTOINCREMENT, fromCurrency TEXT, toCurrency TEXT, threshold REAL, notify INTEGER)',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'CREATE TABLE base_currencies(id INTEGER PRIMARY KEY, baseCurrency TEXT, secondaryBaseCurrency TEXT)',
          );
        }
      },

    );
  }

  // ===================conversion history==========================
  Future<void> insertConversionHistory(ConversionHistory history) async {
    final db = await database;
    await db.insert(
      'conversion_history',
      history.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ConversionHistory>> getConversionHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('conversion_history');

    return List.generate(maps.length, (i) {
      return ConversionHistory.fromJson(maps[i]);
    });
  }

  Future<int> clearConversionHistory() async {
    final db = await database;
    return await db.delete('conversion_history');
  }

  // ============================rate alerts===========================
  Future<void> insertRateAlert(RateAlert alert) async {
    final db = await database;
    await db.insert(
      'rate_alerts',
      alert.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RateAlert>> getRateAlerts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rate_alerts');
    return List.generate(maps.length, (i) {
      return RateAlert.fromJson(maps[i]);
    });
  }

  Future<void> updateRateAlert(RateAlert alert) async {
    final db = await database;
    await db.update(
      'rate_alerts',
      alert.toJson(),
      where: 'id = ?',
      whereArgs: [alert.id],
    );
  }
  Future<void> deleteRateAlert(int id) async {
    final db = await database;
    await db.delete(
      'rate_alerts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  //========================base currencies===============================
// ===================base currencies==========================

  Future<void> setBaseCurrencies(String baseCurrency, String secondaryBaseCurrency) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      'base_currencies',
      {'id': 1, 'baseCurrency': baseCurrency, 'secondaryBaseCurrency': secondaryBaseCurrency},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, String?>> getBaseCurrencies() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'base_currencies',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return {
        'baseCurrency': maps.first['baseCurrency'] as String?,
        'secondaryBaseCurrency': maps.first['secondaryBaseCurrency'] as String?,
      };
    }
    return {'baseCurrency': null, 'secondaryBaseCurrency': null};
  }

}


