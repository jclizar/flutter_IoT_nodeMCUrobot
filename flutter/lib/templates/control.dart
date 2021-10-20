import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'widgets/widget_utilities.dart';
import 'dart:math' as math;

class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
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

  /// Mutiplicar as proporções de cada widget por 1.86
  @override
  Widget build(BuildContext context) {
    final String backgroundImg = 'lib/images/background_controller.svg';

    // Stack Widget: https://medium.com/flutterdevs/stack-and-positioned-widget-in-flutter-3d1a7b30b09a
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            10.364583333.h,
            7.222222222.w,
            10.317708333.h,
            7.227777778.w,
          ),
          color: Colors.white,
          width: 100.h,
          height: 100.w,
          child: SvgPicture.asset(
            backgroundImg,
            semanticsLabel: 'background',
          ),
        ),
        Positioned(
          top: 29.783333333.w,
          left: 60.8.h,
          child: controlButton(
            Text('1'),
            () {},
            width: 5.328125.h,
            height: 9.472222222.w,
            backgroundColor: Theme.of(context).colorScheme.orange,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 29.783333333.w,
          left: 81.7.h,
          child: controlButton(
            Text('2'),
            () {},
            width: 5.328125.h,
            height: 9.472222222.w,
            backgroundColor: Theme.of(context).colorScheme.orange,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 68.533333333.w,
          left: 81.7.h,
          child: controlButton(
            Text('3'),
            () {},
            width: 5.328125.h,
            height: 9.472222222.w,
            backgroundColor: Theme.of(context).colorScheme.orange,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 34.433333333.w,
          left: 70.5.h,
          child: controlButton(
            Text('P'),
            () {},
            width: 7.265625.h,
            height: 12.916666667.w,
            backgroundColor: Theme.of(context).colorScheme.blue,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 60.266666667.w,
          left: 70.5.h,
          child: controlButton(
            Text('F'),
            () {},
            width: 7.265625.h,
            height: 12.916666667.w,
            backgroundColor: Theme.of(context).colorScheme.blue,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 47.35.w,
          left: 63.5.h,
          child: controlButton(
            Text('H'),
            () {},
            width: 7.265625.h,
            height: 12.916666667.w,
            backgroundColor: Theme.of(context).colorScheme.blue,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 47.35.w,
          left: 77.3.h,
          child: controlButton(
            Text('L'),
            () {},
            width: 7.265625.h,
            height: 12.916666667.w,
            backgroundColor: Theme.of(context).colorScheme.blue,
            isCircular: true,
          ),
        ),
        Positioned(
          top: 8.944444444.w,
          left: 19.h,
          child: controlButton(
            Text('L'),
            () {},
            width: 15.h,
            height: 12.916666667.w,
            fontColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
        Positioned(
          top: 8.944444444.w,
          left: 66.40625.h,
          child: controlButton(
            Text('R'),
            () {},
            width: 15.h,
            height: 12.916666667.w,
            fontColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
        Positioned(
          top: 79.727777778.w,
          left: 43.h,
          child: controlButton(
            Text(''),
            () {},
            width: 6.296875.h,
            height: 4.305555556.w,
            backgroundColor: Colors.black,
          ),
        ),
        Positioned(
          top: 79.727777778.w,
          left: 52.7.h,
          child: controlButton(
            Text(''),
            () {},
            width: 6.296875.h,
            height: 4.305555556.w,
            backgroundColor: Colors.black,
          ),
        ),
        Positioned(
          top: 48.7.w,
          left: 29.5.h,
          child: controlButton(
            Icon(
              Icons.arrow_right_outlined,
              textDirection: TextDirection.ltr,
              size: 12.5.w,
            ),
            () {},
            width: 7.265625.h,
            height: 11.194444444.w,
            backgroundColor: Colors.black,
            borderRadio: 5,
          ),
        ),
        Positioned(
          top: 58.796296296.w,
          left: 23.6.h,
          child: controlButton(
            Transform.rotate(
              angle: 90 * math.pi / 180,
              child: Icon(
                Icons.arrow_right_outlined,
                textDirection: TextDirection.ltr,
                size: 12.5.w,
              ),
            ),
            () {},
            width: 11.194444444.w,
            height: 7.265625.h,
            backgroundColor: Colors.black,
            borderRadio: 5,
          ),
        ),
        Positioned(
          top: 48.7.w,
          left: 16.5.h,
          child: controlButton(
            Container(
              child: Icon(
                Icons.arrow_right_outlined,
                textDirection: TextDirection.rtl,
                size: 12.5.w,
              ),
            ),
            () {},
            width: 7.265625.h,
            height: 11.194444444.w,
            backgroundColor: Colors.black,
            borderRadio: 5,
          ),
        ),
        Positioned(
          top: 36.111111111.w,
          left: 23.6.h,
          child: controlButton(
            Transform.rotate(
              angle: 270 * math.pi / 180,
              child: Icon(
                Icons.arrow_right_outlined,
                textDirection: TextDirection.ltr,
                size: 12.5.w,
              ),
            ),
            () {},
            width: 11.194444444.w,
            height: 7.265625.h,
            backgroundColor: Colors.black,
            borderRadio: 5,
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
