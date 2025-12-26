// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      reply: json['reply'] == null
          ? null
          : ReviewReplyModel.fromJson(json['reply'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'rating': instance.rating,
      'title': instance.title,
      'comment': instance.comment,
      'images': instance.images,
      'helpfulCount': instance.helpfulCount,
      'isVerifiedPurchase': instance.isVerifiedPurchase,
      'isRecommended': instance.isRecommended,
      'reply': instance.reply,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ReviewReplyModelImpl _$$ReviewReplyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewReplyModelImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      repliedBy: json['repliedBy'] as String,
      repliedAt: DateTime.parse(json['repliedAt'] as String),
    );

Map<String, dynamic> _$$ReviewReplyModelImplToJson(
        _$ReviewReplyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'repliedBy': instance.repliedBy,
      'repliedAt': instance.repliedAt.toIso8601String(),
    };

_$ReviewSummaryModelImpl _$$ReviewSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewSummaryModelImpl(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      ratingBreakdown: (json['ratingBreakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
          ) ??
          const {},
      recommendedCount: (json['recommendedCount'] as num?)?.toInt() ?? 0,
      verifiedPurchaseCount:
          (json['verifiedPurchaseCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReviewSummaryModelImplToJson(
        _$ReviewSummaryModelImpl instance) =>
    <String, dynamic>{
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'ratingBreakdown':
          instance.ratingBreakdown.map((k, e) => MapEntry(k.toString(), e)),
      'recommendedCount': instance.recommendedCount,
      'verifiedPurchaseCount': instance.verifiedPurchaseCount,
    };
