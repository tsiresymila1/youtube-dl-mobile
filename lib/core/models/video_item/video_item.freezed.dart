// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoItem {
  String get uuid;
  String get path;
  bool get isMp3;
  SerializableVideo get video;
  VideoStatus get status;
  double get progress;

  /// Create a copy of VideoItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoItemCopyWith<VideoItem> get copyWith =>
      _$VideoItemCopyWithImpl<VideoItem>(this as VideoItem, _$identity);

  /// Serializes this VideoItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoItem &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.isMp3, isMp3) || other.isMp3 == isMp3) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uuid, path, isMp3, video, status, progress);

  @override
  String toString() {
    return 'VideoItem(uuid: $uuid, path: $path, isMp3: $isMp3, video: $video, status: $status, progress: $progress)';
  }
}

/// @nodoc
abstract mixin class $VideoItemCopyWith<$Res> {
  factory $VideoItemCopyWith(VideoItem value, $Res Function(VideoItem) _then) =
      _$VideoItemCopyWithImpl;
  @useResult
  $Res call(
      {String uuid,
      String path,
      bool isMp3,
      SerializableVideo video,
      VideoStatus status,
      double progress});

  $SerializableVideoCopyWith<$Res> get video;
}

/// @nodoc
class _$VideoItemCopyWithImpl<$Res> implements $VideoItemCopyWith<$Res> {
  _$VideoItemCopyWithImpl(this._self, this._then);

  final VideoItem _self;
  final $Res Function(VideoItem) _then;

  /// Create a copy of VideoItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? path = null,
    Object? isMp3 = null,
    Object? video = null,
    Object? status = null,
    Object? progress = null,
  }) {
    return _then(_self.copyWith(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isMp3: null == isMp3
          ? _self.isMp3
          : isMp3 // ignore: cast_nullable_to_non_nullable
              as bool,
      video: null == video
          ? _self.video
          : video // ignore: cast_nullable_to_non_nullable
              as SerializableVideo,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoStatus,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of VideoItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SerializableVideoCopyWith<$Res> get video {
    return $SerializableVideoCopyWith<$Res>(_self.video, (value) {
      return _then(_self.copyWith(video: value));
    });
  }
}

/// Adds pattern-matching-related methods to [VideoItem].
extension VideoItemPatterns on VideoItem {
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
    TResult Function(_VideoItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoItem() when $default != null:
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
    TResult Function(_VideoItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoItem():
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
    TResult? Function(_VideoItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoItem() when $default != null:
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
    TResult Function(String uuid, String path, bool isMp3,
            SerializableVideo video, VideoStatus status, double progress)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoItem() when $default != null:
        return $default(_that.uuid, _that.path, _that.isMp3, _that.video,
            _that.status, _that.progress);
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
    TResult Function(String uuid, String path, bool isMp3,
            SerializableVideo video, VideoStatus status, double progress)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoItem():
        return $default(_that.uuid, _that.path, _that.isMp3, _that.video,
            _that.status, _that.progress);
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
    TResult? Function(String uuid, String path, bool isMp3,
            SerializableVideo video, VideoStatus status, double progress)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoItem() when $default != null:
        return $default(_that.uuid, _that.path, _that.isMp3, _that.video,
            _that.status, _that.progress);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VideoItem implements VideoItem {
  const _VideoItem(
      {required this.uuid,
      required this.path,
      this.isMp3 = false,
      required this.video,
      this.status = VideoStatus.downloading,
      this.progress = 0.0});
  factory _VideoItem.fromJson(Map<String, dynamic> json) =>
      _$VideoItemFromJson(json);

  @override
  final String uuid;
  @override
  final String path;
  @override
  @JsonKey()
  final bool isMp3;
  @override
  final SerializableVideo video;
  @override
  @JsonKey()
  final VideoStatus status;
  @override
  @JsonKey()
  final double progress;

  /// Create a copy of VideoItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoItemCopyWith<_VideoItem> get copyWith =>
      __$VideoItemCopyWithImpl<_VideoItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VideoItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoItem &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.isMp3, isMp3) || other.isMp3 == isMp3) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uuid, path, isMp3, video, status, progress);

  @override
  String toString() {
    return 'VideoItem(uuid: $uuid, path: $path, isMp3: $isMp3, video: $video, status: $status, progress: $progress)';
  }
}

/// @nodoc
abstract mixin class _$VideoItemCopyWith<$Res>
    implements $VideoItemCopyWith<$Res> {
  factory _$VideoItemCopyWith(
          _VideoItem value, $Res Function(_VideoItem) _then) =
      __$VideoItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uuid,
      String path,
      bool isMp3,
      SerializableVideo video,
      VideoStatus status,
      double progress});

  @override
  $SerializableVideoCopyWith<$Res> get video;
}

/// @nodoc
class __$VideoItemCopyWithImpl<$Res> implements _$VideoItemCopyWith<$Res> {
  __$VideoItemCopyWithImpl(this._self, this._then);

  final _VideoItem _self;
  final $Res Function(_VideoItem) _then;

  /// Create a copy of VideoItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uuid = null,
    Object? path = null,
    Object? isMp3 = null,
    Object? video = null,
    Object? status = null,
    Object? progress = null,
  }) {
    return _then(_VideoItem(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isMp3: null == isMp3
          ? _self.isMp3
          : isMp3 // ignore: cast_nullable_to_non_nullable
              as bool,
      video: null == video
          ? _self.video
          : video // ignore: cast_nullable_to_non_nullable
              as SerializableVideo,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoStatus,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of VideoItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SerializableVideoCopyWith<$Res> get video {
    return $SerializableVideoCopyWith<$Res>(_self.video, (value) {
      return _then(_self.copyWith(video: value));
    });
  }
}

// dart format on
