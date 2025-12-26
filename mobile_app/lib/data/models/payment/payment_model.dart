import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment Method Model - Saved payment methods
@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String id,
    required PaymentMethodType type,
    required String displayName,
    String? icon,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
    CardDetails? cardDetails,
    MobileWalletDetails? mobileWalletDetails,
    DateTime? createdAt,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
}

/// Payment method types
enum PaymentMethodType {
  @JsonValue('card')
  card,
  @JsonValue('bkash')
  bkash,
  @JsonValue('nagad')
  nagad,
  @JsonValue('rocket')
  rocket,
  @JsonValue('bank_transfer')
  bankTransfer,
  @JsonValue('cod')
  cashOnDelivery,
}

/// Card payment details
@freezed
class CardDetails with _$CardDetails {
  const factory CardDetails({
    required String last4,
    required String brand,
    required int expMonth,
    required int expYear,
    String? cardholderName,
  }) = _CardDetails;

  factory CardDetails.fromJson(Map<String, dynamic> json) =>
      _$CardDetailsFromJson(json);
}

/// Mobile wallet details
@freezed
class MobileWalletDetails with _$MobileWalletDetails {
  const factory MobileWalletDetails({
    required String phoneNumber,
    String? accountName,
    @Default(false) bool isVerified,
  }) = _MobileWalletDetails;

  factory MobileWalletDetails.fromJson(Map<String, dynamic> json) =>
      _$MobileWalletDetailsFromJson(json);
}

/// Payment Transaction Model
@freezed
class PaymentTransactionModel with _$PaymentTransactionModel {
  const factory PaymentTransactionModel({
    required String id,
    required String orderId,
    required double amount,
    @Default('BDT') String currency,
    required PaymentMethodType method,
    required PaymentTransactionStatus status,
    String? transactionId,
    String? gatewayResponse,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _PaymentTransactionModel;

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionModelFromJson(json);
}

/// Payment transaction status
enum PaymentTransactionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded,
}
