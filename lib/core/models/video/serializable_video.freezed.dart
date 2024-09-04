// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'serializable_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SerializableVideo _$SerializableVideoFromJson(Map<String, dynamic> json) {
  return _SerializableVideo.fromJson(json);
}

/// @nodoc
mixin _$SerializableVideo {
  VideoId get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  DateTime? get uploadDate => throw _privateConstructorUsedError;
  String? get uploadDateRaw => throw _privateConstructorUsedError;
  DateTime? get publishDate => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Duration? get duration => throw _privateConstructorUsedError;
  bool get isLive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SerializableVideoCopyWith<SerializableVideo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SerializableVideoCopyWith<$Res> {
  factory $SerializableVideoCopyWith(
          SerializableVideo value, $Res Function(SerializableVideo) then) =
      _$SerializableVideoCopyWithImpl<$Res, SerializableVideo>;
  @useResult
  $Res call(
      {VideoId id,
      String title,
      String author,
      String channelId,
      DateTime? uploadDate,
      String? uploadDateRaw,
      DateTime? publishDate,
      String description,
      Duration? duration,
      bool isLive});

  $VideoIdCopyWith<$Res> get id;
}

/// @nodoc
class _$SerializableVideoCopyWithImpl<$Res, $Val extends SerializableVideo>
    implements $SerializableVideoCopyWith<$Res> {
  _$SerializableVideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? channelId = null,
    Object? uploadDate = freezed,
    Object? uploadDateRaw = freezed,
    Object? publishDate = freezed,
    Object? description = null,
    Object? duration = freezed,
    Object? isLive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as VideoId,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: freezed == uploadDate
          ? _value.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadDateRaw: freezed == uploadDateRaw
          ? _value.uploadDateRaw
          : uploadDateRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isLive: null == isLive
          ? _value.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VideoIdCopyWith<$Res> get id {
    return $VideoIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SerializableVideoImplCopyWith<$Res>
    implements $SerializableVideoCopyWith<$Res> {
  factory _$$SerializableVideoImplCopyWith(_$SerializableVideoImpl value,
          $Res Function(_$SerializableVideoImpl) then) =
      __$$SerializableVideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {VideoId id,
      String title,
      String author,
      String channelId,
      DateTime? uploadDate,
      String? uploadDateRaw,
      DateTime? publishDate,
      String description,
      Duration? duration,
      bool isLive});

  @override
  $VideoIdCopyWith<$Res> get id;
}

/// @nodoc
class __$$SerializableVideoImplCopyWithImpl<$Res>
    extends _$SerializableVideoCopyWithImpl<$Res, _$SerializableVideoImpl>
    implements _$$SerializableVideoImplCopyWith<$Res> {
  __$$SerializableVideoImplCopyWithImpl(_$SerializableVideoImpl _value,
      $Res Function(_$SerializableVideoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? channelId = null,
    Object? uploadDate = freezed,
    Object? uploadDateRaw = freezed,
    Object? publishDate = freezed,
    Object? description = null,
    Object? duration = freezed,
    Object? isLive = null,
  }) {
    return _then(_$SerializableVideoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as VideoId,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: freezed == uploadDate
          ? _value.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadDateRaw: freezed == uploadDateRaw
          ? _value.uploadDateRaw
          : uploadDateRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isLive: null == isLive
          ? _value.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SerializableVideoImpl implements _SerializableVideo {
  const _$SerializableVideoImpl(
      {required this.id,
      required this.title,
      required this.author,
      required this.channelId,
      this.uploadDate,
      this.uploadDateRaw,
      this.publishDate,
      required this.description,
      this.duration,
      required this.isLive});

  factory _$SerializableVideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SerializableVideoImplFromJson(json);

  @override
  final VideoId id;
  @override
  final String title;
  @override
  final String author;
  @override
  final String channelId;
  @override
  final DateTime? uploadDate;
  @override
  final String? uploadDateRaw;
  @override
  final DateTime? publishDate;
  @override
  final String description;
  @override
  final Duration? duration;
  @override
  final bool isLive;

  @override
  String toString() {
    return 'SerializableVideo(id: $id, title: $title, author: $author, channelId: $channelId, uploadDate: $uploadDate, uploadDateRaw: $uploadDateRaw, publishDate: $publishDate, description: $description, duration: $duration, isLive: $isLive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SerializableVideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.uploadDate, uploadDate) ||
                other.uploadDate == uploadDate) &&
            (identical(other.uploadDateRaw, uploadDateRaw) ||
                other.uploadDateRaw == uploadDateRaw) &&
            (identical(other.publishDate, publishDate) ||
                other.publishDate == publishDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isLive, isLive) || other.isLive == isLive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, author, channelId,
      uploadDate, uploadDateRaw, publishDate, description, duration, isLive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SerializableVideoImplCopyWith<_$SerializableVideoImpl> get copyWith =>
      __$$SerializableVideoImplCopyWithImpl<_$SerializableVideoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SerializableVideoImplToJson(
      this,
    );
  }
}

abstract class _SerializableVideo implements SerializableVideo {
  const factory _SerializableVideo(
      {required final VideoId id,
      required final String title,
      required final String author,
      required final String channelId,
      final DateTime? uploadDate,
      final String? uploadDateRaw,
      final DateTime? publishDate,
      required final String description,
      final Duration? duration,
      required final bool isLive}) = _$SerializableVideoImpl;

  factory _SerializableVideo.fromJson(Map<String, dynamic> json) =
      _$SerializableVideoImpl.fromJson;

  @override
  VideoId get id;
  @override
  String get title;
  @override
  String get author;
  @override
  String get channelId;
  @override
  DateTime? get uploadDate;
  @override
  String? get uploadDateRaw;
  @override
  DateTime? get publishDate;
  @override
  String get description;
  @override
  Duration? get duration;
  @override
  bool get isLive;
  @override
  @JsonKey(ignore: true)
  _$$SerializableVideoImplCopyWith<_$SerializableVideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
