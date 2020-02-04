class Order {
  String orderId;
  DateTime date;
  double totalAmount;
  OrderStatus status;
  PaymentMethod paymentMethod;
  String shippingAddress;
}

enum OrderStatus {
  waiting,
  packing,
  shipped,
}

enum PaymentMethod { cod, mastercard }
