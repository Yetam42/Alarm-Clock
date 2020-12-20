/* =======================
 * Imports
 * ======================= */
import 'package:flutter/material.dart';
import 'package:wecker/Classes/database_helper.dart';
import 'Classes/wecker.dart';

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
        title: Text('List of all alert clocks'),

      ),
      body: FutureBuilder<List<Wecker>>(

        future: DatabaseHelper.instance.retrieveAlarms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].time),
                    subtitle: Text(snapshot.data[index].name),
                    onTap: () => _updateAlarm(context, snapshot.data[index]),
                    trailing: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        _deleteAlarm(snapshot.data[index]);
                        setState(() {});
                      },
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('Big oof');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

_deleteAlarm(Wecker wecker) {
  DatabaseHelper.instance.deleteWecker(wecker.id);
}

_updateAlarm(BuildContext context, Wecker wecker) async {
  //Navigator.push(context,
  //    MaterialPageRoute(builder: (context) => CreateAlarm(wecker: wecker)));
}
