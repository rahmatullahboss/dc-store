// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartModelImpl _$$CartModelImplFromJson(Map<String, dynamic> json) =>
    _$CartModelImpl(
      id: json['id'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      coupon: json['coupon'] == null
          ? null
          : CouponModel.fromJson(json['coupon'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CartModelImplToJson(_$CartModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'shipping': instance.shipping,
      'tax': instance.tax,
      'total': instance.total,
      'coupon': instance.coupon,
      'notes': instance.notes,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String?,
      variantId: json['variantId'] as String?,
      variantName: json['variantName'] as String?,
      selectedAttributes:
          (json['selectedAttributes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      itemTotal: (json['itemTotal'] as num?)?.toDouble() ?? 0.0,
      maxQuantity: (json['maxQuantity'] as num?)?.toInt() ?? 0,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'variantId': instance.variantId,
      'variantName': instance.variantName,
      'selectedAttributes': instance.selectedAttributes,
      'quantity': instance.quantity,
      'price': instance.price,
      'compareAtPrice': instance.compareAtPrice,
      'itemTotal': instance.itemTotal,
      'maxQuantity': instance.maxQuantity,
      'addedAt': instance.addedAt?.toIso8601String(),
    };

_$CouponModelImpl _$$CouponModelImplFromJson(Map<String, dynamic> json) =>
    _$CouponModelImpl(
      code: json['code'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble(),
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isValid: json['isValid'] as bool? ?? true,
    );

Map<String, dynamic> _$$CouponModelImplToJson(_$CouponModelImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'type': instance.type,
      'value': instance.value,
      'minOrderAmount': instance.minOrderAmount,
      'maxDiscount': instance.maxDiscount,
      'description': instance.description,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isValid': instance.isValid,
    };
