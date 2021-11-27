import 'package:flutter/material.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';
import 'package:mqtt_dibop/controller/publishItem.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key}) : super(key: key);

  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  List<PublishItem> publishList = <PublishItem>[];

  List<PublishItem> removeList = <PublishItem>[];

  @override
  void initState() {
    publishList.add(PublishItem(2, true));
    publishList.add(PublishItem(3, false));
    publishList.add(PublishItem(8, true));
    super.initState();
  }

  void removeItemfromPublishList() {
    int countRemovedItems = removeList.length;

    setState(() {
      publishList.removeWhere((element) => removeList.contains(element));
      removeList = [];
    });

    String msg = countRemovedItems == 0
        ? "No items has been remove"
        : "$countRemovedItems items removed";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      subscribe(),
      "Subscribe",
    );
  }

  Widget subscribe() {
    final Color titlecolor = Theme.of(context).colorScheme.blue;

    return Container(
      padding: EdgeInsets.all(13.w),
      child: Column(
        children: [
          Row(
            children: [
              title(
                'Lost Messages',
                titleColo: titlecolor,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    publishList
                        .where((element) => element.sendStatus == false)
                        .length
                        .toString(),
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              title(
                'Subscribe History',
                titleColo: titlecolor,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: publishList.length,
              itemBuilder: (context, index) {
                PublishItem item = publishList[index];
                String publishStatus = '';

                if (item.sendStatus == true) {
                  publishStatus = "(SENT)";
                }

                if (item.sendStatus == false) {
                  publishStatus = "(ERROR)";
                }

                String title = "${item.getName()} $publishStatus";

                return Card(
                  elevation: 1,
                  shadowColor: Theme.of(context).colorScheme.blue,
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(fontSize: 10.sp),
                    ),

                    subtitle: Text(item.created.toString()),

                    //selecionar item da lista
                    hoverColor: Colors.blue.shade100,
                    trailing: new CheckBox(
                      checkEvent: () {
                        removeList.add(item);
                      },
                      uncheckEvent: () {
                        removeList.remove(item);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: botao(
                    'clear',
                    removeItemfromPublishList,
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
