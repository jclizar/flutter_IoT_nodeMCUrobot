import 'package:flutter/material.dart';
import 'package:mqtt_dibop/templates/subscribe.dart';
import 'templates/login.dart';
import 'templates/login_signup.dart';
import 'templates/signup.dart';
import 'templates/menu.dart';
import 'templates/profile.dart';
import 'templates/about.dart';
import 'templates/publish.dart';
import 'templates/video.dart';
import 'templates/control.dart';
import 'templates/controllers.dart';

final routes = <String, WidgetBuilder>{
  'loginSignUp': (context) => const LoginSignUp(),
  'signUp': (context) => const SignUp(),
  'login': (context) => const Login(),
  'menu': (context) => const Menu(),
  'profile': (context) => const Profile(),
  'about': (context) => const About(),
  'publish': (context) => const Publish(),
  'video': (context) => const Video(),
  'subscribe': (context) => const Subscribe(),
  'start': (context) => const Control(),
  'controllers': (context) => const ControllerSettings(),
};
