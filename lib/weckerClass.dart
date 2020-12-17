class Wecker {
  int id;
  String time;
  String name;
  /*bool active;
  bool mon = false;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  bool sun = false;*/
  static const String TABLENAME = 'wecker';

  Wecker({
    this.id,
    this.time,
    this.name,
    /*this.active,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat,
      this.sun*/
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'name': name,
      /*'active': active,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'sun': sun*/
    };
  }
}

final Alarm = Wecker(
  id: 1,
  time: '09:00 AM',
  name: 'Alarm',
  /*active: false,
    mon: false,
    tue: false,
    wed: false,
    thu: false,
    fri: false,
    sat: false,
    sun: false*/
);
