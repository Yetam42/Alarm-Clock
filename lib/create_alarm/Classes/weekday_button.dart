import 'package:flutter/material.dart';
import '../../Classes/alarm_clock.dart';

class WeekDayButton extends StatefulWidget {

   // Represents the current alarm clock
  final AlarmClock alarmClock;

   // Points to the week day which is gonna be (un)set
  final int weekDay;

  const WeekDayButton ({
    this.alarmClock, 
    this.weekDay, 
  });

  _WeekDayButtonState createState() => _WeekDayButtonState();
}

class _WeekDayButtonState extends State<WeekDayButton> {

  bool _selected;

  _WeekDayButtonState() {
    this._selected = false;
  }

  /*
    This function toggles the state of the button between
    "selected" and "unselected".
   */
  void _toogleState() {
    if (this._selected) {
      this._selected = false;
      widget.alarmClock.setWeekday(widget.weekDay);
    } else {
      this._selected = true;
      widget.alarmClock.unsetWeekday(widget.weekDay);
    }
  }

  /* ------------------
   * Acutal widget 
   * ------------------ */
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (this._selected
          ? Icon(Icons.check_circle)
          : Icon(Icons.check_circle_outline)),
      onPressed: () {
        _toogleState();
      },
      color: Colors.red[400],
    );
  }
}
