import 'Review.dart';

class Product {
  String id;
  String title;
  double price;
  String description;
  String imageUrl;
  int totalQuantity;
  List<Review> reviews;
  String category;
  double rating;

  Product(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.imageUrl,
      this.totalQuantity});
}

enum Category { electronics, garments, food }
