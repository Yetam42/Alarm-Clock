import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wecker/Classes/alarm.dart';

import 'dart:async';

//https://www.codingpizza.com/en/storing-in-database-with-flutter/
class DatabaseHelper {
  static const databaseName = 'alarm_database.db';
  static final DatabaseHelper instance = DatabaseHelper();
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initDatabase();
    }
    return _database;
  }

  // Erstellung der Datenbank
  initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (db, version) async {
      await db.execute("CREATE TABLE alarm("
          "id INTEGER PRIMARY KEY,"
          "time TEXT,"
          "name TEXT,"
          "active INTEGER,"
          " mon INTEGER,"
          " tue INTEGER,"
          " wed INTEGER,"
          " thu INTEGER,"
          " fri INTEGER,"
          " sat INTEGER,"
          " sun INTEGER)");
    });
  }

  insertAlarm(Alarm alarm) async {
    final db = await database;
    var res = await db.insert(Alarm.TABLENAME, alarm.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Alarm>> retrieveAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Alarm.TABLENAME);

    return List.generate(maps.length, (i) {
      return Alarm(
          id: maps[i]['id'],
          name: maps[i]['name'],
          time: maps[i]['time'],
          active: maps[i]['active'],
          mon: maps[i]['mon'],
          tue: maps[i]['tue'],
          wed: maps[i]['wed'],
          thu: maps[i]['thu'],
          fri: maps[i]['fri'],
          sat: maps[i]['sat'],
          sun: maps[i]['sat']);
    });
  }

  updateAlarm(Alarm alarm) async {
    final db = await database;

    await db.update(Alarm.TABLENAME, alarm.toMap(),
        where: 'id = ?',
        whereArgs: [alarm.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteAlarm(int id) async {
    var db = await database;
    db.delete(Alarm.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}
