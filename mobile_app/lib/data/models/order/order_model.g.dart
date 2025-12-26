// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
          OrderStatus.pending,
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
              PaymentStatus.pending,
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      shippingAddress: AddressModel.fromJson(
          json['shippingAddress'] as Map<String, dynamic>),
      billingAddress: json['billingAddress'] == null
          ? null
          : AddressModel.fromJson(
              json['billingAddress'] as Map<String, dynamic>),
      tracking: json['tracking'] == null
          ? null
          : OrderTrackingModel.fromJson(
              json['tracking'] as Map<String, dynamic>),
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map(
                  (e) => OrderTimelineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totals: OrderTotalsModel.fromJson(json['totals'] as Map<String, dynamic>),
      couponCode: json['couponCode'] as String?,
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      customerNotes: json['customerNotes'] as String?,
      estimatedDelivery: json['estimatedDelivery'] == null
          ? null
          : DateTime.parse(json['estimatedDelivery'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'items': instance.items,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
      'shippingAddress': instance.shippingAddress,
      'billingAddress': instance.billingAddress,
      'tracking': instance.tracking,
      'timeline': instance.timeline,
      'totals': instance.totals,
      'couponCode': instance.couponCode,
      'couponDiscount': instance.couponDiscount,
      'notes': instance.notes,
      'customerNotes': instance.customerNotes,
      'estimatedDelivery': instance.estimatedDelivery?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.outForDelivery: 'outForDelivery',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.returned: 'returned',
  OrderStatus.refunded: 'refunded',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partiallyRefunded: 'partiallyRefunded',
};

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String?,
      variantId: json['variantId'] as String?,
      variantName: json['variantName'] as String?,
      attributes: (json['attributes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      total: (json['total'] as num).toDouble(),
      sku: json['sku'] as String?,
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
        _$OrderItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'variantId': instance.variantId,
      'variantName': instance.variantName,
      'attributes': instance.attributes,
      'quantity': instance.quantity,
      'price': instance.price,
      'compareAtPrice': instance.compareAtPrice,
      'total': instance.total,
      'sku': instance.sku,
    };

_$OrderTotalsModelImpl _$$OrderTotalsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderTotalsModelImpl(
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderTotalsModelImplToJson(
        _$OrderTotalsModelImpl instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'shipping': instance.shipping,
      'tax': instance.tax,
      'total': instance.total,
    };

_$OrderTrackingModelImpl _$$OrderTrackingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderTrackingModelImpl(
      trackingNumber: json['trackingNumber'] as String?,
      carrier: json['carrier'] as String?,
      trackingUrl: json['trackingUrl'] as String?,
      currentLocation: json['currentLocation'] as String?,
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$$OrderTrackingModelImplToJson(
        _$OrderTrackingModelImpl instance) =>
    <String, dynamic>{
      'trackingNumber': instance.trackingNumber,
      'carrier': instance.carrier,
      'trackingUrl': instance.trackingUrl,
      'currentLocation': instance.currentLocation,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };

_$OrderTimelineModelImpl _$$OrderTimelineModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderTimelineModelImpl(
      status: json['status'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      icon: json['icon'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$OrderTimelineModelImplToJson(
        _$OrderTimelineModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'title': instance.title,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'icon': instance.icon,
      'isCompleted': instance.isCompleted,
    };
