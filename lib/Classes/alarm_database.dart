import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:developer' as dev;
import 'dart:io';

import 'package:wecker/Classes/alarm_clock.dart';

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

    } else {
      this.database = await openDatabase(databasePath, onCreate: _onCreate);
    }
  }

  /*
     This function is invoked if the database is initialised for the first time. 
     It creates the default table for the alarm clocks.
   */
  void _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE AlarmClocks (
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
        )""");
  }

  //insertAlarm(AlarmClock alarm) async {
  //  var res = await this.database.insert(Alarm.TABLENAME, alarm.toMap(),
  //      conflictAlgorithm: ConflictAlgorithm.replace);
  //  return res;
  //}
  /*
    This function adds an alarm clock into the database.
   */
  void addAlarm(AlarmClock alarmClock) async {
    // This holds the output of the database queries
    List<Map> retValue;

    int nextID;

    // Look first what the last clock was
    retValue = await this.database.rawQuery("""
                SELECT id FROM alert_db ORDER BY id DESC;
                """);

    nextID = retValue[0]["id"] + 1;

    // add the current alarm clock to the database
    this.database.rawQuery("""
        INSERT INTO alert_db(id, name, time, name, active, 
                mon, tue, wed, thu, fri, sat, sun)
        VALUES (
                $nextID, 
                ${alarmClock.name},
                ${alarmClock.active},
                ${alarmClock.weekdays[0]},
                ${alarmClock.weekdays[1]},
                ${alarmClock.weekdays[2]},
                ${alarmClock.weekdays[3]},
                ${alarmClock.weekdays[4]},
                ${alarmClock.weekdays[5]},
                ${alarmClock.weekdays[6]}
            )""");
  }

  /*
   This function removes one clock in the database.
   */
  void removeAlarm(AlarmClock alarmClock) async {

  }

  /*
    This function updates the values from a clock in the database.
   */
  void updateAlarm(AlarmClock alarmClock) async {

  }

  //Future<List<AlarmClock>> retrieveAlarms() async {
  //  final List<Map<String, dynamic>> maps =
  //      await this.database.query(Alarm.TABLENAME);

  //  return List.generate(maps.length, (i) {
  //    return AlarmClock(
  //        id: maps[i]['id'],
  //        name: maps[i]['name'],
  //        time: maps[i]['time'],
  //        active: maps[i]['active'],
  //        mon: maps[i]['mon'],
  //        tue: maps[i]['tue'],
  //        wed: maps[i]['wed'],
  //        thu: maps[i]['thu'],
  //        fri: maps[i]['fri'],
  //        sat: maps[i]['sat'],
  //        sun: maps[i]['sat']);
  //  });
  //}

  //updateAlarm(Alarm alarm) async {
  //  await this.database.update(Alarm.TABLENAME, alarm.toMap(),
  //      where: 'id = ?',
  //      whereArgs: [alarm.id],
  //      conflictAlgorithm: ConflictAlgorithm.replace);
  //}

  //deleteAlarm(int id) async {
  //  this.database.delete(Alarm.TABLENAME, where: 'id = ?', whereArgs: [id]);
  //}
}
