// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoItem _$VideoItemFromJson(Map<String, dynamic> json) {
  return _VideoItem.fromJson(json);
}

/// @nodoc
mixin _$VideoItem {
  String get uuid => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  bool get isMp3 => throw _privateConstructorUsedError;
  SerializableVideo get video => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VideoItemCopyWith<VideoItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoItemCopyWith<$Res> {
  factory $VideoItemCopyWith(VideoItem value, $Res Function(VideoItem) then) =
      _$VideoItemCopyWithImpl<$Res, VideoItem>;
  @useResult
  $Res call({String uuid, String path, bool isMp3, SerializableVideo video});

  $SerializableVideoCopyWith<$Res> get video;
}

/// @nodoc
class _$VideoItemCopyWithImpl<$Res, $Val extends VideoItem>
    implements $VideoItemCopyWith<$Res> {
  _$VideoItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? path = null,
    Object? isMp3 = null,
    Object? video = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isMp3: null == isMp3
          ? _value.isMp3
          : isMp3 // ignore: cast_nullable_to_non_nullable
              as bool,
      video: null == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as SerializableVideo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SerializableVideoCopyWith<$Res> get video {
    return $SerializableVideoCopyWith<$Res>(_value.video, (value) {
      return _then(_value.copyWith(video: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VideoItemImplCopyWith<$Res>
    implements $VideoItemCopyWith<$Res> {
  factory _$$VideoItemImplCopyWith(
          _$VideoItemImpl value, $Res Function(_$VideoItemImpl) then) =
      __$$VideoItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uuid, String path, bool isMp3, SerializableVideo video});

  @override
  $SerializableVideoCopyWith<$Res> get video;
}

/// @nodoc
class __$$VideoItemImplCopyWithImpl<$Res>
    extends _$VideoItemCopyWithImpl<$Res, _$VideoItemImpl>
    implements _$$VideoItemImplCopyWith<$Res> {
  __$$VideoItemImplCopyWithImpl(
      _$VideoItemImpl _value, $Res Function(_$VideoItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? path = null,
    Object? isMp3 = null,
    Object? video = null,
  }) {
    return _then(_$VideoItemImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isMp3: null == isMp3
          ? _value.isMp3
          : isMp3 // ignore: cast_nullable_to_non_nullable
              as bool,
      video: null == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as SerializableVideo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoItemImpl implements _VideoItem {
  const _$VideoItemImpl(
      {required this.uuid,
      required this.path,
      this.isMp3 = false,
      required this.video});

  factory _$VideoItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoItemImplFromJson(json);

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
  String toString() {
    return 'VideoItem(uuid: $uuid, path: $path, isMp3: $isMp3, video: $video)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoItemImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.isMp3, isMp3) || other.isMp3 == isMp3) &&
            (identical(other.video, video) || other.video == video));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, path, isMp3, video);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoItemImplCopyWith<_$VideoItemImpl> get copyWith =>
      __$$VideoItemImplCopyWithImpl<_$VideoItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoItemImplToJson(
      this,
    );
  }
}

abstract class _VideoItem implements VideoItem {
  const factory _VideoItem(
      {required final String uuid,
      required final String path,
      final bool isMp3,
      required final SerializableVideo video}) = _$VideoItemImpl;

  factory _VideoItem.fromJson(Map<String, dynamic> json) =
      _$VideoItemImpl.fromJson;

  @override
  String get uuid;
  @override
  String get path;
  @override
  bool get isMp3;
  @override
  SerializableVideo get video;
  @override
  @JsonKey(ignore: true)
  _$$VideoItemImplCopyWith<_$VideoItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
