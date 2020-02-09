import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/widgets/myimage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../UserData.dart';
import '../constants.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductCard({this.product, this.scaffoldKey});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ButtonState isButtonLoading = ButtonState.normal;

  @override
  Widget build(BuildContext context) {
    final productId = widget.product.id;
    final totalQuantity = widget.product.totalQuantity;
    return GestureDetector(
      onTap: totalQuantity > 0
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(widget.product)));
            }
          : null,
      child: Container(
        width: 150,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 90,
                  child: Stack(children: <Widget>[
                    Hero(
                      tag: productId,
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageUrl,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    totalQuantity > 0
                        ? Container()
                        : Image.network(
                            'https://pngimage.net/wp-content/uploads/2018/06/out-of-stock-png-5.png')
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.product.title,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.dollarSign,
                        size: 16,
                      ),
                      Text('${widget.product.price}')
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    height: 30,
                    width: 80,
                    child:
                        Consumer<UserData>(builder: (context, userData, child) {
                      return ProgressButton(
                        backgroundColor: totalQuantity > 0
                            ? Colors.deepOrange
                            : Colors.deepOrange.withOpacity(0.6),
                        buttonState: isButtonLoading,
                        child: Icon(
                          FontAwesomeIcons.cartPlus,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: totalQuantity <= 0
                            ? null
                            : () async {
                                print('add product pressed');
                                setState(() {
                                  isButtonLoading = ButtonState.inProgress;
                                });

                                try {
                                  DocumentSnapshot doc = await Firestore
                                      .instance
                                      .collection("users")
                                      .document(userData.id)
                                      .collection('cart')
                                      .document(productId)
                                      .get();

                                  print('Product Id $productId');
                                  if (!doc.exists) {
                                    print('Document does not exist');
                                    Firestore.instance
                                        .collection("users")
                                        .document(userData.id)
                                        .collection('cart')
                                        .document(productId)
                                        .setData(
                                      {
                                        'quantity': FieldValue.increment(1),
                                      },
                                    ).then((_) {
                                      print('Adding to cart');

                                      userData.addToCart(productId);
                                      setState(() {
                                        isButtonLoading = ButtonState.normal;
                                      });
                                      Utils.showInSnackBar(
                                          "Added to cart", widget.scaffoldKey);
                                    }).catchError((error) {
                                      setState(() {
                                        isButtonLoading = ButtonState.error;
                                      });
                                      Utils.showAlertDialog(
                                          context, "Error", error.toString());
                                    });
                                  } else {
                                    print('Document does exist');

                                    Firestore.instance
                                        .collection("users")
                                        .document(userData.id)
                                        .collection('cart')
                                        .document(productId)
                                        .updateData(
                                      {
                                        'quantity': FieldValue.increment(1),
                                      },
                                    ).then((_) {
                                      print('Adding to cart');
                                      userData.addToCart(productId);
                                      setState(() {
                                        isButtonLoading = ButtonState.normal;
                                      });
                                      Utils.showInSnackBar(
                                          "Added to cart", widget.scaffoldKey);
                                    }).catchError((error) {
                                      setState(() {
                                        isButtonLoading = ButtonState.error;
                                      });
                                      Utils.showAlertDialog(
                                          context, "Error", error.toString());
                                    });
                                  }
                                } catch (error) {
                                  setState(() {
                                    isButtonLoading = ButtonState.error;
                                  });
                                  //Utils.showAlertDialog(context, "Error", error.toString());
                                }
                              },
                      );
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
