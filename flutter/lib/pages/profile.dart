import 'package:flutter/material.dart';
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
    return MainScaffold(profile(), "Profile");
  }

  Widget profile() {
    final String imgPath = 'lib/images/no_user.png';

    void saveButton() {
      Navigator.pushNamed(context, 'controllers');
    }

    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();

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
                            ),
                          ],
                        ),
                      ],
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
                      saveButton,
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
