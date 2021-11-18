import 'package:flutter/material.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';
import 'package:mqtt_dibop/controller/publishItem.dart';

class Publish extends StatefulWidget {
  const Publish({Key? key}) : super(key: key);

  @override
  _PublishState createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  List<PublishItem> publishList = <PublishItem>[];

  void addPublishItem(int value) {
    setState(() {
      PublishItem publishItem = new PublishItem(value);
      publishList.add(publishItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      publish(),
      "Publish",
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return new PublishListWidget(
                addPublishItem,
              );
            });
      },
    );
  }

  Widget publish() {
    final Color titlecolor = Theme.of(context).colorScheme.blue;

    return Container(
      padding: EdgeInsets.all(13.w),
      child: Column(
        children: [
          Row(
            children: [
              title(
                "MQTT Broker",
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
                    "mqtt.eclipseprojects.io",
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              title(
                "Publish",
                titleColo: titlecolor,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: this.publishList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  shadowColor: Theme.of(context).colorScheme.blue,
                  child: ListTile(
                    title: Text(
                      this.publishList[index].getName(),
                      style: TextStyle(fontSize: 10.sp),
                    ),

                    subtitle: Text(this.publishList[index].created.toString()),

                    //selecionar item da lista
                    hoverColor: Colors.blue.shade100,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
