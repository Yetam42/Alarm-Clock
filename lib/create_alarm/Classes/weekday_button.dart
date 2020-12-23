import 'package:flutter/material.dart';

class Selecter{
    bool _isSelected;

    bool isSelected() {
        return this._isSelected;
    }

    void setSelected(bool value) {
        this._isSelected = value;
    }
}

class WeekDayButton extends StatefulWidget {

   // Represents the current alarm clock
  final Selecter selecter;

  const WeekDayButton ({
    this.selecter, 
  });

  _WeekDayButtonState createState() => _WeekDayButtonState();
}

class _WeekDayButtonState extends State<WeekDayButton> {

  _WeekDayButtonState() {
    widget.selecter.setSelected(false);
  }

  /*
    This function toggles the state of the button between
    "selected" and "unselected".
   */
  void _toogleState() {
    if (widget.selecter.isSelected()) {
        widget.selecter.setSelected(false);
    } else {
        widget.selecter.setSelected(true);
    }
  }

  /* ------------------
   * Acutal widget 
   * ------------------ */
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (widget.selecter.isSelected()
          ? Icon(Icons.check_circle)
          : Icon(Icons.check_circle_outline)),
      onPressed: () {
        _toogleState();
      },
      color: Colors.red[400],
    );
  }
}
