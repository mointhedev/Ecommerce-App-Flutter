import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/models/UserProduct.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../UserData.dart';
import '../constants.dart';

class CheckoutScreen extends StatefulWidget {
  List<Product> cartProducts;

  CheckoutScreen(this.cartProducts);
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String itemListString = '';
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    widget.cartProducts.forEach((product) {
      itemListString =
          itemListString + '${product.title}x${product.totalQuantity}.';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: MyAppBar(title: 'Checkout'),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Items: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: widget.cartProducts.map((Product product) {
                        return Text(
                            '${product.title} x ${product.totalQuantity}');
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Shipping Address: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${userData.address}'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {},
                child: Text('Change Address'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Payment Method: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(value: true, groupValue: true, onChanged: (_) {}),
                  Text('Cash On Delivery'),
                  Radio(value: true, groupValue: false, onChanged: (_) {}),
                  Text('Bank'),
                ],
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Total: \$${userData.getTotal(widget.cartProducts)}'),
                  RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Firestore.instance.collection('orders').add({
                        'user_id': userData.id,
                        'order_status': 'Waiting Confirmation',
                        'items': itemListString,
                        'payment_method': 'Cash On Delivery',
                        "time": FieldValue.serverTimestamp(),
                        'total_amount': double.parse(
                            userData.getTotal(widget.cartProducts)),
                        'shipping_address': userData.address,
                      }).then((_) {
                        setState(() {
                          _isLoading = false;
                        });

                        Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.id);
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text('Order Placed !'),
                          actions: [
                            //okButton,
                          ],
                        );

                        Firestore.instance
                            .collection('users')
                            .document(userData.id)
                            .collection('cart')
                            .getDocuments()
                            .then((snapshot) {
                          for (DocumentSnapshot ds in snapshot.documents) {
                            ds.reference.delete();
                          }
                        }).then((_) {
                          setState(() {
                            _isLoading = false;
                          });
                          userData.refreshCart();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return alert;
                              });

                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                HomeScreen.id, (Route<dynamic> route) => false);
                          });
                        }).catchError((e) {
                          setState(() {
                            _isLoading = false;
                          });
                          Utils.showAlertDialog(context, "Error", e.toString());
                        });
                      }).catchError((e) {
                        setState(() {
                          _isLoading = false;
                        });
                        Utils.showAlertDialog(context, "Error", e.toString());
                      });
                    },
                    child: Text('Place Order'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
