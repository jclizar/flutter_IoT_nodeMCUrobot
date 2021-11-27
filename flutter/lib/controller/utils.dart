import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getDateFormat(Timestamp timeStamp) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(timeStamp.toDate());
}
