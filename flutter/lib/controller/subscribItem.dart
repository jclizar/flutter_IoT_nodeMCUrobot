import 'package:mqtt_dibop/controller/mqttItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionItem extends MqttItem {
  String publishId;

  Map<String, dynamic> getMapValues() {
    return <String, dynamic>{
      'value': this.value,
      'created_at': this.created,
      'publish_id': this.publishId,
    };
  }

  SubscriptionItem(this.publishId, int value, {Timestamp? created})
      : super(value, created: created);
}
