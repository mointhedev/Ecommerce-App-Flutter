import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/edit_product_screen.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:ecommerce_app/widgets/myimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class ProductListScreen extends StatefulWidget {
  static const String id = 'product_list_screen';

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: MyAppBar(title: "Product List"),
          drawer: MyDrawer(true),
          body: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('products')
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
                List<Product> products = [];
                for (var product in productsSnapshot) {
                  final id = product.documentID;
                  final title = product.data['title'];
                  final price = product.data['price'];
                  final quantity = product.data['total_quantity'];
                  final category = product.data['category'];
                  final imageUrl = product.data['image_url'];
                  final desc = product.data['description'];
                  final productItem = Product(
                      id: id,
                      title: title,
                      price: price,
                      totalQuantity: quantity,
                      description: desc,
                      category: Utils.integerToCategoryString(category),
                      imageUrl: imageUrl);
                  products.add(productItem);
                }
                return ListView(
                  children: products.map((Product product) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blueAccent,
                          icon: Icons.edit,
                          onTap: () async {
                            bool success = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        EditProductScreen(product: product)));

                            success ?? false
                                ? Utils.showInSnackBar(
                                    "Product updated in firestore",
                                    _scaffoldKey)
                                : null;
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });
                            Firestore.instance
                                .collection('products')
                                .document(product.id)
                                .delete()
                                .then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                              Utils.showInSnackBar("Deleted", _scaffoldKey);
                            }).catchError((error) {
                              Utils.showAlertDialog(
                                  context, "Error", error.toString());
                            });
                          },
                        ),
                      ],
                      child: Container(
                        height: 100,
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Center(child: MyImage(product.imageUrl)),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: <Widget>[
                                    Text('ID ${product.id}'),
                                    Text('Title ${product.title}'),
                                    Text('Price ${product.price.toString()}'),
                                    Text(
                                        'Quantity ${product.totalQuantity.toString()}'),
                                    Text(
                                        'Category ${product.category.toString()}'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              })),
    );
  }
}
