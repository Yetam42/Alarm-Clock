import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Classes/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<Database> database =
      openDatabase(join(await getDatabasesPath(), 'alarm_database.db'),
          onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE alarm(id INTEGER PRIMARY KEY, time TEXT, name TEXT, an BOOLEAN)",
    );
  }, version: 1);

  Future<void> insertAlarm(Alarm alarm) async {
    final Database db = await database;
    await db.insert(
      'alarm',
      alarm.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Alarm>> alarm() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('alarm');

    return List.generate(maps.length, (i) {
      return Alarm(
          id: maps[i]['id'], time: maps[i]['time'], name: maps[i]['name']);
      //an: maps[i]['an']);
    });
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final db = await database;

    await db.update(
      'alarm',
      alarm.toMap(),
      where: "id = ?",
      whereArgs: [alarm.id],
    );
  }

  print(await alarm());
}

class CreateNewAlarm extends StatelessWidget {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String name = '';
    String time = '';

    return Scaffold(
        appBar: AppBar(
          title: Text("Neuer Wecker"),
          backgroundColor: Colors.green,
        ),
        body: Container(
          child: Column(
            children: [
              RaisedButton(
                  child: Text('Zurück zum Hauptscreen'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Name des Weckers',
                ),
              ),
              FloatingActionButton(onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(myController.text),
                      );
                    });
              }),
              RaisedButton(
                child: Text('Speichern'),
                onPressed: () {
                  Alarm(id: 1, time: time, name: name);
                },
              )
            ],
          ),
        ));
  }
}
