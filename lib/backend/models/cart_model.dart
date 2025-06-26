class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String description;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
