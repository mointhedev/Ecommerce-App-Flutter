import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'models/Product.dart';

class ProductData extends ChangeNotifier {
  List<Product> _homeProducts = [];
  List<bool> buttonState = [];

  setHomeProductList({List<DocumentSnapshot> productsSnapshots}) {
    List<Product> products = [];
    for (var product in productsSnapshots) {
      final id = product.documentID;
      final title = product.data['title'];
      final price = product.data['price'];
      final quantity = product.data['total_quantity'];
      final category = product.data['category'];
      final imageUrl = product.data['image_url'];
      final desc = product.data['description'];
      final productItem = Product(
          id: id,
          title: title,
          price: price,
          totalQuantity: quantity,
          description: desc,
          category: Utils.integerToCategoryString(category),
          imageUrl: imageUrl);
      products.add(productItem);
    }
    _homeProducts = List<Product>.from(products);
    //notifyListeners();
  }

  List<Product> getHomeProducts() {
    return _homeProducts;
  }

  addProduct(Product product) {
    _homeProducts.add(product);
    notifyListeners();
  }
}
