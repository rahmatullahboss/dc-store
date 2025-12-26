// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodModelImpl _$$PaymentMethodModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      displayName: json['displayName'] as String,
      icon: json['icon'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      cardDetails: json['cardDetails'] == null
          ? null
          : CardDetails.fromJson(json['cardDetails'] as Map<String, dynamic>),
      mobileWalletDetails: json['mobileWalletDetails'] == null
          ? null
          : MobileWalletDetails.fromJson(
              json['mobileWalletDetails'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PaymentMethodModelImplToJson(
        _$PaymentMethodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PaymentMethodTypeEnumMap[instance.type]!,
      'displayName': instance.displayName,
      'icon': instance.icon,
      'isDefault': instance.isDefault,
      'isActive': instance.isActive,
      'cardDetails': instance.cardDetails,
      'mobileWalletDetails': instance.mobileWalletDetails,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.card: 'card',
  PaymentMethodType.bkash: 'bkash',
  PaymentMethodType.nagad: 'nagad',
  PaymentMethodType.rocket: 'rocket',
  PaymentMethodType.bankTransfer: 'bank_transfer',
  PaymentMethodType.cashOnDelivery: 'cod',
};

_$CardDetailsImpl _$$CardDetailsImplFromJson(Map<String, dynamic> json) =>
    _$CardDetailsImpl(
      last4: json['last4'] as String,
      brand: json['brand'] as String,
      expMonth: (json['expMonth'] as num).toInt(),
      expYear: (json['expYear'] as num).toInt(),
      cardholderName: json['cardholderName'] as String?,
    );

Map<String, dynamic> _$$CardDetailsImplToJson(_$CardDetailsImpl instance) =>
    <String, dynamic>{
      'last4': instance.last4,
      'brand': instance.brand,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'cardholderName': instance.cardholderName,
    };

_$MobileWalletDetailsImpl _$$MobileWalletDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$MobileWalletDetailsImpl(
      phoneNumber: json['phoneNumber'] as String,
      accountName: json['accountName'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$$MobileWalletDetailsImplToJson(
        _$MobileWalletDetailsImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'accountName': instance.accountName,
      'isVerified': instance.isVerified,
    };

_$PaymentTransactionModelImpl _$$PaymentTransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentTransactionModelImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'BDT',
      method: $enumDecode(_$PaymentMethodTypeEnumMap, json['method']),
      status: $enumDecode(_$PaymentTransactionStatusEnumMap, json['status']),
      transactionId: json['transactionId'] as String?,
      gatewayResponse: json['gatewayResponse'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$PaymentTransactionModelImplToJson(
        _$PaymentTransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'method': _$PaymentMethodTypeEnumMap[instance.method]!,
      'status': _$PaymentTransactionStatusEnumMap[instance.status]!,
      'transactionId': instance.transactionId,
      'gatewayResponse': instance.gatewayResponse,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$PaymentTransactionStatusEnumMap = {
  PaymentTransactionStatus.pending: 'pending',
  PaymentTransactionStatus.processing: 'processing',
  PaymentTransactionStatus.completed: 'completed',
  PaymentTransactionStatus.failed: 'failed',
  PaymentTransactionStatus.cancelled: 'cancelled',
  PaymentTransactionStatus.refunded: 'refunded',
};
