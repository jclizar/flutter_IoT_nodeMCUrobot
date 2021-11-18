import 'package:flutter/material.dart';
import 'widgets/widget_login_signup.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

// https://medium.com/flutter-community/flutter-visual-studio-code-shortcuts-for-fast-and-efficient-development-7235bc6c3b7d
// stful -> Flutter Stateful Widget -> type ClassName

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  @override
  Widget build(BuildContext context) {
    final logoColor = Theme.of(context).colorScheme.blue;
    final backgroundColor = Colors.white;
    return ModelLoginSignup(
      logoColor,
      backgroundColor,
      formLoginSignUp(context),
    );
  }

  Widget formLoginSignUp(context) {
    void singUpButton() {
      Navigator.pushNamedAndRemoveUntil(context, 'signUp', (r) => false);
    }

    void loginButton() {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (r) => false);
    }

    final String imgPath = 'lib/images/dibop.png';
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17.5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 9.h),
              child: Image.asset(
                imgPath,
                width: 45.w, // - padding widget_login_signup
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: botao('sing up', singUpButton),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: botao('login', loginButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
