import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:developer' as dev;
import 'LightWidget.dart';

class NotificationScreen extends StatelessWidget {
  final String alarmName;

  NotificationScreen({this.alarmName});

  @override
  Widget build(BuildContext context) {
    dev.log('Current max Value ${LightSensorWidgetState.maxValue}',
        name: 'trigger light level');

    // comment the line below to prevent the app from ringing
    FlutterRingtonePlayer.playAlarm();

    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        // if the alarm has no name a default name will be displayed instead
        title: Text(alarmName == '' ? 'Alarm' : alarmName),
        centerTitle: true,
      ),
      body: Center(
        child: LightSensorWidget(
          config: false,
        ),
      ),
    );
  }
}
