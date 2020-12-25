/* =======================
 * Imports
 * ======================= */
import 'package:flutter/material.dart';
import 'Classes/alarm_database.dart';
import 'Classes/alarm_clock.dart';
import 'package:async_builder/async_builder.dart';
import 'package:async_builder/init_builder.dart';

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

  @override
  @protected
  void initState() {
    this._alarmDatabase = AlarmDatabase("alarm_db");
    super.initState();
  }

  // This function makes sure that the databse is loaded so we can get all alarm
  // clocks from the database
  Future<List<AlarmClock>> _getAllAlarmClocks() async {
    await this._alarmDatabase.loadDatabase();
    return await this._alarmDatabase.getAlarmClocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of all alarm clocks'),
      ),
      body: AsyncBuilder<List<AlarmClock>> (
          future: this._getAllAlarmClocks(),
          waiting: (context) => Text("Getting all alarm clocks..."),
          error: (context, error, stackTraxe) =>
              Text("An error happened: $error"),
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

                              // Save the new status in the database
                              this._alarmDatabase.updateAlarm(allAlarmClocks[index]);
                            }),
                        // Update the alarm clock in the database
                        onTap: () {
                          this._alarmDatabase.updateAlarm(allAlarmClocks[index]);
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
                        )
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
