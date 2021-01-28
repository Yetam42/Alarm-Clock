import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as dev;

import 'package:wecker/main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LightSensorWidget extends StatefulWidget {
  // boolean that shows whether the user wants to set a new trigger light level
  final bool config;

  const LightSensorWidget({Key key, this.config}) : super(key: key);

  @override
  LightSensorWidgetState createState() => new LightSensorWidgetState();
}

class LightSensorWidgetState extends State<LightSensorWidget> {
  String luxString = 'Unknown';
  Light _light;
  StreamSubscription _subscription;
  static int maxValue = 5;

  void onData(int luxValue) async {
    dev.log('Current light level: $luxValue', name: 'Light sensor');
    setState(() {
      luxString = "$luxValue";
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
    if (level > maxValue) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // this function stops the stream listening to the light level
  // when closing the screen
  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.config == false) {
      if (lightOn(luxString)) {
        return RaisedButton(
            child: Text('Stop and go back to List'),
            onPressed: () async {
              FlutterRingtonePlayer.stop();
              await flutterLocalNotificationsPlugin.cancelAll();
              Navigator.pop(context);
            });
      } else {
        return Text('NOT BRIGHT ENOUGH, PLEASE TURN ON THE LIGHT');
      }
    } else {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(luxString),
            Text(
                'You can see the  current light level above this text. Please press on the button below to save the light level when the light is turned on'),
            RaisedButton(
                child: Text('Confirm'),
                onPressed: () {
                  LightSensorWidgetState.maxValue = int.parse(luxString);
                  dev.log('New max value : $luxString',
                      name: 'trigger light level');

                  Navigator.pop(context);
                })
          ],
        ),
      );
    }
  }
}
