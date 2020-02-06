import 'package:flutter/material.dart';

import 'models/Product.dart';
import 'widgets/appbar.dart';

class Utils {
  static showAlertDialog(BuildContext context, String type, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(type),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Scaffold getLoadingScreen() {
    return Scaffold(
        appBar: MyAppBar(
          title: "",
        ),
        body: Center(child: new CircularProgressIndicator()));
  }

  static Scaffold getErrorScreen() {
    return Scaffold(
        appBar: MyAppBar(
          title: "",
        ),
        body: Center(child: Text('An error occured')));
  }

  static void showInSnackBar(
      String value, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  static String integerToCategoryString(int i) {
    if (Category.electronics.index == i)
      return 'Electronics';
    else if (Category.garments.index == i)
      return 'Garments';
    else if (Category.garments.index == i)
      return 'Food';
    else
      return "Unknown";
  }

  static Category stringToCategory(String string) {
    if (string[0] == 'E')
      return Category.electronics;
    else if (string[0] == 'G')
      return Category.garments;
    else
      return Category.food;
  }
}
