import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

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
    final fontColor = Theme.of(context).colorScheme.blue;
    final backgroundColor = Theme.of(context).colorScheme.orange;

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    var formKey = GlobalKey<FormState>();

    //
    // LOGIN com Firebase Auth
    //
    void login() {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        print(value);
        Navigator.pushNamedAndRemoveUntil(context, 'menu', (r) => false);
      }).catchError((erro) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('ERRO: Usuário não encontrado'),
            duration: const Duration(seconds: 2)));
      });
    }

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
                              inputText(
                                'E-mail',
                                'email@email.com',
                                textColor,
                                email,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              inputText(
                                'Password',
                                '',
                                textColor,
                                password,
                                isPassword: true,
                              ),
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
                        login,
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
