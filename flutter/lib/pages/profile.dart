import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mqtt_dibop/controller/user.dart' as userController;
import 'package:mqtt_dibop/model/model.dart';
import 'package:mqtt_dibop/redux/actions.dart';
import 'package:redux/redux.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => MainScaffold(
        profile(viewModel),
        "Profile",
      ),
    );
  }

  Widget profile(_ViewModel model) {
    final String imgPath = 'lib/images/no_user.png';

    TextEditingController name = TextEditingController(text: model.user!.name);
    TextEditingController email =
        TextEditingController(text: model.user!.email);
    TextEditingController password =
        TextEditingController(text: model.user!.password);
    TextEditingController confirmPassword =
        TextEditingController(text: model.user!.password);

    var formKey = GlobalKey<FormState>();

    void saveButton(_ViewModel model) {
      if (formKey.currentState!.validate()) {
        String msg = "User updated!";

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          user.updatePassword(password.text).then((value) {
            model.onUpdatePassword(password.text);
          }).catchError((onError) {
            msg = "Error to update user!";
          });
        } else {
          Navigator.pushNamed(context, 'login');
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text(msg),
                duration: const Duration(seconds: 2),
              ),
            )
            .closed
            .then((SnackBarClosedReason closedReason) {
          if (closedReason == SnackBarClosedReason.timeout) {}
        });
      }
    }

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8.h, bottom: 2.h),
                  child: Image.asset(
                    imgPath,
                    width: 38.w,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'menu', (r) => false);
                    },
                    child: Text(
                      "Change Image",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              inputText(
                                'Name',
                                'Your Name',
                                Theme.of(context).colorScheme.blue,
                                name,
                                borderColor: Colors.grey.shade300,
                                enabled: false,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              inputText(
                                'Email',
                                'your@email.com',
                                Theme.of(context).colorScheme.blue,
                                email,
                                borderColor: Colors.grey.shade300,
                                enabled: false,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              inputText(
                                'New Password',
                                'New Password',
                                Theme.of(context).colorScheme.blue,
                                password,
                                borderColor: Colors.grey.shade300,
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
                                'Confirm Password',
                                Theme.of(context).colorScheme.blue,
                                confirmPassword,
                                borderColor: Colors.grey.shade300,
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
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 29.w),
                    child: botao(
                      'save',
                      () {
                        saveButton(model);
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class _ViewModel {
  final userController.User? user;
  final Function(String) onUpdatePassword;

  _ViewModel({
    required this.user,
    required this.onUpdatePassword,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onUpdatePassword(String password) {
      store.dispatch(UpdatePassword(password));
    }

    return _ViewModel(
      user: store.state.user,
      onUpdatePassword: _onUpdatePassword,
    );
  }
}
