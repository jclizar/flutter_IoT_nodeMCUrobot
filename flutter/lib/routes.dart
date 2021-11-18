import 'package:flutter/material.dart';
import 'package:mqtt_dibop/pages/subscribe.dart';
import 'pages/login.dart';
import 'pages/login_signup.dart';
import 'pages/signup.dart';
import 'pages/menu.dart';
import 'pages/profile.dart';
import 'pages/about.dart';
import 'pages/publish.dart';
import 'pages/video.dart';
import 'pages/control.dart';
import 'pages/controllers.dart';

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
