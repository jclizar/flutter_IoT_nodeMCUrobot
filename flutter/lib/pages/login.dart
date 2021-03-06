import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mqtt_dibop/model/model.dart';
import 'package:mqtt_dibop/redux/actions.dart';
import 'package:redux/redux.dart';
import 'widgets/widget_login_signup.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';
import 'package:mqtt_dibop/controller/user.dart' as userController;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final logoColor = Theme.of(context).colorScheme.orange;
    final backgroundLogoColor = Theme.of(context).colorScheme.blue;
    final fontColor = Theme.of(context).colorScheme.blue;
    final backgroundColor = Theme.of(context).colorScheme.orange;

    var formKey = GlobalKey<FormState>();

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      body: ModelLoginSignup(
        logoColor,
        backgroundLogoColor,
        StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => Expanded(
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
                                      logoColor,
                                      email,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    inputText(
                                      'Password',
                                      '',
                                      logoColor,
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
                                          //metodo de navega????o que n??o utilize a pilha de telas
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'loginSignUp',
                                              (r) => false);
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: logoColor,
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
                              () {
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text)
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    var userDoc = querySnapshot.docs.firstWhere(
                                        (user) => user['email'] == email.text);

                                    viewModel.onSetLogedUser(userDoc['name'],
                                        email.text, password.text);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, 'menu', (r) => false);
                                  }).catchError((erro) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'ERRO: Usu??rio n??o encontrado'),
                                            duration:
                                                const Duration(seconds: 2)));
                                  });
                                });
                              },
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
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final userController.User? user;
  final Function(String, String, String) onSetLogedUser;

  _ViewModel({
    required this.user,
    required this.onSetLogedUser,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onSetLogedUser(String name, String email, String password) {
      store.dispatch(SetLogedUser(name, email, password));
    }

    return _ViewModel(
      user: store.state.user,
      onSetLogedUser: _onSetLogedUser,
    );
  }
}
