import 'package:flutter/cupertino.dart';

import 'models/User.dart';

class UserData extends ChangeNotifier {
  bool isAdmin = false;
  String id;
  String name;
  String email;
  String mobileNum;
  String address;

  setUser(
      {String id,
      String email,
      String firstName,
      String lastName,
      String address,
      String mobileNum,
      bool adminStatus}) {
    this.id = id;
    this.email = email;
    this.name = '$firstName $lastName';
    this.mobileNum = mobileNum;
    this.address = address;
    this.isAdmin = adminStatus;
    notifyListeners();
  }

  setUserEmail(String email) {
    email = email;
    notifyListeners();
  }

  setUserMobile(String mobile) {
    mobileNum = mobile;
    notifyListeners();
  }

  setUserAddress(String add) {
    address = add;
    notifyListeners();
  }

  setUserId(String id) {
    id = id;
    notifyListeners();
  }

  setUserName(String firstName, String lastName) {
    name = '$firstName $lastName';
    notifyListeners();
  }

  setAdminStatus(bool value) {
    isAdmin = value;
    notifyListeners();
  }
}
