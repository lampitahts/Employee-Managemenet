import 'dart:io';
import 'package:employee_management/models/attendance_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; 


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'attendance.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY,
        name TEXT,
        position TEXT,
        attendanceStatus TEXT,
        date TEXT
      )
    ''');
  }

  Future<void> insertAttendance(AttendanceRecord record) async {
    final db = await database;
    await db.insert('attendance', record.toMap());
  }

  Future<List<AttendanceRecord>> getAttendanceRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('attendance');

    return List.generate(maps.length, (i) {
      return AttendanceRecord(
        name: maps[i]['name'],
        position: maps[i]['position'],
        attendanceStatus: maps[i]['attendanceStatus'].split(','),
        date: maps[i]['date'],
      );
    });
  }

  Future<void> clearAttendanceRecords() async {
    final db = await database;
    await db.delete('attendance');
  }

  Future<bool> isNewMonth() async {
    final db = await database;
    final List<Map<String, dynamic>> records = await db.query('attendance');

    if (records.isNotEmpty) {
      String lastDate = records.last['date']; // Ambil tanggal terakhir
      String lastMonthYear = DateFormat('MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(lastDate));
      String currentMonthYear = DateFormat('MM-yyyy').format(DateTime.now());
      return lastMonthYear != currentMonthYear; // Bandingkan bulan
    }
    return true;
  }
}
