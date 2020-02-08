import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UserData.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: MyAppBar(title: 'Checkout'),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Items'),
            ListView(
              children: userData.getCart().map((Product product) {
                return Text('$product');
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
