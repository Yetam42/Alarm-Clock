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

  //Map<String, dynamic> toMap() {
  //  return {
  //    'id': id,
  //    'time': time,
  //    'name': name,
  //    'active': active,
  //    'mon': mon,
  //    'tue': tue,
  //    'wed': wed,
  //    'thu': thu,
  //    'fri': fri,
  //    'sat': sat,
  //    'sun': sun
  //  };
  //}
}

//final Test = Alarm(
//    id: 1,
//    time: '09:00 AM',
//    name: 'Alarm',
//    active: 0,
//    mon: 0,
//    tue: 0,
//    wed: 0,
//    thu: 0,
//    fri: 0,
//    sat: 0,
//    sun: 0);
