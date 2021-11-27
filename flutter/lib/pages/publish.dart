import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';
import 'package:mqtt_dibop/controller/publishItem.dart';
import 'package:mqtt_dibop/controller/mqttServer.dart';
import 'package:mqtt_dibop/controller/utils.dart';

class Publish extends StatefulWidget {
  const Publish({Key? key}) : super(key: key);

  @override
  _PublishState createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  List<PublishItem> publishList = <PublishItem>[];

  Future<void> addPublishItem(int value) async {
    bool status;
    PublishItem publishItem;

    try {
      int newMovement = await MqttServer.publish(value.toString());

      status = newMovement == value;
      publishItem = new PublishItem(value, status);
    } on Exception catch (e) {
      publishItem = new PublishItem(value, false);
      publishItem.setErrorMessage(e.toString());
    }

    FirebaseFirestore.instance
        .collection('publish')
        .add(publishItem.getMapValues())
        .then((value) {})
        .catchError((onError) {});
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      connectMqttServe(new PublishList()),
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
}

class PublishList extends StatefulWidget {
  const PublishList({Key? key}) : super(key: key);

  @override
  _PublishListState createState() => _PublishListState();
}

class _PublishListState extends State<PublishList> {
  // Referenciar a Coleção de Cafés
  late CollectionReference publishList;
  @override
  void initState() {
    super.initState();
    publishList = FirebaseFirestore.instance.collection('publish');
  }

  Widget itemLista(item) {
    var data = item.data();

    PublishItem publishItem = new PublishItem(
      data['value'],
      data['sendStatus'],
      created: data['created_at'],
    );

    publishItem.setErrorMessage(data['error_message']);

    return Card(
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.blue,
      child: ListTile(
        title: Text(
          publishItem.getName(),
          style: TextStyle(fontSize: 11.sp),
        ),

        subtitle: subtitel(publishItem),
        //selecionar item da lista
        hoverColor: Colors.blue.shade100,
      ),
    );
  }

  Widget subtitel(PublishItem publishItem) {
    String createdAt = getDateFormat(publishItem.created);
    Text label = Text("Criado em: $createdAt");

    if (publishItem.errorMessage.isNotEmpty) {
      String errorMessage = publishItem.errorMessage;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label,
          Text("Erro: $errorMessage"),
        ],
      );
    }

    return label;
  }

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder<QuerySnapshot>(
              //fonte de dados (coleção)
              stream: publishList.snapshots(),
              //exibir os dados retornados
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Text('Não foi possível conectar ao Firebase'),
                    );
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    final dados = snapshot.requireData.docs.toList();
                    dados.sort((a, b) =>
                        a['created_at'].compareTo(b['created_at']) * -1);
                    return ListView.builder(
                      itemCount: dados.length,
                      itemBuilder: (context, index) {
                        return itemLista(dados[index]);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
