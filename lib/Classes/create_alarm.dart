import 'package:flutter/material.dart';
import 'package:wecker/Classes/alarm.dart';
import 'alarm_database.dart';

class CreateAlarm extends StatefulWidget {
  final Alarm alarm;

  const CreateAlarm({Key key, this.alarm}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateAlarmState(alarm);
}

class _CreateAlarmState extends State<CreateAlarm> {

  AlarmDatabase alarmDatabase;

  _CreateAlarmState() {
    // Load the database
    this.alarmDatabase = AlarmDatabase('alarm_db');
    this.alarmDatabase.loadDatabase();
  }

  // Mit den TextEditingController kann man die Eingaben des Nutzers weiter verwenden
  final timeTextController = TextEditingController();
  final nameTextController = TextEditingController();
  bool day;
  bool mon = false;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  bool sun = false;

  bool _boolStatus(int day) {
    if (day == 0) {
      return false;
    }
    return true;
  }

  //https://flutter.dev/docs/development/ui/interactive
  void _toggleState() async {
    //print('in toggle State $day, $alarmDay');
    setState(() {
      if (day) {
        day = false;
      } else {
        day = true;
      }
    });

    //print('nach togleState $day, $alarmDay');
  }

  Alarm alarm;
  _CreateAlarmState(this.alarm);

  @override
  void initState() {
    super.initState();
    if (alarm != null) {
      timeTextController.text = alarm.time;
      nameTextController.text = alarm.name;
      mon = _boolStatus(alarm.mon);
      tue = _boolStatus(alarm.tue);
      wed = _boolStatus(alarm.wed);
      thu = _boolStatus(alarm.thu);
      fri = _boolStatus(alarm.fri);
      sat = _boolStatus(alarm.sat);
      sun = _boolStatus(alarm.sun);
    }
  }

  @override
  void dispose() {
    timeTextController.dispose();
    nameTextController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //mon = _toggleDayState(alarm.mon, mon);
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Monday
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
                      mon ? alarm.mon = 1 : alarm.mon = 0;
                      //print('Fuckdkoadjaüok${alarm.mon}');
                    },
                    color: Colors.red[400],
                  ),
                  Text('Mon')
                ],
              ),

              // Tuesday
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
                      tue ? alarm.tue = 1 : alarm.tue = 0;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Tue')
                ],
              ),
              // Wednesday
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (wed
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = wed;
                      _toggleState();
                      wed = day;
                      wed ? alarm.wed = 1 : alarm.wed = 0;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Wed')
                ],
              ),
              // Thursday
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (thu
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = thu;
                      _toggleState();
                      thu = day;
                      thu ? alarm.thu = 1 : alarm.thu = 0;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Thu')
                ],
              ),
              // Friday
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (fri
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = fri;
                      _toggleState();
                      fri = day;
                      fri ? alarm.fri = 1 : alarm.fri = 0;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Fri')
                ],
              ),
              // Saturday
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (sat
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = sat;
                      _toggleState();
                      sat = day;
                      sat ? alarm.sat = 1 : alarm.sat = 0;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Sat')
                ],
              ),
              // Sunnday
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (sun
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                      day = sun;
                      _toggleState();
                      sun = day;
                      sun ? alarm.sun = 1 : alarm.sun = 0;
                    },
                    color: Colors.red[400],
                  ),
                  Text('Sun')
                ],
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            _saveAlarm(
                nameTextController.text,
                timeTextController.text
            );
            Navigator.pop(context, "Gespeichert");
            setState(() {});
          }),
    );
  }

//alarm is only saved if there is a time input from the user
  _saveAlarm(String name, String time) async {
    if (alarm == null && time != "") {
      DatabaseHelper.instance.insertAlarm(Alarm(
          name: nameTextController.text,
          time: timeTextController.text,
          active: 0,
          mon: _intStatus(mon),
          tue: _intStatus(tue),
          wed: _intStatus(wed),
          thu: _intStatus(thu),
          fri: _intStatus(fri),
          sat: _intStatus(sat),
          sun: _intStatus(sun)));
    } else {
      await DatabaseHelper.instance.updateAlarm(Alarm(
          id: alarm.id,
          name: name,
          time: time,
          active: alarm.active,
          mon: alarm.mon,
          tue: alarm.tue,
          wed: alarm.wed,
          thu: alarm.thu,
          fri: alarm.fri,
          sat: alarm.sat,
          sun: alarm.sun));
      print('Bei update $mon');
    }
  }
}

//'converts' the int value of the day to a boolean
int _intStatus(bool day) {
  if (day) {
    return 1;
  }
  return 0;
}

//'converts' the boolean value of the day to an int
bool _boolStatus(int day) {
  print('Wert vom Tag: ${day}');
  if (day == 0) {
    return false;
  } else if (day == null) {
    day = 0;
    return false;
  }
  return true;
}
