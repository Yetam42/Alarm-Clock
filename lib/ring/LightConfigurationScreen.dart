import 'package:flutter/material.dart';
import 'LightWidget.dart';
import 'lightsensor.dart';

class LightConfigurationScreen extends StatelessWidget {
  final LightSensor lightSensor = LightSensor();

  @override
  Widget build(BuildContext context) {

    this.lightSensor.startListening();

    return WillPopScope(
        onWillPop: () async {
          this.lightSensor.stopListener();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Configure light value'),
            centerTitle: true,
          ),
          body: Container(
            child: Column(
              children: [
                LightSensorWidget(config: true, lightSensor: this.lightSensor),
              ],
            ),
          ),
        ));
  }
}
