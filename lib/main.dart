/* =======================
 * Imports
 * ======================= */
import 'Classes/alarm_database.dart';
import 'Classes/alarm_clock.dart';
import 'alarm_clock_handler.dart';
import 'main_helper.dart';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as dev;

void main() {
  dev.log("Application installed!", name: "Application");

  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => HomeScreen(),
    '/AlarmClockHandler': (context) => AlarmClockHandler(),
  }));
}

/* ===================
 * The mainscreen 
 * =================== */
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  AlarmDatabase _alarmDatabase;

  AlarmHelper _alarmHelper;

  // This function makes sure that the databse is loaded so we can get all alarm
  // clocks from the database
  Future<List<AlarmClock>> _getAllAlarmClocks() async {
    await this._alarmDatabase.loadDatabase();
    return await this._alarmDatabase.getAlarmClocks();
  }

  @override
  Widget build(BuildContext context) {
    /* =================
     * Preparations 
     * ================= */
    // load the database
    this._alarmDatabase = AlarmDatabase("alarm_db");

    // Prepare the alarm helper which contains many widgets
    this._alarmHelper = AlarmHelper(context);

    /* ======================
     * Actual Homescreen 
     * ====================== */
    return Scaffold(
      appBar: AppBar(
        title: Text('List of all alarm clocks'),
        centerTitle: true,
      ),
      /* ---------------------------------------
       * Button to create a new alarm clock 
       * --------------------------------------- */
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          // Go to the widget where the user can create a new clock
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/AlarmClockHandler',
              arguments: AlarmClockHandlerArgs(false, null),
            )
            // After adding a new alarm clock, refresh the list to display it
            .then((value) => setState(() {}));
          }),
      /* ----------------------------
       * All alarm clocks listed
       * ---------------------------- */
      body: AsyncBuilder<List<AlarmClock>>(
          future: this._getAllAlarmClocks(),
          /* ------------------
           * Loading Screen
           * ------------------ */
          waiting: (context) => this._alarmHelper.getLoadingScreen(context),
          /* -----------------
           * Error Screen
           * ----------------- */
          error: (context, error, stackTraxe) =>
              this._alarmHelper.getErrorContainer(error),
          /* --------------------------------
           * Listing of all alarm clocks
           * -------------------------------- */
          builder: (context, List<AlarmClock> allAlarmClocks) {
            return this
                ._alarmHelper
                .getAlarmClocksList(context, allAlarmClocks, setState);
          }),
    );
  }
}
