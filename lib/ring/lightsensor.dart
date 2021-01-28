import 'dart:async';
import 'dart:developer' as dev;
import 'package:light/light.dart';

class LightSensor {
  StreamSubscription _subscription;
  Light _light;

  Function _callBack; // is called, if the value of the listener changes

  // control variables
  bool _streamIsOn;

  int _luxValue;
  int _maxLuxValue;

  final String _debugName = "Light Sensor";

  LightSensor() {
    this._streamIsOn = false;
    this._luxValue = 0;
    this._maxLuxValue = 0;

    this._subscription = null;
    this._callBack = null;
    this._light = null;
  }

  /* ==============
   * Functions 
   * ============== */
  void stopListener() {
    // cancel the stream if it was activated before
    if (this._streamIsOn) {
      this._subscription.cancel();
      this._subscription = null;
    }
  }

  void startListening() {
    this._light = Light();

    try {
      // make sure that there is no other stream opened
      if (this._subscription != null) {
        this.stopListener();
      }

      this._subscription = this._light.lightSensorStream.listen(refreshValue);
    } on LightException catch (exception) {
      dev.log("$exception", name: this._debugName);
    }

    this._streamIsOn = true;
  }

  void refreshValue(int luxValue) async {
    dev.log('Current light level: $luxValue', name: this._debugName);
    this._luxValue = luxValue;
    this._callBack();
  }

  bool isLightOn() {
    if (this._luxValue > this._maxLuxValue)
      return true;

    return false;
  }

  /* ======================
   * Getter and Setter 
   * ====================== */
  int getLuxValue() {
    return this._luxValue;
  }
  
  void setCallBack(Function callBack) {
    this._callBack = callBack;
  }

  void setMaxLuxValue(int maxLuxValue) {
    this._maxLuxValue = maxLuxValue;
  }
}
