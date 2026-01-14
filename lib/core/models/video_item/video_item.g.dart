// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoItem _$VideoItemFromJson(Map<String, dynamic> json) => _VideoItem(
      uuid: json['uuid'] as String,
      path: json['path'] as String,
      isMp3: json['isMp3'] as bool? ?? false,
      video: SerializableVideo.fromJson(json['video'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$VideoStatusEnumMap, json['status']) ??
          VideoStatus.downloading,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$VideoItemToJson(_VideoItem instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'path': instance.path,
      'isMp3': instance.isMp3,
      'video': instance.video,
      'status': _$VideoStatusEnumMap[instance.status]!,
      'progress': instance.progress,
    };

const _$VideoStatusEnumMap = {
  VideoStatus.downloading: 'downloading',
  VideoStatus.merging: 'merging',
  VideoStatus.converting: 'converting',
  VideoStatus.finished: 'finished',
  VideoStatus.failed: 'failed',
};
