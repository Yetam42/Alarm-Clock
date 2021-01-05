/* =======================
 * Imports
 * ======================= */
import 'package:wecker/ring/NotificationScreen.dart';

import 'Classes/alarm_database.dart';
import 'Classes/alarm_clock.dart';
import 'alarm_clock_handler/alarm_clock_handler.dart';
import 'main_helper.dart';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as dev;
import 'dart:io';

import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'ring/LightConfigurationScreen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final String defaultLocale = Platform.localeName;

void main() {
  dev.log("Application installed!", name: "Application");
  tz.initializeTimeZones();

  runApp(MaterialApp(
    // remove the debug banner
    debugShowCheckedModeBanner: false,

    home: HomeScreen(),
    // Handles the arguments which should be given to each widget
    onGenerateRoute: (RouteSettings nextWidget) {
      // Look which widget is gonna open
      if (nextWidget.name == "/AlarmClockHandler") {
        // Get all needed arguments for the AlarmClockHandler
        final AlarmClockHandlerArgs _args = nextWidget.arguments;

        return MaterialPageRoute(builder: (context) {
          return AlarmClockHandler(
            modeConfigure: _args.modeConfigure,
            alarmClock: _args.alarmClock,
          );
        });
      }

      // Unknown widget
      return MaterialPageRoute(builder: (context) {
        return Column(
          children: <Widget>[
            Text("Congratulation!"),
            Text("You just found a bug :D"),
            Text("Please report it on github and create an issue!"),
            Text("And add a description what you did to create"),
            Text("this bug."),
          ],
        );
      });
    },
  ));
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
  void initState() {
    super.initState();

    // initialisation for the flutter local_notification plugin
    var androidSettings = AndroidInitializationSettings('app_icon');
    var initSettings = InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onClickNotification);
  }

  // open notification screen when the user presses on the notification
  Future onClickNotification(String alarmName) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NotificationScreen(
        // gets the name of the corresponding alarm
        // look in ring_helper for usage
        // it can be found under payload
        alarmName: alarmName,
      );
    }));
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
        title: Text('Alarm Clocks'),
        centerTitle: true,
        /*-----------------------------------------
       * button for light level configuration
       *----------------------------------------*/
        actions: <Widget>[
          IconButton(
              // has the settings icon
              // future features could extend this part of the code
              // for insatnce adding a link to the github page
              icon: Icon(Icons.settings),
              tooltip: 'Configure maximum light level',
              // open screen where the a new trigger light level can be set
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LightConfigurationScreen()));
              })
        ],
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
