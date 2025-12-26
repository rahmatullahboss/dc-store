// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WishlistModel _$WishlistModelFromJson(Map<String, dynamic> json) {
  return _WishlistModel.fromJson(json);
}

/// @nodoc
mixin _$WishlistModel {
  String get id => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  List<WishlistItemModel> get items => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WishlistModelCopyWith<WishlistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistModelCopyWith<$Res> {
  factory $WishlistModelCopyWith(
          WishlistModel value, $Res Function(WishlistModel) then) =
      _$WishlistModelCopyWithImpl<$Res, WishlistModel>;
  @useResult
  $Res call(
      {String id,
      String? userId,
      List<WishlistItemModel> items,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WishlistModelCopyWithImpl<$Res, $Val extends WishlistModel>
    implements $WishlistModelCopyWith<$Res> {
  _$WishlistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? items = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WishlistItemModel>,
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
abstract class _$$WishlistModelImplCopyWith<$Res>
    implements $WishlistModelCopyWith<$Res> {
  factory _$$WishlistModelImplCopyWith(
          _$WishlistModelImpl value, $Res Function(_$WishlistModelImpl) then) =
      __$$WishlistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? userId,
      List<WishlistItemModel> items,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WishlistModelImplCopyWithImpl<$Res>
    extends _$WishlistModelCopyWithImpl<$Res, _$WishlistModelImpl>
    implements _$$WishlistModelImplCopyWith<$Res> {
  __$$WishlistModelImplCopyWithImpl(
      _$WishlistModelImpl _value, $Res Function(_$WishlistModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? items = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WishlistModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WishlistItemModel>,
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
class _$WishlistModelImpl extends _WishlistModel {
  const _$WishlistModelImpl(
      {required this.id,
      this.userId,
      final List<WishlistItemModel> items = const [],
      this.createdAt,
      this.updatedAt})
      : _items = items,
        super._();

  factory _$WishlistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? userId;
  final List<WishlistItemModel> _items;
  @override
  @JsonKey()
  List<WishlistItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WishlistModel(id: $id, userId: $userId, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId,
      const DeepCollectionEquality().hash(_items), createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistModelImplCopyWith<_$WishlistModelImpl> get copyWith =>
      __$$WishlistModelImplCopyWithImpl<_$WishlistModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistModelImplToJson(
      this,
    );
  }
}

abstract class _WishlistModel extends WishlistModel {
  const factory _WishlistModel(
      {required final String id,
      final String? userId,
      final List<WishlistItemModel> items,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WishlistModelImpl;
  const _WishlistModel._() : super._();

  factory _WishlistModel.fromJson(Map<String, dynamic> json) =
      _$WishlistModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get userId;
  @override
  List<WishlistItemModel> get items;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WishlistModelImplCopyWith<_$WishlistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WishlistItemModel _$WishlistItemModelFromJson(Map<String, dynamic> json) {
  return _WishlistItemModel.fromJson(json);
}

/// @nodoc
mixin _$WishlistItemModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get productImage => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  double? get compareAtPrice => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get inStock => throw _privateConstructorUsedError;
  DateTime? get addedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WishlistItemModelCopyWith<WishlistItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistItemModelCopyWith<$Res> {
  factory $WishlistItemModelCopyWith(
          WishlistItemModel value, $Res Function(WishlistItemModel) then) =
      _$WishlistItemModelCopyWithImpl<$Res, WishlistItemModel>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String? productName,
      String? productImage,
      double? price,
      double? compareAtPrice,
      bool isAvailable,
      bool inStock,
      DateTime? addedAt});
}

/// @nodoc
class _$WishlistItemModelCopyWithImpl<$Res, $Val extends WishlistItemModel>
    implements $WishlistItemModelCopyWith<$Res> {
  _$WishlistItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = freezed,
    Object? productImage = freezed,
    Object? price = freezed,
    Object? compareAtPrice = freezed,
    Object? isAvailable = null,
    Object? inStock = null,
    Object? addedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistItemModelImplCopyWith<$Res>
    implements $WishlistItemModelCopyWith<$Res> {
  factory _$$WishlistItemModelImplCopyWith(_$WishlistItemModelImpl value,
          $Res Function(_$WishlistItemModelImpl) then) =
      __$$WishlistItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String? productName,
      String? productImage,
      double? price,
      double? compareAtPrice,
      bool isAvailable,
      bool inStock,
      DateTime? addedAt});
}

/// @nodoc
class __$$WishlistItemModelImplCopyWithImpl<$Res>
    extends _$WishlistItemModelCopyWithImpl<$Res, _$WishlistItemModelImpl>
    implements _$$WishlistItemModelImplCopyWith<$Res> {
  __$$WishlistItemModelImplCopyWithImpl(_$WishlistItemModelImpl _value,
      $Res Function(_$WishlistItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = freezed,
    Object? productImage = freezed,
    Object? price = freezed,
    Object? compareAtPrice = freezed,
    Object? isAvailable = null,
    Object? inStock = null,
    Object? addedAt = freezed,
  }) {
    return _then(_$WishlistItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WishlistItemModelImpl extends _WishlistItemModel {
  const _$WishlistItemModelImpl(
      {required this.id,
      required this.productId,
      this.productName,
      this.productImage,
      this.price,
      this.compareAtPrice,
      this.isAvailable = true,
      this.inStock = true,
      this.addedAt})
      : super._();

  factory _$WishlistItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String? productName;
  @override
  final String? productImage;
  @override
  final double? price;
  @override
  final double? compareAtPrice;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool inStock;
  @override
  final DateTime? addedAt;

  @override
  String toString() {
    return 'WishlistItemModel(id: $id, productId: $productId, productName: $productName, productImage: $productImage, price: $price, compareAtPrice: $compareAtPrice, isAvailable: $isAvailable, inStock: $inStock, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.inStock, inStock) || other.inStock == inStock) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, productId, productName,
      productImage, price, compareAtPrice, isAvailable, inStock, addedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistItemModelImplCopyWith<_$WishlistItemModelImpl> get copyWith =>
      __$$WishlistItemModelImplCopyWithImpl<_$WishlistItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistItemModelImplToJson(
      this,
    );
  }
}

abstract class _WishlistItemModel extends WishlistItemModel {
  const factory _WishlistItemModel(
      {required final String id,
      required final String productId,
      final String? productName,
      final String? productImage,
      final double? price,
      final double? compareAtPrice,
      final bool isAvailable,
      final bool inStock,
      final DateTime? addedAt}) = _$WishlistItemModelImpl;
  const _WishlistItemModel._() : super._();

  factory _WishlistItemModel.fromJson(Map<String, dynamic> json) =
      _$WishlistItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String? get productName;
  @override
  String? get productImage;
  @override
  double? get price;
  @override
  double? get compareAtPrice;
  @override
  bool get isAvailable;
  @override
  bool get inStock;
  @override
  DateTime? get addedAt;
  @override
  @JsonKey(ignore: true)
  _$$WishlistItemModelImplCopyWith<_$WishlistItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
