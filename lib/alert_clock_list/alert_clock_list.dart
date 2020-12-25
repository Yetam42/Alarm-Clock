/* =======================
 * Imports
 * ======================= */
import 'package:flutter/material.dart';
import '../Classes/alarm_database.dart';
import '../Classes/alarm_clock.dart';
import 'package:async_builder/async_builder.dart';

import 'dart:developer' as dev;

/* =======================
 * Stateful Widgets
 * ======================= */
// AclScreen = Alert Clock List Screen
class AclScreen extends StatefulWidget {
  @override
  _AclScreenState createState() => _AclScreenState();
}

/* =======================
 * Generic classes
 * ======================= */
class _AclScreenState extends State<AclScreen> {
  AlarmDatabase _alarmDatabase;

  double _screenWidth;
  double _screenHeight;

  @override
  @protected
  void initState() {
    this._alarmDatabase = AlarmDatabase("alarm_db");
    super.initState();
    dev.log("Loaded initState", name: "Alarm Clock List");
  }

  // This function makes sure that the databse is loaded so we can get all alarm
  // clocks from the database
  Future<List<AlarmClock>> _getAllAlarmClocks() async {
    await this._alarmDatabase.loadDatabase();
    return await this._alarmDatabase.getAlarmClocks();
  }

  @override
  Widget build(BuildContext context) {
    this._screenWidth = MediaQuery.of(context).size.width;
    this._screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('List of all alarm clocks'),
      ),
      body: AsyncBuilder<List<AlarmClock>>(
          future: this._getAllAlarmClocks(),
          /* ------------------
           * Loading Screen 
           * ------------------ */
          waiting: (context) {
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
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height / 100)),

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
          },
          error: (context, error, stackTraxe) {

              return Container(
                child: Text(
                        """
                        An error happened! Please creat an issue on github to
                        the developers and add this error message (just do a
                                screenshot) to the issue:
                        $error
                        """,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                                fontSize: this._screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                )
                        ),
                );
          },
          /* --------------------------------
           * Listing of all alarm clocks 
           * -------------------------------- */
          builder: (context, List<AlarmClock> allAlarmClocks) {
            return ListView.builder(
                itemCount: allAlarmClocks.length,
                itemBuilder: (context, index) {
                  // Delete an alarm by swiping it to the left
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      this._alarmDatabase.removeAlarm(allAlarmClocks[index]);
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

                              setState(() {});

                              // Save the new status in the database
                              this
                                  ._alarmDatabase
                                  .updateAlarm(allAlarmClocks[index]);
                            }),
                        // Update the alarm clock in the database
                        onTap: () async {
                          this
                              ._alarmDatabase
                              .updateAlarm(allAlarmClocks[index]);
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
          }),
    );
  }
}
