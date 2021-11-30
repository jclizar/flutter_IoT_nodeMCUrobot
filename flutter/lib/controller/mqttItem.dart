import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, int> _movements = {
  "Standby": 1,
  "Forward": 2,
  "Backward": 3,
  "Left shift": 4,
  "Right shift": 5,
  "Turn left": 6,
  "Turn Right": 7,
  "Lay Down": 8,
  "Say Hi": 9,
  "Fighting": 10,
  "Push up": 11,
  "Sleep": 12,
  "Dance1": 13,
  "Dance2": 14,
  "Dance3": 15,
};

class MqttItem {
  int value;
  late Timestamp created;

  String getName() {
    String? name = MqttItem.getMovementName(this.value);

    if (name == null) {
      throw new Exception("No value named");
    }

    return name;
  }

  void getMapValues() {
    new Exception('$this.runtimeType need to implement getMapValues');
  }

  static String? getMovementName(int value) {
    String? name;
    _movements.forEach((key, value) {
      if (value == value) {
        name = key;
      }
    });

    return name;
  }

  MqttItem(this.value, {Timestamp? created}) {
    this.created = created == null ? Timestamp.now() : created;
  }
}
