import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mqtt_dibop/controller/user.dart';
import 'package:mqtt_dibop/model/model.dart';
import 'package:redux/redux.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          String userName = viewModel.user!.name;
          return MainScaffold(menu(), "Welcome, " + userName);
        });
  }

  Widget menu() {
    final String imgPath = 'lib/images/dibop.png';

    void cotrollerButton() {
      Navigator.pushNamed(context, 'controllers');
    }

    void publishButton() {
      Navigator.pushNamed(context, 'publish');
    }

    void videoButton() {
      Navigator.pushNamed(context, 'video');
    }

    void subscribButton() {
      Navigator.pushNamed(context, 'subscribe');
    }

    void startButton() {
      Navigator.pushNamed(context, 'start');
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Image.asset(
                    imgPath, // - padding widget_login_signup
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: botao(
                  'Controller',
                  cotrollerButton,
                ),
              ),
              SizedBox(width: 1.5.w),
              Expanded(
                child: botao(
                  'Publish',
                  publishButton,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: botao(
                  'Video',
                  videoButton,
                ),
              ),
              SizedBox(width: 1.5.w),
              Expanded(
                child: botao(
                  'Subscribe',
                  subscribButton,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 27.w),
                  child: botao(
                    'Start',
                    startButton,
                    fontColor: Theme.of(context).colorScheme.blue,
                    backgroundColor: Theme.of(context).colorScheme.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final User? user;

  _ViewModel({
    required this.user,
  });

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
    );
  }
}
