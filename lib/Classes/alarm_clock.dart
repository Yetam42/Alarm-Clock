import 'dart:developer' as dev;

/*
  This class saves the neccessary information for the database. It has all
  information which are needed for an alarm clock.
*/
class AlarmClock {
  int id;
  String time;
  String name;

  int active;

  /* -----------------
   * The weekdays 
   * ----------------- */
  /*
    Each index represents one weekday and if it's 1, than it means that it's
    selected. As a result, that means:
    Index 0 => Monday
    Index 1 => Tuesday
    Index 2 => Wednesday
    Index 3 => Thursday
    Index 4 => Friday
    Index 5 => Saturday
    Index 6 => Sunday
  */
  List<int> weekdays = [0, 0, 0, 0, 0, 0, 0];

  /* ==============
   * Functions 
   * ============== */
  AlarmClock() {
    this.id = 0;
    this.time = "";
    this.name = "";
    this.active = 0;
  }

  /*
    This function set a weekday as "selected".
   */
  void setWeekday(int weekday) {
    this.weekdays[weekday] = 1;
  }

  /*
    This function set a weekday as "unselected".
   */
  void unsetWeekday(int weekday) {
    this.weekdays[weekday] = 0;
  }

  bool getWeekday(int index) {

    dev.log("Weekday value: ${this.weekdays[index]}", name: "getWeekday");

    // Control first, if the index is in a valid field
    if (index < 7 && index >= 0) {
        if (this.weekdays[index] == 1)
            return true;
        else
            return false;
    } else {
        // Invalid index range
        return null;
    }
  }
}
