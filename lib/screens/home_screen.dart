import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void checkifAdmin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _auth.currentUser();
//      if (user != null) {
//        var userQuery = Firestore.instance
//            .collection('Users')
//            .where('e-mail', isEqualTo: user.email)
//            .limit(1);
//        userQuery.getDocuments().then((value) {
//          bool some = value.documents[0].data["role"];
//        });}
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool jsonString = prefs.get("isAdmin");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('IsAdmin Value: ${Provider.of<UserData>(context).isAdmin}');
    return ChangeNotifierProvider(
      create: (context) => ProductData(),
      child: Scaffold(
          appBar: MyAppBar(
            title: "Home",
          ),
          drawer: MyDrawer(Provider.of<UserData>(context).isAdmin),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: Category.values.map((Category category) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('products')
//            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          _isLoading = false;
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
                                category:
                                    Utils.integerToCategoryString(category),
                                imageUrl: imageUrl);
                            products.add(productItem);
                          }
                          Provider.of<ProductData>(context, listen: false)
                              .setHomeProductList(products);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Category Name'),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //scrollDirection: Axis.horizontal,
                                    children: products.map((product) {
                                      return ProductCard();
                                    }).toList()),
                              )
                            ],
                          );
                        });
                  }).toList()),
            ),
          )),
    );
  }
}
