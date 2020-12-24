import 'package:flutter/material.dart';
import '../Classes/alarm_database.dart';
import '../Classes/alarm_clock.dart';

import 'dart:developer' as dev;

class CreateAlarm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {

  AlarmDatabase _alarmDatabase;

  // each index represents one of the weekdays
  //List<WeekDayButton> _weekDayButtons;
  
  // All values of the alarmclock are gonna saved here
  AlarmClock _alarmClock;

  // The input boxes for the user
  TextEditingController _timeTextController;
  TextEditingController _nameTextController;

  /* ---------------
   * "Conctructor"
   * --------------- */
  @protected
  @mustCallSuper
  void initState() {

    // Load the database
    this._alarmDatabase = AlarmDatabase('alarm_db');
    this._alarmDatabase.loadDatabase();

    // Prepare the variables
    this._alarmClock = AlarmClock();
    _timeTextController = TextEditingController();
    _nameTextController = TextEditingController();

    // Initialise every button
    //for (int index=0; index<7; index++) {
    //    this._weekDayButtons.add(WeekDayButton());
    //}

    dev.log("Initialised the default variables",
            name: "Create Alarm Constructor",
            level: 1200);

    super.initState();
  }

  // This saves the alarm clock into the database
  void _saveAlarmClock() {
       this._alarmClock.name = this._nameTextController.text.toString();
       this._alarmClock.time = this._timeTextController.text.toString();
       this._alarmClock.active = 1;

       // look which days are active
       //for (int index=0; index<7; index++) {
       //     if (this._weekDayButtons[index].selecter.isSelected()) {
       //         this._alarmClock.setWeekday(index);
       //     }
       // }

       this._alarmDatabase.addAlarm(this._alarmClock);

  }

  //bool _boolStatus(int day) {
  //  if (day == 0) {
  //    return false;
  //  }
  //  return true;
  //}

  //https://flutter.dev/docs/development/ui/interactive
  void _toggleState(int index) async {
    if (this._alarmClock.getWeekday(index)) {
        this._alarmClock.unsetWeekday(index);
    } else {
        this._alarmClock.setWeekday(index);
    }

    // update the selected days
    setState(() {
      this._alarmClock.getWeekday(index);
    });
    print("Toggling from $index, new value: ${this._alarmClock.getWeekday(index)}");
  }

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
    _timeTextController.dispose();
    _nameTextController.dispose();
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
                  border: OutlineInputBorder(), labelText: "Name of Alarm Clock"),
              maxLines: 1,
              controller: _nameTextController,
            ),
          ),
          TextField(
            textAlign: TextAlign.center,
            readOnly: true,
            controller: _timeTextController,
            decoration: InputDecoration(hintText: 'Select time'),
            onTap: () async {
              var time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              _timeTextController.text = time.format(context);
            },
          ),

          /* ==========================
           * The weekdays listed in a row 
           * ========================== */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                /* -----------
                 * Monday 
                 * ----------- */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(0)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(0);
                    },
                    color: Colors.red[400],
                  ),
                  Text('Mon')
                ],
              ),

              /* ------------
               * Tuesday 
               * ------------ */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(1)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(1);
                    },
                    color: Colors.red[400],
                  ),
                  Text('Tue')
                ],
              ),
            /* --------------
             * Wednesday 
             * -------------- */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(2)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(2);
                    },
                    color: Colors.red[400],
                  ),
                  Text('Wed')
                ],
              ),
            /* -------------
             * Thursday 
             * ------------- */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(3)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(3);
                    },
                    color: Colors.red[400],
                  ),
                  Text('Thu')
                ],
              ),
            /* -----------
             * Friday 
             * ----------- */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(4)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(4);
                    },
                    color: Colors.red[400],
                  ),
                  Text('Fri')
                ],
              ),
            /* -------------
             * Saturday 
             * ------------- */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(5)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(5);
                    },
                    color: Colors.red[400],
                  ),
                  Text('Sat')
                ],
              ),
            /* ------------
             * Sunnday 
             * ------------ */
              Column(
                children: <Widget>[
                  IconButton(
                    icon: (this._alarmClock.getWeekday(6)
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.check_circle_outline)),
                    onPressed: () {
                        this._toggleState(6);
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
            //_saveAlarm(
            //    nameTextController.text,
            //    timeTextController.text
            //);
            dev.log("Saving the current alarm clock...",
                    name: "Saving Alarm Clock", level: 1200);
            this._saveAlarmClock();
            Navigator.pop(context, "Gespeichert");
            setState(() {});
          }),
    );
  }
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
