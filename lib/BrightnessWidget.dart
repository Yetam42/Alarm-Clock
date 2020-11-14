import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:light/light.dart';
import 'dart:async';

class BrightnessWidget extends StatefulWidget {
  BrightnessWidget({label});

  @override
  _BrightnessWidgetState createState() => _BrightnessWidgetState();
}

class _BrightnessWidgetState extends State<BrightnessWidget>{
  String luxlight = "Unknown";
  Light _light;
  StreamSubscription _subscribtion;

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    setState(() {
      luxlight = "$luxValue";

    });
  }

  void stopListening(){
    _subscribtion.cancel();
  }

  void startListening(){
    _light = new Light();
    try {
      _subscribtion = _light.lightSensorStream.listen(onData);
    }
    on LightException catch (exception){
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  bool brightEnough(){
    if(int.parse(luxlight) > 10){
      return true;
    }
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    if(brightEnough() == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: new Text('Lichtstärke: $luxlight\n'),
          ),
          RaisedButton(
              child: Text('Ausschalten'),
              onPressed: () {
                FlutterRingtonePlayer.stop();}
          )
        ],
      );
    }
    else{
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: new Text('Lichtstärke: $luxlight\n'),
          )
        ],
      );
    }
  }
}