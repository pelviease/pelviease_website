class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final int totalRatingCount;
  final double currentRating;
  final int originalPrice;
  final int discountPrice;
  final bool isCertified;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.totalRatingCount,
    required this.currentRating,
    required this.originalPrice,
    required this.discountPrice,
    required this.isCertified,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    int? totalRatingCount,
    double? currentRating,
    int? originalPrice,
    int? discountPrice,
    bool? isCertified,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      totalRatingCount: totalRatingCount ?? this.totalRatingCount,
      currentRating: currentRating ?? this.currentRating,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      isCertified: isCertified ?? this.isCertified,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      totalRatingCount: json['totalRatingCount'] ?? 0,
      currentRating: (json['currentRating'] ?? 0).toDouble(),
      originalPrice: json['originalPrice'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      isCertified: json['isCertified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'totalRatingCount': totalRatingCount,
      'currentRating': currentRating,
      'originalPrice': originalPrice,
      'discountPrice': discountPrice,
      'isCertified': isCertified,
    };
  }
}

List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'PERINEOMETER',
    description:
        'Perineometer is an advanced diagnostic and rehabilitation device designed to assess and strengthen pelvic floor muscles. It offers real-time feedback and progress tracking, empowering clinicians and users to manage conditions such as urinary incontinence, pelvic organ prolapse, and postpartum recovery with precision and ease.',
    images: [
      'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1584362917165-526a968579e8?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop',
    ],
    totalRatingCount: 45,
    currentRating: 5.0,
    originalPrice: 7960,
    discountPrice: 6499,
    isCertified: true,
  ),
  Product(
    id: '2',
    name: 'BLOOD PRESSURE MONITOR',
    description:
        'Digital blood pressure monitor with accurate readings and memory storage. Features automatic inflation and deflation with large LCD display for easy reading. Perfect for home healthcare monitoring.',
    images: [
      'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop',
    ],
    totalRatingCount: 127,
    currentRating: 4.5,
    originalPrice: 2500,
    discountPrice: 1899,
    isCertified: true,
  ),
  Product(
    id: '3',
    name: 'DIGITAL THERMOMETER',
    description:
        'Fast and accurate digital thermometer with fever alarm. Waterproof design with flexible tip for comfortable use. Suitable for oral, rectal, and underarm measurements.',
    images: [
      'https://images.unsplash.com/photo-1584362917165-526a968579e8?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop',
    ],
    totalRatingCount: 89,
    currentRating: 4.8,
    originalPrice: 599,
    discountPrice: 399,
    isCertified: false,
  ),
  Product(
    id: '4',
    name: 'PULSE OXIMETER',
    description:
        'Fingertip pulse oximeter for measuring blood oxygen saturation and pulse rate. Compact design with OLED display showing clear readings. Essential for respiratory health monitoring.',
    images: [
      'https://images.unsplash.com/photo-1628595351029-c2bf17511435?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&h=400&fit=crop',
    ],
    totalRatingCount: 203,
    currentRating: 4.7,
    originalPrice: 1200,
    discountPrice: 899,
    isCertified: true,
  ),
  Product(
    id: '5',
    name: 'NEBULIZER MACHINE',
    description:
        'Portable nebulizer for respiratory therapy. Converts liquid medication into fine mist for effective inhalation treatment. Quiet operation with easy-to-clean components.',
    images: [
      'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=400&fit=crop',
    ],
    totalRatingCount: 67,
    currentRating: 4.3,
    originalPrice: 3500,
    discountPrice: 2799,
    isCertified: true,
  ),
  Product(
    id: '6',
    name: 'GLUCOMETER KIT',
    description:
        'Complete blood glucose monitoring system with test strips and lancets. Quick and accurate results in seconds. Includes carrying case and logbook for tracking readings.',
    images: [
      'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&h=400&fit=crop',
    ],
    totalRatingCount: 156,
    currentRating: 4.6,
    originalPrice: 1800,
    discountPrice: 1299,
    isCertified: true,
  ),
];
