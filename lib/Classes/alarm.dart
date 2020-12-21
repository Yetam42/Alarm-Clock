class Alarm {
  int id;
  String time = "";
  String name;
  int active = 0;
  int mon = 0;
  int tue = 0;
  int wed = 0;
  int thu = 0;
  int fri = 0;
  int sat = 0;
  int sun = 0;
  static const String TABLENAME = 'alarm';

  Alarm(
      {this.id,
      this.time,
      this.name,
      this.active,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat,
      this.sun});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'name': name,
      'active': active,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'sun': sun
    };
  }
}

final Test = Alarm(
    id: 1,
    time: '09:00 AM',
    name: 'Alarm',
    active: 0,
    mon: 0,
    tue: 0,
    wed: 0,
    thu: 0,
    fri: 0,
    sat: 0,
    sun: 0);
