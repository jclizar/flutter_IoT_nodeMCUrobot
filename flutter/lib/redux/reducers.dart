import 'package:mqtt_dibop/controller/user.dart';
import 'package:mqtt_dibop/redux/actions.dart';
import 'package:mqtt_dibop/model/model.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    user: userReducer(state.user, action),
  );
}

User? userReducer(User? state, action) {
  if (action is SetLogedUser) {
    return User(
      name: action.name,
      email: action.email,
      password: action.password,
    );
  }

  if (action is UpdatePassword) {
    return User(
      name: state!.name,
      email: state.email,
      password: action.password,
    );
  }

  if (action is LogoutUser) {
    return null;
  }

  return state;
}
