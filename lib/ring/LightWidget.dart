import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as dev;
import 'lightsensor.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LightSensorWidget extends StatefulWidget {
  // boolean that shows whether the user wants to set a new trigger light level
  final bool config;
  final LightSensor lightSensor;

  const LightSensorWidget({Key key, this.config, this.lightSensor})
      : super(key: key);

  @override
  LightSensorWidgetState createState() => new LightSensorWidgetState();
}

class LightSensorWidgetState extends State<LightSensorWidget> {
  static int maxValue = 5;
  String luxString;

  @override
  void initState() {
    super.initState();

    this.luxString = "Placeholder";

    widget.lightSensor.setCallBack(this.refreshLuxValue);
  }

  void refreshLuxValue() async {
    //dev.log('Current light level: $luxValue', name: 'Light sensor');
    setState(() {
      luxString = widget.lightSensor.getLuxValue().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.config == false) {
      if (widget.lightSensor.isLightOn()) {
        return RaisedButton(
            child: Text('Stop and go back to List'),
            onPressed: () async {
              widget.lightSensor.stopListener();
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
                  widget.lightSensor.setMaxLuxValue(int.parse(luxString));
                  //LightSensorWidgetState.maxValue = int.parse(luxString);
                  dev.log('New max value : $luxString',
                      name: 'trigger light level');

                  widget.lightSensor.stopListener();

                  Navigator.pop(context);
                })
          ],
        ),
      );
    }
  }
}
