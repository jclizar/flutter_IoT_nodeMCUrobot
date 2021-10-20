import 'package:flutter/material.dart';
import 'widgets/widget_login_signup.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final logoColor = Theme.of(context).colorScheme.orange;
    final backgroundColor = Theme.of(context).colorScheme.blue;

    return Scaffold(
      body: ModelLoginSignup(
        logoColor,
        backgroundColor,
        formLogin(logoColor),
      ),
    );
  }

  Widget formLogin(Color textColor) {
    void menuButton() {
      Navigator.pushNamedAndRemoveUntil(context, 'menu', (r) => false);
    }

    final fontColor = Theme.of(context).colorScheme.blue;
    final backgroundColor = Theme.of(context).colorScheme.orange;

    var email = TextEditingController();
    var password = TextEditingController();

    var formKey = GlobalKey<FormState>();

    return Expanded(
      child: Form(
        key: formKey,
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 13.5.h),
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              inputText('E-mail', 'email@email.com', textColor,
                                  email),
                            ],
                          ),
                          Row(
                            children: [
                              inputText('Password', '', textColor, password),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 4.h),
                                child: TextButton(
                                  onPressed: () {
                                    //metodo de navegação que não utilize a pilha de telas
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, 'loginSignUp', (r) => false);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 17.5.w),
                      child: botao(
                        "login",
                        menuButton,
                        fontColor: fontColor,
                        backgroundColor: backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
