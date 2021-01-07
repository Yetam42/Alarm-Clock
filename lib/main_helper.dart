import 'package:flutter/material.dart';
import 'package:wecker/ring/ring_helper.dart';
import 'Classes/alarm_clock.dart';
import 'Classes/alarm_database.dart';
import 'Classes/alarm_clock_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlarmHelper {
  double _screenWidth;
  double _screenHeight;

  AlarmDatabase _alarmDatabase;

  AlarmHelper(BuildContext context) {
    this._screenWidth = MediaQuery.of(context).size.width;
    this._screenHeight = MediaQuery.of(context).size.height;

    this._alarmDatabase = AlarmDatabase('alarm_db');
    this._alarmDatabase.loadDatabase();
  }

  /*
    This returns the loading screen for the listing of the alarm clocks
   */
  Center getLoadingScreen(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Display a loading circle
            SizedBox(
              width: this._screenWidth / 3,
              height: this._screenHeight / 6,
              child: CircularProgressIndicator(
                backgroundColor: Color(0x00FFFF),
                strokeWidth: 5.0,
              ),
            ),

            Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 100)),

            // Displaying why it's loading (a little text)
            Container(
              width: this._screenWidth,
              height: this._screenHeight / 10,
              child: Text(
                "Loading Alarm Clocks...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this._screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
    );
  }

  /*
    This returns an error message for the user, so he/she knows
    what he/she can do, if an error happens
   */
  Container getErrorContainer(String errorMsg) {
    return Container(
      child: Text("""
        An error happened! Please creat an issue on github to
        the developers and add this error message (just do a
        screenshot) to the issue:
        $errorMsg
        """,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: this._screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  /*
    This returns all alarm clocks ordered in a ListView.

    "ownSetState" is just an alias for "setState" since we can't use "setState"
    in this function directly.
   */
  ListView getAlarmClocksList(BuildContext context,
      List<AlarmClock> allAlarmClocks, Function ownSetState) {
    return ListView.builder(
        itemCount: allAlarmClocks.length,
        itemBuilder: (context, index) {
          // start notification plugin if alarm is activated
          if (allAlarmClocks[index].active == 1) {
            RingHelper(allAlarmClocks[index]).showNotification();
          }

          // Delete an alarm by swiping it to the left
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              // Remove the alarm clock from the databse
              this._alarmDatabase.removeAlarm(allAlarmClocks[index]);

              ownSetState(() {
                // Reload the list but remove the alarm Clock from
                // the list first
                allAlarmClocks.removeAt(index);
              });
            },
            /*
                 Display on each card on the left:
                  - the name
                  - the alarm time
                 of the current alarm clock
                 */
            child: Card(
              child: ListTile(
                title: Text(allAlarmClocks[index].time),
                subtitle: Text(allAlarmClocks[index].name),
                // A switch to toggle the alarm clock active status
                trailing: Switch(
                    value: allAlarmClocks[index].active == 1,
                    onChanged: (changingStatus) {
                      // Toogle the status of the alarm clock first
                      if (allAlarmClocks[index].active == 1)
                        allAlarmClocks[index].active = 0;
                      else
                        allAlarmClocks[index].active = 1;

                      ownSetState(() {});

                      // Save the new status in the database
                      this._alarmDatabase.updateAlarm(allAlarmClocks[index]);
                    }),
                // Update the alarm clock in the database
                onTap: () async {
                  // Go to the editing page first than refresh the alarm
                  // clock list next

                  Navigator.pushNamed(
                    context,
                    "/AlarmClockHandler",
                    arguments:
                        AlarmClockHandlerArgs(true, allAlarmClocks[index]),
                  ).whenComplete(() => ownSetState(() {}));
                },
              ),
            ),
            // the color and image that is revealed on the right
            // while swiping
            background: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
          );
        });
  }
}
