import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wecker/Classes/alarm.dart';

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

//https://www.codingpizza.com/en/storing-in-database-with-flutter/
class AlarmDatabase {
  // The name of the database
  String _name;

  //static const databaseName = 'alarm_database.db';
  //static final DatabaseHelper instance = DatabaseHelper();
  // the instance of
  Database database;

  // It can be used to mark that the database can be used
  bool isLoaded;

  /* ----------------
   * Constructor
   * ---------------- */
  AlarmDatabase(String databaseName) {
    // Set the needed values for the database
    this._name = databaseName;
    this.database = null;
    /* ------------
     * Logging 
     * ------------ */
    dev.log("DatabaseName: ${this._name}", name: "Database Initialisation");
  }

  /*
     This function loads the database from its path. If it doesn't exist
     than it creates a new database.
   */
  void loadDatabase() async {
    // Get the path of the database and the database itself from the path
    String databasePath = join(await getDatabasesPath(), this._name);

    // Used to look up, if the loading failed
    bool loadingFailed = false;

    // To get the values of the logging levels:
    // https://pub.dev/documentation/logging/latest/logging/Level-class.html
    // This part makes sure that the database exist!
    try {
      await Directory(databasePath).create(recursive: true);
    } catch (error) {
      dev.log("Couldn't create or read the database!",
          name: "Loading Database", level: 1200);

      loadingFailed = true;
    }

    /* ---------------------------
     * Test if loading failed 
     * --------------------------- */
    if (loadingFailed) {
      // It ends the program for the time beeing. An implementation of an error
      // message might come up in the future.
      // TODO: Add Error popup for user

    }

    else {
      this.database = await openDatabase(databasePath, onCreate: _onCreate);
    }
  }

  /*
     This function is invoked if the database is initialised for the first time. 
     It creates the default table for the alarm clocks.
   */
  void _onCreate(Database db, int version) async {
    await db.execute(
        """CREATE TABLE AlarmClocks (
          id INTEGER PRIMARY KEY NOT NULL,
          time TEXT,
          name TEXT,
          active INT2,
          mon INT2,
          tue INT2,
          wed INT2,
          thu INT2,
          fri INT2,
          sat INT2,
          sun INT2
        )"""
      );
  }

  insertAlarm(Alarm alarm) async {
    var res = await this.database.insert(Alarm.TABLENAME, alarm.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Alarm>> retrieveAlarms() async {
    final List<Map<String, dynamic>> maps = await this.database.query(Alarm.TABLENAME);

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
    await this.database.update(Alarm.TABLENAME, alarm.toMap(),
        where: 'id = ?',
        whereArgs: [alarm.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteAlarm(int id) async {
    this.database.delete(Alarm.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}
