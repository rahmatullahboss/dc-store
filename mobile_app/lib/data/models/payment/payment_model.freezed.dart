// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) {
  return _PaymentMethodModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodModel {
  String get id => throw _privateConstructorUsedError;
  PaymentMethodType get type => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  CardDetails? get cardDetails => throw _privateConstructorUsedError;
  MobileWalletDetails? get mobileWalletDetails =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentMethodModelCopyWith<PaymentMethodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodModelCopyWith<$Res> {
  factory $PaymentMethodModelCopyWith(
          PaymentMethodModel value, $Res Function(PaymentMethodModel) then) =
      _$PaymentMethodModelCopyWithImpl<$Res, PaymentMethodModel>;
  @useResult
  $Res call(
      {String id,
      PaymentMethodType type,
      String displayName,
      String? icon,
      bool isDefault,
      bool isActive,
      CardDetails? cardDetails,
      MobileWalletDetails? mobileWalletDetails,
      DateTime? createdAt});

  $CardDetailsCopyWith<$Res>? get cardDetails;
  $MobileWalletDetailsCopyWith<$Res>? get mobileWalletDetails;
}

/// @nodoc
class _$PaymentMethodModelCopyWithImpl<$Res, $Val extends PaymentMethodModel>
    implements $PaymentMethodModelCopyWith<$Res> {
  _$PaymentMethodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? displayName = null,
    Object? icon = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? cardDetails = freezed,
    Object? mobileWalletDetails = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      cardDetails: freezed == cardDetails
          ? _value.cardDetails
          : cardDetails // ignore: cast_nullable_to_non_nullable
              as CardDetails?,
      mobileWalletDetails: freezed == mobileWalletDetails
          ? _value.mobileWalletDetails
          : mobileWalletDetails // ignore: cast_nullable_to_non_nullable
              as MobileWalletDetails?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CardDetailsCopyWith<$Res>? get cardDetails {
    if (_value.cardDetails == null) {
      return null;
    }

    return $CardDetailsCopyWith<$Res>(_value.cardDetails!, (value) {
      return _then(_value.copyWith(cardDetails: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MobileWalletDetailsCopyWith<$Res>? get mobileWalletDetails {
    if (_value.mobileWalletDetails == null) {
      return null;
    }

    return $MobileWalletDetailsCopyWith<$Res>(_value.mobileWalletDetails!,
        (value) {
      return _then(_value.copyWith(mobileWalletDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentMethodModelImplCopyWith<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  factory _$$PaymentMethodModelImplCopyWith(_$PaymentMethodModelImpl value,
          $Res Function(_$PaymentMethodModelImpl) then) =
      __$$PaymentMethodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PaymentMethodType type,
      String displayName,
      String? icon,
      bool isDefault,
      bool isActive,
      CardDetails? cardDetails,
      MobileWalletDetails? mobileWalletDetails,
      DateTime? createdAt});

  @override
  $CardDetailsCopyWith<$Res>? get cardDetails;
  @override
  $MobileWalletDetailsCopyWith<$Res>? get mobileWalletDetails;
}

/// @nodoc
class __$$PaymentMethodModelImplCopyWithImpl<$Res>
    extends _$PaymentMethodModelCopyWithImpl<$Res, _$PaymentMethodModelImpl>
    implements _$$PaymentMethodModelImplCopyWith<$Res> {
  __$$PaymentMethodModelImplCopyWithImpl(_$PaymentMethodModelImpl _value,
      $Res Function(_$PaymentMethodModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? displayName = null,
    Object? icon = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? cardDetails = freezed,
    Object? mobileWalletDetails = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$PaymentMethodModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      cardDetails: freezed == cardDetails
          ? _value.cardDetails
          : cardDetails // ignore: cast_nullable_to_non_nullable
              as CardDetails?,
      mobileWalletDetails: freezed == mobileWalletDetails
          ? _value.mobileWalletDetails
          : mobileWalletDetails // ignore: cast_nullable_to_non_nullable
              as MobileWalletDetails?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodModelImpl implements _PaymentMethodModel {
  const _$PaymentMethodModelImpl(
      {required this.id,
      required this.type,
      required this.displayName,
      this.icon,
      this.isDefault = false,
      this.isActive = true,
      this.cardDetails,
      this.mobileWalletDetails,
      this.createdAt});

  factory _$PaymentMethodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodModelImplFromJson(json);

  @override
  final String id;
  @override
  final PaymentMethodType type;
  @override
  final String displayName;
  @override
  final String? icon;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final CardDetails? cardDetails;
  @override
  final MobileWalletDetails? mobileWalletDetails;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PaymentMethodModel(id: $id, type: $type, displayName: $displayName, icon: $icon, isDefault: $isDefault, isActive: $isActive, cardDetails: $cardDetails, mobileWalletDetails: $mobileWalletDetails, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.cardDetails, cardDetails) ||
                other.cardDetails == cardDetails) &&
            (identical(other.mobileWalletDetails, mobileWalletDetails) ||
                other.mobileWalletDetails == mobileWalletDetails) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, displayName, icon,
      isDefault, isActive, cardDetails, mobileWalletDetails, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodModelImplCopyWith<_$PaymentMethodModelImpl> get copyWith =>
      __$$PaymentMethodModelImplCopyWithImpl<_$PaymentMethodModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodModel implements PaymentMethodModel {
  const factory _PaymentMethodModel(
      {required final String id,
      required final PaymentMethodType type,
      required final String displayName,
      final String? icon,
      final bool isDefault,
      final bool isActive,
      final CardDetails? cardDetails,
      final MobileWalletDetails? mobileWalletDetails,
      final DateTime? createdAt}) = _$PaymentMethodModelImpl;

  factory _PaymentMethodModel.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodModelImpl.fromJson;

  @override
  String get id;
  @override
  PaymentMethodType get type;
  @override
  String get displayName;
  @override
  String? get icon;
  @override
  bool get isDefault;
  @override
  bool get isActive;
  @override
  CardDetails? get cardDetails;
  @override
  MobileWalletDetails? get mobileWalletDetails;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PaymentMethodModelImplCopyWith<_$PaymentMethodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CardDetails _$CardDetailsFromJson(Map<String, dynamic> json) {
  return _CardDetails.fromJson(json);
}

/// @nodoc
mixin _$CardDetails {
  String get last4 => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  int get expMonth => throw _privateConstructorUsedError;
  int get expYear => throw _privateConstructorUsedError;
  String? get cardholderName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CardDetailsCopyWith<CardDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardDetailsCopyWith<$Res> {
  factory $CardDetailsCopyWith(
          CardDetails value, $Res Function(CardDetails) then) =
      _$CardDetailsCopyWithImpl<$Res, CardDetails>;
  @useResult
  $Res call(
      {String last4,
      String brand,
      int expMonth,
      int expYear,
      String? cardholderName});
}

/// @nodoc
class _$CardDetailsCopyWithImpl<$Res, $Val extends CardDetails>
    implements $CardDetailsCopyWith<$Res> {
  _$CardDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last4 = null,
    Object? brand = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? cardholderName = freezed,
  }) {
    return _then(_value.copyWith(
      last4: null == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      cardholderName: freezed == cardholderName
          ? _value.cardholderName
          : cardholderName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardDetailsImplCopyWith<$Res>
    implements $CardDetailsCopyWith<$Res> {
  factory _$$CardDetailsImplCopyWith(
          _$CardDetailsImpl value, $Res Function(_$CardDetailsImpl) then) =
      __$$CardDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String last4,
      String brand,
      int expMonth,
      int expYear,
      String? cardholderName});
}

/// @nodoc
class __$$CardDetailsImplCopyWithImpl<$Res>
    extends _$CardDetailsCopyWithImpl<$Res, _$CardDetailsImpl>
    implements _$$CardDetailsImplCopyWith<$Res> {
  __$$CardDetailsImplCopyWithImpl(
      _$CardDetailsImpl _value, $Res Function(_$CardDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last4 = null,
    Object? brand = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? cardholderName = freezed,
  }) {
    return _then(_$CardDetailsImpl(
      last4: null == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      cardholderName: freezed == cardholderName
          ? _value.cardholderName
          : cardholderName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardDetailsImpl implements _CardDetails {
  const _$CardDetailsImpl(
      {required this.last4,
      required this.brand,
      required this.expMonth,
      required this.expYear,
      this.cardholderName});

  factory _$CardDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardDetailsImplFromJson(json);

  @override
  final String last4;
  @override
  final String brand;
  @override
  final int expMonth;
  @override
  final int expYear;
  @override
  final String? cardholderName;

  @override
  String toString() {
    return 'CardDetails(last4: $last4, brand: $brand, expMonth: $expMonth, expYear: $expYear, cardholderName: $cardholderName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardDetailsImpl &&
            (identical(other.last4, last4) || other.last4 == last4) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.cardholderName, cardholderName) ||
                other.cardholderName == cardholderName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, last4, brand, expMonth, expYear, cardholderName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CardDetailsImplCopyWith<_$CardDetailsImpl> get copyWith =>
      __$$CardDetailsImplCopyWithImpl<_$CardDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardDetailsImplToJson(
      this,
    );
  }
}

abstract class _CardDetails implements CardDetails {
  const factory _CardDetails(
      {required final String last4,
      required final String brand,
      required final int expMonth,
      required final int expYear,
      final String? cardholderName}) = _$CardDetailsImpl;

  factory _CardDetails.fromJson(Map<String, dynamic> json) =
      _$CardDetailsImpl.fromJson;

  @override
  String get last4;
  @override
  String get brand;
  @override
  int get expMonth;
  @override
  int get expYear;
  @override
  String? get cardholderName;
  @override
  @JsonKey(ignore: true)
  _$$CardDetailsImplCopyWith<_$CardDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MobileWalletDetails _$MobileWalletDetailsFromJson(Map<String, dynamic> json) {
  return _MobileWalletDetails.fromJson(json);
}

/// @nodoc
mixin _$MobileWalletDetails {
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get accountName => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MobileWalletDetailsCopyWith<MobileWalletDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileWalletDetailsCopyWith<$Res> {
  factory $MobileWalletDetailsCopyWith(
          MobileWalletDetails value, $Res Function(MobileWalletDetails) then) =
      _$MobileWalletDetailsCopyWithImpl<$Res, MobileWalletDetails>;
  @useResult
  $Res call({String phoneNumber, String? accountName, bool isVerified});
}

/// @nodoc
class _$MobileWalletDetailsCopyWithImpl<$Res, $Val extends MobileWalletDetails>
    implements $MobileWalletDetailsCopyWith<$Res> {
  _$MobileWalletDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? accountName = freezed,
    Object? isVerified = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MobileWalletDetailsImplCopyWith<$Res>
    implements $MobileWalletDetailsCopyWith<$Res> {
  factory _$$MobileWalletDetailsImplCopyWith(_$MobileWalletDetailsImpl value,
          $Res Function(_$MobileWalletDetailsImpl) then) =
      __$$MobileWalletDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String? accountName, bool isVerified});
}

/// @nodoc
class __$$MobileWalletDetailsImplCopyWithImpl<$Res>
    extends _$MobileWalletDetailsCopyWithImpl<$Res, _$MobileWalletDetailsImpl>
    implements _$$MobileWalletDetailsImplCopyWith<$Res> {
  __$$MobileWalletDetailsImplCopyWithImpl(_$MobileWalletDetailsImpl _value,
      $Res Function(_$MobileWalletDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? accountName = freezed,
    Object? isVerified = null,
  }) {
    return _then(_$MobileWalletDetailsImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileWalletDetailsImpl implements _MobileWalletDetails {
  const _$MobileWalletDetailsImpl(
      {required this.phoneNumber, this.accountName, this.isVerified = false});

  factory _$MobileWalletDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileWalletDetailsImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String? accountName;
  @override
  @JsonKey()
  final bool isVerified;

  @override
  String toString() {
    return 'MobileWalletDetails(phoneNumber: $phoneNumber, accountName: $accountName, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileWalletDetailsImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNumber, accountName, isVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileWalletDetailsImplCopyWith<_$MobileWalletDetailsImpl> get copyWith =>
      __$$MobileWalletDetailsImplCopyWithImpl<_$MobileWalletDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileWalletDetailsImplToJson(
      this,
    );
  }
}

abstract class _MobileWalletDetails implements MobileWalletDetails {
  const factory _MobileWalletDetails(
      {required final String phoneNumber,
      final String? accountName,
      final bool isVerified}) = _$MobileWalletDetailsImpl;

  factory _MobileWalletDetails.fromJson(Map<String, dynamic> json) =
      _$MobileWalletDetailsImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String? get accountName;
  @override
  bool get isVerified;
  @override
  @JsonKey(ignore: true)
  _$$MobileWalletDetailsImplCopyWith<_$MobileWalletDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentTransactionModel _$PaymentTransactionModelFromJson(
    Map<String, dynamic> json) {
  return _PaymentTransactionModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentTransactionModel {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentMethodType get method => throw _privateConstructorUsedError;
  PaymentTransactionStatus get status => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  String? get gatewayResponse => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentTransactionModelCopyWith<PaymentTransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTransactionModelCopyWith<$Res> {
  factory $PaymentTransactionModelCopyWith(PaymentTransactionModel value,
          $Res Function(PaymentTransactionModel) then) =
      _$PaymentTransactionModelCopyWithImpl<$Res, PaymentTransactionModel>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      double amount,
      String currency,
      PaymentMethodType method,
      PaymentTransactionStatus status,
      String? transactionId,
      String? gatewayResponse,
      String? errorMessage,
      DateTime? createdAt,
      DateTime? completedAt});
}

/// @nodoc
class _$PaymentTransactionModelCopyWithImpl<$Res,
        $Val extends PaymentTransactionModel>
    implements $PaymentTransactionModelCopyWith<$Res> {
  _$PaymentTransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? gatewayResponse = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentTransactionStatus,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      gatewayResponse: freezed == gatewayResponse
          ? _value.gatewayResponse
          : gatewayResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentTransactionModelImplCopyWith<$Res>
    implements $PaymentTransactionModelCopyWith<$Res> {
  factory _$$PaymentTransactionModelImplCopyWith(
          _$PaymentTransactionModelImpl value,
          $Res Function(_$PaymentTransactionModelImpl) then) =
      __$$PaymentTransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      double amount,
      String currency,
      PaymentMethodType method,
      PaymentTransactionStatus status,
      String? transactionId,
      String? gatewayResponse,
      String? errorMessage,
      DateTime? createdAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$PaymentTransactionModelImplCopyWithImpl<$Res>
    extends _$PaymentTransactionModelCopyWithImpl<$Res,
        _$PaymentTransactionModelImpl>
    implements _$$PaymentTransactionModelImplCopyWith<$Res> {
  __$$PaymentTransactionModelImplCopyWithImpl(
      _$PaymentTransactionModelImpl _value,
      $Res Function(_$PaymentTransactionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? gatewayResponse = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$PaymentTransactionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentTransactionStatus,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      gatewayResponse: freezed == gatewayResponse
          ? _value.gatewayResponse
          : gatewayResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentTransactionModelImpl implements _PaymentTransactionModel {
  const _$PaymentTransactionModelImpl(
      {required this.id,
      required this.orderId,
      required this.amount,
      this.currency = 'BDT',
      required this.method,
      required this.status,
      this.transactionId,
      this.gatewayResponse,
      this.errorMessage,
      this.createdAt,
      this.completedAt});

  factory _$PaymentTransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentTransactionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  final PaymentMethodType method;
  @override
  final PaymentTransactionStatus status;
  @override
  final String? transactionId;
  @override
  final String? gatewayResponse;
  @override
  final String? errorMessage;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'PaymentTransactionModel(id: $id, orderId: $orderId, amount: $amount, currency: $currency, method: $method, status: $status, transactionId: $transactionId, gatewayResponse: $gatewayResponse, errorMessage: $errorMessage, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.gatewayResponse, gatewayResponse) ||
                other.gatewayResponse == gatewayResponse) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      amount,
      currency,
      method,
      status,
      transactionId,
      gatewayResponse,
      errorMessage,
      createdAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTransactionModelImplCopyWith<_$PaymentTransactionModelImpl>
      get copyWith => __$$PaymentTransactionModelImplCopyWithImpl<
          _$PaymentTransactionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentTransactionModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentTransactionModel implements PaymentTransactionModel {
  const factory _PaymentTransactionModel(
      {required final String id,
      required final String orderId,
      required final double amount,
      final String currency,
      required final PaymentMethodType method,
      required final PaymentTransactionStatus status,
      final String? transactionId,
      final String? gatewayResponse,
      final String? errorMessage,
      final DateTime? createdAt,
      final DateTime? completedAt}) = _$PaymentTransactionModelImpl;

  factory _PaymentTransactionModel.fromJson(Map<String, dynamic> json) =
      _$PaymentTransactionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentMethodType get method;
  @override
  PaymentTransactionStatus get status;
  @override
  String? get transactionId;
  @override
  String? get gatewayResponse;
  @override
  String? get errorMessage;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$PaymentTransactionModelImplCopyWith<_$PaymentTransactionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
