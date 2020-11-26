
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:wecker/SelectTime.dart';
import 'package:wecker/BrightnessWidget.dart';
import 'package:wecker/weckerClass.dart';
import 'package:wecker/WeckerErstellen.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => HomeScreen(),
    '/second': (context) => WeckerErstellen(),
    '/third': (context) => MyApp()
  }));
}

class MyApp extends StatelessWidget {
  var actic = Wecker(id: 0, time: '10:00 AM', name: 'Actic', an: true);

  //
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
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

        ]),
      ),
    );
  }
}
