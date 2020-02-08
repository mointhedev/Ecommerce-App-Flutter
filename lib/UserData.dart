import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/UserProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier {
  bool isAdmin = false;
  String id;
  String name;
  String email;
  String mobileNum;
  String address;
  List<UserProduct> cart = [];

  addToCart(String id) {
    cart ??= [];
    List<UserProduct> eachProduct =
        cart?.where((product) => product.productId == id)?.toList() ?? [];
    eachProduct.isNotEmpty
        ? cart[cart.indexWhere((product) => product.productId == id)].quantity++
        : cart.add(UserProduct(productId: id, quantity: 1));
    notifyListeners();
  }

  removeFromCart(String id) {
    cart ??= [];
    List<UserProduct> eachProduct =
        cart?.where((product) => product.productId == id)?.toList() ?? [];
    eachProduct.isNotEmpty
        ? cart[cart.indexWhere((product) => product.productId == id)].quantity--
        : cart.add(UserProduct(productId: id, quantity: 1));
    notifyListeners();
  }

  removeProductFromCart(String id) {
    cart ??= [];
    List<UserProduct> eachProduct =
        cart?.where((product) => product.productId == id)?.toList() ?? [];
    eachProduct.isNotEmpty
        ? cart.removeAt(cart.indexWhere((product) => product.productId == id))
        : null;
    notifyListeners();
  }

//  Future<UserData> getCurrentUser() {
//    FirebaseAuth.instance.currentUser().then((user) async {
//      DocumentSnapshot snap =
//          await Firestore.instance.collection('users').document(user.uid).get();
//      var snapData = snap.data;
//      isAdmin = snapData['role'] == 'admin';
//      final address = snapData['address'];
//      final firstName = snapData['first_name'];
//      final lastName = snapData['last_name'];
//      final mobile = snapData['mobile_num'];
//      setUser(
//          id: user.uid,
//          email: user.email,
//          adminStatus: isAdmin,
//          address: address,
//          firstName: firstName,
//          lastName: lastName,
//          mobileNum: mobile);
//      return this;
//    }).catchError((e) {
//      throw e;
//    });
//  }

  List<UserProduct> getCart() {
    return cart != null ? cart : [];
  }

  addCartList(List<UserProduct> cartList) {
    cart ??= [];
    cart = List<UserProduct>.from(cartList);
  }

  int getCartQuantity() {
    int quantity = 0;
    if (cart != null && cart.isNotEmpty) {
      quantity = cart.length;
    }
    return quantity;
  }

  setUserWithoutNotifying(
      {DocumentSnapshot userData, List<DocumentSnapshot> cartSnapshots}) {
    List<UserProduct> cartList = [];
    if (cartSnapshots.length > 0) {
      for (var cartData in cartSnapshots) {
        final productId = cartData.documentID;
        final quantity = cartData['quantity'];

        cartList.add(UserProduct(productId: productId, quantity: quantity));
      }
    }
    this.id = userData.documentID;
    this.email = userData['email'];
    this.name = '${userData['first_name']} ${userData['last_name']}';
    this.mobileNum = userData['mobile_name'];
    this.address = userData['address'];
    this.isAdmin = userData['role'] == 'admin';
    cart ??= [];
    this.cart = List<UserProduct>.from(cartList);
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
