import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:wecker/SelectTime.dart';
import 'package:wecker/BrightnessWidget.dart';
import 'package:wecker/kp.dart';
import 'package:wecker/WeckerErstellen.dart';
import 'test.dart';

void main() {

  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => HomeScreen(),
    '/createAlarmClock': (context) => WeckerErstellen(),
    '/testingPage': (context) => MyApp(),
    '/forth': (context) => CreateAlarm(),
    '/5': (context) => Listenscreen()
  }));
}

/* =======================
 * Stateful Widgets
 * ======================= */
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

/* =======================
 * Generic classes
 * ======================= */
class MyAppState extends State<MyApp> {
  //var actic = Wecker(id: 0, time: '10:00 AM', name: 'Actic', active: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringtone player'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: RaisedButton(
                child: const Text('playAlarm'),
                onPressed: () {
                  FlutterRingtonePlayer.playAlarm();
                },
              ),
            ),
            BrightnessWidget(),
            DateTimePicker(),
            RaisedButton(
              child: Text('Zurück zum Hauptbildschrim'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Sunshine'),
        backgroundColor: Colors.orange,
      ),

      body: Center(
        child: Column(children: <Widget>[
          RaisedButton(

            // add the color
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ]
                )
              ),

              child: Text('Neuer Wecker'),
            ),

            onPressed: () {
              Navigator.pushNamed((context), '/createAlarmClock');
            },
          ),
          RaisedButton(
              child: Text('Alter Screen'),
              onPressed: () {
                Navigator.pushNamed(context, '/testingPage');
              }),
          RaisedButton(
              child: Text('Test1'),
              onPressed: () {
                Navigator.pushNamed(context, '/forth');
              }),
          RaisedButton(
            child: Text('Liste'),
            onPressed: () {
              Navigator.pushNamed(context, '/5');
            },
          )
        ]),
      ),
    );
  }
}
