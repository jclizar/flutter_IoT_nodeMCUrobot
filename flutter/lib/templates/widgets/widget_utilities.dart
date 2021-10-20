import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

Widget botao(
  String rotulo,
  Function()? onPressed, {
  Color fontColor = Colors.white,
  Color backgroundColor = const Color.fromRGBO(19, 43, 155, 1.0),
}) {
  return Container(
    padding: EdgeInsets.only(top: 3.w),
    child: ElevatedButton(
      child: Text(rotulo.toUpperCase()),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15),
          ),
          primary: backgroundColor,
          onPrimary: fontColor,
          padding: EdgeInsets.symmetric(vertical: 2.5.h),
          textStyle: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold)),
    ),
  );
}

Widget inputText(
  String label,
  String hintLabel,
  Color focusColor,
  TextEditingController textController, {
  Color borderColor = Colors.white,
}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.only(bottom: 3.5.h),
      //height: 7.0.h,
      //Change the default border color of TextFormField in FLUTTER
      //https://stackoverflow.com/questions/56730412/change-the-default-border-color-of-textformfield-in-flutter
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          hintText: hintLabel,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: borderColor,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: focusColor,
              width: 2.0,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 12.5.sp,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

class MainScaffold extends StatefulWidget {
  const MainScaffold(
    this.body,
    this.title, {
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final Widget body;
  final String title;
  final void Function()? onPressed;

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  PageController pageController = PageController();
  int screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    FloatingActionButton? floatingActionButton;
    if (widget.onPressed != null) {
      floatingActionButton = FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        child: Icon(Icons.add),
        onPressed: widget.onPressed,
      );
    }

    return Scaffold(
      //Side Menu: https://maffan.medium.com/how-to-create-a-side-menu-in-flutter-a2df7833fdfb
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(251, 160, 24, 1),
        automaticallyImplyLeading: true,
      ),
      body: widget.body,
      backgroundColor: Colors.white,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(251, 160, 24, 1),
        iconSize: 8.w,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedFontSize: 16,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        onTap: (index) {
          String screen = index == 0 ? 'start' : 'menu';
          Navigator.pushNamedAndRemoveUntil(context, screen, (r) => false);
        },
      ),
    );
  }
}

Widget title(String text, {Color titleColo: Colors.black}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Text(
        text,
        style: TextStyle(
          color: titleColo,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DrawerHeader(
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(251, 160, 24, 1),
                    image: DecorationImage(
                      scale: 0.6.w,
                      image: AssetImage('lib/images/no_user.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.gamepad),
                  title: Text('Controller'),
                  onTap: () => {Navigator.pushNamed(context, 'controllers')},
                ),
                ListTile(
                  leading: Icon(Icons.video_collection_rounded),
                  title: Text('Video'),
                  onTap: () => {Navigator.pushNamed(context, 'video')},
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Publish'),
                  onTap: () => {Navigator.pushNamed(context, 'publish')},
                ),
                ListTile(
                  leading: Icon(Icons.import_contacts_rounded),
                  title: Text('Subscribe'),
                  onTap: () => {Navigator.pushNamed(context, 'subscribe')},
                ),
                ListTile(
                  leading: Icon(Icons.play_circle),
                  title: Text('Start'),
                  onTap: () => {Navigator.pushNamed(context, 'start')},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () => {Navigator.pushNamed(context, 'profile')},
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => {Navigator.pushNamed(context, 'menu')},
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () => {Navigator.pushNamed(context, 'about')},
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Dialog Widget with Radio Button: https://gist.github.com/jonahwilliams/25fa99b6b73fdcbd58ac85585343bbd0
class PublishListWidget extends StatefulWidget {
  const PublishListWidget(this.sendAction, {Key? key}) : super(key: key);

  final void Function(int value) sendAction;

  @override
  _PublishListWidgetState createState() => _PublishListWidgetState();
}

class _PublishListWidgetState extends State<PublishListWidget> {
  int? publishAction;

  void setpublishAction(int? value) {
    setState(() {
      publishAction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Standby'),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Backward'),
                  leading: Radio<int>(
                    value: 3,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Left shift'),
                  leading: Radio<int>(
                    value: 4,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Right shift'),
                  leading: Radio<int>(
                    value: 5,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Turn left'),
                  leading: Radio<int>(
                    value: 6,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Turn Right'),
                  leading: Radio<int>(
                    value: 7,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Lie'),
                  leading: Radio<int>(
                    value: 8,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Say Hi'),
                  leading: Radio<int>(
                    value: 9,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Fighting'),
                  leading: Radio<int>(
                    value: 10,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Push up'),
                  leading: Radio<int>(
                    value: 11,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Sleep'),
                  leading: Radio<int>(
                    value: 12,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Dance1'),
                  leading: Radio<int>(
                    value: 13,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Dance2'),
                  leading: Radio<int>(
                    value: 14,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
                ListTile(
                  title: const Text('Dance3'),
                  leading: Radio<int>(
                    value: 15,
                    groupValue: publishAction,
                    onChanged: setpublishAction,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          child: Text('send'),
          onPressed: () {
            String msg = "Action sent!";

            if (publishAction == null) {
              msg = "Choose an action to send";
            } else {
              widget.sendAction(publishAction!);
            }

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(msg),
              duration: Duration(seconds: 2),
            ));
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('cancel'),
          onPressed: () {
            setState(() {
              publishAction = null;
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({this.checkEvent, this.uncheckEvent, Key? key})
      : super(key: key);
  final Function()? checkEvent;
  final Function()? uncheckEvent;
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Theme.of(context).colorScheme.blue;
      }
      return Theme.of(context).colorScheme.orange;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: this.isChecked,
      onChanged: (bool? value) {
        setState(() {
          this.isChecked = value!;
        });
        if (widget.checkEvent != null && this.isChecked) {
          widget.checkEvent!();
        }

        if (widget.uncheckEvent != null && !this.isChecked) {
          widget.uncheckEvent!();
        }
      },
    );
  }
}

Widget controlButton(Widget label, Function() onPressed,
    {Color fontColor = Colors.white,
    Color backgroundColor = const Color.fromRGBO(19, 43, 155, 1.0),
    double width = 10,
    double height = 10,
    bool isCircular = false,
    double borderRadio = 15}) {
  OutlinedBorder shape = isCircular
      ? CircleBorder()
      : RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(borderRadio),
        );

  return Container(
    width: width,
    height: height,
    child: ElevatedButton(
      child: label,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        shape: shape,
        primary: backgroundColor,
        onPrimary: fontColor,
        textStyle: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
