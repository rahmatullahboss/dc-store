// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get shortDescription => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get compareAtPrice => throw _privateConstructorUsedError;
  double? get salePrice => throw _privateConstructorUsedError;
  int? get discountPercent => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  List<ProductImageModel> get images => throw _privateConstructorUsedError;
  String? get featuredImage => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String? get brandId => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;
  List<ProductVariantModel> get variants => throw _privateConstructorUsedError;
  List<ProductAttributeModel> get attributes =>
      throw _privateConstructorUsedError;
  List<ProductSpecificationModel> get specifications =>
      throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int get soldCount => throw _privateConstructorUsedError;
  String? get weight => throw _privateConstructorUsedError;
  String? get dimensions => throw _privateConstructorUsedError;
  Map<String, dynamic>? get meta => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? slug,
      String? description,
      String? shortDescription,
      double price,
      double? compareAtPrice,
      double? salePrice,
      int? discountPercent,
      int stock,
      String? sku,
      String? barcode,
      List<ProductImageModel> images,
      String? featuredImage,
      String? categoryId,
      String? categoryName,
      String? brandId,
      String? brandName,
      List<ProductVariantModel> variants,
      List<ProductAttributeModel> attributes,
      List<ProductSpecificationModel> specifications,
      List<String> tags,
      double rating,
      int reviewCount,
      bool isActive,
      bool isFeatured,
      int soldCount,
      String? weight,
      String? dimensions,
      Map<String, dynamic>? meta,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? shortDescription = freezed,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? salePrice = freezed,
    Object? discountPercent = freezed,
    Object? stock = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? images = null,
    Object? featuredImage = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? brandId = freezed,
    Object? brandName = freezed,
    Object? variants = null,
    Object? attributes = null,
    Object? specifications = null,
    Object? tags = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? soldCount = null,
    Object? weight = freezed,
    Object? dimensions = freezed,
    Object? meta = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPercent: freezed == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as int?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImageModel>,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      variants: null == variants
          ? _value.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<ProductAttributeModel>,
      specifications: null == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as List<ProductSpecificationModel>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      soldCount: null == soldCount
          ? _value.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as String?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? slug,
      String? description,
      String? shortDescription,
      double price,
      double? compareAtPrice,
      double? salePrice,
      int? discountPercent,
      int stock,
      String? sku,
      String? barcode,
      List<ProductImageModel> images,
      String? featuredImage,
      String? categoryId,
      String? categoryName,
      String? brandId,
      String? brandName,
      List<ProductVariantModel> variants,
      List<ProductAttributeModel> attributes,
      List<ProductSpecificationModel> specifications,
      List<String> tags,
      double rating,
      int reviewCount,
      bool isActive,
      bool isFeatured,
      int soldCount,
      String? weight,
      String? dimensions,
      Map<String, dynamic>? meta,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? shortDescription = freezed,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? salePrice = freezed,
    Object? discountPercent = freezed,
    Object? stock = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? images = null,
    Object? featuredImage = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? brandId = freezed,
    Object? brandName = freezed,
    Object? variants = null,
    Object? attributes = null,
    Object? specifications = null,
    Object? tags = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? soldCount = null,
    Object? weight = freezed,
    Object? dimensions = freezed,
    Object? meta = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPercent: freezed == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as int?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImageModel>,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      variants: null == variants
          ? _value._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      attributes: null == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<ProductAttributeModel>,
      specifications: null == specifications
          ? _value._specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as List<ProductSpecificationModel>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      soldCount: null == soldCount
          ? _value.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as String?,
      meta: freezed == meta
          ? _value._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl extends _ProductModel {
  const _$ProductModelImpl(
      {required this.id,
      required this.name,
      this.slug,
      this.description,
      this.shortDescription,
      required this.price,
      this.compareAtPrice,
      this.salePrice,
      this.discountPercent,
      this.stock = 0,
      this.sku,
      this.barcode,
      final List<ProductImageModel> images = const [],
      this.featuredImage,
      this.categoryId,
      this.categoryName,
      this.brandId,
      this.brandName,
      final List<ProductVariantModel> variants = const [],
      final List<ProductAttributeModel> attributes = const [],
      final List<ProductSpecificationModel> specifications = const [],
      final List<String> tags = const [],
      this.rating = 0.0,
      this.reviewCount = 0,
      this.isActive = true,
      this.isFeatured = false,
      this.soldCount = 0,
      this.weight,
      this.dimensions,
      final Map<String, dynamic>? meta,
      this.createdAt,
      this.updatedAt})
      : _images = images,
        _variants = variants,
        _attributes = attributes,
        _specifications = specifications,
        _tags = tags,
        _meta = meta,
        super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? description;
  @override
  final String? shortDescription;
  @override
  final double price;
  @override
  final double? compareAtPrice;
  @override
  final double? salePrice;
  @override
  final int? discountPercent;
  @override
  @JsonKey()
  final int stock;
  @override
  final String? sku;
  @override
  final String? barcode;
  final List<ProductImageModel> _images;
  @override
  @JsonKey()
  List<ProductImageModel> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? featuredImage;
  @override
  final String? categoryId;
  @override
  final String? categoryName;
  @override
  final String? brandId;
  @override
  final String? brandName;
  final List<ProductVariantModel> _variants;
  @override
  @JsonKey()
  List<ProductVariantModel> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  final List<ProductAttributeModel> _attributes;
  @override
  @JsonKey()
  List<ProductAttributeModel> get attributes {
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attributes);
  }

  final List<ProductSpecificationModel> _specifications;
  @override
  @JsonKey()
  List<ProductSpecificationModel> get specifications {
    if (_specifications is EqualUnmodifiableListView) return _specifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specifications);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final int soldCount;
  @override
  final String? weight;
  @override
  final String? dimensions;
  final Map<String, dynamic>? _meta;
  @override
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, slug: $slug, description: $description, shortDescription: $shortDescription, price: $price, compareAtPrice: $compareAtPrice, salePrice: $salePrice, discountPercent: $discountPercent, stock: $stock, sku: $sku, barcode: $barcode, images: $images, featuredImage: $featuredImage, categoryId: $categoryId, categoryName: $categoryName, brandId: $brandId, brandName: $brandName, variants: $variants, attributes: $attributes, specifications: $specifications, tags: $tags, rating: $rating, reviewCount: $reviewCount, isActive: $isActive, isFeatured: $isFeatured, soldCount: $soldCount, weight: $weight, dimensions: $dimensions, meta: $meta, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.featuredImage, featuredImage) ||
                other.featuredImage == featuredImage) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            const DeepCollectionEquality()
                .equals(other._specifications, _specifications) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        slug,
        description,
        shortDescription,
        price,
        compareAtPrice,
        salePrice,
        discountPercent,
        stock,
        sku,
        barcode,
        const DeepCollectionEquality().hash(_images),
        featuredImage,
        categoryId,
        categoryName,
        brandId,
        brandName,
        const DeepCollectionEquality().hash(_variants),
        const DeepCollectionEquality().hash(_attributes),
        const DeepCollectionEquality().hash(_specifications),
        const DeepCollectionEquality().hash(_tags),
        rating,
        reviewCount,
        isActive,
        isFeatured,
        soldCount,
        weight,
        dimensions,
        const DeepCollectionEquality().hash(_meta),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel(
      {required final String id,
      required final String name,
      final String? slug,
      final String? description,
      final String? shortDescription,
      required final double price,
      final double? compareAtPrice,
      final double? salePrice,
      final int? discountPercent,
      final int stock,
      final String? sku,
      final String? barcode,
      final List<ProductImageModel> images,
      final String? featuredImage,
      final String? categoryId,
      final String? categoryName,
      final String? brandId,
      final String? brandName,
      final List<ProductVariantModel> variants,
      final List<ProductAttributeModel> attributes,
      final List<ProductSpecificationModel> specifications,
      final List<String> tags,
      final double rating,
      final int reviewCount,
      final bool isActive,
      final bool isFeatured,
      final int soldCount,
      final String? weight,
      final String? dimensions,
      final Map<String, dynamic>? meta,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get slug;
  @override
  String? get description;
  @override
  String? get shortDescription;
  @override
  double get price;
  @override
  double? get compareAtPrice;
  @override
  double? get salePrice;
  @override
  int? get discountPercent;
  @override
  int get stock;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  List<ProductImageModel> get images;
  @override
  String? get featuredImage;
  @override
  String? get categoryId;
  @override
  String? get categoryName;
  @override
  String? get brandId;
  @override
  String? get brandName;
  @override
  List<ProductVariantModel> get variants;
  @override
  List<ProductAttributeModel> get attributes;
  @override
  List<ProductSpecificationModel> get specifications;
  @override
  List<String> get tags;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  bool get isActive;
  @override
  bool get isFeatured;
  @override
  int get soldCount;
  @override
  String? get weight;
  @override
  String? get dimensions;
  @override
  Map<String, dynamic>? get meta;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) {
  return _ProductImageModel.fromJson(json);
}

/// @nodoc
mixin _$ProductImageModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String? get alt => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductImageModelCopyWith<ProductImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductImageModelCopyWith<$Res> {
  factory $ProductImageModelCopyWith(
          ProductImageModel value, $Res Function(ProductImageModel) then) =
      _$ProductImageModelCopyWithImpl<$Res, ProductImageModel>;
  @useResult
  $Res call(
      {String id,
      String url,
      String? thumbnail,
      String? alt,
      bool isDefault,
      int sortOrder});
}

/// @nodoc
class _$ProductImageModelCopyWithImpl<$Res, $Val extends ProductImageModel>
    implements $ProductImageModelCopyWith<$Res> {
  _$ProductImageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? thumbnail = freezed,
    Object? alt = freezed,
    Object? isDefault = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      alt: freezed == alt
          ? _value.alt
          : alt // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImageModelImplCopyWith<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  factory _$$ProductImageModelImplCopyWith(_$ProductImageModelImpl value,
          $Res Function(_$ProductImageModelImpl) then) =
      __$$ProductImageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      String? thumbnail,
      String? alt,
      bool isDefault,
      int sortOrder});
}

/// @nodoc
class __$$ProductImageModelImplCopyWithImpl<$Res>
    extends _$ProductImageModelCopyWithImpl<$Res, _$ProductImageModelImpl>
    implements _$$ProductImageModelImplCopyWith<$Res> {
  __$$ProductImageModelImplCopyWithImpl(_$ProductImageModelImpl _value,
      $Res Function(_$ProductImageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? thumbnail = freezed,
    Object? alt = freezed,
    Object? isDefault = null,
    Object? sortOrder = null,
  }) {
    return _then(_$ProductImageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      alt: freezed == alt
          ? _value.alt
          : alt // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImageModelImpl implements _ProductImageModel {
  const _$ProductImageModelImpl(
      {required this.id,
      required this.url,
      this.thumbnail,
      this.alt,
      this.isDefault = false,
      this.sortOrder = 0});

  factory _$ProductImageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final String? thumbnail;
  @override
  final String? alt;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'ProductImageModel(id: $id, url: $url, thumbnail: $thumbnail, alt: $alt, isDefault: $isDefault, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.alt, alt) || other.alt == alt) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, url, thumbnail, alt, isDefault, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImageModelImplCopyWith<_$ProductImageModelImpl> get copyWith =>
      __$$ProductImageModelImplCopyWithImpl<_$ProductImageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImageModelImplToJson(
      this,
    );
  }
}

abstract class _ProductImageModel implements ProductImageModel {
  const factory _ProductImageModel(
      {required final String id,
      required final String url,
      final String? thumbnail,
      final String? alt,
      final bool isDefault,
      final int sortOrder}) = _$ProductImageModelImpl;

  factory _ProductImageModel.fromJson(Map<String, dynamic> json) =
      _$ProductImageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  String? get thumbnail;
  @override
  String? get alt;
  @override
  bool get isDefault;
  @override
  int get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$ProductImageModelImplCopyWith<_$ProductImageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) {
  return _ProductVariantModel.fromJson(json);
}

/// @nodoc
mixin _$ProductVariantModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get compareAtPrice => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  Map<String, String> get attributes =>
      throw _privateConstructorUsedError; // e.g., {"color": "Red", "size": "XL"}
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductVariantModelCopyWith<ProductVariantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariantModelCopyWith<$Res> {
  factory $ProductVariantModelCopyWith(
          ProductVariantModel value, $Res Function(ProductVariantModel) then) =
      _$ProductVariantModelCopyWithImpl<$Res, ProductVariantModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      double? compareAtPrice,
      int stock,
      String? sku,
      String? image,
      Map<String, String> attributes,
      bool isActive});
}

/// @nodoc
class _$ProductVariantModelCopyWithImpl<$Res, $Val extends ProductVariantModel>
    implements $ProductVariantModelCopyWith<$Res> {
  _$ProductVariantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? stock = null,
    Object? sku = freezed,
    Object? image = freezed,
    Object? attributes = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductVariantModelImplCopyWith<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  factory _$$ProductVariantModelImplCopyWith(_$ProductVariantModelImpl value,
          $Res Function(_$ProductVariantModelImpl) then) =
      __$$ProductVariantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      double? compareAtPrice,
      int stock,
      String? sku,
      String? image,
      Map<String, String> attributes,
      bool isActive});
}

/// @nodoc
class __$$ProductVariantModelImplCopyWithImpl<$Res>
    extends _$ProductVariantModelCopyWithImpl<$Res, _$ProductVariantModelImpl>
    implements _$$ProductVariantModelImplCopyWith<$Res> {
  __$$ProductVariantModelImplCopyWithImpl(_$ProductVariantModelImpl _value,
      $Res Function(_$ProductVariantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? stock = null,
    Object? sku = freezed,
    Object? image = freezed,
    Object? attributes = null,
    Object? isActive = null,
  }) {
    return _then(_$ProductVariantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      attributes: null == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductVariantModelImpl implements _ProductVariantModel {
  const _$ProductVariantModelImpl(
      {required this.id,
      required this.name,
      required this.price,
      this.compareAtPrice,
      required this.stock,
      this.sku,
      this.image,
      final Map<String, String> attributes = const {},
      this.isActive = true})
      : _attributes = attributes;

  factory _$ProductVariantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVariantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final double? compareAtPrice;
  @override
  final int stock;
  @override
  final String? sku;
  @override
  final String? image;
  final Map<String, String> _attributes;
  @override
  @JsonKey()
  Map<String, String> get attributes {
    if (_attributes is EqualUnmodifiableMapView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_attributes);
  }

// e.g., {"color": "Red", "size": "XL"}
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, name: $name, price: $price, compareAtPrice: $compareAtPrice, stock: $stock, sku: $sku, image: $image, attributes: $attributes, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      price,
      compareAtPrice,
      stock,
      sku,
      image,
      const DeepCollectionEquality().hash(_attributes),
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariantModelImplCopyWith<_$ProductVariantModelImpl> get copyWith =>
      __$$ProductVariantModelImplCopyWithImpl<_$ProductVariantModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVariantModelImplToJson(
      this,
    );
  }
}

abstract class _ProductVariantModel implements ProductVariantModel {
  const factory _ProductVariantModel(
      {required final String id,
      required final String name,
      required final double price,
      final double? compareAtPrice,
      required final int stock,
      final String? sku,
      final String? image,
      final Map<String, String> attributes,
      final bool isActive}) = _$ProductVariantModelImpl;

  factory _ProductVariantModel.fromJson(Map<String, dynamic> json) =
      _$ProductVariantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  double? get compareAtPrice;
  @override
  int get stock;
  @override
  String? get sku;
  @override
  String? get image;
  @override
  Map<String, String> get attributes;
  @override // e.g., {"color": "Red", "size": "XL"}
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ProductVariantModelImplCopyWith<_$ProductVariantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductAttributeModel _$ProductAttributeModelFromJson(
    Map<String, dynamic> json) {
  return _ProductAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$ProductAttributeModel {
  String get name => throw _privateConstructorUsedError;
  List<String> get values => throw _privateConstructorUsedError;
  String? get displayType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductAttributeModelCopyWith<ProductAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAttributeModelCopyWith<$Res> {
  factory $ProductAttributeModelCopyWith(ProductAttributeModel value,
          $Res Function(ProductAttributeModel) then) =
      _$ProductAttributeModelCopyWithImpl<$Res, ProductAttributeModel>;
  @useResult
  $Res call({String name, List<String> values, String? displayType});
}

/// @nodoc
class _$ProductAttributeModelCopyWithImpl<$Res,
        $Val extends ProductAttributeModel>
    implements $ProductAttributeModelCopyWith<$Res> {
  _$ProductAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? values = null,
    Object? displayType = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
      displayType: freezed == displayType
          ? _value.displayType
          : displayType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductAttributeModelImplCopyWith<$Res>
    implements $ProductAttributeModelCopyWith<$Res> {
  factory _$$ProductAttributeModelImplCopyWith(
          _$ProductAttributeModelImpl value,
          $Res Function(_$ProductAttributeModelImpl) then) =
      __$$ProductAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<String> values, String? displayType});
}

/// @nodoc
class __$$ProductAttributeModelImplCopyWithImpl<$Res>
    extends _$ProductAttributeModelCopyWithImpl<$Res,
        _$ProductAttributeModelImpl>
    implements _$$ProductAttributeModelImplCopyWith<$Res> {
  __$$ProductAttributeModelImplCopyWithImpl(_$ProductAttributeModelImpl _value,
      $Res Function(_$ProductAttributeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? values = null,
    Object? displayType = freezed,
  }) {
    return _then(_$ProductAttributeModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
      displayType: freezed == displayType
          ? _value.displayType
          : displayType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductAttributeModelImpl implements _ProductAttributeModel {
  const _$ProductAttributeModelImpl(
      {required this.name,
      required final List<String> values,
      this.displayType})
      : _values = values;

  factory _$ProductAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductAttributeModelImplFromJson(json);

  @override
  final String name;
  final List<String> _values;
  @override
  List<String> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  final String? displayType;

  @override
  String toString() {
    return 'ProductAttributeModel(name: $name, values: $values, displayType: $displayType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAttributeModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.displayType, displayType) ||
                other.displayType == displayType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(_values), displayType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAttributeModelImplCopyWith<_$ProductAttributeModelImpl>
      get copyWith => __$$ProductAttributeModelImplCopyWithImpl<
          _$ProductAttributeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductAttributeModelImplToJson(
      this,
    );
  }
}

abstract class _ProductAttributeModel implements ProductAttributeModel {
  const factory _ProductAttributeModel(
      {required final String name,
      required final List<String> values,
      final String? displayType}) = _$ProductAttributeModelImpl;

  factory _ProductAttributeModel.fromJson(Map<String, dynamic> json) =
      _$ProductAttributeModelImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get values;
  @override
  String? get displayType;
  @override
  @JsonKey(ignore: true)
  _$$ProductAttributeModelImplCopyWith<_$ProductAttributeModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProductSpecificationModel _$ProductSpecificationModelFromJson(
    Map<String, dynamic> json) {
  return _ProductSpecificationModel.fromJson(json);
}

/// @nodoc
mixin _$ProductSpecificationModel {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get group => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductSpecificationModelCopyWith<ProductSpecificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSpecificationModelCopyWith<$Res> {
  factory $ProductSpecificationModelCopyWith(ProductSpecificationModel value,
          $Res Function(ProductSpecificationModel) then) =
      _$ProductSpecificationModelCopyWithImpl<$Res, ProductSpecificationModel>;
  @useResult
  $Res call({String name, String value, String? group});
}

/// @nodoc
class _$ProductSpecificationModelCopyWithImpl<$Res,
        $Val extends ProductSpecificationModel>
    implements $ProductSpecificationModelCopyWith<$Res> {
  _$ProductSpecificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? group = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductSpecificationModelImplCopyWith<$Res>
    implements $ProductSpecificationModelCopyWith<$Res> {
  factory _$$ProductSpecificationModelImplCopyWith(
          _$ProductSpecificationModelImpl value,
          $Res Function(_$ProductSpecificationModelImpl) then) =
      __$$ProductSpecificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value, String? group});
}

/// @nodoc
class __$$ProductSpecificationModelImplCopyWithImpl<$Res>
    extends _$ProductSpecificationModelCopyWithImpl<$Res,
        _$ProductSpecificationModelImpl>
    implements _$$ProductSpecificationModelImplCopyWith<$Res> {
  __$$ProductSpecificationModelImplCopyWithImpl(
      _$ProductSpecificationModelImpl _value,
      $Res Function(_$ProductSpecificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? group = freezed,
  }) {
    return _then(_$ProductSpecificationModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSpecificationModelImpl implements _ProductSpecificationModel {
  const _$ProductSpecificationModelImpl(
      {required this.name, required this.value, this.group});

  factory _$ProductSpecificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSpecificationModelImplFromJson(json);

  @override
  final String name;
  @override
  final String value;
  @override
  final String? group;

  @override
  String toString() {
    return 'ProductSpecificationModel(name: $name, value: $value, group: $group)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSpecificationModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.group, group) || other.group == group));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, group);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSpecificationModelImplCopyWith<_$ProductSpecificationModelImpl>
      get copyWith => __$$ProductSpecificationModelImplCopyWithImpl<
          _$ProductSpecificationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSpecificationModelImplToJson(
      this,
    );
  }
}

abstract class _ProductSpecificationModel implements ProductSpecificationModel {
  const factory _ProductSpecificationModel(
      {required final String name,
      required final String value,
      final String? group}) = _$ProductSpecificationModelImpl;

  factory _ProductSpecificationModel.fromJson(Map<String, dynamic> json) =
      _$ProductSpecificationModelImpl.fromJson;

  @override
  String get name;
  @override
  String get value;
  @override
  String? get group;
  @override
  @JsonKey(ignore: true)
  _$$ProductSpecificationModelImplCopyWith<_$ProductSpecificationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
