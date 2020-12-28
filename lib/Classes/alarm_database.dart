import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:developer' as dev;

import 'package:wecker/Classes/alarm_clock.dart';

class AlarmDatabase {
  // The name of the database
  String _name;

  // The name of the table
  final String _tableName = "AlarmClocks";

  //static const databaseName = 'alarm_database.db';
  //static final DatabaseHelper instance = DatabaseHelper();
  // the instance of
  Database database;

  // It can be used to mark that the database can be used
  bool _isLoaded;

  /* ----------------
   * Constructor
   * ---------------- */
  AlarmDatabase(String databaseName) {
    // Set the needed values for the database
    this._name = databaseName;
    this.database = null;
    this._isLoaded = false;

    dev.log("DatabaseName: ${this._name}", name: "Database Initialisation");
  }

  /*
     This function loads the database from its path. If it doesn't exist
     than it creates a new database.
   */
  Future<void> loadDatabase() async {
    // Get the path of the database and the database itself from the path
    String _databasePath = join(await getDatabasesPath(), this._name) + '.db';

    dev.log("Database path: $_databasePath", name: "Loading database");

    // To get the values of the logging levels:
    // https://pub.dev/documentation/logging/latest/logging/Level-class.html
    this.database = await openDatabase(_databasePath, version: 1);

    // Test, if the table exists
    if (await this.tableNotExist()) {
      this._createTable();
    }

    this._isLoaded = true;

    dev.log("Finished loading the database", name: "Loading database");
  }

  // This function creates the default table in the database if it didn't exist
  void _createTable() async {
    await this.database.execute("""CREATE TABLE ${this._tableName} (
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
          sun INT2);""");

    dev.log("Created table ${this._tableName}", name: "Creating table");
  }

  Future<bool> tableNotExist() async {
    try {
      await this.database.rawQuery("""
            SELECT * FROM ${this._tableName};""");

      dev.log("Table ${this._tableName} does exist!",
          name: "Test if table exist");
      return false;
    } catch (error) {
      dev.log("Table ${this._tableName} doesn't exist!",
          name: "Test if table exist");
      return true;
    }
  }

  /*
    This function adds an alarm clock into the database.
   */
  void addAlarm(AlarmClock alarmClock) async {
    // This holds the output of the database queries
    List<Map> retValue;

    int _nextID;

    // Look first what the last clock was
    retValue = await this.database.rawQuery("""
                SELECT id FROM ${this._tableName} ORDER BY id DESC;
                """);

    // Be sure that it isn't the first entry
    if (retValue.isNotEmpty)
      _nextID = retValue[0]["id"] + 1;
    else
      _nextID = 1;

    // add the current alarm clock to the database
    this.database.rawQuery("""
        INSERT INTO ${this._tableName} (id, time, name, active, 
                mon, tue, wed, thu, fri, sat, sun)
        VALUES (
                $_nextID, 
                '${alarmClock.time}',
                '${alarmClock.name}',
                ${alarmClock.active},
                ${alarmClock.weekdays[0]},
                ${alarmClock.weekdays[1]},
                ${alarmClock.weekdays[2]},
                ${alarmClock.weekdays[3]},
                ${alarmClock.weekdays[4]},
                ${alarmClock.weekdays[5]},
                ${alarmClock.weekdays[6]}
            );""");
  }

  /*
   This function removes one clock in the database.
   */
  void removeAlarm(AlarmClock alarmClock) async {
    this.database.rawQuery("""
        DELETE FROM ${this._tableName} WHERE id=${alarmClock.id}
        ;""");
  }

  /*
    This function updates the values from a clock in the database.
   */
  void updateAlarm(AlarmClock alarmClock) async {
    this.database.rawQuery("""
            UPDATE ${this._tableName} SET
                time='${alarmClock.time}',
                name='${alarmClock.name}',
                active=${alarmClock.active},
                mon=${alarmClock.weekdays[0]},
                tue=${alarmClock.weekdays[1]},
                wed=${alarmClock.weekdays[2]},
                thu=${alarmClock.weekdays[3]},
                fri=${alarmClock.weekdays[4]},
                sat=${alarmClock.weekdays[5]},
                sun=${alarmClock.weekdays[6]}
            WHERE id=${alarmClock.id};
            """);
  }

  /*
    This function returns all alarm clocks which are saved inside of the
    database ordered by their ID.
   */
  Future<List<AlarmClock>> getAlarmClocks() async {
    // Due to a bug: https://github.com/flutter/flutter/issues/62019
    // We need to load (in case if it hasn't been loaded yet) the content
    // of the database first
    if (!this._isLoaded) {
      this.loadDatabase();
    }

    List<Map<String, dynamic>> queryRet;
    AlarmClock tmp;

    queryRet = await this.database.query(this._tableName);

    dev.log("All alarm clocks:", name: "Getting alarm clocks");

    /*queryRet = this.database.rawQuery("""
            SELECT * FROM ${this._tableName} ORDER BY id;
            """);*/

    return List.generate(queryRet.length, (alarmClockIndex) {
      // Create a temporary alarm clock which is added into the list
      // but we need to save the values of this alarm clock first
      tmp = AlarmClock();
      tmp.id = queryRet[alarmClockIndex]["id"];
      tmp.time = queryRet[alarmClockIndex]["time"];
      tmp.name = queryRet[alarmClockIndex]["name"];
      tmp.active = queryRet[alarmClockIndex]["active"];

      tmp.weekdays[0] = queryRet[alarmClockIndex]["mon"];
      tmp.weekdays[1] = queryRet[alarmClockIndex]["tue"];
      tmp.weekdays[2] = queryRet[alarmClockIndex]["wed"];
      tmp.weekdays[3] = queryRet[alarmClockIndex]["thu"];
      tmp.weekdays[4] = queryRet[alarmClockIndex]["fri"];
      tmp.weekdays[5] = queryRet[alarmClockIndex]["sat"];
      tmp.weekdays[6] = queryRet[alarmClockIndex]["sun"];

      return tmp;
    });
  }
}
