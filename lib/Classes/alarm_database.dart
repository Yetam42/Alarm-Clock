import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:developer' as dev;

import 'package:wecker/Classes/alarm_clock.dart';

//https://www.codingpizza.com/en/storing-in-database-with-flutter/
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
  bool isLoaded;

  /* ----------------
   * Constructor
   * ---------------- */
  AlarmDatabase(String databaseName) {
    // Set the needed values for the database
    this._name = databaseName;
    this.database = null;

    dev.log("DatabaseName: ${this._name}", name: "Database Initialisation");
  }

  /*
     This function loads the database from its path. If it doesn't exist
     than it creates a new database.
   */
  void loadDatabase() async {

    // Get the path of the database and the database itself from the path
    String _databasePath = join(await getDatabasesPath(), this._name) + '.db';

    dev.log("Database path: $_databasePath", name: "Loading database");

    // To get the values of the logging levels:
    // https://pub.dev/documentation/logging/latest/logging/Level-class.html
    this.database = await openDatabase(_databasePath, version: 1);

    // Test, if the table exists
    if (await this.tableNotExist())
        this._createTable();

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
          sun INT2)""");
  }

  Future<bool> tableNotExist() async {

    try {
      await this.database.rawQuery("""
            SELECT * FROM ${this._tableName};"""
      );

      dev.log("Table ${this._tableName} does exist!",
          name: "Test if table exist");
      return true;
    } catch (error) {
      dev.log("Table ${this._tableName} doesn't exist!",
          name: "Test if table exist");
      return false;
    }
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
            );"""
        );
  }

  /*
   This function removes one clock in the database.
   */
  void removeAlarm(Map<String, dynamic> alarmClock) async {
    this.database.rawQuery("""
        DELETE FROM ${this._tableName} WHERE id=${alarmClock['id']}
        );""");
  }

  /*
    This function updates the values from a clock in the database.
   */
  void updateAlarm(Map<String, dynamic> alarmClock) async {
    this.database.rawQuery("""
        UPDATE ${this._tableName} SET
            time=${alarmClock['time']},
            name=${alarmClock['name']},
            active=${alarmClock['active']},
            mon=${alarmClock['weekdays'][0]},
            tue=${alarmClock['weekdays'][1]},
            wed=${alarmClock['weekdays'][2]},
            thu=${alarmClock['weekdays'][3]},
            fri=${alarmClock['weekdays'][4]},
            sat=${alarmClock['weekdays'][5]},
            sun=${alarmClock['weekdays'][6]}
        WHERE id=${alarmClock['id']};
            """);
  }

  /*
    This function returns all alarm clocks which are saved inside of the
    database ordered by their ID.
   */
  Future<List<Map<String, dynamic>>> getAlarmClocks() async {
    
    Future<List<Map<String, dynamic>>> queryRet;

    queryRet = this.database.rawQuery("""
            SELECT * FROM ${this._tableName} ORDER BY id;
            """);

    //print("${queryRet[0]}");
    dev.log("All alarm clocks:", name: "Getting alarm clocks");
    //for (int index=0; index<queryRet.length; index++) {
    //  dev.log("${queryRet[index]}", name: "Getting alarm clocks");
    //}

    return queryRet;
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
