// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoItemImpl _$$VideoItemImplFromJson(Map<String, dynamic> json) =>
    _$VideoItemImpl(
      uuid: json['uuid'] as String,
      path: json['path'] as String,
      isMp3: json['isMp3'] as bool? ?? false,
      video: SerializableVideo.fromJson(json['video'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VideoItemImplToJson(_$VideoItemImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'path': instance.path,
      'isMp3': instance.isMp3,
      'video': instance.video,
    };
