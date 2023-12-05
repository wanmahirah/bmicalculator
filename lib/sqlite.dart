import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the SQLite database
  await BMIDatabase.init();
}

class BMIDatabase {
  static final String _dbName = "bitp3453_bmi";
  static final String _tblName = "bmi";
  static final String _colUsername = "username";
  static final String _colWeight = "weight";
  static final String _colHeight = "height";
  static final String _colGender = "gender";
  static final String _colStatus = "bmi_status";

  static late Future<Database> _database;

  static Future<void> init() async {
    _database = _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $_tblName (
            $_colUsername TEXT,
            $_colHeight TEXT,
            $_colWeight TEXT,
            $_colGender TEXT,
            $_colStatus TEXT
          )
          ''',
        );
      },
      version: 1,
    );

    return db;
  }

  static Future<void> insertBMI(BMI bmi) async {
    final Database db = await _database;
    await db.insert(
      _tblName,
      bmi.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<BMI>> getBMIList() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(_tblName);

    return List.generate(maps.length, (index) {
      return BMI(
        maps[index][_colUsername],
        maps[index][_colHeight],
        maps[index][_colWeight],
        maps[index][_colGender],
        maps[index][_colStatus],
      );
    });
  }
}

class BMI {
  final String fullname;
  final String height;
  final String weight;
  final String gender;
  final String bmiStatus;

  BMI(this.fullname, this.height, this.weight, this.gender, this.bmiStatus);

  Map<String, dynamic> toMap() {
    return {
      BMIDatabase._colUsername: fullname,
      BMIDatabase._colHeight: height,
      BMIDatabase._colWeight: weight,
      BMIDatabase._colGender: gender,
      BMIDatabase._colStatus: bmiStatus,
    };
  }
}