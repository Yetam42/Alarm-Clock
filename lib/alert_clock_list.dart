/* =======================
 * Imports
 * ======================= */
import 'package:flutter/material.dart';
import 'Classes/alarm_database.dart';
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

  AlarmDatabase alarmDatabase;
  Future<String> _test = Future<String>.delayed(Duration(seconds: 2), () => "I use Arch btw");
  Future<List<Map<String, dynamic>>> _allAlarmClocks;

  final String _logName = "Alarm Clock List";

  @override
  @protected
  @mustCallSuper
  void initState() {
        this.alarmDatabase = AlarmDatabase("alarm_db");
        this.alarmDatabase.loadDatabase();
        dev.log("Loaded database", name: this._logName);
        this._allAlarmClocks = this.alarmDatabase.getAlarmClocks();
        dev.log("Getting all alarm clocks...", name: this._logName);
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of all alarm clocks'),
      ),
      // Get the values from the list of alarm clocks
      body: Center(
            child: FutureBuilder<List<Map<String, dynamic>>>
                  //FutureBuilder<String>
            (
                future: this._allAlarmClocks,
                builder: (
                    BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    //AsyncSnapshot<String> snapshot) {
                        List<Widget> children;
                        dev.log("Hello", name: this._logName);
                        if (snapshot.hasData) {
                            children = <Widget> [
                                Text("${snapshot.data}"),
                            ];
                        } else {
                            children = <Widget>[
                                Text("Nein")
                            ];
                        }

                        return Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: children,
                                        ),
                                );
                    }
                )
            )
      //body: FutureBuilder<List<Map<String, dynamic>>>(
      //  future: this.alarmDatabase.getAlarmClocks(),
      //  builder: (
      //          BuildContext context,
      //          AsyncSnapshot<List<Map<String, dynamic>>> snapshot)
      //  {

      //    if (snapshot.hasData) {
      //      return ListView.builder(
      //        itemCount: snapshot.data.length,
      //        itemBuilder: (context, index) {
      //          //By swiping from right to left an alarm is now deleted

      //          // The button to remove an alarm clock
      //          return Dismissible(
      //            key: UniqueKey(),
      //            direction: DismissDirection.endToStart,
      //            onDismissed: (_) {
      //              this.alarmDatabase.removeAlarm(snapshot.data[index]);
      //              setState(() {});
      //            },
      //            // list tile with the necessary information for the user
      //            child: Card(
      //              child: ListTile(
      //                title: Text(snapshot.data[index]["time"]),
      //                subtitle: Text(snapshot.data[index]["name"]),
      //                // Toogle the active-status of the alarm clock
      //                trailing: Switch(
      //                    value: snapshot.data[index]["active"],
      //                    onChanged: (value) {
      //                      //_toogleActiveState(snapshot.data[index]);

      //                      // Toogle the status of the alarm clock first
      //                      snapshot.data[index]["active"] =
      //                              !snapshot.data[index]["active"];

      //                      // Save the new status in the database
      //                      this.alarmDatabase.updateAlarm(
      //                              snapshot.data[index]
      //                              );
      //                      setState(() {
      //                        //return snapshot.data[index]["active"];
      //                        //print(_getStatus(snapshot.data[index].active));
      //                      });
      //                    }),

      //                // Update the alarm clock in the database
      //                onTap: () {
      //                  this.alarmDatabase.updateAlarm(snapshot.data[index]);
      //                  //Navigator.push(context, )
      //                  //_updateAlarm(context, snapshot.data[index]);
      //                  setState(() {});
      //                },
      //              ),
      //            ),
      //            // the color and image that is revealed while swiping
      //            background: Container(
      //                margin: EdgeInsets.symmetric(horizontal: 15),
      //                color: Colors.red,
      //                child: Column(
      //                  mainAxisAlignment: MainAxisAlignment.center,
      //                  children: [
      //                    Icon(
      //                      Icons.delete,
      //                      color: Colors.white,
      //                    ),
      //                    Text('Delete')
      //                  ],
      //                )),
      //          );
      //        },
      //      );
      //    } else if (snapshot.hasError) {
      //      return Center(
      //              child: Text("""
      //                      Couldn't load the data from the database. Did you
      //                      create any alarm clock?
      //                      """),
      //      );
      //    }
      //    return Container(
      //      child: CircularProgressIndicator(),
      //      alignment: Alignment.center,
      //    );
      //  },
      //),
    );
  }
}

//_deleteAlarm(Alarm alarm) {
//  DatabaseHelper.instance.deleteAlarm(alarm.id);
//}

//_updateAlarm(BuildContext context, Alarm alarm) async {
//  Navigator.push(context,
//      MaterialPageRoute(builder: (context) => CreateAlarm(alarm: alarm)));
//}

//bool _getStatus(int active) {
//  if (active == 0) {
//    return false;
//  }
//  return true;
//}

//_toogleActiveState(Alarm alarm) {
//  if (alarm.active == 0) {
//    alarm.active = 1;
//  } else {
//    alarm.active = 0;
//  }
//
//  DatabaseHelper.instance.updateAlarm(alarm);
//}
