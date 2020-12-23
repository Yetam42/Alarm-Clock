import 'package:flutter/material.dart';
import '../Classes/alarm_database.dart';
import '../Classes/alarm_clock.dart';
import 'Classes/weekday_button.dart';

class CreateAlarm extends StatefulWidget {
  //final Alarm alarm;

  //const CreateAlarm({Key key, this.alarm}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {

  AlarmDatabase alarmDatabase;
  
  // All values of the alarmclock are gonna saved here
  AlarmClock alarmClock;

  // The input boxes for the user
  TextEditingController timeTextController;
  TextEditingController nameTextController;

  /* ---------------
   * Conctructor 
   * --------------- */
  _CreateAlarmState() {
    // Load the database
    this.alarmDatabase = AlarmDatabase('alarm_db');
    this.alarmDatabase.loadDatabase();

    // Prepare the variables
    this.alarmClock = AlarmClock();
    timeTextController = TextEditingController();
    nameTextController = TextEditingController();
  }

  //bool _boolStatus(int day) {
  //  if (day == 0) {
  //    return false;
  //  }
  //  return true;
  //}

  //https://flutter.dev/docs/development/ui/interactive
  //void _toggleState() async {
  //  //print('in toggle State $day, $alarmDay');
  //  setState(() {
  //    if (day) {
  //      day = false;
  //    } else {
  //      day = true;
  //    }
  //  });

  //  //print('nach togleState $day, $alarmDay');
  //}

  //Alarm alarm;
  //_CreateAlarmState(this.alarm);

  //@override
  //void initState() {
  //  super.initState();
  //  if (alarm != null) {
  //    timeTextController.text = alarm.time;
  //    nameTextController.text = alarm.name;
  //    mon = _boolStatus(alarm.mon);
  //    tue = _boolStatus(alarm.tue);
  //    wed = _boolStatus(alarm.wed);
  //    thu = _boolStatus(alarm.thu);
  //    fri = _boolStatus(alarm.fri);
  //    sat = _boolStatus(alarm.sat);
  //    sun = _boolStatus(alarm.sun);
  //  }
  //}

  @override
  void dispose() {
    timeTextController.dispose();
    nameTextController.dispose();
    super.dispose();
  }

  /* -----------------
   * Widget Build 
   * ----------------- */
  Widget build(BuildContext context) {

    //mon = _toggleDayState(alarm.mon, mon);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new Alarm Clock'),
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
            decoration: InputDecoration(hintText: 'Select time'),
            onTap: () async {
              var time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              timeTextController.text = time.format(context);
            },
          ),

          /* --------------------------
           * The weekdays listed in a row 
           * -------------------------- */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Monday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (alarmClock.weekdays[0]
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = mon;
                  //    _toggleState();
                  //    mon = day;
                  //    mon ? alarm.mon = 1 : alarm.mon = 0;
                  //    //print('Fuckdkoadjaüok${alarm.mon}');
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock : this.alarmClock,
                      weekDay : 0
                      ),
                  Text('Mon')
                ],
              ),

              // Tuesday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (tue
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = tue;
                  //    _toggleState();
                  //    tue = day;
                  //    tue ? alarm.tue = 1 : alarm.tue = 0;
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock: this.alarmClock,
                      weekDay: 1
                      ),
                  Text('Tue')
                ],
              ),
              // Wednesday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (wed
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = wed;
                  //    _toggleState();
                  //    wed = day;
                  //    wed ? alarm.wed = 1 : alarm.wed = 0;
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock: this.alarmClock,
                      weekDay: 2
                      ),
                  Text('Wed')
                ],
              ),
              // Thursday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (thu
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = thu;
                  //    _toggleState();
                  //    thu = day;
                  //    thu ? alarm.thu = 1 : alarm.thu = 0;
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock: this.alarmClock,
                      weekDay: 3
                      ),
                  Text('Thu')
                ],
              ),
              // Friday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (fri
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = fri;
                  //    _toggleState();
                  //    fri = day;
                  //    fri ? alarm.fri = 1 : alarm.fri = 0;
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock: this.alarmClock,
                      weekDay: 4
                      ),
                  Text('Fri')
                ],
              ),
              // Saturday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (sat
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = sat;
                  //    _toggleState();
                  //    sat = day;
                  //    sat ? alarm.sat = 1 : alarm.sat = 0;
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock: this.alarmClock,
                      weekDay: 5
                      ),
                  Text('Sat')
                ],
              ),
              // Sunnday
              Column(
                children: <Widget>[
                  //IconButton(
                  //  icon: (sun
                  //      ? Icon(Icons.check_circle)
                  //      : Icon(Icons.check_circle_outline)),
                  //  onPressed: () {
                  //    day = sun;
                  //    _toggleState();
                  //    sun = day;
                  //    sun ? alarm.sun = 1 : alarm.sun = 0;
                  //  },
                  //  color: Colors.red[400],
                  //),
                  WeekDayButton(
                      alarmClock: this.alarmClock,
                      weekDay: 6
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
            //_saveAlarm(
            //    nameTextController.text,
            //    timeTextController.text
            //);
            this.alarmDatabase.addAlarm(this.alarmClock);
            Navigator.pop(context, "Gespeichert");
            setState(() {});
          }),
    );
  }



//alarm is only saved if there is a time input from the user
//  _saveAlarm(String name, String time) async {
//    if (alarm == null && time != "") {
//      DatabaseHelper.instance.insertAlarm(Alarm(
//          name: nameTextController.text,
//          time: timeTextController.text,
//          active: 0,
//          mon: _intStatus(mon),
//          tue: _intStatus(tue),
//          wed: _intStatus(wed),
//          thu: _intStatus(thu),
//          fri: _intStatus(fri),
//          sat: _intStatus(sat),
//          sun: _intStatus(sun)));
//    } else {
//      await DatabaseHelper.instance.updateAlarm(Alarm(
//          id: alarm.id,
//          name: name,
//          time: time,
//          active: alarm.active,
//          mon: alarm.mon,
//          tue: alarm.tue,
//          wed: alarm.wed,
//          thu: alarm.thu,
//          fri: alarm.fri,
//          sat: alarm.sat,
//          sun: alarm.sun));
//      print('Bei update $mon');
//    }
//  }
//}

//'converts' the int value of the day to a boolean
//int _intStatus(bool day) {
//  if (day) {
//    return 1;
//  }
//  return 0;
//}

//'converts' the boolean value of the day to an int
//bool _boolStatus(int day) {
//  print('Wert vom Tag: ${day}');
//  if (day == 0) {
//    return false;
//  } else if (day == null) {
//    day = 0;
//    return false;
//  }
//  return true;
//}
