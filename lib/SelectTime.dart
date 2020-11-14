import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  double _height;
  double _width;

  String _setTime;

  String _hour, _minute, _time;

  String dateTime;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _timeController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2020, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        createData(_timeController.text);
      });
  }

  String compare (zeug){
    String a = '';
    if(zeug == formatDate(
        DateTime(2020, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString()){
      a = 'Yes';
    }
    print(_selectTime(context));
    return a;
  }


  void createData(time){
    databaseReference.child("Wecker3").set({
      'Angeschalten': false,
      'Uhrzeit': time
    });
  }

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2020, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    print('Baum');

    return Container(
      width: _width,
      height: _height,
      child: Column(
        children: <Widget>[
          Text(
            'Choose Time',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
          ),
          InkWell(
            onTap: () {
              _selectTime(context);
              print(_timeController.text);
              print('----------------------------------------');
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              width: _width / 1.7,
              height: _height / 9,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: TextFormField(
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
                onSaved: (String val) {
                  _setTime = val;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _timeController,
                decoration: InputDecoration(
                    disabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.all(5)),
              ),
            ),
          ),
          new Text(
            //compare(_timeController.text)
            'Platzhalter'
          ),
//Debug zeug für datenbank
          /*RaisedButton(
            child: const Text('In Datenbank speicher'),
              onPressed: () {
                createData(_timeController.text);
                print(_timeController.text);
              }
          ),*/
        ],
      ),
    );

  }
}
