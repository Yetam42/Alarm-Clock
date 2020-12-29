import 'dart:developer' as dev;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../Classes/alarm_clock.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class RingHelper {
  AlarmClock alarmClock;
  List weekdays;

  RingHelper(AlarmClock alarmClock) {
    this.alarmClock = alarmClock;
    this.weekdays = this.alarmClock.weekdays;
  }

  bool tomorrow(tz.TZDateTime l) {
    int posDay;

    tz.TZDateTime tomorrowDateTime = l;

    posDay = tomorrowDateTime.weekday - 1;

    String tomorrowDay = DateFormat.EEEE().format(tomorrowDateTime);
    dev.log('Tomorrow is $tomorrowDay', name: 'Ring');

    if (weekdays[posDay] == 1) {
      return true;
    }
    return false;
  }

  tz.TZDateTime convertTZDateTime(String selectedTime) {
    var selectedTimes = selectedTime.split(':');
    dev.log('Uhrzeit: ${selectedTimes}', name: 'Ring');
    tz.TZDateTime now = tz.TZDateTime.now(tz.UTC);
    tz.TZDateTime convertedTime = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, int.parse(selectedTimes[0]), int.parse(selectedTimes[1]), 00);

    return convertedTime;
  }

  tz.TZDateTime nextRing() {
    tz.TZDateTime chosenTime =
        convertTZDateTime(alarmClock.time).add(Duration(hours: -1));
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    dev.log('Time now $now', name: 'Ring');
    dev.log('chosen time $chosenTime', name: 'Ring');

    if (chosenTime.isBefore(now)) {
      chosenTime = nextScheduledTime(chosenTime);
      dev.log('${alarmClock.time} has already passed', name: 'Ring');
      dev.log('New time: ${chosenTime}', name: 'Ring');
    }

    return chosenTime;
  }

  tz.TZDateTime nextScheduledTime(tz.TZDateTime l) {
    tz.TZDateTime scheduledTime = l;
    do {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    } while (tomorrow(scheduledTime) == false);

    String t = DateFormat.EEEE().format(scheduledTime.add(Duration(days: 1)));
    dev.log('It will ring on ${t}', name: 'Ring');

    dev.log('Next Ring on $scheduledTime', name: 'Ring');
    return scheduledTime;
  }

  showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        'ID0', 'CHANNEL0', 'DESCRIPTION0',
        fullScreenIntent: true,
        priority: Priority.high,
        importance: Importance.high);
    var platFormDetails = new NotificationDetails(android: androidDetails);
    if (alarmClock.active == 1)
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0, 'Wecker App', alarmClock.name, nextRing(), platFormDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);

    //dev.log('${nextRing()}', name: 'Ring');
  }
}
