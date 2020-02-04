import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;

  ProductCard({this.title, this.price, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: Image.network(imageUrl),
          ),
          Text(title),
          Text('\$price'),
          FlatButton(
            color: Colors.yellow,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => ProductDetailScreen()));
            },
            child: Text(
              'Add to cart',
            ),
          )
        ],
      ),
    );
  }
}
