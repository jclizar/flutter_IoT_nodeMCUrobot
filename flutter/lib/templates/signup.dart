import 'package:flutter/material.dart';
import 'widgets/widget_login_signup.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final logoColor = Theme.of(context).colorScheme.blue;
    final backgroundColor = Theme.of(context).colorScheme.orange;

    return Scaffold(
      body: ModelLoginSignup(
        logoColor,
        backgroundColor,
        formSignUp(context, logoColor),
      ),
    );
  }

  Widget formSignUp(BuildContext context, Color textColor) {
    void menuButton() {
      Navigator.pushNamedAndRemoveUntil(context, 'menu', (r) => false);
    }

    var name = TextEditingController();
    var email = TextEditingController();
    var password = TextEditingController();
    var confirmPassword = TextEditingController();

    var formKey = GlobalKey<FormState>();

    return Expanded(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            inputText('Name', 'Your Name', textColor, name),
                          ],
                        ),
                        Row(
                          children: [
                            inputText(
                                'E-mail', 'email@email.com', textColor, email),
                          ],
                        ),
                        Row(
                          children: [
                            inputText('Password', '', textColor, password),
                          ],
                        ),
                        Row(
                          children: [
                            inputText('Confirm Password', '', textColor,
                                confirmPassword),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                //metodo de navegação que não utilize a pilha de telas
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'login', (r) => false);
                              },
                              child: Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
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
                    child: botao("sign up", menuButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
