import 'package:flutter/material.dart';

class UndefinedScreen extends StatelessWidget {
  final String name;
  UndefinedScreen(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Error routing to $name Screen'),
      ),
    );
  }
}
