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
    '/second': (context) => WeckerErstellen(),
    '/third': (context) => MyApp(),
    '/forth': (context) => CreateAlarm(),
    '/5': (context) => Listenscreen()
  }));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            child: Text('Neuer Wecker'),
            onPressed: () {
              Navigator.pushNamed((context), '/second');
            },
          ),
          RaisedButton(
              child: Text('Alter Screen'),
              onPressed: () {
                Navigator.pushNamed(context, '/third');
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
