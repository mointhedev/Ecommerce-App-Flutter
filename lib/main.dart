import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/UserData.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/order_list_screen.dart';
import 'package:ecommerce_app/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'ProductData.dart';
import 'constants.dart';
import 'screens/add_product_screen.dart';
import 'screens/login_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/undefined_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool home = false;
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
//        FutureProvider(create: (_) => UserData().getCurrentUser()),
        ChangeNotifierProvider(create: (_) => ProductData()),
        ChangeNotifierProvider(create: (_) => UserData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => FutureBuilder<FirebaseUser>(
              future: FirebaseAuth.instance.currentUser(),
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasError) {
                  return Utils.getErrorScreen();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Utils.getLoadingScreen();
                }

                if (snapshot.hasData) {
                  String userId = snapshot.data.uid;
                  return FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection('users')
                          .document(userId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Utils.getErrorScreen();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Utils.getLoadingScreen();
                        }

                        if (snapshot.hasData) {
                          var userData = snapshot.data;

                          print('After getting user data');

                          return FutureBuilder<QuerySnapshot>(
                              future: userData.reference
                                  .collection('cart')
                                  .getDocuments(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Utils.getErrorScreen();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Utils.getLoadingScreen();
                                }

                                if (snapshot.hasData) {
                                  var cartSnapshot = snapshot.data;

                                  print('After getting user data');

                                  print('After getting cart data');

                                  if (cartSnapshot.documents.length > 0) {
                                    print('Cart Document exists');
                                    var cartSnapshots = cartSnapshot.documents;
                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .setUserWithoutNotifying(
                                            userData: userData,
                                            cartSnapshots: cartSnapshots);
                                  } else {
                                    print('Cart Document does not exists');

                                    Provider.of<UserData>(context,
                                            listen: false)
                                        .setUserWithoutNotifying(
                                            userData: userData);
                                  }

                                  return HomeScreen();
                                }

                                /// other way there is no user logged.
                                return LoginScreen();
                              });
                        }

                        /// other way there is no user logged.
                        return LoginScreen();
                      });
                }

                /// other way there is no user logged.
                return LoginScreen();
              }),
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          AddProductScreen.id: (context) => AddProductScreen(),
          ProductListScreen.id: (context) => ProductListScreen(),
          CartScreen.id: (context) => CartScreen(),
          OrderListScreen.id: (context) => OrderListScreen(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => UndefinedScreen(
                  settings.name,
                )),
      ),
    );
  }
}
