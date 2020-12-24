/* =======================
 * Imports
 * ======================= */
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class TimeSelecter extends StatefulWidget {
  @override
  _TimeSelecterState createState() => _TimeSelecterState();
}

class _TimeSelecterState extends State<TimeSelecter> {
  double _height;
  double _width;

  //String _selectedAlertTime;
  String _hour;
  String _minute;
  String _time;
  String dateTime;

  TimeOfDay selectedTime;
  TextEditingController _timeController;

  /* -----------------
   * Constructor
   * ----------------- */
  _TimeSelecterState() {
    int suggestedHour = (TimeOfDay.now().hour + 1) % 13;

    // Give a first assumption that the user wants
    // to set the timer one hour later
    this.selectedTime =
        TimeOfDay(hour: suggestedHour, minute: TimeOfDay.now().minute);

    this._timeController = TextEditingController();
  }

  /* -----------------
   * Functions
   * ----------------- */
  void _updateTimeDisplay(BuildContext context) async {
    // This functions refreshes the time which is displayed by the
    // "_timeController"

    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);

    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = "$_hour:$_minute";
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2020, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2020, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  /* -----------------------------
   * The looking of this widget
   * ----------------------------- */
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.shortestSide;
    _width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          // Report the current time (not neccessary for the client)
          onTap: () {
            _updateTimeDisplay(context);

            dev.log("Current selected time: ${_timeController.text}",
                name: "TimeSelecter => TimeDisplayValue");
          },

          child: Container(
            // The time block where the selected alert time is displayed
            margin: EdgeInsets.only(top: 30),
            width: _width * 0.7,
            height: _height * 0.25,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey[200]),

            child: TextFormField(
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
              onSaved: (String val) {
                //_selectedAlertTime = val;
              },
              enabled: false,
              keyboardType: TextInputType.text,

              // the circle to select the number
              controller: _timeController,
              decoration: InputDecoration(
                  disabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(5)),
            ),
          ),
        ),
      ],
    );
  }
}
