import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/widgets/myimage.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ProgressButton progressButton;

  ProductCard({this.product, this.progressButton});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
          Text(product.title),
          Text('${product.price}'),
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
