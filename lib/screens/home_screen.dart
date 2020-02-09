import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../ProductData.dart';
import '../UserData.dart';
import '../constants.dart';
import '../widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore _firestore = Firestore.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final UserData _user = Provider.of<UserData>(context);
    print('IsAdmin Value: ${_user.isAdmin}');
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF3366FF),
              const Color(0xFF00CCFF),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: AppBar(
              flexibleSpace: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF3366FF),
                        const Color(0xFF00CCFF),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
              title: Text('Home'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: GestureDetector(
                    onTap: _user.getCartQuantity() > 0
                        ? () {
                            Navigator.of(context).pushNamed(CartScreen.id);
                          }
                        : () {},
                    child: Stack(children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: null,
                      ),
                      _user.getCartQuantity() == 0
                          ? Container()
                          : Positioned(
                              child: Stack(
                              children: <Widget>[
                                Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.red[800]),
                                Positioned(
                                    top: 4.0,
                                    right: 6.0,
                                    child: Center(
                                      child: Text(
                                        _user.getCartQuantity().toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ))
                    ]),
                  ),
                ),
              ]),
          drawer: MyDrawer(_user.isAdmin),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        SizedBox(
                          height: 230,
                          width: double.infinity,
                          child: Carousel(
                            images: [
                              NetworkImage(
                                  'https://static.wixstatic.com/media/30e693_b63d45c114c04c9aa93823c4a2a1e780~mv2.gif'),
                              NetworkImage(
                                  'https://media.istockphoto.com/vectors/sale-banner-template-design-vector-id945107144'),
                              NetworkImage(
                                  'https://46ba123xc93a357lc11tqhds-wpengine.netdna-ssl.com/wp-content/uploads/2019/09/amazon-alexa-event-sept-2019.jpg'),

//                            https://46ba123xc93a357lc11tqhds-wpengine.netdna-ssl.com/wp-content/uploads/2019/09/amazon-alexa-event-sept-2019.jpg
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ...Category.values.map((Category category) {
                          return StreamBuilder<QuerySnapshot>(
                              stream:
                                  _firestore.collection('products').snapshots(),
                              builder: (context, snapshot) {
                                _isLoading = false;
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('An Error Occured'));
                                }

                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                final productsSnapshots =
                                    snapshot.data.documents;

                                Provider.of<ProductData>(context, listen: false)
                                    .setHomeProductList(
                                        productsSnapshots: productsSnapshots);

                                List<Product> products =
                                    Provider.of<ProductData>(context)
                                        .getHomeProducts();

                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              Utils.integerToCategoryString(
                                                  category.index),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: products.isEmpty
                                            ? Center(
                                                child:
                                                    Text('No Products found'),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: products
                                                    .where((product) =>
                                                        Utils.stringToCategory(
                                                            product.category) ==
                                                        category)
                                                    .map((product) {
                                                  return ProductCard(
                                                      product: product,
                                                      scaffoldKey:
                                                          _scaffoldKey);
                                                }).toList()),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Divider(
                                        color: Colors.black26,
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ]);
                              });
                        }).toList()
                      ])),
                )),
    );
  }
}
