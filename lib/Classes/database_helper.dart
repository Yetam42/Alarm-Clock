import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wecker/Classes/wecker.dart';

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
      await db.execute(
          "CREATE TABLE wecker("
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

  insertAlarm(Wecker wecker) async {
    final db = await database;
    var res = await db.insert(Wecker.TABLENAME, wecker.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Wecker>> retrieveAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Wecker.TABLENAME);

    return List.generate(maps.length, (i) {
      return Wecker(
        id: maps[i]['id'],
        name: maps[i]['name'],
        time: maps[i]['time'],
      );
    });
  }

  updateWecker(Wecker wecker) async {
    final db = await database;

    await db.update(Wecker.TABLENAME, wecker.toMap(),
        where: 'id = ?',
        whereArgs: [wecker.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteWecker(int id) async {
    var db = await database;
    db.delete(Wecker.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}

