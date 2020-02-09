import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UserData.dart';

class OrderListScreen extends StatefulWidget {
  static const String id = 'order_list_screen';
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<String> orderStatuses = ['Waiting Confirmation', 'Shipped'];

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    bool isAdmin = userData.isAdmin;

    return Scaffold(
      appBar: MyAppBar(
        title: isAdmin ? 'Order List' : 'My Orders',
      ),
      drawer: MyDrawer(isAdmin),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: isAdmin
                  ? Firestore.instance
                      .collection('orders')
                      .orderBy('time', descending: true)
                      .snapshots()
                  : Firestore.instance
                      .collection('orders')
                      .orderBy('time', descending: true)
                      .where('user_id', isEqualTo: userData.id)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('An Error Occured'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final orderSnapshot = snapshot.data.documents;

                List<Container> containerList = [];

                for (var order in orderSnapshot) {
                  List<String> items = order['items'].toString().split('.');
                  var orderStatus = order['order_status'];

                  Container singleContainer = Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FittedBox(
                              child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Order ID',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        FittedBox(child: Text(order.documentID))
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Items',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ...items.map((item) {
                                  return Text(item);
                                }).toList(),
                              ]),
                            ),
                            isAdmin
                                ? Container(
                                    padding: EdgeInsets.all(8),
                                    color: Colors.yellow,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Order Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        DropdownButton<String>(
                                          value: orderStatus,
                                          onChanged: (value) {
                                            Firestore.instance
                                                .collection('orders')
                                                .document(order.documentID)
                                                .updateData(
                                                    {'order_status': value});
                                          },
                                          items: orderStatuses
                                              .map((String status) {
                                            print('Status $status');
                                            return DropdownMenuItem<String>(
                                              value: status,
                                              child: Text(status),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: <Widget>[
                                      Text(
                                        'Order Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(orderStatus),
                                    ],
                                  )
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        )
                      ],
                    ),
                  );

                  containerList.add(singleContainer);
                }

                return SingleChildScrollView(
                  child: Column(
                    children: containerList,
                  ),
                );
              })),
    );
  }
}
