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

    dev.log("Initialised the default variables",
        name: "Create Alarm Constructor");

    super.initState();
  }

  // This saves the alarm clock into the database
  void _saveAlarmClock() {
    this._alarmClock.name = this._nameTextController.text.toString();
    this._alarmClock.time = this._timeTextController.text.toString();
    this._alarmClock.active = 1;

    this._alarmDatabase.addAlarm(this._alarmClock);
    dev.log("Saved the current configured alarm clock.",
        name: "Create Alarm Clock");
  }

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

    dev.log("Toggling from $index to: ${this._alarmClock.getWeekday(index)}.",
            name: "Create Alarm Clock");
  }

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
                  border: OutlineInputBorder(),
                  labelText: "Name of Alarm Clock"),
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
            this._saveAlarmClock();
            Navigator.pop(context, "Alarm Clock saved");
            setState(() {});

            dev.log("Pressed the save button.", name: "Create Alarm Clock");
          }),
    );
  }
}
