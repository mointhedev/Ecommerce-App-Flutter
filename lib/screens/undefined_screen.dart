import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:flutter/material.dart';

class UndefinedScreen extends StatelessWidget {
  final String name;
  UndefinedScreen(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Error',
      ),
      body: Container(
        child: Center(
          child: Text('Error routing to $name'),
        ),
      ),
    );
  }
}
