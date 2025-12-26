// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map(
                  (e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      featuredImage: json['featuredImage'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      brandId: json['brandId'] as String?,
      brandName: json['brandName'] as String?,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) =>
                  ProductAttributeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) =>
                  ProductSpecificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      soldCount: (json['soldCount'] as num?)?.toInt() ?? 0,
      weight: json['weight'] as String?,
      dimensions: json['dimensions'] as String?,
      meta: json['meta'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'price': instance.price,
      'compareAtPrice': instance.compareAtPrice,
      'salePrice': instance.salePrice,
      'discountPercent': instance.discountPercent,
      'stock': instance.stock,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'images': instance.images,
      'featuredImage': instance.featuredImage,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'brandId': instance.brandId,
      'brandName': instance.brandName,
      'variants': instance.variants,
      'attributes': instance.attributes,
      'specifications': instance.specifications,
      'tags': instance.tags,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'soldCount': instance.soldCount,
      'weight': instance.weight,
      'dimensions': instance.dimensions,
      'meta': instance.meta,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ProductImageModelImpl _$$ProductImageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductImageModelImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String?,
      alt: json['alt'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ProductImageModelImplToJson(
        _$ProductImageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnail': instance.thumbnail,
      'alt': instance.alt,
      'isDefault': instance.isDefault,
      'sortOrder': instance.sortOrder,
    };

_$ProductVariantModelImpl _$$ProductVariantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductVariantModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
      stock: (json['stock'] as num).toInt(),
      sku: json['sku'] as String?,
      image: json['image'] as String?,
      attributes: (json['attributes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$ProductVariantModelImplToJson(
        _$ProductVariantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'compareAtPrice': instance.compareAtPrice,
      'stock': instance.stock,
      'sku': instance.sku,
      'image': instance.image,
      'attributes': instance.attributes,
      'isActive': instance.isActive,
    };

_$ProductAttributeModelImpl _$$ProductAttributeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductAttributeModelImpl(
      name: json['name'] as String,
      values:
          (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      displayType: json['displayType'] as String?,
    );

Map<String, dynamic> _$$ProductAttributeModelImplToJson(
        _$ProductAttributeModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'values': instance.values,
      'displayType': instance.displayType,
    };

_$ProductSpecificationModelImpl _$$ProductSpecificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductSpecificationModelImpl(
      name: json['name'] as String,
      value: json['value'] as String,
      group: json['group'] as String?,
    );

Map<String, dynamic> _$$ProductSpecificationModelImplToJson(
        _$ProductSpecificationModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'group': instance.group,
    };
