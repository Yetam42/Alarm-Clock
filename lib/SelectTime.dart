import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';


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
      });
  }

  String compare(zeug) {
    String a = '';
    if (zeug ==
        formatDate(
            DateTime(2020, 08, 1, DateTime.now().hour, DateTime.now().minute),
            [hh, ':', nn, " ", am]).toString()) {
      a = 'Yes';
    }
    //print(_selectTime(context));
    return a;
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
    _height = MediaQuery.of(context).size.shortestSide;
    _width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          //ListView(),


//Erzeugt einen Knopf mit dem man manuell in die Datenbank hochladen kann
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
