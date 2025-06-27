import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pelviease_website/const/enums/order_status.dart';
import 'package:pelviease_website/const/enums/payment_enum.dart';
import 'cart_model.dart';

class OrderItem {
  final String productId;
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String image;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  // Create from CartItem
  factory OrderItem.fromCartItem(CartItem cartItem) {
    return OrderItem(
      productId: cartItem.productId,
      productName: cartItem.productName,
      description: cartItem.description ?? '',
      price: cartItem.price,
      quantity: cartItem.quantity,
      image: cartItem.image,
    );
  }

  // Create from Firestore Map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      image: map['image'] ?? '',
    );
  }
}

class DeliveryAddress {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;

  DeliveryAddress({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAddress.fromJson(String source) =>
      DeliveryAddress.fromMap(json.decode(source));

  DeliveryAddress copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class StatusChange {
  final OrderStatus status;
  final DateTime timestamp;
  final String? comment;

  StatusChange({
    required this.status,
    required this.timestamp,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status.toString(),
      'timestamp': Timestamp.fromDate(timestamp),
      'comment': comment,
    };
  }

  factory StatusChange.fromMap(Map<String, dynamic> map) {
    return StatusChange(
      status: OrderStatus.fromString(map['status'] ?? 'Pending'),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comment: map['comment'],
    );
  }
}

class OrderDetails {
  final String? id;
  final String userId;
  final String userName;
  final String userFcmToken;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final DeliveryAddress deliveryAddress;
  final PaymentType paymentMethod;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime updatedAt;
  final List<StatusChange> statusHistory;
  final DateTime? estimatedDeliveryDate;
  final String? deliveryPersonId;
  final String? deliveryCode;
  final String? deliveredBy;
  final String? trackingUrl;
  final double? discount;

  OrderDetails({
    this.id,
    required this.userId,
    required this.userName,
    required this.userFcmToken,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.discount,
    this.status = OrderStatus.pending,
    DateTime? orderDate,
    DateTime? updatedAt,
    List<StatusChange>? statusHistory,
    this.estimatedDeliveryDate,
    this.deliveryPersonId,
    this.deliveryCode,
    this.deliveredBy,
    this.trackingUrl,
  })  : orderDate = orderDate ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        statusHistory = statusHistory ??
            [
              StatusChange(
                status: OrderStatus.pending,
                timestamp: orderDate ?? DateTime.now(),
                comment: 'Order placed',
              )
            ];

  DateTime? getEstimatedDeliveryDate() {
    final confirmedStatusChange = statusHistory.firstWhere(
      (change) => change.status == OrderStatus.orderConfirmed,
      orElse: () => StatusChange(
        status: OrderStatus.pending,
        timestamp: DateTime.now(),
      ),
    );

    if (confirmedStatusChange.status == OrderStatus.orderConfirmed) {
      return confirmedStatusChange.timestamp.add(const Duration(days: 2));
    }

    return null;
  }

  Map<String, dynamic> toMap() {
    final DateTime? deliveryDate =
        estimatedDeliveryDate ?? getEstimatedDeliveryDate();

    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userFcmToken': userFcmToken,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingCost': shippingCost,
      'total': total,
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod.toString(),
      'status': status.toString(),
      'orderDate': Timestamp.fromDate(orderDate),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'statusHistory': statusHistory.map((change) => change.toMap()).toList(),
      'estimatedDeliveryDate':
          deliveryDate != null ? Timestamp.fromDate(deliveryDate) : null,
      'deliveryPersonId': deliveryPersonId,
      'deliveryCode': deliveryCode,
      'deliveredBy': deliveredBy,
      'trackingUrl': trackingUrl,
      'discount': discount,
    };
  }

  factory OrderDetails.fromFirestore(Map<String, dynamic> data, String docId) {
    try {
      List<StatusChange> statusHistory = [];
      if (data['statusHistory'] != null) {
        statusHistory = (data['statusHistory'] as List<dynamic>)
            .map((item) => StatusChange.fromMap(item))
            .toList();
      } else {
        statusHistory = [
          StatusChange(
            status: OrderStatus.fromString(data['status'] ?? 'Pending'),
            timestamp:
                (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
            comment: 'Order created',
          ),
        ];
      }

      return OrderDetails(
        id: docId,
        userId: data['userId'] ?? '',
        userName: data['userName'] ?? '',
        userFcmToken: data['userFcmToken'] ?? '',
        items: (data['items'] as List<dynamic>?)
                ?.map((item) => OrderItem.fromMap(item))
                .toList() ??
            [],
        subtotal: (data['subtotal'] ?? 0.0).toDouble(),
        tax: (data['tax'] ?? 0.0).toDouble(),
        shippingCost: (data['shippingCost'] ?? 0.0).toDouble(),
        total: (data['total'] ?? 0.0).toDouble(),
        deliveryAddress: DeliveryAddress.fromMap(
            data['deliveryAddress'] as Map<String, dynamic>? ?? {}),
        paymentMethod: PaymentType.fromString(data['paymentMethod'] ?? 'Cash'),
        status: OrderStatus.fromString(data['status'] ?? 'Pending'),
        orderDate:
            (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt:
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        statusHistory: statusHistory,
        estimatedDeliveryDate:
            (data['estimatedDeliveryDate'] as Timestamp?)?.toDate(),
        deliveryPersonId: data['deliveryPersonId'],
        deliveryCode: data['deliveryCode'],
        deliveredBy: data['deliveredBy'],
        trackingUrl: data['trackingUrl'],
        discount: data['discount'],
      );
    } catch (e) {
      return OrderDetails(
        id: docId,
        userId: '',
        userName: '',
        userFcmToken: '',
        items: [],
        subtotal: 0.0,
        tax: 0.0,
        shippingCost: 0.0,
        total: 0.0,
        deliveryAddress: DeliveryAddress(
          id: '',
          fullName: '',
          phoneNumber: '',
          addressLine1: '',
          addressLine2: '',
          city: '',
          state: '',
          postalCode: '',
          country: '',
        ),
        paymentMethod: PaymentType.cash,
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
        updatedAt: DateTime.now(),
        statusHistory: [],
        estimatedDeliveryDate: null,
        deliveryPersonId: null,
        deliveryCode: null,
        deliveredBy: null,
        trackingUrl: null,
        discount: 0.0,
      );
    }
  }
  factory OrderDetails.fromCartItems(
      {required String id,
      required String userId,
      required String userName,
      required String userFcmToken,
      required List<CartItem> cartItems,
      required double subtotal,
      required double tax,
      required double shippingCost,
      required double total,
      required DeliveryAddress deliveryAddress,
      required PaymentType paymentMethod,
      required discount}) {
    return OrderDetails(
        id: id,
        userId: userId,
        userName: userName,
        userFcmToken: userFcmToken,
        items: cartItems.map((item) => OrderItem.fromCartItem(item)).toList(),
        subtotal: subtotal,
        tax: tax,
        shippingCost: shippingCost,
        total: total,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        discount: discount);
  }

  OrderDetails updateStatus(OrderStatus newStatus, {String? comment}) {
    final updatedHistory = [...statusHistory];

    updatedHistory.add(StatusChange(
      status: newStatus,
      timestamp: DateTime.now(),
      comment: comment,
    ));

    DateTime? newEstimatedDelivery = estimatedDeliveryDate;
    if (newStatus == OrderStatus.orderConfirmed &&
        status != OrderStatus.orderConfirmed) {
      newEstimatedDelivery = DateTime.now().add(const Duration(days: 2));
    }

    return copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      statusHistory: updatedHistory,
      estimatedDeliveryDate: newEstimatedDelivery,
    );
  }

  OrderDetails copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userFcmToken,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? shippingCost,
    double? total,
    DeliveryAddress? deliveryAddress,
    PaymentType? paymentMethod,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? updatedAt,
    List<StatusChange>? statusHistory,
    DateTime? estimatedDeliveryDate,
    String? deliveryPersonId,
    String? deliveryCode,
    String? deliveredBy,
    String? trackingUrl,
    double? discount,
  }) {
    return OrderDetails(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userFcmToken: userFcmToken ?? this.userFcmToken,
        items: items ?? this.items,
        subtotal: subtotal ?? this.subtotal,
        tax: tax ?? this.tax,
        shippingCost: shippingCost ?? this.shippingCost,
        total: total ?? this.total,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        status: status ?? this.status,
        orderDate: orderDate ?? this.orderDate,
        updatedAt: updatedAt ?? this.updatedAt,
        statusHistory: statusHistory ?? this.statusHistory,
        estimatedDeliveryDate:
            estimatedDeliveryDate ?? this.estimatedDeliveryDate,
        deliveryPersonId: deliveryPersonId ?? this.deliveryPersonId,
        deliveryCode: deliveryCode ?? this.deliveryCode,
        deliveredBy: deliveredBy ?? this.deliveredBy,
        trackingUrl: trackingUrl ?? this.trackingUrl,
        discount: discount ?? this.discount);
  }
}
