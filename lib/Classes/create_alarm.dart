import 'package:flutter/material.dart';
import 'package:wecker/Classes/database_helper.dart';
import 'package:wecker/Classes/wecker.dart';

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
