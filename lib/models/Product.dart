import 'Review.dart';

class Product {
  String id;
  String title;
  double price;
  String description;
  String imageUrl;
  int totalQuantity;
  List<Review> reviews;
  Category category;
  double rating;

  Product(
      {this.title,
      this.price,
      this.description,
      this.category,
      this.imageUrl,
      this.totalQuantity});
}

enum Category { garments, electronics, food }
