import 'package:flutter/material.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  //String gifPath = 'assets/1.gif';

  @override
  Widget build(BuildContext context) {
    return MainScaffold(new VideoContainer(), "Moviments");
  }
}

class VideoContainer extends StatefulWidget {
  const VideoContainer({Key? key}) : super(key: key);

  @override
  _VideoContainerState createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  String gifPath = 'assets/1.gif';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 65.w,
                margin: EdgeInsets.symmetric(vertical: 3.h),
                child: Image.asset(
                  gifPath,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: botao(
                            'Push up',
                            () {
                              setState(() {
                                gifPath = 'assets/11.gif';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Say Hi',
                            () {
                              setState(() {
                                gifPath = 'assets/9.gif';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Fighting',
                            () {
                              setState(() {
                                gifPath = 'assets/10.gif';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Lay',
                            () {
                              setState(() {
                                gifPath = 'assets/8.gif';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: botao(
                            'Dance 1',
                            () {
                              setState(() {
                                gifPath = 'assets/13.gif';
                              });
                            },
                            fontColor: Theme.of(context).colorScheme.blue,
                            backgroundColor:
                                Theme.of(context).colorScheme.orange,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: botao(
                            'Dance 2',
                            () {
                              setState(() {
                                gifPath = 'assets/14.gif';
                              });
                            },
                            fontColor: Theme.of(context).colorScheme.blue,
                            backgroundColor:
                                Theme.of(context).colorScheme.orange,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: botao(
                            'Dance 3',
                            () {
                              setState(() {
                                gifPath = 'assets/15.gif';
                              });
                            },
                            fontColor: Theme.of(context).colorScheme.blue,
                            backgroundColor:
                                Theme.of(context).colorScheme.orange,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: botao(
                            'Left shift',
                            () {
                              setState(() {
                                gifPath = 'assets/4.gif';
                              });
                            },
                            backgroundColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Foward',
                            () {
                              setState(() {
                                gifPath = 'assets/2.gif';
                              });
                            },
                            backgroundColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Backward',
                            () {
                              setState(() {
                                gifPath = 'assets/3.gif';
                              });
                            },
                            backgroundColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Right shift',
                            () {
                              setState(() {
                                gifPath = 'assets/5.gif';
                              });
                            },
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: botao(
                            'Turn left',
                            () {
                              setState(() {
                                gifPath = 'assets/6.gif';
                              });
                            },
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Standby',
                            () {
                              setState(() {
                                gifPath = 'assets/1.gif';
                              });
                            },
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Sleep',
                            () {
                              setState(() {
                                gifPath = 'assets/12.gif';
                              });
                            },
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: botao(
                            'Turn right',
                            () {
                              setState(() {
                                gifPath = 'assets/7.gif';
                              });
                            },
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
