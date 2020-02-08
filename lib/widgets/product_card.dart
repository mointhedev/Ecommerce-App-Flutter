import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/widgets/myimage.dart';
import 'package:flutter/material.dart';
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
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
          Text(widget.product.title),
          Text('${widget.product.price}'),
          Container(
              height: 30,
              width: 80,
              child: Consumer<UserData>(builder: (context, userData, child) {
                return ProgressButton(
                  buttonState: isButtonLoading,
                  child: Text('Add to Cart'),
                  onPressed: () async {
                    print('add product pressed');
                    setState(() {
                      isButtonLoading = ButtonState.inProgress;
                    });

                    try {
                      DocumentSnapshot doc = await Firestore.instance
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
    );
  }
}
