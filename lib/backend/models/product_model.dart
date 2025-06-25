import 'package:pelviease_website/const/enums/payment_enum.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double basePrice;
  final double discountPercentage;
  final double finalPrice;
  final bool isCDSCOCertified;
  final int totalRatingCount;
  final double currentRating;
  final List<PaymentType> paymentTypes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.basePrice,
    required this.discountPercentage,
    required this.finalPrice,
    required this.isCDSCOCertified,
    this.totalRatingCount = 0,
    this.currentRating = 0.0,
    required this.paymentTypes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final base = (json['basePrice'] ?? 0).toDouble();
    final discount = (json['discountPercentage'] ?? 0).toDouble();
    final discountType = json['discountType'] ?? 'Percentage';
    double finalPrice;

    if (discountType == 'Percentage') {
      finalPrice = base - (base * discount / 100);
    } else {
      finalPrice = base - discount;
    }

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      basePrice: base,
      discountPercentage: discount,
      finalPrice: finalPrice,
      isCDSCOCertified: json['isCDSCOCertified'] ?? false,
      totalRatingCount: json['totalRatingCount'] ?? 0,
      currentRating: (json['currentRating'] ?? 0).toDouble(),
      paymentTypes: (json['paymentType'] as List<dynamic>? ?? [])
          .map((e) => PaymentType.fromString(e.toString()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'basePrice': basePrice,
      'discountPercentage': discountPercentage,
      'finalPrice': finalPrice,
      'isCDSCOCertified': isCDSCOCertified,
      'totalRatingCount': totalRatingCount,
      'currentRating': currentRating,
      'paymentType': paymentTypes.map((e) => e.toString()).toList(),
    };
  }
}
