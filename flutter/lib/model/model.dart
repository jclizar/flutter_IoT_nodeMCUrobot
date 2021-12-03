import 'package:mqtt_dibop/controller/user.dart';

class AppState {
  final User? user;

  AppState({
    required this.user,
  });

  AppState.initialState() : user = null;
}
