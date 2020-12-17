/*class Wecker{
  String time;
  int id;

  Wecker(this.time, this.id);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'time': time,
      'id': id
    };
    return map;
  }

  Wecker.fromMap(Map<String, dynamic> map){
    time = map['time'];
    id = map['id'];
  }

}*/

/*lass Wecker {
  final int id;
  final String time;
  final String name;
  final bool an;
  final bool mon;
  final bool tue;
  final bool wed;
  final bool thu;
  final bool fri;
  final bool sat;
  final bool sun;

  Wecker({this.id, this.time, this.name, this.an});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'name': name,
      'an': an,
    };
  }

  static void test() {
    print('Jawohl00');
  }

  //MyApp(test);

  @override
  String toString() {
    return 'Wecker(id: $id, time: $time, name: $name, an: $an)';
  }
}*/

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
