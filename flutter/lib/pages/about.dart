import 'package:flutter/material.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(about(), "About");
  }

  Widget develop(String name, String imagePath) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            child: Image.asset(
              imagePath,
              width: 28.w,
            ),
          ),
          RichText(
            text: TextSpan(
              text: name,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget about() {
    final Color titlecolor = Theme.of(context).colorScheme.blue;

    return Container(
      padding: EdgeInsets.all(13.w),
      child: Column(
        children: [
          Row(
            children: [
              title(
                "Theme",
                titleColo: titlecolor,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    "Microcontroller and IoT.",
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
              title(
                "Objectives",
                titleColo: titlecolor,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                // Format text: https://api.flutter.dev/flutter/widgets/RichText-class.html
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:
                          'The Dibop app aims to control an open source code ',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'R1 quadruped mg90s NodeMCU robot ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'using IoT in an intuitivefun experience.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              title(
                "Developers",
                titleColo: titlecolor,
              ),
            ],
          ),
          Row(
            children: [
              develop(
                "Jéssica Lizar",
                'lib/images/developer_jessica.png',
              ),
              SizedBox(width: 5.w),
              develop(
                "Hugo Menegasse",
                'lib/images/developer_hugo.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
