import 'package:flutter/material.dart';
import './routes.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:mqtt_dibop/model/model.dart';
import 'package:mqtt_dibop/redux/reducers.dart';

//How to make flutter app responsive according to different screen size?
//https://stackoverflow.com/questions/49704497/how-to-make-flutter-app-responsive-according-to-different-screen-size
//https://www.youtube.com/watch?v=FqBdCPwf24Q

void main() {
  runApp(
    // The MaterialApp configures the top-level Navigator to search for routes in the following order: https://api.flutter.dev/flutter/material/MaterialApp-class.html
    Sizer(
      builder: (context, orientation, deviceType) {
        final Store<AppState> store = Store<AppState>(
          appStateReducer,
          initialState: AppState.initialState(),
        );

        // Redux: https://www.youtube.com/watch?v=Wj216eSBBWs&ab_channel=TensorProgramming
        return StoreProvider<AppState>(
          store: store,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dibop | Login - Sign Up',
            initialRoute: 'loginSignUp',
            routes: routes,
          ),
        );
      },
    ),
  );
}
