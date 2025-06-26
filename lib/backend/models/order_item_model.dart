class OrderItem {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String image;
  final Map<String, String> address;
  final String paymentType;
  final DateTime orderDate;
  final String status;
  final String trackingUrl;
  final String phoneNumber;

  const OrderItem(
      {this.id = '',
      required this.productId,
      required this.userId,
      required this.userName,
      required this.productName,
      required this.description,
      required this.price,
      required this.quantity,
      required this.image,
      required this.address,
      required this.paymentType,
      required this.orderDate,
      required this.status,
      this.trackingUrl = '',
      required this.phoneNumber});

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as String,
      productId: map['productId'] as String,
      userId: map['userId'] as String,
      productName: map['productName'] as String,
      userName: map['userName'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      image: map['image'] as String,
      address: map['address'] as Map<String, String>,
      paymentType: map['paymentType'] as String,
      orderDate: DateTime.parse(map['orderDate'] as String),
      status: map['status'] as String,
      trackingUrl: map['trackingUrl'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'productName': productName,
      'description': description,
      'price': price,
      'quantity': quantity,
      'image': image,
      'address': address,
      'paymentType': paymentType,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'trackingUrl': trackingUrl,
      'phoneNumber': phoneNumber,
    };
  }
}
