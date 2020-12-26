import 'package:flutter/material.dart';

import 'Classes/alarm_clock.dart';
import 'Classes/alarm_database.dart';

import 'dart:developer' as dev;

/*

 */
class AlarmClockHandlerArgs {
  /*
     True => This widget is called in order to *add* an alarm clock.
     False => This widget is called in order to *update* an alarm clock.
     */
  final bool modeConfigure;
  final AlarmClock alarmClock;

  AlarmClockHandlerArgs(this.modeConfigure, this.alarmClock);
}


class AlarmClockHandler extends StatefulWidget {
  /*
     True => This widget is called in order to *add* an alarm clock.
     False => This widget is called in order to *update* an alarm clock.
     */
  final bool adding;

  AlarmClockHandler({
    this.adding,
  });

  @override
  _HandleAlarmClock createState() => _HandleAlarmClock();
}

class _HandleAlarmClock extends State<AlarmClockHandler> {

  /* ===============
   * Attributes 
   * =============== */
  AlarmDatabase _alarmDatabase;

  // All values of the alarmclock are gonna saved here
  AlarmClock _alarmClock;

  // The input boxes for the user
  TextEditingController _timeTextController;
  TextEditingController _nameTextController;

  // Here are all arguments which are provided
  AlarmClockHandlerArgs _args;

  /* ==============
   * Functions 
   * ============== */
  // This saves the alarm clock into the database
  void _saveAlarmClock() {
    this._alarmClock.name = this._nameTextController.text.toString();
    this._alarmClock.time = this._timeTextController.text.toString();
    this._alarmClock.active = 1;

    this._alarmDatabase.addAlarm(this._alarmClock);
    dev.log("Saved the current configured alarm clock.",
        name: "Create Alarm Clock");
  }

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
    this._timeTextController.dispose();
    this._nameTextController.dispose();
    super.dispose();
  }

  /* ==================
   * Actual widget 
   * ================== */
  @override
  Widget build(BuildContext context) {
    /* -----------------
     * Preparations 
     * ----------------- */
    // Load the database
    this._alarmDatabase = AlarmDatabase('alarm_db');
    this._alarmDatabase.loadDatabase();

    // Get to know what to do with the clock:
    // Creating a new one or configuring an existing one?
    this._args = ModalRoute.of(context).settings.arguments;

    // Prepare the variables
    this._alarmClock = AlarmClock();
    this._timeTextController = TextEditingController();
    this._nameTextController = TextEditingController();

    // The user just wants to config a current alarm clock
    if (this._args.modeConfigure) {
      // Use the provided alarm clock and set the values
      this._timeTextController.text = this._args.alarmClock.time;
      this._nameTextController.text = this._args.alarmClock.name;

      // Set the values to the alarmClock alias
      this._alarmClock.name = this._args.alarmClock.name;
      this._alarmClock.time = this._args.alarmClock.time;
      this._alarmClock.weekdays = this._args.alarmClock.weekdays;

      dev.log(
          "Loaded variables for configuring mode.",
          name: "Alarm Handler"
      );
    }

    dev.log(
        "Initialised the default variables",
        name: "Alarm Handler"
    );

    /* ----------------------
     * The actual widget 
     * ---------------------- */
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new Alarm Clock'),
        centerTitle: true,
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
            // Check first, if the user provided enough information
            if (this._nameTextController.text.isEmpty) {
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //       return AlertDialog(
              //           title: Text("Please enter a Name!"),
              //           titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              //           content:
              //           Text("Please enter a name of your alarm clock!"),
              //           actions: [
              //               FlatButton(child: Text("Bruh"), onPressed: () {}),
              //           ]
              //       );
              //   }
              //   );
              print("Yes");
            }
            this._saveAlarmClock();
            Navigator.pop(context, "Alarm Clock saved");

            setState(() {});
            dev.log("Pressed the save button.", name: "Create Alarm Clock");
          }),
    );
  }
}
