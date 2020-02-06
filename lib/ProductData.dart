import 'package:flutter/material.dart';

import 'models/Product.dart';

class ProductData extends ChangeNotifier {
  List<Product> _homeProducts = [];

  setHomeProductList(List<Product> products) {
    _homeProducts = List<Product>.from(products);
    notifyListeners();
  }

  getHomeProducts() {
    return _homeProducts;
  }

  addProduct(Product product) {
    _homeProducts.add(product);
    notifyListeners();
  }
}
