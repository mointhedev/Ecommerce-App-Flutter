import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/Product.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  static const id = 'product_detail_screen';

  Product product;

  ProductDetailScreen(this.product);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Product _product = widget.product;
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: MyAppBar(
        title: 'Product Details',
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _product.title,
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                    child: Hero(
                      tag: _product.id,
                      child: Container(
                          height: queryData.size.height * 0.4,
                          child: Image.network(_product.imageUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Availability: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text('In Stock', style: TextStyle(fontSize: 16)),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(FontAwesomeIcons.checkCircle),
                    ),
                    Spacer(),
                    Icon(FontAwesomeIcons.dollarSign),
                    Text(
                      _product.price.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Description: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  _product.description,
                  style: TextStyle(fontSize: 16),
                ),
//                RaisedButton(
//                  onPressed: () {},
//                  child: Text('Add to Cart'),
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      'Reviews',
//                      style: TextStyle(fontWeight: FontWeight.w500),
//                    ),
//                    Text('Rating *****')
//                  ],
//                ),
//                Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 10),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text('ReviewerName'),
//                      Text('Nice product, vert nice, very good'
//                          'Nice product, vert nice, very good'
//                          'Nice product, vert nice, very good')
//                    ],
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 10),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text('ReviewerName'),
//                      Text('Nice product, vert nice, very good'
//                          'Nice product, vert nice, very good'
//                          'Nice product, vert nice, very good')
//                    ],
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
