import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:wecker/weckerClass.dart';

//https://www.codingpizza.com/en/storing-in-database-with-flutter/
class DatabaseHelper {
  //erstellt einen prviaten Constructor
  DatabaseHelper._();

  static const databaseName = 'alarm_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;


  Future<Database> get database async {
    if (_database == null) {
      return await initDatabase();
    }
    return _database;
  }

  //Erstellung der Datenbank
  initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE wecker(id INTEGER PRIMARY KEY, time TEXT, name TEXT, active INTEGER, mon INTEGER, tue INTEGER, wed INTEGER, thu INTEGER, fri INTEGER, sat INTEGER, sun INTEGER)");
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

class CreateAlarm extends StatefulWidget {
  final Wecker wecker;

  const CreateAlarm({Key key, this.wecker}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateAlarmState(wecker);
}

class _CreateAlarmState extends State<CreateAlarm> {
  //Mit den TextEditingController kann man die Eingaben des Nutzers weiter verwenden
  //
  final timeTextController = TextEditingController();
  final nameTextController = TextEditingController();
  bool day;
  bool mon = false;
  bool tue = false;

  //https://flutter.dev/docs/development/ui/interactive
  void _toggleState() async {
    setState(() {
      if (day) {
        day = false;
      } else {
        day = true;
      }
    });
  }

  Wecker wecker;
  _CreateAlarmState(this.wecker);

  @override
  void initState() {
    super.initState();
    if (wecker != null) {
      timeTextController.text = wecker.time;
      nameTextController.text = wecker.name;
      //mon = wecker.mon;
      //tue = wecker.tue;
    }
  }

  @override
  void dispose() {
    timeTextController.dispose();
    nameTextController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wecker erstellen'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Alarmbezeichnung"),
              maxLines: 1,
              controller: nameTextController,
            ),
          ),
          TextField(
            textAlign: TextAlign.center,
            readOnly: true,
            controller: timeTextController,
            decoration: InputDecoration(hintText: 'Zeit auswählen'),
            onTap: () async {
              var time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              timeTextController.text = time.format(context);
            },
          ),
          Row(
            children: <Widget>[
              //Montag
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (mon
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = mon;
                      _toggleState();
                      mon = day;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Mon')
                ],
              ),

              //Dienstag
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (tue
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = tue;
                      _toggleState();
                      tue = day;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Die')
                ],
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            _saveAlarm(nameTextController.text, timeTextController.text);
            Navigator.pop(context, "Gespeichert");
            setState(() {});
          }),
    );
  }

  _saveAlarm(String name, String time) async {
    if (wecker == null) {
      DatabaseHelper.instance.insertAlarm(Wecker(
        name: nameTextController.text,
        time: timeTextController.text,
      ));
    } else {
      await DatabaseHelper.instance
          .updateWecker(Wecker(id: wecker.id, name: name, time: time));
    }
  }
}
