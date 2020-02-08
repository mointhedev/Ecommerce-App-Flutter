import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Home'), actions: <Widget>[
          GestureDetector(
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
                      children: Category.values.map((Category category) {
                        return StreamBuilder<QuerySnapshot>(
                            stream:
                                _firestore.collection('products').snapshots(),
                            builder: (context, snapshot) {
                              _isLoading = false;
                              if (snapshot.hasError) {
                                return Center(child: Text('An Error Occured'));
                              }

                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              final productsSnapshots = snapshot.data.documents;

                              Provider.of<ProductData>(context, listen: false)
                                  .setHomeProductList(
                                      productsSnapshots: productsSnapshots);

                              List<Product> products =
                                  Provider.of<ProductData>(context)
                                      .getHomeProducts();

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(Utils.integerToCategoryString(
                                            category.index)),
                                      ],
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: products.isEmpty
                                          ? Center(
                                              child: Text('No Products found'),
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
                                                    scaffoldKey: _scaffoldKey);
                                              }).toList()),
                                    )
                                  ]);
                            });
                      }).toList()),
                ),
              ));
  }
}
