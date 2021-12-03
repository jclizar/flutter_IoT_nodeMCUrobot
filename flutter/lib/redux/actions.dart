import 'package:mqtt_dibop/controller/user.dart';

class SetLogedUser {
  final String name;
  final String email;
  final String password;

  SetLogedUser(this.name, this.email, this.password);
}

class UpdatePassword {
  final String password;

  UpdatePassword(this.password);
}

class LogoutUser {
  final User user;

  LogoutUser(this.user);
}
