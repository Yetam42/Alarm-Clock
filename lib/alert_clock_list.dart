/* =======================
 * Imports
 * ======================= */
import 'package:flutter/material.dart';
import 'package:wecker/Classes/create_alarm.dart';
import 'package:wecker/Classes/database_helper.dart';
import 'Classes/alarm.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of all alarm clocks'),
      ),
      body: FutureBuilder<List<Alarm>>(
        future: DatabaseHelper.instance.retrieveAlarms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                //By swiping from right to left an alarm is now deleted

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _deleteAlarm(snapshot.data[index]);
                    setState(() {});
                  },
                  //list tile with the necessary information for the user
                  child: ListTile(
                    title: Text(snapshot.data[index].time),
                    subtitle: Text(snapshot.data[index].name),
                    //Switch that de -/ activates an alarm
                    trailing: Switch(
                        value: _getStatus(snapshot.data[index].active),
                        onChanged: (value) {
                          _toogleActiveState(snapshot.data[index]);
                          setState(() {
                            _getStatus(snapshot.data[index].active);
                            print(_getStatus(snapshot.data[index].active));
                          });
                        }),

                    onTap: () {
                      _updateAlarm(context, snapshot.data[index]);
                      setState(() {});
                    },
                  ),

                  //the color + image that is revealed while swiping
                  background: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text('Delete')
                        ],
                      )),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Big oof');
          }
          return Container(
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          );
        },
      ),
    );
  }
}

_deleteAlarm(Alarm alarm) {
  DatabaseHelper.instance.deleteAlarm(alarm.id);
}

_updateAlarm(BuildContext context, Alarm alarm) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => CreateAlarm(alarm: alarm)));
}

bool _getStatus(int active) {
  if (active == 0) {
    return false;
  }
  return true;
}

_toogleActiveState(Alarm alarm) {
  if (alarm.active == 0) {
    alarm.active = 1;
  } else {
    alarm.active = 0;
  }

  DatabaseHelper.instance.updateAlarm(alarm);
}
