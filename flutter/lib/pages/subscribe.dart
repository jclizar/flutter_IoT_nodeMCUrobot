import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/widget_utilities.dart';
import 'package:sizer/sizer.dart';
import 'package:mqtt_dibop/theme.dart';
import 'package:mqtt_dibop/controller/subscribItem.dart';
import 'package:mqtt_dibop/controller/utils.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key}) : super(key: key);

  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      connectMqttServe(new SubscribeList()),
      "Subscribe",
    );
  }
}

class SubscribeList extends StatefulWidget {
  const SubscribeList({Key? key}) : super(key: key);

  @override
  _SubscribeListState createState() => _SubscribeListState();
}

class _SubscribeListState extends State<SubscribeList> {
  // Referenciar a Coleção de Cafés
  late CollectionReference subscribeList;

  List<String> removeListIds = <String>[];

  @override
  void initState() {
    super.initState();
    subscribeList = FirebaseFirestore.instance.collection('subscription');
  }

  void removeItemfromPublishList() {
    if (removeListIds.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No items has been remove"),
        duration: Duration(seconds: 2),
      ));
    }

    for (String id in removeListIds) {
      subscribeList.doc(id).delete().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Items removed"),
          duration: Duration(seconds: 2),
        ));
      }).catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro to remove some items"),
          duration: Duration(seconds: 2),
        ));
      });
    }

    setState(() {
      removeListIds = [];
    });
  }

  Widget itemLista(item) {
    var data = item.data();

    SubscriptionItem subscriptionItem = new SubscriptionItem(
      data['publish_id'],
      data['value'],
      created: data['created_at'],
    );

    String publishStatus =
        subscriptionItem.publishId.isNotEmpty ? "(SEND)" : "(ERROR)";

    String title = "${subscriptionItem.getName()} $publishStatus";

    return Card(
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.blue,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 10.sp),
        ),

        subtitle: Text(getDateFormat(subscriptionItem.created)),

        //selecionar item da lista
        hoverColor: Colors.blue.shade100,
        trailing: new CheckBox(
          checkEvent: () {
            removeListIds.add(item.id);
          },
          uncheckEvent: () {
            removeListIds.remove(item.id);
          },
        ),
      ),
    );
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
                    '0',
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
            child: StreamBuilder<QuerySnapshot>(
              //fonte de dados (coleção)
              stream: subscribeList.snapshots(),
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
