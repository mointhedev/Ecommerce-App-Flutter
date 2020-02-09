class Order {
  String orderId;
  double totalAmount;
  String status;
  String paymentMethod;
  String shippingAddress;
}

enum OrderStatus {
  waiting,
  packing,
  shipped,
}

enum PaymentMethod { cod, bank }
