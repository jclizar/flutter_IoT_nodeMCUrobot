import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    var name = TextEditingController();
    var email = TextEditingController();
    var password = TextEditingController();
    var confirmPassword = TextEditingController();

    var formKey = GlobalKey<FormState>();

    //
    // CRIAR CONTA no Firebase Auth
    //
    void signup() {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        )
            .then((value) {
          if (name.text.isNotEmpty) {
            FirebaseFirestore.instance.collection('usuarios').add({
              'email': email.text,
              'name': name.text,
            });
          }
          Navigator.pushNamedAndRemoveUntil(context, 'menu', (r) => false);
        }).catchError((erro) {
          String message = "";
          if (erro.code == 'email-already-in-use') {
            message = 'ERRO: O email informado já está em uso.';
          } else {
            message = 'ERRO: ${erro.message}';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ),
          );
        });
      }
    }

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
                              'E-mail',
                              'email@email.com',
                              textColor,
                              email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'The email field is required';
                                }

                                return null;
                              },
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
                              validator: (value) {
                                if (value!.length < 8) {
                                  return 'The minimal password length is 8';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            inputText(
                              'Confirm Password',
                              '',
                              textColor,
                              confirmPassword,
                              isPassword: true,
                              validator: (value) {
                                if (value!.length < 8) {
                                  return 'The minimal password length is 8';
                                }

                                if (value != password.text) {
                                  return 'The field Password and Confirm Password need to be equal';
                                }

                                return null;
                              },
                            ),
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
                    child: botao("sign up", signup),
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
