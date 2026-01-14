// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'serializable_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SerializableVideo {
  VideoId get id;
  String get title;
  String get author;
  String get channelId;
  DateTime? get uploadDate;
  String? get uploadDateRaw;
  DateTime? get publishDate;
  String get description;
  Duration? get duration;
  String get thumbnailUrl;
  bool get isLive;

  /// Create a copy of SerializableVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SerializableVideoCopyWith<SerializableVideo> get copyWith =>
      _$SerializableVideoCopyWithImpl<SerializableVideo>(
          this as SerializableVideo, _$identity);

  /// Serializes this SerializableVideo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SerializableVideo &&
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
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.isLive, isLive) || other.isLive == isLive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      author,
      channelId,
      uploadDate,
      uploadDateRaw,
      publishDate,
      description,
      duration,
      thumbnailUrl,
      isLive);

  @override
  String toString() {
    return 'SerializableVideo(id: $id, title: $title, author: $author, channelId: $channelId, uploadDate: $uploadDate, uploadDateRaw: $uploadDateRaw, publishDate: $publishDate, description: $description, duration: $duration, thumbnailUrl: $thumbnailUrl, isLive: $isLive)';
  }
}

/// @nodoc
abstract mixin class $SerializableVideoCopyWith<$Res> {
  factory $SerializableVideoCopyWith(
          SerializableVideo value, $Res Function(SerializableVideo) _then) =
      _$SerializableVideoCopyWithImpl;
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
      String thumbnailUrl,
      bool isLive});

  $VideoIdCopyWith<$Res> get id;
}

/// @nodoc
class _$SerializableVideoCopyWithImpl<$Res>
    implements $SerializableVideoCopyWith<$Res> {
  _$SerializableVideoCopyWithImpl(this._self, this._then);

  final SerializableVideo _self;
  final $Res Function(SerializableVideo) _then;

  /// Create a copy of SerializableVideo
  /// with the given fields replaced by the non-null parameter values.
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
    Object? thumbnailUrl = null,
    Object? isLive = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as VideoId,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _self.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: freezed == uploadDate
          ? _self.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadDateRaw: freezed == uploadDateRaw
          ? _self.uploadDateRaw
          : uploadDateRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _self.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      thumbnailUrl: null == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isLive: null == isLive
          ? _self.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of SerializableVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoIdCopyWith<$Res> get id {
    return $VideoIdCopyWith<$Res>(_self.id, (value) {
      return _then(_self.copyWith(id: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SerializableVideo].
extension SerializableVideoPatterns on SerializableVideo {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SerializableVideo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SerializableVideo() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SerializableVideo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SerializableVideo():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SerializableVideo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SerializableVideo() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            VideoId id,
            String title,
            String author,
            String channelId,
            DateTime? uploadDate,
            String? uploadDateRaw,
            DateTime? publishDate,
            String description,
            Duration? duration,
            String thumbnailUrl,
            bool isLive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SerializableVideo() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.author,
            _that.channelId,
            _that.uploadDate,
            _that.uploadDateRaw,
            _that.publishDate,
            _that.description,
            _that.duration,
            _that.thumbnailUrl,
            _that.isLive);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            VideoId id,
            String title,
            String author,
            String channelId,
            DateTime? uploadDate,
            String? uploadDateRaw,
            DateTime? publishDate,
            String description,
            Duration? duration,
            String thumbnailUrl,
            bool isLive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SerializableVideo():
        return $default(
            _that.id,
            _that.title,
            _that.author,
            _that.channelId,
            _that.uploadDate,
            _that.uploadDateRaw,
            _that.publishDate,
            _that.description,
            _that.duration,
            _that.thumbnailUrl,
            _that.isLive);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            VideoId id,
            String title,
            String author,
            String channelId,
            DateTime? uploadDate,
            String? uploadDateRaw,
            DateTime? publishDate,
            String description,
            Duration? duration,
            String thumbnailUrl,
            bool isLive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SerializableVideo() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.author,
            _that.channelId,
            _that.uploadDate,
            _that.uploadDateRaw,
            _that.publishDate,
            _that.description,
            _that.duration,
            _that.thumbnailUrl,
            _that.isLive);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SerializableVideo implements SerializableVideo {
  const _SerializableVideo(
      {required this.id,
      required this.title,
      required this.author,
      required this.channelId,
      this.uploadDate,
      this.uploadDateRaw,
      this.publishDate,
      required this.description,
      this.duration,
      required this.thumbnailUrl,
      required this.isLive});
  factory _SerializableVideo.fromJson(Map<String, dynamic> json) =>
      _$SerializableVideoFromJson(json);

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
  final String thumbnailUrl;
  @override
  final bool isLive;

  /// Create a copy of SerializableVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SerializableVideoCopyWith<_SerializableVideo> get copyWith =>
      __$SerializableVideoCopyWithImpl<_SerializableVideo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SerializableVideoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SerializableVideo &&
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
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.isLive, isLive) || other.isLive == isLive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      author,
      channelId,
      uploadDate,
      uploadDateRaw,
      publishDate,
      description,
      duration,
      thumbnailUrl,
      isLive);

  @override
  String toString() {
    return 'SerializableVideo(id: $id, title: $title, author: $author, channelId: $channelId, uploadDate: $uploadDate, uploadDateRaw: $uploadDateRaw, publishDate: $publishDate, description: $description, duration: $duration, thumbnailUrl: $thumbnailUrl, isLive: $isLive)';
  }
}

/// @nodoc
abstract mixin class _$SerializableVideoCopyWith<$Res>
    implements $SerializableVideoCopyWith<$Res> {
  factory _$SerializableVideoCopyWith(
          _SerializableVideo value, $Res Function(_SerializableVideo) _then) =
      __$SerializableVideoCopyWithImpl;
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
      String thumbnailUrl,
      bool isLive});

  @override
  $VideoIdCopyWith<$Res> get id;
}

/// @nodoc
class __$SerializableVideoCopyWithImpl<$Res>
    implements _$SerializableVideoCopyWith<$Res> {
  __$SerializableVideoCopyWithImpl(this._self, this._then);

  final _SerializableVideo _self;
  final $Res Function(_SerializableVideo) _then;

  /// Create a copy of SerializableVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    Object? thumbnailUrl = null,
    Object? isLive = null,
  }) {
    return _then(_SerializableVideo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as VideoId,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _self.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: freezed == uploadDate
          ? _self.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadDateRaw: freezed == uploadDateRaw
          ? _self.uploadDateRaw
          : uploadDateRaw // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _self.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      duration: freezed == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      thumbnailUrl: null == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isLive: null == isLive
          ? _self.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of SerializableVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoIdCopyWith<$Res> get id {
    return $VideoIdCopyWith<$Res>(_self.id, (value) {
      return _then(_self.copyWith(id: value));
    });
  }
}

// dart format on
