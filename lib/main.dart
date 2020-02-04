import 'package:ecommerce_app/screens/add_product_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => RegistrationScreen(),
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        ProductDetailScreen.id: (context) => ProductDetailScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen()
      },
    );
  }
}
