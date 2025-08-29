import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final String number;
  final String status;
  final String pickupOrDelivery;
  final String? addressText;
  final double? lat;
  final double? lng;
  final double subtotal;
  final double discount;
  final double total;
  final bool paid;
  final String paymentMethod;
  final String? promocodeCode;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.number,
    required this.status,
    required this.pickupOrDelivery,
    this.addressText,
    this.lat,
    this.lng,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paid,
    required this.paymentMethod,
    this.promocodeCode,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      number: json['number'],
      status: json['status'],
      pickupOrDelivery: json['pickup_or_delivery'],
      addressText: json['address_text'],
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paid: json['paid'],
      paymentMethod: json['payment_method'],
      promocodeCode: json['promocode_code'],
      createdAt: DateTime.parse(json['created_at']),
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    number,
    status,
    pickupOrDelivery,
    addressText,
    lat,
    lng,
    subtotal,
    discount,
    total,
    paid,
    paymentMethod,
    promocodeCode,
    createdAt,
    items,
  ];
}

class OrderItem extends Equatable {
  final int id;
  final int? itemId;
  final String nameSnapshot;
  final int qty;
  final double priceAtMoment;
  final List<OrderItemModification> modifications;

  const OrderItem({
    required this.id,
    this.itemId,
    required this.nameSnapshot,
    required this.qty,
    required this.priceAtMoment,
    required this.modifications,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemId: json['item_id'],
      nameSnapshot: json['name_snapshot'],
      qty: json['qty'],
      priceAtMoment: (json['price_at_moment'] as num).toDouble(),
      modifications: (json['modifications'] as List)
          .map((e) => OrderItemModification.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [id, itemId, nameSnapshot, qty, priceAtMoment, modifications];
}

class OrderItemModification extends Equatable {
  final int id;
  final int orderItemId;
  final int modificationTypeId;
  final String action;
  final DateTime createdAt;
  final ModificationType? modificationType;

  const OrderItemModification({
    required this.id,
    required this.orderItemId,
    required this.modificationTypeId,
    required this.action,
    required this.createdAt,
    this.modificationType,
  });

  factory OrderItemModification.fromJson(Map<String, dynamic> json) {
    return OrderItemModification(
      id: json['id'],
      orderItemId: json['order_item_id'],
      modificationTypeId: json['modification_type_id'],
      action: json['action'],
      createdAt: DateTime.parse(json['created_at']),
      modificationType: json['modification_type'] != null
          ? ModificationType.fromJson(json['modification_type'])
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [id, orderItemId, modificationTypeId, action, createdAt, modificationType];
}

class ModificationType extends Equatable {
  final int id;
  final String name;

  const ModificationType({required this.id, required this.name});

  factory ModificationType.fromJson(Map<String, dynamic> json) {
    return ModificationType(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
