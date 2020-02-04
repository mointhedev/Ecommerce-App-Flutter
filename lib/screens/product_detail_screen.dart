import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  static const id = 'product_detail_screen';
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: MyAppBar(
        title: 'Product Details',
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title'),
              Center(
                child: Container(
                    height: queryData.size.height * 0.4,
                    child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTp33LbWAAJBvWaKHRBqSAnOpohg2jPYHs8HqZZYuZFKPBBYxDF')),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Price: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('\$66')
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Availability: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('InStock')
                ],
              ),
              Text(
                'Description',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('Some detail about the product'
                  'Some detail about the product'
                  'Some detail about the product'
                  'Some detail about the product'
                  'Some detail about the product'
                  'Some detail about the product'),
              RaisedButton(
                onPressed: () {},
                child: Text('Add to Cart'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Reviews',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('Rating *****')
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ReviewerName'),
                    Text('Nice product, vert nice, very good'
                        'Nice product, vert nice, very good'
                        'Nice product, vert nice, very good')
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ReviewerName'),
                    Text('Nice product, vert nice, very good'
                        'Nice product, vert nice, very good'
                        'Nice product, vert nice, very good')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
