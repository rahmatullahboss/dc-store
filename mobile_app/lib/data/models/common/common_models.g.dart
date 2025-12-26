// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemModelImpl _$$WishlistItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WishlistItemModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String?,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
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
      'inStock': instance.inStock,
      'addedAt': instance.addedAt?.toIso8601String(),
    };

_$BannerModelImpl _$$BannerModelImplFromJson(Map<String, dynamic> json) =>
    _$BannerModelImpl(
      id: json['id'] as String,
      image: json['image'] as String,
      mobileImage: json['mobileImage'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      buttonText: json['buttonText'] as String?,
      actionType: json['actionType'] as String?,
      actionValue: json['actionValue'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$BannerModelImplToJson(_$BannerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'mobileImage': instance.mobileImage,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'buttonText': instance.buttonText,
      'actionType': instance.actionType,
      'actionValue': instance.actionValue,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String?,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'type': instance.type,
      'data': instance.data,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$FaqModelImpl _$$FaqModelImplFromJson(Map<String, dynamic> json) =>
    _$FaqModelImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FaqModelImplToJson(_$FaqModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'category': instance.category,
      'sortOrder': instance.sortOrder,
    };

_$SettingsModelImpl _$$SettingsModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingsModelImpl(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'BDT',
      themeMode: json['themeMode'] as String? ?? 'system',
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$SettingsModelImplToJson(_$SettingsModelImpl instance) =>
    <String, dynamic>{
      'pushNotifications': instance.pushNotifications,
      'emailNotifications': instance.emailNotifications,
      'smsNotifications': instance.smsNotifications,
      'language': instance.language,
      'currency': instance.currency,
      'themeMode': instance.themeMode,
      'biometricEnabled': instance.biometricEnabled,
    };
