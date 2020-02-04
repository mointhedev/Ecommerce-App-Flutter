import 'package:ecommerce_app/widgets/appbar.dart';

import '../widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const id = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "Home",
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildColumnCategory(),
                buildColumnCategory(),
                buildColumnCategory(),
              ],
            ),
          ),
        ));
  }

  Column buildColumnCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Category Name'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //scrollDirection: Axis.horizontal,
            children: <Widget>[
              ProductCard(
                title: 'Title',
                price: 67,
                imageUrl:
                    'https://pngimage.net/wp-content/uploads/2018/06/product-image-png-3.png',
              ),
              ProductCard(
                title: 'Title',
                price: 67,
                imageUrl:
                    'https://pngimage.net/wp-content/uploads/2018/06/product-image-png-3.png',
              ),
              ProductCard(
                title: 'Title',
                price: 67,
                imageUrl:
                    'https://pngimage.net/wp-content/uploads/2018/06/product-image-png-3.png',
              ),
              ProductCard(
                title: 'Title',
                price: 67,
                imageUrl:
                    'https://pngimage.net/wp-content/uploads/2018/06/product-image-png-3.png',
              ),
            ],
          ),
        )
      ],
    );
  }
}
