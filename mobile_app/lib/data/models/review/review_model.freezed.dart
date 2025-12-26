// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return _ReviewModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  int get helpfulCount => throw _privateConstructorUsedError;
  bool get isVerifiedPurchase => throw _privateConstructorUsedError;
  bool get isRecommended => throw _privateConstructorUsedError;
  ReviewReplyModel? get reply => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
          ReviewModel value, $Res Function(ReviewModel) then) =
      _$ReviewModelCopyWithImpl<$Res, ReviewModel>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String userId,
      String userName,
      String? userAvatar,
      double rating,
      String? title,
      String? comment,
      List<String> images,
      int helpfulCount,
      bool isVerifiedPurchase,
      bool isRecommended,
      ReviewReplyModel? reply,
      DateTime createdAt,
      DateTime? updatedAt});

  $ReviewReplyModelCopyWith<$Res>? get reply;
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res, $Val extends ReviewModel>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? rating = null,
    Object? title = freezed,
    Object? comment = freezed,
    Object? images = null,
    Object? helpfulCount = null,
    Object? isVerifiedPurchase = null,
    Object? isRecommended = null,
    Object? reply = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerifiedPurchase: null == isVerifiedPurchase
          ? _value.isVerifiedPurchase
          : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isRecommended: null == isRecommended
          ? _value.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReviewReplyModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewReplyModelCopyWith<$Res>? get reply {
    if (_value.reply == null) {
      return null;
    }

    return $ReviewReplyModelCopyWith<$Res>(_value.reply!, (value) {
      return _then(_value.copyWith(reply: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReviewModelImplCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$$ReviewModelImplCopyWith(
          _$ReviewModelImpl value, $Res Function(_$ReviewModelImpl) then) =
      __$$ReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String userId,
      String userName,
      String? userAvatar,
      double rating,
      String? title,
      String? comment,
      List<String> images,
      int helpfulCount,
      bool isVerifiedPurchase,
      bool isRecommended,
      ReviewReplyModel? reply,
      DateTime createdAt,
      DateTime? updatedAt});

  @override
  $ReviewReplyModelCopyWith<$Res>? get reply;
}

/// @nodoc
class __$$ReviewModelImplCopyWithImpl<$Res>
    extends _$ReviewModelCopyWithImpl<$Res, _$ReviewModelImpl>
    implements _$$ReviewModelImplCopyWith<$Res> {
  __$$ReviewModelImplCopyWithImpl(
      _$ReviewModelImpl _value, $Res Function(_$ReviewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? rating = null,
    Object? title = freezed,
    Object? comment = freezed,
    Object? images = null,
    Object? helpfulCount = null,
    Object? isVerifiedPurchase = null,
    Object? isRecommended = null,
    Object? reply = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReviewModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerifiedPurchase: null == isVerifiedPurchase
          ? _value.isVerifiedPurchase
          : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isRecommended: null == isRecommended
          ? _value.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReviewReplyModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewModelImpl extends _ReviewModel {
  const _$ReviewModelImpl(
      {required this.id,
      required this.productId,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.rating,
      this.title,
      this.comment,
      final List<String> images = const [],
      this.helpfulCount = 0,
      this.isVerifiedPurchase = false,
      this.isRecommended = false,
      this.reply,
      required this.createdAt,
      this.updatedAt})
      : _images = images,
        super._();

  factory _$ReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewModelImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final double rating;
  @override
  final String? title;
  @override
  final String? comment;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final int helpfulCount;
  @override
  @JsonKey()
  final bool isVerifiedPurchase;
  @override
  @JsonKey()
  final bool isRecommended;
  @override
  final ReviewReplyModel? reply;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReviewModel(id: $id, productId: $productId, userId: $userId, userName: $userName, userAvatar: $userAvatar, rating: $rating, title: $title, comment: $comment, images: $images, helpfulCount: $helpfulCount, isVerifiedPurchase: $isVerifiedPurchase, isRecommended: $isRecommended, reply: $reply, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.isVerifiedPurchase, isVerifiedPurchase) ||
                other.isVerifiedPurchase == isVerifiedPurchase) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      userId,
      userName,
      userAvatar,
      rating,
      title,
      comment,
      const DeepCollectionEquality().hash(_images),
      helpfulCount,
      isVerifiedPurchase,
      isRecommended,
      reply,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      __$$ReviewModelImplCopyWithImpl<_$ReviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewModel extends ReviewModel {
  const factory _ReviewModel(
      {required final String id,
      required final String productId,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final double rating,
      final String? title,
      final String? comment,
      final List<String> images,
      final int helpfulCount,
      final bool isVerifiedPurchase,
      final bool isRecommended,
      final ReviewReplyModel? reply,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ReviewModelImpl;
  const _ReviewModel._() : super._();

  factory _ReviewModel.fromJson(Map<String, dynamic> json) =
      _$ReviewModelImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  double get rating;
  @override
  String? get title;
  @override
  String? get comment;
  @override
  List<String> get images;
  @override
  int get helpfulCount;
  @override
  bool get isVerifiedPurchase;
  @override
  bool get isRecommended;
  @override
  ReviewReplyModel? get reply;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewReplyModel _$ReviewReplyModelFromJson(Map<String, dynamic> json) {
  return _ReviewReplyModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewReplyModel {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get repliedBy => throw _privateConstructorUsedError;
  DateTime get repliedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewReplyModelCopyWith<ReviewReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewReplyModelCopyWith<$Res> {
  factory $ReviewReplyModelCopyWith(
          ReviewReplyModel value, $Res Function(ReviewReplyModel) then) =
      _$ReviewReplyModelCopyWithImpl<$Res, ReviewReplyModel>;
  @useResult
  $Res call({String id, String content, String repliedBy, DateTime repliedAt});
}

/// @nodoc
class _$ReviewReplyModelCopyWithImpl<$Res, $Val extends ReviewReplyModel>
    implements $ReviewReplyModelCopyWith<$Res> {
  _$ReviewReplyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? repliedBy = null,
    Object? repliedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      repliedBy: null == repliedBy
          ? _value.repliedBy
          : repliedBy // ignore: cast_nullable_to_non_nullable
              as String,
      repliedAt: null == repliedAt
          ? _value.repliedAt
          : repliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewReplyModelImplCopyWith<$Res>
    implements $ReviewReplyModelCopyWith<$Res> {
  factory _$$ReviewReplyModelImplCopyWith(_$ReviewReplyModelImpl value,
          $Res Function(_$ReviewReplyModelImpl) then) =
      __$$ReviewReplyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content, String repliedBy, DateTime repliedAt});
}

/// @nodoc
class __$$ReviewReplyModelImplCopyWithImpl<$Res>
    extends _$ReviewReplyModelCopyWithImpl<$Res, _$ReviewReplyModelImpl>
    implements _$$ReviewReplyModelImplCopyWith<$Res> {
  __$$ReviewReplyModelImplCopyWithImpl(_$ReviewReplyModelImpl _value,
      $Res Function(_$ReviewReplyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? repliedBy = null,
    Object? repliedAt = null,
  }) {
    return _then(_$ReviewReplyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      repliedBy: null == repliedBy
          ? _value.repliedBy
          : repliedBy // ignore: cast_nullable_to_non_nullable
              as String,
      repliedAt: null == repliedAt
          ? _value.repliedAt
          : repliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewReplyModelImpl implements _ReviewReplyModel {
  const _$ReviewReplyModelImpl(
      {required this.id,
      required this.content,
      required this.repliedBy,
      required this.repliedAt});

  factory _$ReviewReplyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewReplyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String repliedBy;
  @override
  final DateTime repliedAt;

  @override
  String toString() {
    return 'ReviewReplyModel(id: $id, content: $content, repliedBy: $repliedBy, repliedAt: $repliedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewReplyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.repliedBy, repliedBy) ||
                other.repliedBy == repliedBy) &&
            (identical(other.repliedAt, repliedAt) ||
                other.repliedAt == repliedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, repliedBy, repliedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewReplyModelImplCopyWith<_$ReviewReplyModelImpl> get copyWith =>
      __$$ReviewReplyModelImplCopyWithImpl<_$ReviewReplyModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewReplyModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewReplyModel implements ReviewReplyModel {
  const factory _ReviewReplyModel(
      {required final String id,
      required final String content,
      required final String repliedBy,
      required final DateTime repliedAt}) = _$ReviewReplyModelImpl;

  factory _ReviewReplyModel.fromJson(Map<String, dynamic> json) =
      _$ReviewReplyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get repliedBy;
  @override
  DateTime get repliedAt;
  @override
  @JsonKey(ignore: true)
  _$$ReviewReplyModelImplCopyWith<_$ReviewReplyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewSummaryModel _$ReviewSummaryModelFromJson(Map<String, dynamic> json) {
  return _ReviewSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewSummaryModel {
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  Map<int, int> get ratingBreakdown =>
      throw _privateConstructorUsedError; // {5: 100, 4: 50, 3: 20, 2: 5, 1: 2}
  int get recommendedCount => throw _privateConstructorUsedError;
  int get verifiedPurchaseCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewSummaryModelCopyWith<ReviewSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewSummaryModelCopyWith<$Res> {
  factory $ReviewSummaryModelCopyWith(
          ReviewSummaryModel value, $Res Function(ReviewSummaryModel) then) =
      _$ReviewSummaryModelCopyWithImpl<$Res, ReviewSummaryModel>;
  @useResult
  $Res call(
      {double averageRating,
      int totalReviews,
      Map<int, int> ratingBreakdown,
      int recommendedCount,
      int verifiedPurchaseCount});
}

/// @nodoc
class _$ReviewSummaryModelCopyWithImpl<$Res, $Val extends ReviewSummaryModel>
    implements $ReviewSummaryModelCopyWith<$Res> {
  _$ReviewSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? ratingBreakdown = null,
    Object? recommendedCount = null,
    Object? verifiedPurchaseCount = null,
  }) {
    return _then(_value.copyWith(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      ratingBreakdown: null == ratingBreakdown
          ? _value.ratingBreakdown
          : ratingBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      recommendedCount: null == recommendedCount
          ? _value.recommendedCount
          : recommendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      verifiedPurchaseCount: null == verifiedPurchaseCount
          ? _value.verifiedPurchaseCount
          : verifiedPurchaseCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewSummaryModelImplCopyWith<$Res>
    implements $ReviewSummaryModelCopyWith<$Res> {
  factory _$$ReviewSummaryModelImplCopyWith(_$ReviewSummaryModelImpl value,
          $Res Function(_$ReviewSummaryModelImpl) then) =
      __$$ReviewSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double averageRating,
      int totalReviews,
      Map<int, int> ratingBreakdown,
      int recommendedCount,
      int verifiedPurchaseCount});
}

/// @nodoc
class __$$ReviewSummaryModelImplCopyWithImpl<$Res>
    extends _$ReviewSummaryModelCopyWithImpl<$Res, _$ReviewSummaryModelImpl>
    implements _$$ReviewSummaryModelImplCopyWith<$Res> {
  __$$ReviewSummaryModelImplCopyWithImpl(_$ReviewSummaryModelImpl _value,
      $Res Function(_$ReviewSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? ratingBreakdown = null,
    Object? recommendedCount = null,
    Object? verifiedPurchaseCount = null,
  }) {
    return _then(_$ReviewSummaryModelImpl(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      ratingBreakdown: null == ratingBreakdown
          ? _value._ratingBreakdown
          : ratingBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      recommendedCount: null == recommendedCount
          ? _value.recommendedCount
          : recommendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      verifiedPurchaseCount: null == verifiedPurchaseCount
          ? _value.verifiedPurchaseCount
          : verifiedPurchaseCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewSummaryModelImpl extends _ReviewSummaryModel {
  const _$ReviewSummaryModelImpl(
      {required this.averageRating,
      required this.totalReviews,
      final Map<int, int> ratingBreakdown = const {},
      this.recommendedCount = 0,
      this.verifiedPurchaseCount = 0})
      : _ratingBreakdown = ratingBreakdown,
        super._();

  factory _$ReviewSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewSummaryModelImplFromJson(json);

  @override
  final double averageRating;
  @override
  final int totalReviews;
  final Map<int, int> _ratingBreakdown;
  @override
  @JsonKey()
  Map<int, int> get ratingBreakdown {
    if (_ratingBreakdown is EqualUnmodifiableMapView) return _ratingBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratingBreakdown);
  }

// {5: 100, 4: 50, 3: 20, 2: 5, 1: 2}
  @override
  @JsonKey()
  final int recommendedCount;
  @override
  @JsonKey()
  final int verifiedPurchaseCount;

  @override
  String toString() {
    return 'ReviewSummaryModel(averageRating: $averageRating, totalReviews: $totalReviews, ratingBreakdown: $ratingBreakdown, recommendedCount: $recommendedCount, verifiedPurchaseCount: $verifiedPurchaseCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewSummaryModelImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality()
                .equals(other._ratingBreakdown, _ratingBreakdown) &&
            (identical(other.recommendedCount, recommendedCount) ||
                other.recommendedCount == recommendedCount) &&
            (identical(other.verifiedPurchaseCount, verifiedPurchaseCount) ||
                other.verifiedPurchaseCount == verifiedPurchaseCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averageRating,
      totalReviews,
      const DeepCollectionEquality().hash(_ratingBreakdown),
      recommendedCount,
      verifiedPurchaseCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewSummaryModelImplCopyWith<_$ReviewSummaryModelImpl> get copyWith =>
      __$$ReviewSummaryModelImplCopyWithImpl<_$ReviewSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewSummaryModel extends ReviewSummaryModel {
  const factory _ReviewSummaryModel(
      {required final double averageRating,
      required final int totalReviews,
      final Map<int, int> ratingBreakdown,
      final int recommendedCount,
      final int verifiedPurchaseCount}) = _$ReviewSummaryModelImpl;
  const _ReviewSummaryModel._() : super._();

  factory _ReviewSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ReviewSummaryModelImpl.fromJson;

  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  Map<int, int> get ratingBreakdown;
  @override // {5: 100, 4: 50, 3: 20, 2: 5, 1: 2}
  int get recommendedCount;
  @override
  int get verifiedPurchaseCount;
  @override
  @JsonKey(ignore: true)
  _$$ReviewSummaryModelImplCopyWith<_$ReviewSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
