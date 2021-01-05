import 'package:flutter/material.dart';
import 'LightWidget.dart';

class LightConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure light value'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            LightSensorWidget(config: true),
          ],
        ),
      ),
    );
  }
}
