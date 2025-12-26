// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistModelImpl _$$WishlistModelImplFromJson(Map<String, dynamic> json) =>
    _$WishlistModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WishlistModelImplToJson(_$WishlistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'items': instance.items,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$WishlistItemModelImpl _$$WishlistItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WishlistItemModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String?,
      productImage: json['productImage'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      inStock: json['inStock'] as bool? ?? true,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$$WishlistItemModelImplToJson(
        _$WishlistItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'price': instance.price,
      'compareAtPrice': instance.compareAtPrice,
      'isAvailable': instance.isAvailable,
      'inStock': instance.inStock,
      'addedAt': instance.addedAt?.toIso8601String(),
    };
