import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_dibop/controller/mqttItem.dart';
import 'package:mqtt_dibop/controller/mqttServer.dart';

class PublishItem extends MqttItem {
  bool? sendStatus;
  late String errorMessage;

  void setErrorMessage(String message) {
    this.errorMessage = message;
  }

  Map<String, dynamic> getMapValues() {
    return <String, dynamic>{
      'value': this.value,
      'created_at': this.created,
      'sendStatus': this.sendStatus,
      'error_message': this.errorMessage,
    };
  }

  PublishItem(int value, this.sendStatus,
      {Timestamp? created, String? errorMensage})
      : super(value, created: created) {
    this.errorMessage = errorMensage == null ? "" : errorMessage;
  }

  static Future<void> publishValue(int value) async {
    bool status;
    PublishItem publishItem;

    try {
      int newMovement = await MqttServer.publish(value.toString());

      status = newMovement == value;
      publishItem = new PublishItem(value, status);
    } on Exception catch (e) {
      publishItem = new PublishItem(value, false);
      publishItem.setErrorMessage(e.toString());
    }

    FirebaseFirestore.instance
        .collection('publish')
        .add(publishItem.getMapValues())
        .then((value) {})
        .catchError((onError) {});
  }
}
