import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'widgets/widget_utilities.dart';
import 'package:mqtt_dibop/theme.dart';

class ControllerSettings extends StatefulWidget {
  const ControllerSettings({Key? key}) : super(key: key);

  @override
  _ControllerSettingsState createState() => _ControllerSettingsState();
}

class _ControllerSettingsState extends State<ControllerSettings> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImg = 'lib/images/controller.svg';

    return Stack(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(2.5.h),
          width: 100.h,
          height: 100.w,
          child: SvgPicture.asset(
            backgroundImg,
            semanticsLabel: 'backgroundSetting',
          ),
        ),
        Positioned(
          top: 84.537037037.w,
          left: 90.78125.h,
          child: controlButton(
            Icon(Icons.home),
            () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              Navigator.pushNamedAndRemoveUntil(context, 'menu', (r) => false);
            },
            width: 6.71875.h,
            height: 11.944444444.w,
            backgroundColor: Theme.of(context).colorScheme.orange,
            isCircular: true,
          ),
        ),
      ],
    );
  }
}
