/* =======================
 * Imports
 * ======================= */
import 'package:flutter/material.dart';
import 'package:wecker/alert_clock_list/alert_clock_list.dart';
import 'package:wecker/old_screen.dart';
import 'create_alarm/create_alarm.dart';

import 'dart:developer' as dev;

void main() {
  dev.log("Application installed!", name: "Application");

  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => _HomeScreen(),
    '/createAlarmClock': (context) => CreateAlarm(),
    '/oldscreen': (context) => OldScreen(),
    '/AlarmClockListScreen': (context) => AclScreen()
  }));
}

/* ===================
 * The mainscreen 
 * =================== */
class _HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm Clock App'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(children: <Widget>[
          RaisedButton(
              child: Text('Create Alarm'),
              onPressed: () {
                Navigator.pushNamed(context, '/createAlarmClock');
              }),
          RaisedButton(
            child: Text('Alarm Clock List'),
            onPressed: () {
              Navigator.pushNamed(context, '/AlarmClockListScreen');
            },
          ),
        ]),
      ),
    );
  }
}
