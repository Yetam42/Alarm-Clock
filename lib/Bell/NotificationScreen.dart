import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:light/light.dart';
import 'dart:async';
import 'dart:developer' as dev;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationScreen extends StatelessWidget {
  String alarmName;
  NotificationScreen({this.alarmName});

  @override
  Widget build(BuildContext context) {
    FlutterRingtonePlayer.playAlarm();

    return Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body: Center(
          child: Column(
            children: [
              Text(alarmName),
              LightSensorWidget(),
              RaisedButton(
                  child: Text('Stop Alarm'),
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                  })
            ],
          ),
        ));
  }
}

class LightSensorWidget extends StatefulWidget {
  @override
  _LightSensorWidgetState createState() => new _LightSensorWidgetState();
}

class _LightSensorWidgetState extends State<LightSensorWidget> {
  String _luxString = 'Unknown';
  Light _light;
  StreamSubscription _subscription;

  void onData(int luxValue) async {
    dev.log('Current light level: $luxValue', name: 'Light sensor');
    setState(() {
      _luxString = "$luxValue";
    });
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exeption) {
      dev.log('$exeption', name: 'Light');
    }
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  bool lightOn(String luxValue) {
    int level = int.parse(luxValue);
    int maxValue = 5;
    if (level > maxValue) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    if (lightOn(_luxString)) {
      return RaisedButton(
          child: Text('Stop'),
          onPressed: () async {
            stopListening();
            FlutterRingtonePlayer.stop();
            await flutterLocalNotificationsPlugin.cancelAll();
            Navigator.pop(context);
          });
    } else {
      return Text('NOT BRIGHT ENOUGH, PLEASE TURN ON THE LIGHT');
    }
  }
}
