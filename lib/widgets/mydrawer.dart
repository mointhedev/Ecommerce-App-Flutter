import 'package:ecommerce_app/screens/add_product_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
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
      return Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(" ${userData.email}"),
            currentAccountPicture: Icon(
              Icons.account_circle,
              size: 60,
            ),
            accountName: Text(" ${userData.name}"),
          ),
          ...(isAdmin ? getAdminWidgets(context) : getUserWidgets(context)),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(LoginScreen.id);
            },
            child: Container(
              margin: EdgeInsets.all(8),
              color: Colors.amber,
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Log out"),
              ),
            ),
          ),
        ],
      );
    }));
  }

  List<Widget> getAdminWidgets(context) {
    List<Widget> list = [
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          color: Colors.lightGreenAccent,
          child: ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(AddProductScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          color: Colors.lightGreenAccent,
          child: ListTile(
            leading: Icon(Icons.add_box),
            title: Text("Add Product"),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(ProductListScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          color: Colors.lightGreenAccent,
          child: ListTile(
            leading: Icon(Icons.list),
            title: Text("Product List"),
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
        Navigator.of(context).pushReplacementNamed(HomeScreen.id);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        color: Colors.lightGreenAccent,
        child: ListTile(
          title: Text("Home"),
        ),
      ),
    ),
  ];

  return list;
}
