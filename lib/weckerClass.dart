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

class Wecker {
  final int id;
  final String time;
  final String name;
  final bool an;

  Wecker({this.id, this.time, this.name, this.an});
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'time': time,
      'name': name,
      'an' : an,
    };
  }

  static void test() {
    print('Jawohl00');
  }

  //MyApp(test);

  @override
  String toString(){
    return 'Wecker(id: $id, time: $time, name: $name, an: $an)';
  }
}