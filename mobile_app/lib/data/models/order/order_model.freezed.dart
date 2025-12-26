// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  List<OrderItemModel> get items => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  AddressModel get shippingAddress => throw _privateConstructorUsedError;
  AddressModel? get billingAddress => throw _privateConstructorUsedError;
  OrderTrackingModel? get tracking => throw _privateConstructorUsedError;
  List<OrderTimelineModel> get timeline => throw _privateConstructorUsedError;
  OrderTotalsModel get totals => throw _privateConstructorUsedError;
  String? get couponCode => throw _privateConstructorUsedError;
  double? get couponDiscount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get customerNotes => throw _privateConstructorUsedError;
  DateTime? get estimatedDelivery => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deliveredAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String id,
      String orderNumber,
      List<OrderItemModel> items,
      OrderStatus status,
      PaymentStatus paymentStatus,
      String? paymentMethod,
      String? transactionId,
      AddressModel shippingAddress,
      AddressModel? billingAddress,
      OrderTrackingModel? tracking,
      List<OrderTimelineModel> timeline,
      OrderTotalsModel totals,
      String? couponCode,
      double? couponDiscount,
      String? notes,
      String? customerNotes,
      DateTime? estimatedDelivery,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? deliveredAt});

  $AddressModelCopyWith<$Res> get shippingAddress;
  $AddressModelCopyWith<$Res>? get billingAddress;
  $OrderTrackingModelCopyWith<$Res>? get tracking;
  $OrderTotalsModelCopyWith<$Res> get totals;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? items = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? transactionId = freezed,
    Object? shippingAddress = null,
    Object? billingAddress = freezed,
    Object? tracking = freezed,
    Object? timeline = null,
    Object? totals = null,
    Object? couponCode = freezed,
    Object? couponDiscount = freezed,
    Object? notes = freezed,
    Object? customerNotes = freezed,
    Object? estimatedDelivery = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deliveredAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddress: null == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      billingAddress: freezed == billingAddress
          ? _value.billingAddress
          : billingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      tracking: freezed == tracking
          ? _value.tracking
          : tracking // ignore: cast_nullable_to_non_nullable
              as OrderTrackingModel?,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<OrderTimelineModel>,
      totals: null == totals
          ? _value.totals
          : totals // ignore: cast_nullable_to_non_nullable
              as OrderTotalsModel,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      couponDiscount: freezed == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerNotes: freezed == customerNotes
          ? _value.customerNotes
          : customerNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDelivery: freezed == estimatedDelivery
          ? _value.estimatedDelivery
          : estimatedDelivery // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res> get shippingAddress {
    return $AddressModelCopyWith<$Res>(_value.shippingAddress, (value) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get billingAddress {
    if (_value.billingAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.billingAddress!, (value) {
      return _then(_value.copyWith(billingAddress: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderTrackingModelCopyWith<$Res>? get tracking {
    if (_value.tracking == null) {
      return null;
    }

    return $OrderTrackingModelCopyWith<$Res>(_value.tracking!, (value) {
      return _then(_value.copyWith(tracking: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderTotalsModelCopyWith<$Res> get totals {
    return $OrderTotalsModelCopyWith<$Res>(_value.totals, (value) {
      return _then(_value.copyWith(totals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderNumber,
      List<OrderItemModel> items,
      OrderStatus status,
      PaymentStatus paymentStatus,
      String? paymentMethod,
      String? transactionId,
      AddressModel shippingAddress,
      AddressModel? billingAddress,
      OrderTrackingModel? tracking,
      List<OrderTimelineModel> timeline,
      OrderTotalsModel totals,
      String? couponCode,
      double? couponDiscount,
      String? notes,
      String? customerNotes,
      DateTime? estimatedDelivery,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? deliveredAt});

  @override
  $AddressModelCopyWith<$Res> get shippingAddress;
  @override
  $AddressModelCopyWith<$Res>? get billingAddress;
  @override
  $OrderTrackingModelCopyWith<$Res>? get tracking;
  @override
  $OrderTotalsModelCopyWith<$Res> get totals;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? items = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? transactionId = freezed,
    Object? shippingAddress = null,
    Object? billingAddress = freezed,
    Object? tracking = freezed,
    Object? timeline = null,
    Object? totals = null,
    Object? couponCode = freezed,
    Object? couponDiscount = freezed,
    Object? notes = freezed,
    Object? customerNotes = freezed,
    Object? estimatedDelivery = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deliveredAt = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddress: null == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      billingAddress: freezed == billingAddress
          ? _value.billingAddress
          : billingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      tracking: freezed == tracking
          ? _value.tracking
          : tracking // ignore: cast_nullable_to_non_nullable
              as OrderTrackingModel?,
      timeline: null == timeline
          ? _value._timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<OrderTimelineModel>,
      totals: null == totals
          ? _value.totals
          : totals // ignore: cast_nullable_to_non_nullable
              as OrderTotalsModel,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      couponDiscount: freezed == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerNotes: freezed == customerNotes
          ? _value.customerNotes
          : customerNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDelivery: freezed == estimatedDelivery
          ? _value.estimatedDelivery
          : estimatedDelivery // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl extends _OrderModel {
  const _$OrderModelImpl(
      {required this.id,
      required this.orderNumber,
      required final List<OrderItemModel> items,
      this.status = OrderStatus.pending,
      this.paymentStatus = PaymentStatus.pending,
      this.paymentMethod,
      this.transactionId,
      required this.shippingAddress,
      this.billingAddress,
      this.tracking,
      final List<OrderTimelineModel> timeline = const [],
      required this.totals,
      this.couponCode,
      this.couponDiscount,
      this.notes,
      this.customerNotes,
      this.estimatedDelivery,
      required this.createdAt,
      this.updatedAt,
      this.deliveredAt})
      : _items = items,
        _timeline = timeline,
        super._();

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String id;
  @override
  final String orderNumber;
  final List<OrderItemModel> _items;
  @override
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final OrderStatus status;
  @override
  @JsonKey()
  final PaymentStatus paymentStatus;
  @override
  final String? paymentMethod;
  @override
  final String? transactionId;
  @override
  final AddressModel shippingAddress;
  @override
  final AddressModel? billingAddress;
  @override
  final OrderTrackingModel? tracking;
  final List<OrderTimelineModel> _timeline;
  @override
  @JsonKey()
  List<OrderTimelineModel> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  final OrderTotalsModel totals;
  @override
  final String? couponCode;
  @override
  final double? couponDiscount;
  @override
  final String? notes;
  @override
  final String? customerNotes;
  @override
  final DateTime? estimatedDelivery;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deliveredAt;

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, items: $items, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, transactionId: $transactionId, shippingAddress: $shippingAddress, billingAddress: $billingAddress, tracking: $tracking, timeline: $timeline, totals: $totals, couponCode: $couponCode, couponDiscount: $couponDiscount, notes: $notes, customerNotes: $customerNotes, estimatedDelivery: $estimatedDelivery, createdAt: $createdAt, updatedAt: $updatedAt, deliveredAt: $deliveredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.billingAddress, billingAddress) ||
                other.billingAddress == billingAddress) &&
            (identical(other.tracking, tracking) ||
                other.tracking == tracking) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline) &&
            (identical(other.totals, totals) || other.totals == totals) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.couponDiscount, couponDiscount) ||
                other.couponDiscount == couponDiscount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customerNotes, customerNotes) ||
                other.customerNotes == customerNotes) &&
            (identical(other.estimatedDelivery, estimatedDelivery) ||
                other.estimatedDelivery == estimatedDelivery) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        const DeepCollectionEquality().hash(_items),
        status,
        paymentStatus,
        paymentMethod,
        transactionId,
        shippingAddress,
        billingAddress,
        tracking,
        const DeepCollectionEquality().hash(_timeline),
        totals,
        couponCode,
        couponDiscount,
        notes,
        customerNotes,
        estimatedDelivery,
        createdAt,
        updatedAt,
        deliveredAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel extends OrderModel {
  const factory _OrderModel(
      {required final String id,
      required final String orderNumber,
      required final List<OrderItemModel> items,
      final OrderStatus status,
      final PaymentStatus paymentStatus,
      final String? paymentMethod,
      final String? transactionId,
      required final AddressModel shippingAddress,
      final AddressModel? billingAddress,
      final OrderTrackingModel? tracking,
      final List<OrderTimelineModel> timeline,
      required final OrderTotalsModel totals,
      final String? couponCode,
      final double? couponDiscount,
      final String? notes,
      final String? customerNotes,
      final DateTime? estimatedDelivery,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? deliveredAt}) = _$OrderModelImpl;
  const _OrderModel._() : super._();

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orderNumber;
  @override
  List<OrderItemModel> get items;
  @override
  OrderStatus get status;
  @override
  PaymentStatus get paymentStatus;
  @override
  String? get paymentMethod;
  @override
  String? get transactionId;
  @override
  AddressModel get shippingAddress;
  @override
  AddressModel? get billingAddress;
  @override
  OrderTrackingModel? get tracking;
  @override
  List<OrderTimelineModel> get timeline;
  @override
  OrderTotalsModel get totals;
  @override
  String? get couponCode;
  @override
  double? get couponDiscount;
  @override
  String? get notes;
  @override
  String? get customerNotes;
  @override
  DateTime? get estimatedDelivery;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deliveredAt;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get productImage => throw _privateConstructorUsedError;
  String? get variantId => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  Map<String, String>? get attributes => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get compareAtPrice => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) then) =
      _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      String? productImage,
      String? variantId,
      String? variantName,
      Map<String, String>? attributes,
      int quantity,
      double price,
      double? compareAtPrice,
      double total,
      String? sku});
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? productImage = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? attributes = freezed,
    Object? quantity = null,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? total = null,
    Object? sku = freezed,
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
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      attributes: freezed == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(_$OrderItemModelImpl value,
          $Res Function(_$OrderItemModelImpl) then) =
      __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      String? productImage,
      String? variantId,
      String? variantName,
      Map<String, String>? attributes,
      int quantity,
      double price,
      double? compareAtPrice,
      double total,
      String? sku});
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
      _$OrderItemModelImpl _value, $Res Function(_$OrderItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? productImage = freezed,
    Object? variantId = freezed,
    Object? variantName = freezed,
    Object? attributes = freezed,
    Object? quantity = null,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? total = null,
    Object? sku = freezed,
  }) {
    return _then(_$OrderItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      attributes: freezed == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl(
      {required this.id,
      required this.productId,
      required this.productName,
      this.productImage,
      this.variantId,
      this.variantName,
      final Map<String, String>? attributes,
      required this.quantity,
      required this.price,
      this.compareAtPrice,
      required this.total,
      this.sku})
      : _attributes = attributes;

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? productImage;
  @override
  final String? variantId;
  @override
  final String? variantName;
  final Map<String, String>? _attributes;
  @override
  Map<String, String>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableMapView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int quantity;
  @override
  final double price;
  @override
  final double? compareAtPrice;
  @override
  final double total;
  @override
  final String? sku;

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productId: $productId, productName: $productName, productImage: $productImage, variantId: $variantId, variantName: $variantName, attributes: $attributes, quantity: $quantity, price: $price, compareAtPrice: $compareAtPrice, total: $total, sku: $sku)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.sku, sku) || other.sku == sku));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      productName,
      productImage,
      variantId,
      variantName,
      const DeepCollectionEquality().hash(_attributes),
      quantity,
      price,
      compareAtPrice,
      total,
      sku);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel(
      {required final String id,
      required final String productId,
      required final String productName,
      final String? productImage,
      final String? variantId,
      final String? variantName,
      final Map<String, String>? attributes,
      required final int quantity,
      required final double price,
      final double? compareAtPrice,
      required final double total,
      final String? sku}) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get productImage;
  @override
  String? get variantId;
  @override
  String? get variantName;
  @override
  Map<String, String>? get attributes;
  @override
  int get quantity;
  @override
  double get price;
  @override
  double? get compareAtPrice;
  @override
  double get total;
  @override
  String? get sku;
  @override
  @JsonKey(ignore: true)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderTotalsModel _$OrderTotalsModelFromJson(Map<String, dynamic> json) {
  return _OrderTotalsModel.fromJson(json);
}

/// @nodoc
mixin _$OrderTotalsModel {
  double get subtotal => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get shipping => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderTotalsModelCopyWith<OrderTotalsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderTotalsModelCopyWith<$Res> {
  factory $OrderTotalsModelCopyWith(
          OrderTotalsModel value, $Res Function(OrderTotalsModel) then) =
      _$OrderTotalsModelCopyWithImpl<$Res, OrderTotalsModel>;
  @useResult
  $Res call(
      {double subtotal,
      double discount,
      double shipping,
      double tax,
      double total});
}

/// @nodoc
class _$OrderTotalsModelCopyWithImpl<$Res, $Val extends OrderTotalsModel>
    implements $OrderTotalsModelCopyWith<$Res> {
  _$OrderTotalsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? discount = null,
    Object? shipping = null,
    Object? tax = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: null == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderTotalsModelImplCopyWith<$Res>
    implements $OrderTotalsModelCopyWith<$Res> {
  factory _$$OrderTotalsModelImplCopyWith(_$OrderTotalsModelImpl value,
          $Res Function(_$OrderTotalsModelImpl) then) =
      __$$OrderTotalsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double subtotal,
      double discount,
      double shipping,
      double tax,
      double total});
}

/// @nodoc
class __$$OrderTotalsModelImplCopyWithImpl<$Res>
    extends _$OrderTotalsModelCopyWithImpl<$Res, _$OrderTotalsModelImpl>
    implements _$$OrderTotalsModelImplCopyWith<$Res> {
  __$$OrderTotalsModelImplCopyWithImpl(_$OrderTotalsModelImpl _value,
      $Res Function(_$OrderTotalsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? discount = null,
    Object? shipping = null,
    Object? tax = null,
    Object? total = null,
  }) {
    return _then(_$OrderTotalsModelImpl(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: null == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderTotalsModelImpl implements _OrderTotalsModel {
  const _$OrderTotalsModelImpl(
      {required this.subtotal,
      this.discount = 0.0,
      this.shipping = 0.0,
      this.tax = 0.0,
      required this.total});

  factory _$OrderTotalsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderTotalsModelImplFromJson(json);

  @override
  final double subtotal;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double shipping;
  @override
  @JsonKey()
  final double tax;
  @override
  final double total;

  @override
  String toString() {
    return 'OrderTotalsModel(subtotal: $subtotal, discount: $discount, shipping: $shipping, tax: $tax, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderTotalsModelImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, subtotal, discount, shipping, tax, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderTotalsModelImplCopyWith<_$OrderTotalsModelImpl> get copyWith =>
      __$$OrderTotalsModelImplCopyWithImpl<_$OrderTotalsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderTotalsModelImplToJson(
      this,
    );
  }
}

abstract class _OrderTotalsModel implements OrderTotalsModel {
  const factory _OrderTotalsModel(
      {required final double subtotal,
      final double discount,
      final double shipping,
      final double tax,
      required final double total}) = _$OrderTotalsModelImpl;

  factory _OrderTotalsModel.fromJson(Map<String, dynamic> json) =
      _$OrderTotalsModelImpl.fromJson;

  @override
  double get subtotal;
  @override
  double get discount;
  @override
  double get shipping;
  @override
  double get tax;
  @override
  double get total;
  @override
  @JsonKey(ignore: true)
  _$$OrderTotalsModelImplCopyWith<_$OrderTotalsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderTrackingModel _$OrderTrackingModelFromJson(Map<String, dynamic> json) {
  return _OrderTrackingModel.fromJson(json);
}

/// @nodoc
mixin _$OrderTrackingModel {
  String? get trackingNumber => throw _privateConstructorUsedError;
  String? get carrier => throw _privateConstructorUsedError;
  String? get trackingUrl => throw _privateConstructorUsedError;
  String? get currentLocation => throw _privateConstructorUsedError;
  DateTime? get lastUpdate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderTrackingModelCopyWith<OrderTrackingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderTrackingModelCopyWith<$Res> {
  factory $OrderTrackingModelCopyWith(
          OrderTrackingModel value, $Res Function(OrderTrackingModel) then) =
      _$OrderTrackingModelCopyWithImpl<$Res, OrderTrackingModel>;
  @useResult
  $Res call(
      {String? trackingNumber,
      String? carrier,
      String? trackingUrl,
      String? currentLocation,
      DateTime? lastUpdate});
}

/// @nodoc
class _$OrderTrackingModelCopyWithImpl<$Res, $Val extends OrderTrackingModel>
    implements $OrderTrackingModelCopyWith<$Res> {
  _$OrderTrackingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackingNumber = freezed,
    Object? carrier = freezed,
    Object? trackingUrl = freezed,
    Object? currentLocation = freezed,
    Object? lastUpdate = freezed,
  }) {
    return _then(_value.copyWith(
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      carrier: freezed == carrier
          ? _value.carrier
          : carrier // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingUrl: freezed == trackingUrl
          ? _value.trackingUrl
          : trackingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdate: freezed == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderTrackingModelImplCopyWith<$Res>
    implements $OrderTrackingModelCopyWith<$Res> {
  factory _$$OrderTrackingModelImplCopyWith(_$OrderTrackingModelImpl value,
          $Res Function(_$OrderTrackingModelImpl) then) =
      __$$OrderTrackingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? trackingNumber,
      String? carrier,
      String? trackingUrl,
      String? currentLocation,
      DateTime? lastUpdate});
}

/// @nodoc
class __$$OrderTrackingModelImplCopyWithImpl<$Res>
    extends _$OrderTrackingModelCopyWithImpl<$Res, _$OrderTrackingModelImpl>
    implements _$$OrderTrackingModelImplCopyWith<$Res> {
  __$$OrderTrackingModelImplCopyWithImpl(_$OrderTrackingModelImpl _value,
      $Res Function(_$OrderTrackingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackingNumber = freezed,
    Object? carrier = freezed,
    Object? trackingUrl = freezed,
    Object? currentLocation = freezed,
    Object? lastUpdate = freezed,
  }) {
    return _then(_$OrderTrackingModelImpl(
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      carrier: freezed == carrier
          ? _value.carrier
          : carrier // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingUrl: freezed == trackingUrl
          ? _value.trackingUrl
          : trackingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdate: freezed == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderTrackingModelImpl implements _OrderTrackingModel {
  const _$OrderTrackingModelImpl(
      {this.trackingNumber,
      this.carrier,
      this.trackingUrl,
      this.currentLocation,
      this.lastUpdate});

  factory _$OrderTrackingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderTrackingModelImplFromJson(json);

  @override
  final String? trackingNumber;
  @override
  final String? carrier;
  @override
  final String? trackingUrl;
  @override
  final String? currentLocation;
  @override
  final DateTime? lastUpdate;

  @override
  String toString() {
    return 'OrderTrackingModel(trackingNumber: $trackingNumber, carrier: $carrier, trackingUrl: $trackingUrl, currentLocation: $currentLocation, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderTrackingModelImpl &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.carrier, carrier) || other.carrier == carrier) &&
            (identical(other.trackingUrl, trackingUrl) ||
                other.trackingUrl == trackingUrl) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, trackingNumber, carrier,
      trackingUrl, currentLocation, lastUpdate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderTrackingModelImplCopyWith<_$OrderTrackingModelImpl> get copyWith =>
      __$$OrderTrackingModelImplCopyWithImpl<_$OrderTrackingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderTrackingModelImplToJson(
      this,
    );
  }
}

abstract class _OrderTrackingModel implements OrderTrackingModel {
  const factory _OrderTrackingModel(
      {final String? trackingNumber,
      final String? carrier,
      final String? trackingUrl,
      final String? currentLocation,
      final DateTime? lastUpdate}) = _$OrderTrackingModelImpl;

  factory _OrderTrackingModel.fromJson(Map<String, dynamic> json) =
      _$OrderTrackingModelImpl.fromJson;

  @override
  String? get trackingNumber;
  @override
  String? get carrier;
  @override
  String? get trackingUrl;
  @override
  String? get currentLocation;
  @override
  DateTime? get lastUpdate;
  @override
  @JsonKey(ignore: true)
  _$$OrderTrackingModelImplCopyWith<_$OrderTrackingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderTimelineModel _$OrderTimelineModelFromJson(Map<String, dynamic> json) {
  return _OrderTimelineModel.fromJson(json);
}

/// @nodoc
mixin _$OrderTimelineModel {
  String get status => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderTimelineModelCopyWith<OrderTimelineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderTimelineModelCopyWith<$Res> {
  factory $OrderTimelineModelCopyWith(
          OrderTimelineModel value, $Res Function(OrderTimelineModel) then) =
      _$OrderTimelineModelCopyWithImpl<$Res, OrderTimelineModel>;
  @useResult
  $Res call(
      {String status,
      String title,
      String? description,
      DateTime timestamp,
      String? icon,
      bool isCompleted});
}

/// @nodoc
class _$OrderTimelineModelCopyWithImpl<$Res, $Val extends OrderTimelineModel>
    implements $OrderTimelineModelCopyWith<$Res> {
  _$OrderTimelineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? title = null,
    Object? description = freezed,
    Object? timestamp = null,
    Object? icon = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderTimelineModelImplCopyWith<$Res>
    implements $OrderTimelineModelCopyWith<$Res> {
  factory _$$OrderTimelineModelImplCopyWith(_$OrderTimelineModelImpl value,
          $Res Function(_$OrderTimelineModelImpl) then) =
      __$$OrderTimelineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String title,
      String? description,
      DateTime timestamp,
      String? icon,
      bool isCompleted});
}

/// @nodoc
class __$$OrderTimelineModelImplCopyWithImpl<$Res>
    extends _$OrderTimelineModelCopyWithImpl<$Res, _$OrderTimelineModelImpl>
    implements _$$OrderTimelineModelImplCopyWith<$Res> {
  __$$OrderTimelineModelImplCopyWithImpl(_$OrderTimelineModelImpl _value,
      $Res Function(_$OrderTimelineModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? title = null,
    Object? description = freezed,
    Object? timestamp = null,
    Object? icon = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_$OrderTimelineModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderTimelineModelImpl implements _OrderTimelineModel {
  const _$OrderTimelineModelImpl(
      {required this.status,
      required this.title,
      this.description,
      required this.timestamp,
      this.icon,
      this.isCompleted = false});

  factory _$OrderTimelineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderTimelineModelImplFromJson(json);

  @override
  final String status;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime timestamp;
  @override
  final String? icon;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'OrderTimelineModel(status: $status, title: $title, description: $description, timestamp: $timestamp, icon: $icon, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderTimelineModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, status, title, description, timestamp, icon, isCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderTimelineModelImplCopyWith<_$OrderTimelineModelImpl> get copyWith =>
      __$$OrderTimelineModelImplCopyWithImpl<_$OrderTimelineModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderTimelineModelImplToJson(
      this,
    );
  }
}

abstract class _OrderTimelineModel implements OrderTimelineModel {
  const factory _OrderTimelineModel(
      {required final String status,
      required final String title,
      final String? description,
      required final DateTime timestamp,
      final String? icon,
      final bool isCompleted}) = _$OrderTimelineModelImpl;

  factory _OrderTimelineModel.fromJson(Map<String, dynamic> json) =
      _$OrderTimelineModelImpl.fromJson;

  @override
  String get status;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get timestamp;
  @override
  String? get icon;
  @override
  bool get isCompleted;
  @override
  @JsonKey(ignore: true)
  _$$OrderTimelineModelImplCopyWith<_$OrderTimelineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
