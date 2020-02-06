import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/UserData.dart';
import 'package:ecommerce_app/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider<UserData>(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Ecommerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => FutureBuilder<FirebaseUser>(
              future: FirebaseAuth.instance.currentUser(),
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                print("User snapshot Data = ${snapshot.data}");

                if (snapshot.hasError) {
                  return Utils.getErrorScreen();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Utils.getLoadingScreen();
                }

                if (snapshot.hasData) {
                  if (home) {
                    return HomeScreen();
                  }

                  FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
                    if (user != null) {
                      print('User email ${user.email}');
                      Firestore.instance
                          .collection('users')
                          .document(user.uid)
                          .get()
                          .then((data) {
                        bool isAdmin = data["role"] == 'admin';
                        String Fname = data['first_name'];
                        String Lname = data['last_name'];
                        String address = data['address'];
                        String num = data['mobile_num'];
                        print("Role of User :  $data['role']");
                        Provider.of<UserData>(context, listen: false).setUser(
                            id: user.uid,
                            email: user.email,
                            firstName: Fname,
                            lastName: Lname,
                            address: address,
                            mobileNum: num,
                            adminStatus: isAdmin);
                        setState(() {
                          home = true;
                        });
                        return HomeScreen();
                      }).catchError((e) {
                        setState(() {
                          error = true;
                        });
                        return Utils.getErrorScreen();
                      });
                    }
                  }).catchError((e) {
                    setState(() {
                      error = true;
                    });
                    return Utils.getErrorScreen();
                  });
                  if (!home && !error) return Utils.getLoadingScreen();
                  if (error) return Utils.getErrorScreen();
                }

                /// other way there is no user logged.
                return LoginScreen();
              }),
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ProductDetailScreen.id: (context) => ProductDetailScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          AddProductScreen.id: (context) => AddProductScreen(),
          ProductListScreen.id: (context) => ProductListScreen(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => UndefinedScreen(
                  settings.name,
                )),
      ),
    );
  }
}
