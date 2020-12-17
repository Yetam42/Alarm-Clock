import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wecker/weckerClass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<Database> database =
      openDatabase(join(await getDatabasesPath(), 'wecker_database.db'),
          onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE wecker(id INTEGER PRIMARY KEY, time TEXT, name TEXT, an BOOLEAN)",
    );
  }, version: 1);
}
/*Future<void> insertWecker(Wecker wecker) async {
    final Database db = await database;

    await db.insert(
      'wecker',
      wecker.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Wecker>> wecker() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('wecker');

    return List.generate(maps.length, (i) {
      return Wecker(
          id: maps[i]['id'],
          time: maps[i]['time'],
          name: maps[i]['name'],
          an: maps[i]['an']);
    });
  }

  Future<void> updateWecker(Wecker wecker) async {
    final db = await database;

    await db.update(
      'wecker',
      wecker.toMap(),
      where: "id = ?",
      whereArgs: [wecker.id],
    );
  }

  print(await wecker());
}*/

class WeckerErstellen extends StatelessWidget {
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
                  Wecker(id: 1, time: time, name: name);
                },
              )
            ],
          ),
        ));
  }
}
