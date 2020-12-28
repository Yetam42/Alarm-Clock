import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Classes/alarm_clock.dart';
import '../Classes/alarm_database.dart';

/*
   This function represents all needed information in order to call the
   "AlarmClockHandler" widget.
 */
class AlarmClockHandlerArgs {

    final bool modeConfigure;
    final AlarmClock alarmClock;

    AlarmClockHandlerArgs(this.modeConfigure, this.alarmClock);
}

class AlarmClockHandler extends StatefulWidget {
  /*
     True => This widget is called in order to *add* an alarm clock.
     False => This widget is called in order to *update* an alarm clock.
     */
  final bool modeConfigure;
  final AlarmClock alarmClock;

  AlarmClockHandler({
    this.modeConfigure,
    this.alarmClock,
  });

  @override
  _AlarmClockHandler createState() => _AlarmClockHandler();
}

class _AlarmClockHandler extends State<AlarmClockHandler> {
  /* ===============
   * Attributes 
   * =============== */
  AlarmDatabase _alarmDatabase;

  final _debugName = "Alarm Clock Handler";

  // All values of the alarmclock are gonna saved here
  AlarmClock _alarmClock;

  // The input boxes for the user
  TextEditingController _timeTextController;
  TextEditingController _nameTextController;

  String _widgetTitle;

  /* ----------------
   * "Constructor"
   * ---------------- */
  @protected
  @override
  void initState() {
    /*
        This function is needed, because we can't initialize everything in
        the build function since it's always called after if we call the
        "setState(() {})" function. This would create avoidable initialisations.
    */
    super.initState();

    // Load the database
    this._alarmDatabase = AlarmDatabase('alarm_db');
    this._alarmDatabase.loadDatabase();

    // Prepare the variables
    this._alarmClock = AlarmClock();
    this._timeTextController = TextEditingController();
    this._nameTextController = TextEditingController();

    // The user just wants to config a current alarm clock
    if (this.widget.modeConfigure) {
      // Use the provided alarm clock and set the values
      this._nameTextController.text = this.widget.alarmClock.name;
      this._timeTextController.text = this.widget.alarmClock.time;

      // Set the values to the alarmClock alias
      this._alarmClock.id = this.widget.alarmClock.id;
      this._alarmClock.name = this.widget.alarmClock.name;
      this._alarmClock.time = this.widget.alarmClock.time;
      this._alarmClock.weekdays = this.widget.alarmClock.weekdays;

      this._widgetTitle = "Configure alarm clock";

      dev.log("Loaded variables for configuring mode.", name: this._debugName);
    }
    // The user wants to create a new alarm clock
    else {
        this._nameTextController.text = "Alarm Clock";

        // Add a default time which is the next hour
        this._timeTextController.text =
                DateFormat.jm().format(DateTime.now().add(Duration(hours: 1)));

        for (int index=0; index<7; index++)
            this._alarmClock.weekdays[index] = 0;

        this._widgetTitle = "Create new alarm clock";
    }

    dev.log("Initialised all values.", name: this._debugName);
  }

  /* ==============
   * Functions 
   * ============== */
  void _toggleState(int index) async {
    if (this._alarmClock.getWeekday(index)) {
      this._alarmClock.unsetWeekday(index);
    } else {
      this._alarmClock.setWeekday(index);
    }

    // update the selected days
    setState(() {});

    dev.log("Toggling from $index to: ${this._alarmClock.getWeekday(index)}.",
        name: this._debugName);
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
    /* ----------------------
     * The actual widget 
     * ---------------------- */
    return Scaffold(
      appBar: AppBar(
        title: Text(this._widgetTitle),
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
              TimeOfDay time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now()
                );

              // Test first, if the user provided any time
              if (time != null) {
                _timeTextController.text = time.format(context);
              }
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

            // Save the changed values into the alarm clock
            this._alarmClock.name = this._nameTextController.text;
            this._alarmClock.time = this._timeTextController.text;
            this._alarmClock.active = 1;

            // Look if the user wanted to create a new alarm clock or
            // did he/her just changed the settings?
            if (widget.modeConfigure) {
              this._alarmDatabase.updateAlarm(this._alarmClock);
            } else {
              this._alarmDatabase.addAlarm(this._alarmClock);
            }

            dev.log(
                "Saving changes to the alarm clock",
                name: "Alarm Clock Handler"
            );
            Navigator.pop(context, "Alarm Clock saved");
          }),
    );
  }
}
