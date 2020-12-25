import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wecker/time_selecter.dart';

class OldScreen extends StatefulWidget {
  @override
  OldScreenState createState() => OldScreenState();
}

/* =======================
 * Screen cotent
 * ======================= */
class OldScreenState extends State<OldScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new alert clock'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // Little description
            Text(
              'Choose Time',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),

            // The widget to select the time
            TimeSelecter(),
            // The button to save the time

            RaisedButton(
              child: Text('Back to Homescreen'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
