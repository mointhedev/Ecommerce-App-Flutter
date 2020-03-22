import 'package:ecommerce_app/screens/add_product_screen.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/order_list_screen.dart';
import 'package:ecommerce_app/screens/product_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UserData.dart';

class MyDrawer extends StatelessWidget {
  final bool isAdmin;
  MyDrawer(this.isAdmin);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Consumer<UserData>(builder: (context, userData, child) {
      return Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: new BoxDecoration(
                color: Color(0xfffff),
              ),
              accountEmail: Text(
                " ${userData.email}",
                style: TextStyle(color: Colors.black87),
              ),
              currentAccountPicture: Icon(
                Icons.account_circle,
                size: 60,
              ),
              accountName: Text(
                " ${userData.name}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Divider(
              color: Colors.black26,
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(HomeScreen.id);
              },
              child: Container(
                margin: EdgeInsets.all(8),
                color: Colors.white,
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                  ),
                ),
              ),
            ),
            ...(isAdmin ? getAdminWidgets(context) : getUserWidgets(context)),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed(LoginScreen.id);
              },
              child: Container(
                margin: EdgeInsets.all(8),
                color: Colors.white,
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Log out"),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }

  List<Widget> getAdminWidgets(context) {
    List<Widget> list = [
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(AddProductScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          color: Colors.white,
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.add_box),
              title: Text("Add Product"),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(ProductListScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          color: Colors.white,
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.list),
              title: Text("Product List"),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(OrderListScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          color: Colors.white,
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.list),
              title: Text("Order List"),
            ),
          ),
        ),
      ),
    ];

    return list;
  }
}

List<Widget> getUserWidgets(context) {
  List<Widget> list = [
    GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(OrderListScreen.id);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        color: Colors.lightGreenAccent,
        child: ListTile(
          leading: Icon(Icons.list),
          title: Text("My Orders"),
        ),
      ),
    ),
  ];

  return list;
}
