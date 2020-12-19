import 'package:flutter/material.dart';
import 'package:wecker/test.dart';
import 'weckerClass.dart';

/* =======================
 * Stateful Widgets
 * ======================= */
class Listenscreen extends StatefulWidget {
  @override
  _ListenscreenState createState() => _ListenscreenState();
}

/* =======================
 * Generic classes
 * ======================= */
class _ListenscreenState extends State<Listenscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wecker'),

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
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => CreateAlarm(wecker: wecker)));
}
