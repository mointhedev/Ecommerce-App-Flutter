import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:ecommerce_app/widgets/myimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ProductData.dart';
import '../UserData.dart';
import '../constants.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Firestore _firestore;

  @override
  void initState() {
    _firestore = Firestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    final UserData setUserData = Provider.of<UserData>(context, listen: false);
    final ProductData productData = Provider.of<ProductData>(context);
    return Scaffold(
      appBar: MyAppBar(
        title: 'Your Cart',
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .document(userData.id)
                  .collection('cart')
//            .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('An Error Occured'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final productsSnapshot = snapshot.data.documents;
                List<Product> homeProducts = productData.getHomeProducts();
                List<Product> cartProducts = [];
                Product singleItem;

                double total = 0.0;

                for (var product in productsSnapshot) {
                  final productId = product.documentID;
                  final quantity = product.data['quantity'];
                  singleItem = homeProducts
                      .where((product) => productId == product.id)
                      .toList()
                      .first;
                  total = total + singleItem.price * quantity;
                  singleItem.totalQuantity = quantity;
                  cartProducts.add(singleItem);
                }

                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: cartProducts.isEmpty
                          ? Center(
                              child: Text('Your cart is empty'),
                            )
                          : ListView(
                              children: cartProducts.map((product) {
                                return Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.startToEnd,
                                  background: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    color: Colors.red,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Remove",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        )),
                                  ),
                                  onDismissed: (_) {
                                    setUserData.removeFromCart(product.id);
                                    _firestore
                                        .collection('users')
                                        .document(userData.id)
                                        .collection('cart')
                                        .document(product.id)
                                        .delete()
                                        .catchError((e) {
                                      Utils.showAlertDialog(
                                          context, "Error", e.toString());
                                      setUserData.addToCart(product.id);
                                    });
                                  },
                                  child: Container(
                                    height: 80,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            MyImage(product.imageUrl),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(product.title),
                                            ),
                                            Expanded(
                                              child: Container(),
                                              flex: 1,
                                            ),
                                            VerticalDivider(),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: Icon(
                                                        Icons.remove_circle),
                                                    onTap: () {
                                                      if (product
                                                              .totalQuantity >
                                                          1) {
                                                        setUserData
                                                            .removeFromCart(
                                                                product.id);
                                                        _firestore
                                                            .collection('users')
                                                            .document(
                                                                userData.id)
                                                            .collection('cart')
                                                            .document(
                                                                product.id)
                                                            .updateData(({
                                                              'quantity':
                                                                  FieldValue
                                                                      .increment(
                                                                          -1),
                                                            }))
                                                            .catchError((e) {
                                                          Utils.showAlertDialog(
                                                              context,
                                                              "Error",
                                                              e.toString());
                                                          setUserData.addToCart(
                                                              product.id);
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Container(
                                                    width: 26,
                                                    child: Center(
                                                      child: Text(product
                                                          .totalQuantity
                                                          .toString()),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child:
                                                        Icon(Icons.add_circle),
                                                    onTap: () {
                                                      setUserData.addToCart(
                                                          product.id);
                                                      _firestore
                                                          .collection('users')
                                                          .document(userData.id)
                                                          .collection('cart')
                                                          .document(product.id)
                                                          .updateData(({
                                                            'quantity':
                                                                FieldValue
                                                                    .increment(
                                                                        1),
                                                          }))
                                                          .catchError((e) {
                                                        Utils.showAlertDialog(
                                                            context,
                                                            "Error",
                                                            e.toString());
                                                        setUserData
                                                            .removeFromCart(
                                                                product.id);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    Container(
                      color: Colors.black54,
                      child: Card(
                        child: ListTile(
                            title:
                                Text('Total : \$${total.toStringAsFixed(2)}'),
                            trailing: RaisedButton(
                              color: Colors.yellow,
                              onPressed: total > 0.0
                                  ? () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => CheckoutScreen(
                                                  cartProducts)));
                                    }
                                  : null,
                              child: Text('Checkout'),
                            )),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
